#!/bin/sh
case "$1" in
"CrazySimpleFormParser")
    curl -o ./source/javascripts/_crazySimpleFormParser.js.coffee https://raw.github.com/Benjamin-Threlkeld/CrazySimpleFormParser/master/CrazySimpleFormParser.coffee 
    ;;
"LiveHTML-Object")
    curl -o ./source/javascripts/_liveHTML_Object.js.coffee https://raw.github.com/Benjamin-Threlkeld/LiveHTML-object/master/LiveHTML-object.coffee
    ;;
*)
    echo "I dont have have record of dat"
    ;;
esac