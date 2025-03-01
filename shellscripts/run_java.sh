#!/bin/bash

filename="$1"
classfile="${filename%.*}.class"
classname=$(basename "${filename%.*}")  
classdir=$(dirname "$filename")         

javac "$filename"

if [ $? -eq 0 ]; then
    (cd "$classdir" && java "$classname")
else
    echo "Compilação falhou"
    exit 1
fi
