###
server.coffee
FlashCause!
- 2014-02-06: created.
###

stylus=require 'stylus'
level=require 'level'
db=level 'store'

require('zappajs') ->
	@use 'partials'
	@enable 'default layout'
	@with css:'stylus'

	@view index:->
		h1 @title
		section 'Blurb…'
		video
		button 'Shoot!'

	@on 'events':->
		@emit 'events',['Hackathon']

	@client '/app.js':->
		@connect()
		$ =>
			console.log 'It works!'
			#$('h1').text 'It works!'
			$('html').addClass 'mw'
			@emit 'events'
		#@on 'events':(data)->
			#

	@get '*':->
		@render index:
			title:'FlashCause'
			scripts:'''
				/zappa/Zappa-simple.js
				/app.js
				'''.match /[^\s]+/g
			stylesheets:'''
				'''.match /[^\s]+/g
			style: stylus.render '''
body
	font-family Ubuntu,sans-serif
'''
