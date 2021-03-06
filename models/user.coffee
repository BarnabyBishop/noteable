mongoose = require('mongoose')
Schema = mongoose.Schema
bcrypt = require('bcrypt')
SALT_WORK_FACTOR = 10

userSchema = mongoose.Schema(
	email:
		type: String
		required: true
		index:
			unique: true
	password:
		type: String
		required: true
)

userSchema.pre('save', (next) ->
	user = this
	# only hash the password if it has been modified (or is new)
	unless user.isModified('password')
		return next();

	# generate a salt
	bcrypt.genSalt(SALT_WORK_FACTOR,
		(err, salt) ->
			if err
				return next(err)

			# hash the password along with our new SALT_WORK_FACTOR
			bcrypt.hash(user.password, salt,
				(err, hash) ->
					if (err)
						return next(err)

					# override the cleartext password with the hashed one
					user.password = hash
					next()
		)
	)
)

userSchema.methods.comparePassword = (candidatePassword, cb) ->
	bcrypt.compare(candidatePassword, this.password,
		(err, isMatch) ->
			if err
				return cb(err)
			cb(null, isMatch)
	)

userSchema.methods.create = (user) ->
	user = new User({email: user.email, password: user.password })
	user.save()


userModel = mongoose.model('User', userSchema)

# If there are no users in the DB and the default user is
# set in env variables create the inital user
if process.env.DEFAULT_USER and process.env.DEFAULT_PASS
	userModel.count (err, count) ->
		if count is 0
			userModel.create({ email: process.env.DEFAULT_USER, password: process.env.DEFAULT_PASS })

module.exports = userModel