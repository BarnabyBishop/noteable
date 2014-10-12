express = require('express')
router = express.Router()
mongoose = require('mongoose')


router.get('/', (req, res) ->
	res.render('index')
)

router.get('/notes', (req, res) ->
	Note = mongoose.model('Note')
	Note.find((err, notes) ->
		if err
			console.error(err)
		res.json(notes)
	)
)

router.get('/:id', (req, res) ->
	res.json({})
)


router.post('/savenote', (req, res) ->
	console.log JSON.stringify req.body
	id = req.body._id
	savedNote =
		title: req.body.title
		text: req.body.text

	Note = mongoose.model('Note')
	Note.findOneAndUpdate({ _id: id }, savedNote, (err, note) ->
		if err
			console.error(err)
		else
			console.info('saved: ' + note)

	)
)

module.exports = router
