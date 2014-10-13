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
