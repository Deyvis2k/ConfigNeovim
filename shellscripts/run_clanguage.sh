#!/bin/bash

filename="$1"
file_ext="${filename##*.}"
dir_name=$(dirname "$filename") 

if [ -f "$dir_name/Makefile" ]; then
    echo "Compilando usando o Makefile em $dir_name"
    (cd "$dir_name" && make)  
else

# Pegar o caminho do Makefile (diretório pai)
if [ -f "$(dirname "$filename")/Makefile" ]; then
    echo "compilando em $(dirname "$filename")"
    dir_name="$(dirname "$filename")"
else
    dir_name="$(dirname "$(dirname "$filename")")"
fi

# Verificar se o Makefile está dentro do diretório build e executar make lá
build_dir="$dir_name/build"
if [ -f "$build_dir/Makefile" ]; then
    echo "Makefile encontrado em $build_dir. Executando make..."
    (cd "$build_dir" && make)
else
    # Compilar manualmente se não encontrar o Makefile
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
# Pegar o caminho do executável (gerado na pasta nvim/temp/build.txt)
build_file="$HOME/.config/nvim/temp/build.txt"
if [ -f "$build_file" ]; then
    filename_path=$(head -n 1 "$build_file")
else
    echo "Erro: Arquivo $build_file não encontrado"
    exit 1
fi

# Verifica se o executável existe antes de tentar rodá-lo
exec_path="$filename_path/$(basename "${filename%.*}")"
if [ -x "$exec_path" ]; then
    "$exec_path"
else
    echo "Erro: O arquivo $exec_path não é executável ou não foi encontrado."
    exit 1
fi

