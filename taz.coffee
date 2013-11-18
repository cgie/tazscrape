casper = require('casper').create(
  imageLoad: false
)

base = 'http://www.taz.de/1/archiv/digitaz/'

toc = 'ul.digitaz'

getSections = ->
  sections = document.querySelectorAll('ul.digitaz li a')
  Array::map.call sections, (s) -> s.getAttribute "href"


url = casper.cli.get('url')

getHeadline = ->
  document.querySelector('div.sectbody > h1').innerHTML

getIntro = ->
  document.querySelector('div.sectbody > p.intro').innerHTML

getSubhead = ->
  document.querySelector('div.sectbody > h5').innerHTML

getBlocks = ->
  blocks = document.querySelectorAll "div.sectbody p.article"
  Array::map.call blocks,  (a) -> a.innerHTML

getArticleLinks = ->
  links = document.querySelectorAll "h3 > a"
  Array::map.call links, (link) -> link.innerHTML

processPage = ->
  sections = @evaluate getSections
  @each sections, (self, link) ->
    fullUrl = "http://taz.de" + link
    @thenOpen fullUrl, ->
      @echo "Found #{fullUrl}"
      alinks = @evaluate getArticleLinks
      @each alinks, (s, l) ->
        @echo "\t#{l}"


casper.start base

casper.then ->
  processPage.call @

###
casper.then ->
  sections = @evaluate getSections
  @echo x for x in sections
###

casper.run()

