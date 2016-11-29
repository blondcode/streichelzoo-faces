#!/bin/bash -eu

# Download Google Fonts

# (c) 2015 Stefan Katerkamp

declare -a families

skatfonts() {
families+=('Open Sans:700')
families+=('Open Sans:700italic')
families+=('Open Sans:800')
families+=('Open Sans:800italic')
families+=('Open Sans:400italic')
families+=('Open Sans:300')
families+=('Open Sans:300italic')
families+=('Open Sans:400')
families+=('Open Sans:600')
families+=('Open Sans:600italic')
families+=('UnifrakturCook:700')
families+=('UnifrakturMaguntia:400')
families+=('Salsa:400')
families+=('Lobster:400')
families+=('Courgette:400')
families+=('Permanent Marker:400')
families+=('Playball:400')
families+=('Droid Sans Mono:400')
families+=('Noto Serif:400')
families+=('Noto Serif:700')
families+=('Noto Serif Italic:400')
families+=('Noto Serif Italic:700')
families+=('Noto Serif Bold Italic:700')
}

skatfonts

# some google fonts have bad local names
declare -a fixnames
fixnames+=(OpenSansLight-Italic:OpenSans-LightItalic)

usage() {
	cat <<EOR
$0 [options] <jsfresourcename> <jsffontdir>
Options:
-q query Google only and print names
-d download fonts
EOR
	exit
}

download=""
queryonly=""
while getopts "qd" option; do
    case $option in
    q)  queryonly=true ;;
    d)  download=true ;;
    *)  usage
        exit 1
        ;;
    esac
done
shift $(($OPTIND - 1))

