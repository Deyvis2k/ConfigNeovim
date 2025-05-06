#!/usr/bin/env python3
import os
import sys
import subprocess

# Obter o diretório atual
current_dir = os.getcwd()
build_file = os.path.join(current_dir, "build.txt")

# Verificar o arquivo build.txt
try:
    with open(build_file, 'r') as f:
        content = f.read().strip()
        if not content:
            print("Erro: build.txt está vazio")
            sys.exit(1)
        filename_path = content
except FileNotFoundError:
    print(f"Erro: {build_file} não existe")
    sys.exit(1)

# Verificar se foi fornecido um arquivo de código fonte
if len(sys.argv) < 2:
    print("Erro: Nenhum arquivo de código fonte foi fornecido.")
    sys.exit(1)

# Construir o caminho completo do arquivo
filename = os.path.join(filename_path, os.path.basename(sys.argv[1]))
file_ext = os.path.splitext(filename)[1][1:]  # Extensão sem o ponto
dir_name = os.path.dirname(filename)

# Verificar Makefile em diferentes locais
makefile_found = False

# Verificar Makefile no mesmo diretório
if os.path.isdir(dir_name) and os.path.isfile(os.path.join(dir_name, "Makefile")):
    print("\033[1;31mCompilando usando o Makefile em {}\033[0m".format(dir_name))
    result = subprocess.run(["make"], cwd=dir_name)
    makefile_found = True

# Verificar Makefile no diretório pai
elif os.path.isdir(os.path.dirname(dir_name)) and os.path.isfile(os.path.join(os.path.dirname(dir_name), "Makefile")):
    parent_dir = os.path.dirname(dir_name)
    print("\033[1;32mCompilando usando o Makefile em {}\033[0m".format(parent_dir))
    result = subprocess.run(["make"], cwd=parent_dir)
    makefile_found = True

# Verificar Makefile no diretório de build
elif os.path.isdir(os.path.join(dir_name, "build")) and os.path.isfile(os.path.join(dir_name, "build", "Makefile")):
    build_dir = os.path.join(dir_name, "build")
    print("\033[1;32mCompilando usando o Makefile encontrado em {}. Executando make...\033[0m".format(build_dir))
    result = subprocess.run(["make"], cwd=build_dir)
    makefile_found = True

# Compilar com gcc ou g++ se não encontrou Makefile
else:
    if file_ext == "cpp":
        print(f"Compilando C++ {filename}")
        result = subprocess.run(["g++", filename, "-o", os.path.splitext(filename)[0]])
    else:
        print("\033[1;33mCompilando C em {}\033[0m".format(filename))
        result = subprocess.run(["gcc", filename, "-o", os.path.splitext(filename)[0]])

# Verificar se a compilação foi bem-sucedida
if result.returncode == 0:
    exec_path = os.path.join(filename_path, "main")
    if os.path.isfile(exec_path) and os.access(exec_path, os.X_OK):
        # Executar o programa compilado
        subprocess.run([exec_path])
    else:
        print(f"Erro: O arquivo {exec_path} não é executável ou não foi encontrado.")
        sys.exit(1)
else:
    print("Compilação falhou")
    sys.exit(1)
