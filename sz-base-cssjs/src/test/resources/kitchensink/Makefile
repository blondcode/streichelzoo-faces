BASEDIR=../../../..
STYLESDIR=$(BASEDIR)/target/classes/foundation-sites/dist/ 
NS=-N n="http://www.w3.org/1999/xhtml" 

# TODO: do not link in src, link in project.build.directory

all:	css kitchensink

css:
	ln -f -s $(BASEDIR)/target/classes/node_modules
	gulp sass

kitchensink:
	#asciidoctor -b xhtml5  -a linkcss -a stylesheet=foundation.css -a stylesdir=$(STYLESDIR) -o kitchen-sink.tmp.html kitchen-sink.adoc
	asciidoctor -b xhtml5  -o kitchen-sink.tmp.html kitchen-sink.adoc
	-tidy5 -q -asxml -i kitchen-sink.tmp.html  2>/dev/null
	cat header.txt > kitchen-sink.tmp.xhtml
	xmlstarlet sel $(NS) -t  -c "/n:html/n:body"  kitchen-sink.tmp.html >> kitchen-sink.tmp.xhtml
	cat footer.txt >> kitchen-sink.tmp.xhtml
	-tidy5 -q -asxml -i kitchen-sink.tmp.xhtml  2>/dev/null
	
clean:
	rm -f kitchen-sink.tmp.xhtml kitchen-sink.tmp.html node_modules
