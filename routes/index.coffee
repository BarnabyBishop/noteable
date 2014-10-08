express = require('express')
router = express.Router()
mongoose = require('mongoose')

router.render  = (res, selected) ->
	Note = mongoose.model('Note')
	Note.find((err, notes) ->
		if err
			console.error(err)
		res.render('index', title: 'Express', notes:notes, selected: if selected then selected else '')
	)

router.get('/', (req, res) ->
	router.render(res)
)

router.get('/:id', (req, res) ->
	router.render(res, req.params.id)
)


module.exports = router
