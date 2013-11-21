# tazscrape

A simple webscraper for the newspaper website taz.de.
You will need
  * PhantomJS
  * CasperJS
  * I recommend Pandoc for further processing the output

The script `taz.coffee` scrapes the text contents of the current issue
and outputs them in Markdown to the standard output.

Invocation:

If you like reading your newspaper like a manpage
```
casperjs taz.coffee | pandoc -s -f markdown -t man | man -l -
```

which looks like this for me

![manpage view of the newspaper](https://raw.github.com/cgie/tazscrape/master/img/taz.png)

