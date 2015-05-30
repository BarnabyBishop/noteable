require('dotenv').load()
debug = require('debug')('noteable')
express = require('express')
session = require('express-session')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
flash = require('connect-flash')
routes = require('./routes/routes')
model = require('./models/model')
passport = require('passport')
LocalStrategy = require('passport-local').Strategy
MongoStore = require('connect-mongo')(session)
nunjucks = require('nunjucks')

app = express()

# view engine setup
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'html')
# app.set('view engine', 'jade')
nunjucks.configure(
	'views',
	autoescape: true,
	express: app
	)

#app.use(favicon(__dirname + '/public/favicon.ico'))
# app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded( extended: false ))
app.use(cookieParser())
app.use(express.static(path.join(__dirname, 'build/public')))
app.use(session(
	secret: 'i have no idea what im doing'
	saveUninitialized: true
	resave: true
	cookie:
		maxAge: 604800000 # 7 days
	store: new MongoStore(db: 'noteable')
	))
app.use(passport.initialize())
app.use(passport.session())
app.use(flash())

app.use('/', routes)

passport.use(new LocalStrategy({
	usernameField: 'email',
	passwordField: 'password'
	},
	(email, password, done) ->
		model.user.findOne(
			email: email,
			(err, user) ->
				if err
					console.log err
					return done(err)
				unless user
					console.log 'incorrect username'
					return done(null, false, message: 'Incorrect username.')

				user.comparePassword(password,
					(err, isMatch) ->
						if err
							throw err
						console.log('Password: ', isMatch)
						if isMatch
							return done(null, user)
						else
							return done(null, false, message: 'Incorrect password.')
				)

			)
		)
)

passport.serializeUser((user, done) ->
	done(null, user.id)
)


passport.deserializeUser((id, done) ->
	model.user.findById(id, (err, user) ->
		if err
			done(err)
		if user
			done(null,user)
	)
)

# catch 404 and forward to error handler
app.use((req, res, next) ->
	err = new Error('Not Found')
	err.status = 404
	next(err)
)

# error handler

# development error handler
# will print stacktrace
if app.get('env') == 'development'
	app.use((err, req, res, next) ->
		res.status(err.status or 500)
		res.render('error',
			message: err.message,
			error: err
			)
	)


# production error handler
# no stacktraces leaked to user
app.use((err, req, res, next) ->
	res.status(err.status or 500)
	res.render('error',
		message: err.message,
		error: {}
	)
)

module.exports = app

app.set('port', 3100)

server = app.listen(app.get('port'), () ->
	console.log('Express server listening on port ' + server.address().port)
)
