# Polizeiticker Übersicht widget
# Displays latest headlines from the Polizeiticker.ch RSS (in German)

# ## CONFIGURATION ######################################################################
max_items = 8 # how many headlines you want displayed, at most
scroll_time = "100s" # How much time until the ticker has traveled across the screen
# Notice: the longer the ticker, the faster it will go to fulfill a scroll_time
headlines_color = "white" # What font colou you want to see the headlines in
first_hl_color = "black" # If you want the first (and newest) item in a different colour
bg_color = "orange" # The colour of the background, the ticker itself
# Notice: the colours should be valid CSS names or values (e.g "BurlyWood" or "#DEB887")
position = "bottom" # Where on the screen you want the ticker: "top" or "bottom"

##########################################################################################
# IMAGE LICENCES FOR THE CANTONS' COATS OF ARMS:
# Zürich: By Stadt Zürich, see https://commons.wikimedia.org/wiki/File:Wappen_Z%C3%BCrich_matt.svg, via Wikimedia Commons
# Bern: See https://commons.wikimedia.org/wiki/File%3AWappen_Bern_matt.svg, via Wikimedia Commons
# Luzern: See https://commons.wikimedia.org/wiki/File%3AWappen_Luzern_matt.svg, from Wikimedia Commons
# Uri: See https://commons.wikimedia.org/wiki/File%3AWappen_Uri_matt.svg, from Wikimedia Commons
# Schwyz: See https://commons.wikimedia.org/wiki/File%3AWappen_des_Kantons_Schwyz.svg, from Wikimedia Commons
# Obwalden: See https://commons.wikimedia.org/wiki/File%3AWappen_Obwalden_matt.svg, from Wikimedia Commons
# Nidwalden: See https://commons.wikimedia.org/wiki/File%3AWappen_Nidwalden_matt.svg, from Wikimedia Commons
# Glarus: See https://commons.wikimedia.org/wiki/File%3AWappen_Glarus_matt.svg, from Wikimedia Commons
# Zug: See https://commons.wikimedia.org/wiki/File%3AWappen_Zug_matt.svg, from Wikimedia Commons
# Freiburg: See https://commons.wikimedia.org/wiki/File%3AWappen_Freiburg_matt.svg, from Wikimedia Commons
# Solothurn: See https://commons.wikimedia.org/wiki/File%3AWappen_Solothurn_matt.svg, from Wikimedia Commons
# Basel-Stadt: See https://commons.wikimedia.org/wiki/File%3AWappen_Basel-Stadt_matt.svg, from Wikimedia Commons
# Basel-Landschaft:By Otto Plattner and Jwnabd, see https://commons.wikimedia.org/wiki/File%3ACoat_of_arms_of_Kanton_Basel-Landschaft.svg, from Wikimedia Commons
# Schaffhausen: See https://commons.wikimedia.org/wiki/File%3AWappen_Schaffhausen_matt.svg, from Wikimedia Commons
# Appenzell-Ausserrhoden: See https://commons.wikimedia.org/wiki/File%3AWappen_Appenzell_Ausserrhoden_matt.svg, from Wikimedia Commons
# Appenzell-Innerrhoden: See https://commons.wikimedia.org/wiki/File%3AWappen_Appenzell_Innerrhoden_matt.svg, from Wikimedia Commons
# Sankt Gallen: By Jwnabd, see https://commons.wikimedia.org/wiki/File%3ACoat_of_arms_of_canton_of_St._Gallen.svg, from Wikimedia Commons
# Graubünden: See https://commons.wikimedia.org/wiki/File%3AWappen_Graub%C3%BCnden_matt.svg, from Wikimedia Commons
# Aargau: See https://commons.wikimedia.org/wiki/File%3AWappen_Aargau_matt.svg, from Wikimedia Commons
# Thurgau: See https://commons.wikimedia.org/wiki/File%3AWappen_Thurgau_matt.svg, from Wikimedia Commons
# Tessin: See https://commons.wikimedia.org/wiki/File%3AWappen_Tessin_matt.svg, from Wikimedia Commons
# Waadt: See https://commons.wikimedia.org/wiki/File%3AWappen_Waadt_matt.svg, from Wikimedia Commons
# Wallis: See https://commons.wikimedia.org/wiki/File%3AWappen_Wallis_matt.svg, from Wikimedia Commons
# Neuenburg: See https://commons.wikimedia.org/wiki/File%3AWappen_Neuenburg_matt.svg, from Wikimedia Commons
# Genf: See https://commons.wikimedia.org/wiki/File%3AWappen_Genf_matt.svg, from Wikimedia Commons
# Jura: See https://commons.wikimedia.org/wiki/File%3AWappen_Jura_matt.svg, from Wikimedia Commons


command: "python polizeiticker.widget/getnews.py"
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

	swiss_cantons = ["ZH", "BE", "LU", "UR", "SZ", "OW", "NW", "GL", "ZG", "FR", "SO", "BS", "BL", "SH", "AR", "AI", "SG", "GR", "AG", "TG", "TI", "VD", "VS", "NE", "GE", "JU"]

	if newslist.length < max_items
		max_iterations = newslist.length
	else
		max_iterations = max_items
	for i in [1..max_iterations]
		if newslist[i-1][0] not in swiss_cantons
			coat_of_arms = "polizeiticker.widget/images/XX.png"
		else
			coat_of_arms = "polizeiticker.widget/images/" + newslist[i-1][0] + ".png"
		$(domEl).find("#canton#{i}").attr "src", coat_of_arms # Canton
		$(domEl).find("#place#{i}").text newslist[i-1][1] + ": " # Place
		$(domEl).find("#story#{i}").text newslist[i-1][2] + " ••• " # Title
		$(domEl).find("#story#{i}").attr "href", newslist[i-1][3] # URL
		######################### TO DO ###############################
		#                                                             #
		#          WHY CAN'T I GET THE LINKS CLICKABLE?               #
		#                                                             #
		###############################################################

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

