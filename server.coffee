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
	@io.set 'log level',1 # Shut up already! Lower verbosity.

	@view index:->
		h1 @title
		section ->
			p 'Coolest web app for flash-crowd-funding hacked at Battlehack 2014 Tel-Aviv! With kittens! And Node, Twitter, jQM and kittens! And PayPal API.'
			#???p 'Pitch: crowd-fund with realtime pain sensor and vivid/visibility something…'
		video width:200,height:150,autoplay:'autoplay'
		button 'Feel me!?'

	@on 'events':->
		@emit 'events',['Hackathon']

	@client '/app.js':->
		@connect()
		$ =>
			console.log 'It works!'
			#$('h1').text 'It works!'
			$('html').addClass 'mw'

			# Video — layout, responsive, resize it appropriately, whatever.
			#???

			# Snap a pic!
			v=$('video').get 0

			crash=(err)->
				alert 'ERROR: video capture failed',err.code,err #??? Oy! Alert?!

			if navigator.getUserMedia
				navigator.getUserMedia({video:true,audio:false}
				,(stream)->
					console.log 'start'
					v.src=stream
				,crash)
			else if navigator.webkitGetUserMedia
				navigator.webkitGetUserMedia({video:true,audio:false}
				,(stream)->
					console.log 'start'
					v.src=window.webkitURL.createObjectURL stream
				,crash)
			else if navigator.mozGetUserMedia
				navigator.mozGetUserMedia({video:true,audio:false}
				,(stream)->
					console.log 'start'
					v.src=window.URL.createObjectURL stream
				,crash)
			else
				# Unsupported?
				console.log 'ERROR: can\'t getUserMedia. Report browser and operating system versions to us, please.'
				return

			# Click to shoot.
			$('button').click (ev)->
				cv=$('<canvas width="200" height="150">')
				$('body').append cv
				cv.get(0).getContext('2d').drawImage v,0,0,200,200
				$('video,button').remove() # Don't need them no more.
				return false

			#@emit 'events'

		# Listen to announcements from server.
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
	width 20em
	margin 0 auto
	background url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAAAaklEQVQYV2NkYGAwBuKzQAwC9UA8C4ifQ/n/GaEMkCIfIG6E8iWB9DMgZoQpAOncgmTSfyBbCmQSSAFIEqYTZNIZkE6YSSAGyDi4nUC2CbKb4CphdqK7CaYAbieSb8BuAikASSKblIbsJgCKXBfTNjWx1AAAAABJRU5ErkJggg==") repeat
	text-align center

	&
	button
		font-size 120%
'''
