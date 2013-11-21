# Web Scraper for taz.de in Coffeescript
# You will need PhantomJS and CasperJS
# The outpout is plain Markdown

casper = require('casper').create(
  imageLoad: false
)

tazhome = 'http://www.taz.de/1/archiv/digitaz/'
base = "http://www.taz.de"

# Scraping Methods

getDate = ->
  pipes = document.querySelectorAll "div#date > span.I"
  Array::map.call pipes, (p) -> p.innerText = "."
  document.querySelector('div#date').innerText

getCategory = ->
  document.querySelector('ul.digitaz li.red').innerText

getCategoryLinks = ->
  sections = document.querySelectorAll('ul.digitaz li a')
  Array::map.call sections, (s) -> s.getAttribute "href"

getHeadline = ->
  document.querySelector('div.sectbody > h1').innerText

getSubhead = ->
  document.querySelector('div.sectbody > h5').innerText

getBlocks = ->
  blocks = document.querySelectorAll "div.sectbody p.article"
  Array::map.call blocks,  (a) -> a.innerText

getArticleLinks = ->
  links = document.querySelectorAll "h3 > a"
  Array::map.call links, (link) -> link.getAttribute "href"

processPage = ->
  # First Level: scrape all category-links of the newspaper
  categories = @evaluate getCategoryLinks
  @each categories, (self, link) ->
    fullUrl = base + link
    @thenOpen fullUrl, ->
      category = @evaluate getCategory # the category's name
      @echo "## #{category}\n"
      # Second Level: scrape all article links of the current category
      alinks = @evaluate getArticleLinks
      @each alinks, (s, l) ->
        articleurl = "http://taz.de/" + l
        @thenOpen articleurl, ->
          # actual content scraping
          headline = @evaluate getHeadline
          subhead = @evaluate getSubhead
          blocks = @evaluate getBlocks
          @echo  "### " + headline + "\n" if headline
          @echo "\*" + subhead + "\*\n" if subhead
          @each blocks, (x, y) ->
            @echo y + "\n" if y

# Start browsing
casper.start tazhome

# Print the head of the resulting markdown file
casper.then ->
  date = @evaluate getDate
  @echo """
        % taz - die tageszeitung
        %
        % #{date}

        # taz - die tageszeitung (#{date})

        """

# Invoke processPage in order to scrape the website
casper.then ->
  processPage.call @

casper.run()

