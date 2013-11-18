casper = require('casper').create(
  imageLoad: false
)

tazhome = 'http://www.taz.de/1/archiv/digitaz/'
base = "http://www.taz.de"

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
  Array::map.call links, (link) -> link.getAttribute "href"

processPage = ->
  sections = @evaluate getSections
  @each sections, (self, link) ->
    fullUrl = base + link
    @thenOpen fullUrl, ->
      @echo "Found #{fullUrl}"
      alinks = @evaluate getArticleLinks
      @each alinks, (s, l) ->
        articleurl = "http://taz.de/" + l
        @echo "Article url: #{articleurl}"
        @thenOpen articleurl, ->
          headline = @evaluate getHeadline
          subhead = @evaluate getSubhead
          blocks = @evaluate getBlocks
          @echo headline unless null
          @echo subhead unless null
          @each blocks, (x, y) ->
            @echo y unless null



casper.start tazhome

casper.then ->
  processPage.call @

###
casper.then ->
  sections = @evaluate getSections
  @echo x for x in sections
###

casper.run()

