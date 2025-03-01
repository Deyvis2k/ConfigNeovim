#!/bin/bash

build_file="$HOME/.config/nvim/temp/build.txt"
if [ -f "$build_file" ]; then
    filename_path=$(head -n 1 "$build_file")
    if [ -z "$filename_path" ]; then
        echo "Erro: $build_file está vazio"
        exit 1
    fi
    filename="$filename_path/$(basename "$1")"
else
    echo "Erro: Arquivo $build_file não encontrado"
    exit 1
fi

file_ext="${filename##*.}"
dir_name=$(dirname "$filename")

if [ -f "$dir_name/Makefile" ]; then
    echo "Compilando usando o Makefile em $dir_name"
    (cd "$dir_name" && make)
else
    if [ -f "$(dirname "$dir_name")/Makefile" ]; then
        echo "Compilando em $(dirname "$dir_name")"
        dir_name="$(dirname "$dir_name")"
        (cd "$dir_name" && make)
    else
        build_dir="$dir_name/build"
        if [ -f "$build_dir/Makefile" ]; then
            echo "Makefile encontrado em $build_dir. Executando make..."
            (cd "$build_dir" && make)
        else
            if [ "$file_ext" = "cpp" ]; then
                echo "Compilando C++ $filename"
                g++ "$filename" -o "${filename%.*}"
            else
                echo "Compilando C $filename"
                gcc "$filename" -o "${filename%.*}"
            fi
        fi
    fi
fi

if [ $? -eq 0 ]; then
    exec_path="${filename%.*}"
    if [ -x "$exec_path" ]; then
        "$exec_path"
    else
        echo "Erro: O arquivo $exec_path não é executável ou não foi encontrado."
        exit 1
    fi
else
    echo "Compilação falhou"
    exit 1
fi
