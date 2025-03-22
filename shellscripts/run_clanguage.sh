#!/bin/bash

current_dir="$PWD"
build_file="$current_dir/build.txt"

if [ -s "$build_file" ]; then
    filename_path="$(cat "$build_file")"
else
    echo "Erro: $build_file está vazio ou não existe"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Erro: Nenhum arquivo de código fonte foi fornecido."
    exit 1
fi

filename="$filename_path/$(basename "$1")"
file_ext="${filename##*.}"
dir_name=$(dirname "$filename")

if [ -d "$dir_name" ] && [ -f "$dir_name/Makefile" ]; then
    echo -e "\033[1;31mCompilando usando o Makefile em $dir_name\033[0m"
    (cd "$dir_name" && make)
elif [ -d "$(dirname "$dir_name")" ] && [ -f "$(dirname "$dir_name")/Makefile" ]; then
    dir_name="$(dirname "$dir_name")"
    echo -e "\033[1;32mCompilando usando o Makefile em $dir_name\033[0m"
    (cd "$dir_name" && make)
elif [ -d "$dir_name/build" ] && [ -f "$dir_name/build/Makefile" ]; then
    build_dir="$dir_name/build"
    echo -e "\033[1;32mCompilando usando o Makefile encontrado em $build_dir. Executando make...\033[0m"
    (cd "$build_dir" && make)
else
    if [ "$file_ext" = "cpp" ]; then
        echo "Compilando C++ $filename"
        g++ "$filename" -o "${filename%.*}"
    else
        echo -e "\033[1;33mCompilando C em $filename\033[0m"
        gcc "$filename" -o "${filename%.*}"
    fi
fi

if [ $? -eq 0 ]; then
    exec_path="${filename_path}/main"
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

