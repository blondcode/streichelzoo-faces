BASEDIR=../../../..
STYLESDIR=$(BASEDIR)/target/classes/foundation-sites/dist/ 
NS=-N n="http://www.w3.org/1999/xhtml" 


complex:
	#asciidoctor -b xhtml5  -a linkcss -a stylesheet=foundation.css -a stylesdir=$(STYLESDIR) -o complex.tmp.html complex.adoc
	asciidoctor -b xhtml5  -o complex.tmp.html complex.adoc
	-tidy5 -q -asxml -i complex.tmp.html  2>/dev/null
	cat header.txt > complex.tmp.xhtml
	xmlstarlet sel $(NS) -t  -c "/n:html/n:body"  complex.tmp.html >> complex.tmp.xhtml
	cat footer.txt >> complex.tmp.xhtml
	-tidy5 -q -asxml -i complex.tmp.xhtml  2>/dev/null
	
clean:
	rm -f complex.tmp.xhtml complex.tmp.html node_modules
