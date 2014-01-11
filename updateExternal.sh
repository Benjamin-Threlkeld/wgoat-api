#!/bin/sh
case "$1" in
"CrazySimpleFormParser")
    curl -o ./source/javascripts/_crazySimpleFormParser.js.coffee https://raw.github.com/Benjamin-Threlkeld/CrazySimpleFormParser/master/CrazySimpleFormParser.coffee 
    ;;
*)
    echo "I dont have have record of dat"
    ;;
esac