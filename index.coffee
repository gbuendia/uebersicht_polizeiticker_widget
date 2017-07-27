max_items = 5

###########################################################################

command: "python polizeiticker.widget/getnews.py"
refreshFrequency: 1000 * 60 * 5

render: (_) -> """
	
	<div class="ticker-wrap">
		<div id="ticker">
		</div>
	</div>
"""

afterRender: (_) -> # I don't know how to do it in Coffeescript
	`function additem(theid) {
		var child = document.createElement("div");
		if (theid === "item1") {
			child.className = "ticker_item firstitem";
		} else {
			child.className = "ticker_item";
		}
		child.setAttribute("id", theid);
		parent = document.getElementById("ticker");
		parent.appendChild(child);
	}`
	for i in [1..max_items]
		newid = "item#{i}"
		additem(newid)

update: (output, domEl) ->
	# This is ugly, I know :(
	newslist = []
	chunks = output.split("xxx0xxx")
	for chunk in chunks
		newsitem = []
		parts = chunk.split("xxx1xxx")
		info = parts[0].split("xxx2xxx")
		for i in info
			newsitem.push i # canton, place and title
		newsitem.push parts[1] # url
		newslist.push newsitem

	for i in [1..max_items]
		content = "[" + newslist[i-1][0] + " ] " + newslist[i-1][1] + ": " + newslist[i-1][2]
		theid = "#item#{i}" 
		$(domEl).find(theid).text content

style: """
	color: #fff
	font-family: Helvetica
	background: rgba(#000, 0.5)

	left: 0px
	top: 670px
	width: 320px
	/* font-size: 1em */

	/* Pure CSS Ticker by Lewis Carey: https://codepen.io/lewismcarey/pen/GJZVoG */
	@keyframes ticker {
		0% { 
			-webkit-transform: translate3d(0,0,0)
			transform: translate3d(0,0,0)
			visibility: visible
		}
		100% {
			-webkit-transform: translate3d(-100%,0,0)
			transform: translate3d(-100%,0,0)
		}
	
	}
	.ticker-wrap
		position: fixed
		background-color: red
		width: 100%
		overflow: hidden
		height: 1.5rem
		padding-left: 100%
	#ticker
		display: inline-block
		background-color: red
		height: 1.5rem
		line-height: 1.5rem
		white-space: nowrap
		padding-right: 100%
		-webkit-animation-iteration-count: infinite
		-webkit-animation-timing-function: linear
		-webkit-animation-name: ticker
		-webkit-animation-duration: 100s
		animation-iteration-count: infinite
		animation-timing-function: linear
		animation-name: ticker
		animation-duration: 100s
	.ticker_item
		display: inline-block
		padding: 0 0.75rem
		font-size: 1rem
		color: black
	.firstitem
		font-weight: bold
"""

