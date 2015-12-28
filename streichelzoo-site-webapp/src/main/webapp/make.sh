#!/bin/bash

#filename=$(basename $1 .ad)
filename=ad-template

echo "$filename.ad --> $filename.xhtml"

args="--out-file=- -b xhtml5 -a linkcss -a stylesheet=adfoundation.css?ln=streichelzoo \
-a iconfont-remote! \
-a iconfont-name=../streichelzoo/css/font-awesome \
-a stylesdir=javax.faces.resource/css"

asciidoctor $args $filename.ad > $filename.xhtml
