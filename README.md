# tazscrape

A simple webscraper for the newspaper website taz.de.
You will need
  * PhantomJS
  * CasperJS
  * Pandoc

The script `taz.coffee` scrapes the text contents of the current issue
and outputs them in Markdown to the standard output.

Invocation:
```
casperjs taz.coffee | pandoc taz.md --standalone --smart --toc --template bootstrap.html5 > taz.html
```

Or, if you like reading everything as a manpage:
```
casperjs taz.coffee | pandoc taz.md -s -f markdown -t man | man -l -
```
