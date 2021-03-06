# Polizeiticker Übersicht widget
# Displays latest headlines from the Polizeiticker.ch RSS (in German)

# ## CONFIGURATION ############################################################

max_items = 8	# how many headlines you want displayed, at most.
             	# Wieviele Nachrichten auf Bildschirm, maximal.
scroll_time = "50s"	# How much time until the ticker has traveled across the screen.
                   	# Wieviel Zeit bis alle Nachrichten durch die Bildschirm Breite vorbei sind.
# Notice: the longer the ticker, the faster it will go to fulfill a scroll_time.
# Achtung: je länger der Ticker, desto schneller muss es gehen um den Zeit zu erreichen.

headlines_color = "white"	# What font colou you want to see the headlines in.
                         	# Welche Farbe für das Schrift den Nachrichten.
first_hl_color = "black"	# If you want the first (and newest) item in a different colour.
                        	# Welche Farbe für das Schrift der erste (und neuste) Nachricht.
bg_color = "orange"	# The colour of the background, the ticker itself.
                   	# Welche Farbe für den Hintergrund des Tickers.
# Notice: the colours should be valid CSS names or values (e.g. "BurlyWood" or "#DEB887").
# Achtung: die Farben mussen gültige CSS Namen oder Werte sein (z.B. "BurlyWood" oder "#DEB887").

position = "top"	# Where on the screen you want the ticker: "top" or "bottom"
                	# Ob der Ticker oben (top) oder unten (bottom) sein soll.


################ END OF CONFIGURATION, PROCEED AT YOUR OWN RISK ################
################################################################################

# IMAGE LICENCES:
# SEE THE CORRESPONDING LICENCE FILE IN THE REPO.

command: "polizeiticker.widget/getnews"
refreshFrequency: 1000 * 60 * 5

render: (_) -> """
	
	<div class="ticker-wrap">
		<div id="ticker">
		</div>
	</div>
"""

afterRender: (domEl) -> # I don't know how to do it in Coffeescript
	`function additem(idnr) {
		var theid = "item" + i
		var theid_canton = "canton" + i
		var theid_place = "place" + i
		var theid_description = "story" + i
		var child = document.createElement("div");
		if (theid === "item1") {
			child.className = "ticker_item firstitem";
		} else {
			child.className = "ticker_item";
		}
		child.setAttribute("id", theid);
		child.innerHTML = '<img id="' + theid_canton + '" src=""></> \
		<span> \
		<p id="' + theid_place + '"></p> \
		<a id="' + theid_description + '" href="#"></a> \
		</span>'
		parent = document.getElementById("ticker");
		parent.appendChild(child);
	}`
	for i in [1..max_items]
		additem(i)
	$(domEl).find(".ticker-wrap").width screen.width + "px"
	$(domEl).find(".ticker-wrap").css position, "0px"

update: (output, domEl) ->
	# Get the JSON object containing all the tasks
	jsonObj = JSON.parse(output)

	count = 0
	for item in jsonObj
		count += 1
		coat_of_arms = "polizeiticker.widget/images/" + item["region"] + ".png"
		$(domEl).find("#canton#{count}").attr "src", coat_of_arms
		$(domEl).find("#place#{count}").text item["place"]
		$(domEl).find("#story#{count}").text item["headline"]
		$(domEl).find("#story#{count}").attr "href", item["link"]
		if count == max_items
			break

style: """
	color: #fff
	font-family: Helvetica
	background: rgba(#000, 0.5)

	left: 0px
	width: 320px
	font-size: 16px

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
		background-color: #{bg_color}
		width: 100%
		overflow: hidden
		height: 1.5rem
		padding-left: 100%
	#ticker
		display: inline-block
		background-color: #{bg_color}
		height: 1.5rem
		line-height: 1.5rem
		white-space: nowrap
		padding-right: 100%
		-webkit-animation-iteration-count: infinite
		-webkit-animation-timing-function: linear
		-webkit-animation-name: ticker
		-webkit-animation-duration: #{scroll_time}
		animation-iteration-count: infinite
		animation-timing-function: linear
		animation-name: ticker
		animation-duration: #{scroll_time}
	.ticker_item
		display: inline-block
		padding: 0 0.75rem
		font-size: 1rem
		color: #{headlines_color}
	.firstitem
		font-weight: bold
		color: #{first_hl_color}
	.ticker_item img
		vertical-align: middle
		height: 1.25rem
	.ticker_item span p
		display: inline
	.ticker_item span a
		&:link
		&:visited
		&:hover
		&:active
			text-decoration: none
			color: inherit
"""

