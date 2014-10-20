express = require('express')
router = express.Router()
mongoose = require('mongoose')
passport = require('passport')

ensureAuthenticated = (req, res, next) ->
	if req.isAuthenticated()
		return next()
	res.redirect('/login')

router.get('/login', (req, res) ->
	res.render('login')
)

router.post('/login', (req, res, next) ->
	passport.authenticate('local', (err, user, info) ->
		if err
			return next(err)
		unless user
			req.session.messages = [info.message];
			return res.redirect('/login')

		req.logIn(user, (err) ->
			if err
				return next(err)
			return res.redirect('/')
		)
	)(req, res, next)
)

router.get('/logout', (req, res) ->
	req.logout()
	res.redirect('/')
)

router.get('/',
		ensureAuthenticated,
		(req, res) ->
			res.render('index')
)

router.get('/notes',
	ensureAuthenticated,
	(req, res) ->
		Note = mongoose.model('Note')
		Note.find((err, notes) ->
			if err
				console.error(err)
			res.json(notes)
		)
)

router.get('/:id',
	ensureAuthenticated,
	(req, res) ->
		res.json({})
)


router.post('/savenote',
	ensureAuthenticated,
	(req, res) ->
		_id = req.body._id
		savedNote =
			title: req.body.title || ''
			text: req.body.text || ''
		Note = mongoose.model('Note')
		Note.findOneAndUpdate({ _id: _id }, savedNote, { upsert:true }, (err, note) ->
			if err
				console.error(err)
		)

		res.status(200).end()
)



module.exports = router
