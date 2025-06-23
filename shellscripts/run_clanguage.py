#!/usr/bin/env python3
import os
import sys
import subprocess

current_dir = os.getcwd()
build_file = os.path.join(current_dir, "build.txt")
executable_name = ""

def after_pattern_partition(s: str, pattern: str) -> str | None:
    before, sep, after = s.partition(pattern)
    return after if sep else None

try:
    with open(build_file, 'r') as f:
        content = f.read().strip()
        if not content:
            print("Erro: build.txt está vazio")
            sys.exit(1)
        splited_content = content.split("\n")
        filename_path = str(after_pattern_partition(splited_content[0], " ")).strip()
        executable_name = str(after_pattern_partition(splited_content[1], " ")).strip()
        print("""-> \033[1;32mCompilando e usando o Makefile em {}\033[0m\n-> \033[1;32mExecutando \033[4m{}\033[0m \033[0m
\033[1;37m⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\033[0m"""
        .format(filename_path, executable_name))
except FileNotFoundError:
    print(f"Erro: {build_file} não existe")
    sys.exit(1)

if len(sys.argv) < 2:
    print("Erro: Nenhum arquivo de código fonte foi fornecido.")
    sys.exit(1)

filename = os.path.join(filename_path, os.path.basename(sys.argv[1]))
file_ext = os.path.splitext(filename)[1][1:]
dir_name = os.path.dirname(filename)

makefile_found = False

if os.path.isdir(dir_name) and os.path.isfile(os.path.join(dir_name, "Makefile")):
    result = subprocess.run(["make"], cwd=dir_name)
    makefile_found = True

elif os.path.isdir(os.path.dirname(dir_name)) and os.path.isfile(os.path.join(os.path.dirname(dir_name), "Makefile")):
    parent_dir = os.path.dirname(dir_name)
    result = subprocess.run(["make"], cwd=parent_dir)
    makefile_found = True

elif os.path.isdir(os.path.join(dir_name, "build")) and os.path.isfile(os.path.join(dir_name, "build", "Makefile")):
    build_dir = os.path.join(dir_name, "build")
    result = subprocess.run(["make"], cwd=build_dir)
    makefile_found = True

else:
    if file_ext == "cpp":
        print(f"Compilando C++ {filename}")
        result = subprocess.run(["g++", filename, "-o", os.path.splitext(filename)[0]])
    else:
        print("\033[1;33mCompilando C em {}\033[0m".format(filename))
        result = subprocess.run(["gcc", filename, "-o", os.path.splitext(filename)[0]])

if result.returncode == 0:
    exec_path = os.path.join(filename_path, executable_name)
    if os.path.isfile(exec_path) and os.access(exec_path, os.X_OK):
        subprocess.run([exec_path])
    else:
        print(f"Erro: O arquivo {exec_path} não é executável ou não foi encontrado.")
        sys.exit(1)
else:
    print("Compilação falhou")
    sys.exit(1)
