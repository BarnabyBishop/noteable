express = require('express')
router = express.Router()
mongoose = require('mongoose')

router.get('/', (req, res) ->

	Note = mongoose.model('Note')
	Note.find((err, notes) ->
		if err
			console.error(err)
		res.render('index', title: 'Express', notes:notes)
	)

)

module.exports = router
