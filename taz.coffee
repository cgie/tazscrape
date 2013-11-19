casper = require('casper').create(
  imageLoad: false
)

tazhome = 'http://www.taz.de/1/archiv/digitaz/'
base = "http://www.taz.de"


getDate = ->
  document.querySelector('div#date').innerText
getCategory = ->
  document.querySelector('ul.digitaz li.red').innerText

getCategoryLinks = ->
  sections = document.querySelectorAll('ul.digitaz li a')
  Array::map.call sections, (s) -> s.getAttribute "href"

url = casper.cli.get('url')

getHeadline = ->
  document.querySelector('div.sectbody > h1').innerText

getIntro = ->
  document.querySelector('div.sectbody > p.intro').innerText

getSubhead = ->
  document.querySelector('div.sectbody > h5').innerText

getBlocks = ->
  blocks = document.querySelectorAll "div.sectbody p.article"
  Array::map.call blocks,  (a) -> a.innerText

getArticleLinks = ->
  links = document.querySelectorAll "h3 > a"
  Array::map.call links, (link) -> link.getAttribute "href"

processPage = ->
  sections = @evaluate getCategoryLinks
  @each sections, (self, link) ->
    fullUrl = base + link
    @thenOpen fullUrl, ->
      category = @evaluate getCategory
      @echo "## #{category}\n" 
      alinks = @evaluate getArticleLinks
      @each alinks, (s, l) ->
        articleurl = "http://taz.de/" + l
        @thenOpen articleurl, ->
          headline = @evaluate getHeadline
          subhead = @evaluate getSubhead
          blocks = @evaluate getBlocks
          @echo  "### " + headline + "\n" if headline
          @echo "\*" + subhead + "\*\n" if subhead
          @each blocks, (x, y) ->
            @echo y + "\n" if y


casper.start tazhome

casper.then ->
  @echo "# taz - die tageszeitung\n\n"

casper.then ->
  processPage.call @

casper.run()