if [ $# -eq 0 -a "$download" == "true" ]; then
	usage
fi

jsfResourceName="streichelzoo"
jsfFontResource="fonts"
jsfCssResource="css"
jsfResourceDir=""
if [ $# -eq 2 ]; then
	jsfResourceName=${1}
	jsfResourceDir=${2}

	if [ ! -r $jsfResourceDir/$jsfFontResource ]; then
		echo "Mising Fonts Dir: $jsfResourceDir/$jsfFontResource"
		exit 1
	fi
	if [ ! -r $jsfResourceDir/$jsfCssResource ]; then
		echo "Mising CSS Dir: $jsfResourceDir/$jsfCssResource"
		exit 1
	fi
fi

cssFontsFile="gfonts.css"
logfile=/tmp/gfonts.log

echo log is in $logfile

gfontsurl="http://fonts.googleapis.com/css"

# Depending on user agent string, Google returns different formats
# Got this from https://github.com/neverpanic/google-font-download
declare -A useragent
useragent[eot]='Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'
useragent[woff]='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:27.0) Gecko/20100101 Firefox/27.0'
useragent[svg]='Mozilla/4.0 (iPad; CPU OS 4_0_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/4.1 Mobile/9A405 Safari/7534.48.3'
useragent[ttf]='Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.54.16 (KHTML, like Gecko) Version/5.1.4 Safari/534.54.16'

localFontDir=""
localFontName=""
fontFamily=""
fontStyle=""
fontWeight=""
getfontcss() {
	family="$1"
	css=$(curl -sf --get --data-urlencode "family=$family" $gfontsurl)
	if [ $? -ne 0 ]; then
		echo "Font family not found: $family"
		echo "Fix this."
		exit 1
	fi

	# last local expression in line seems to work
	localFontName="$(echo $css | sed -E -e 's/.* local\(//' -e 's/\).*//')"
	localFontName=${localFontName//\'/}
	for name in "${fixnames[@]}"; do
		oldname=${name%%:*}
		newname=${name##*:}
		if [ "$localFontName" == "$oldname" ]; then
			localFontName=$newname
		fi
	done
	localFontDir="${localFontName/-*/}"

	fontFamily="$(echo $css|sed -E -e 's/.*font-family: //' -e 's/;.*//')"
	fontFamily="${fontFamily//\'/}"

	fontStyle="$(echo $css|sed -E -e 's/.*font-style: //' -e 's/;.*//')"
	fontStyle="${fontStyle//\'/}"

	fontWeight="$(echo $css|sed -E -e 's/.*font-weight: //' -e 's/;.*//')"
	fontWeight="${fontWeight//\'/}"
}

getfonturl() {
	family="$1"
	ua="$2"
	uakey="$3"
	css=$(curl -sf -A "$ua" --get --data-urlencode "family=$family" $gfontsurl)
	echo curl -sf -A "$ua" --get --data-urlencode "family=$family" $gfontsurl >> $logfile
	echo "Format: $uakey" >> $logfile
	echo "UA: $ua" >> $logfile
	echo "Google provided CSS: $css" >> $logfile
	url=$(echo $css | sed -e 's/.*url(//' -e 's/).*//')
	echo "URL: $url" >> $logfile
	echo $url
}

if [ "$queryonly" == "true" ]; then
	echo $(date) > $logfile
	for family in "${families[@]}"; do
		getfontcss "$family"
		echo -e "\n$family font: $localFontDir/$localFontName"
		echo fontFamily: $fontFamily
		echo fontStyle: $fontStyle
		echo fontWeight: $fontWeight

		echo -e "\n$family" >> $logfile
		echo "$family font: $localFontDir/$localFontName" >> $logfile
		echo $css >> $logfile
		
	done
	echo
	echo logfile is $logfile
	exit
fi

if [ "$download" != "true" ]; then
	echo "If you wish to download the fonts, specify -d option."
	usage
fi

fontface() {
	cat <<EOR

@font-face {
	font-family: '$fontFamily';
	font-style:  $fontStyle;
	font-weight: $fontWeight;
	src: url("#{resource['$jsfResourceName:$jsfFontResource/$localFontDir/$localFontName.eot']}");
	src: url("#{resource['$jsfResourceName:$jsfFontResource/$localFontDir/$localFontName.eot']}?#iefix") format('embedded-opentype'),
	     url("#{resource['$jsfResourceName:$jsfFontResource/$localFontDir/$localFontName.woff']}") format('woff'),
	     url("#{resource['$jsfResourceName:$jsfFontResource/$localFontDir/$localFontName.ttf']}") format('truetype'),
	     url("#{resource['$jsfResourceName:$jsfFontResource/$localFontDir/$localFontName.svg']}#$fontId") format('svg');
}
EOR
}

[ -d "$jsfResourceDir/$jsfFontResource" ] || mkdir -p "$jsfResourceDir/$jsfFontResource"
[ -d "$jsfResourceDir/$jsfCssResource" ] || mkdir -p "$jsfResourceDir/$jsfCssResource"

if [ -r $jsfResourceDir/$jsfCssResource/$cssFontsFile ]; then 
	echo "WARNING:"
	echo "A CSS fonts file existed."
	echo "It has been saved in /tmp/$cssFontsFile. Check and eventually merge."
	cp $jsfResourceDir/$jsfCssResource/$cssFontsFile /tmp/$cssFontsFile
fi
echo "/* CSS Fonts file created $(date) by $0 */" > $jsfResourceDir/$jsfCssResource/$cssFontsFile
echo "Google Fonts Download Log $(date)" > $logfile

echo "CSS file created: $jsfResourceDir/$jsfCssResource/$cssFontsFile"

for family in "${families[@]}"; do

	echo "Family: $family" >> $logfile

	getfontcss "$family"
	echo "Local Font Name: $localFontName" >> $logfile
  	thisfont=$jsfFontResource/$localFontDir/$localFontName
	echo "thisfont: $thisfont" >>$logfile
  	echo -n "$family ($localFontName) $thisfont "

  	for uakey in eot woff ttf svg; do
      		echo -n "$uakey:"

		fontURL=$(getfonturl "$family" "${useragent[$uakey]}" $uakey)
		#case "$uakey" in
		#svg)
		#	#fontURL=$(getfonturl "$family" "${useragent[$uakey]}" "http:\\/\\/[^\\)]+" $uakey)
		#	;;
		#*)
		#	fontURL=$(getfonturl "$family" "${useragent[$uakey]}" "http:\\/\\/[^\\)]+\\.$uakey" $uakey)
		#	;;
		#esac

		status=FAIL
      		echo "Getting file $jsfResourceDir/$thisfont.$uakey" >> $logfile
      		echo curl -sfL "$fontURL" --create-dirs -o "$jsfResourceDir/$thisfont.$uakey" >> $logfile
      		curl -sfL "$fontURL" --create-dirs -o "$jsfResourceDir/$thisfont.$uakey"
		[ $? -eq 0 ] && status=OK

		echo -n "$status "
  		echo "$family ($localFontName) $uakey $fontURL $status" >> $logfile
  	done
	fontId=$(grep "<font id=" $jsfResourceDir/$thisfont.svg | sed -e 's/^.* id="//' -e 's/".*$//')
	echo "Font ID: $fontId" >> $logfile
	fontface >> $jsfResourceDir/$jsfCssResource/$cssFontsFile
	echo "."
done
echo "Log file in $logfile"
exit 0

