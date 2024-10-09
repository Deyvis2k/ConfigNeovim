#!/bin/bash

filename="$1"
file_ext="${filename##*.}"
dir_name=$(dirname "$filename") 

if [ -f "$dir_name/Makefile" ]; then
    echo "Compilando usando o Makefile em $dir_name"
    (cd "$dir_name" && make)  
else
    if [ "$file_ext" = "cpp" ]; then
        echo "Compilando C++ $filename"
        g++ "$filename" -o "${filename%.*}"
    else
        echo "Compilando C $filename"
        gcc "$filename" -o "${filename%.*}"
    fi
fi

if [ $? -eq 0 ]; then
    if [[ "$filename" == /* ]]; then
        "${filename%.*}"  
    else
        ./"${filename%.*}"
    fi
else
    echo "Compilação falhou"
    exit 1
fi
