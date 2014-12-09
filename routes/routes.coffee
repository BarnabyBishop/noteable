express = require('express')
router = express.Router()
mongoose = require('mongoose')
passport = require('passport')
model = require('../models/model')

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

router.get('/getnotes',
	ensureAuthenticated,
	(req, res) ->
		model.note.get(
			(err, notes) ->
				if err
					console.error(err)
				res.json(notes)
		)
)

router.get('/getfolders',
	ensureAuthenticated,
	(req, res) ->
		model.folder.get(
			(err, folders) ->
				if err
					console.error(err)
				res.json(folders)
		)
)


router.get('/:id',
	ensureAuthenticated,
	(req, res) ->
		res.json({})
)

router.post('/savefolder',
	ensureAuthenticated,
	(req, res) ->
		folder = req.body || {}
		model.folder.save(folder,
			(err, folder) ->
				if err
					console.error(err)
					return res.status(500).end()
				return res.status(200).end()
		)
)

router.post('/savenote',
	ensureAuthenticated,
	(req, res) ->
		note = req.body || {}
		model.note.save(note,
			(err, note) ->
				if err
					console.error(err)
					return res.status(500).end()
				return res.status(200).end()
		)
)

router.post('/deletenote',
	ensureAuthenticated,
	(req, res) ->
		_id = req.body._id
		model.note.delete(_id,
			(err,  note) ->
				if err
					console.error(err)
					return res.status(500).end()
				return res.status(200).end()
		)
)


module.exports = router
