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


module.exports = router
