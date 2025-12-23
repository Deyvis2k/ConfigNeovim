#!/usr/bin/env python3
import os
import sys
import subprocess
import shlex
from enum import Enum

class Colors(Enum):
    RED = "\033[1;31m"
    GREEN = "\033[1;32m"
    YELLOW = "\033[1;33m"
    BLUE = "\033[1;34m"
    PURPLE = "\033[1;35m"
    CYAN = "\033[1;36m"
    WHITE = "\033[1;37m"
    GRAY = "\033[1;90m"
    RESET = "\033[0m"

class TextFormat(Enum):
    BOLD = "\033[1m"
    ITALIC = "\033[3m"
    UNDERLINE = "\033[4m"
    RESET = "\033[0m"


def ways_to_run_executable(way_to_exec, executable_name):
    ways_to_run_executable = {
        "run with gdb": str.format("gdb -ex run --args {}", executable_name),
        "run with valgrind": str.format("valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --show-reachable=no {}", executable_name),
        "run with lldb": str.format("lldb {} -o 'run' -o 'bt'", executable_name),
        "run normally": str.format("{}", executable_name)
    }
    print(
        str.format(
            "-> {Colors.YELLOW.value}Running {executable_name} with {way_to_exec}{Colors.RESET.value}",
            Colors=Colors,
            executable_name=executable_name,
            way_to_exec=way_to_exec
        )
    )
    return ways_to_run_executable[way_to_exec]


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
            print("Error: build.txt is empty.")
            sys.exit(1)
        splited_content = content.split("\n")
        filename_path = str(after_pattern_partition(splited_content[0], " ")).strip()
        executable_name = str(after_pattern_partition(splited_content[1], " ")).strip()
        total_lines = "⎯" * (len(filename_path) * 2 - 5)
        print(f"-> {Colors.GREEN.value}Compiling and running makefile in \
{TextFormat.ITALIC.value}{filename_path}{TextFormat.RESET.value}\n-> {Colors.GREEN.value}Running \
{TextFormat.UNDERLINE.value}{executable_name}{TextFormat.RESET.value}\n{Colors.RED.value}{total_lines}{Colors.RESET.value}")
except FileNotFoundError:
    print(f"Error: {build_file} does not exist.")
    sys.exit(1)

if len(sys.argv) < 2:
    print("Error: No source file provided.")
    sys.exit(1)

way_to_exec = sys.argv[2] if len(sys.argv) > 2 else "run normally"
file_passed = sys.argv[1]
extra_args: str = sys.argv[3] if len(sys.argv) > 3 else ""
file_ext = os.path.splitext(file_passed)[1][1:]
dir_name = os.path.dirname(filename_path)

makefile_found = False

def final_execution(result):
    if result.returncode == 0:
        exec_path = os.path.join(filename_path, executable_name)
        if os.path.isfile(exec_path) and os.access(exec_path, os.X_OK):
            os.chdir(os.path.dirname(exec_path))
            final_command = ways_to_run_executable(way_to_exec.lower(), exec_path) + f" {extra_args}" \
                if (extra_args.strip() != "") else ways_to_run_executable(way_to_exec.lower(), exec_path)

            subprocess.run(shlex.split(final_command))
        else:
            print(f"Error: {exec_path} is either not found or not executable.")
            sys.exit(1)
    else:
        print("Error: Compilation failed.")
        sys.exit(1)

if os.path.isdir(dir_name) and os.path.isfile(os.path.join(dir_name, "Makefile")):
    result = subprocess.run(["make"], cwd=dir_name)
    makefile_found = True
    final_execution(result)

elif os.path.isdir(os.path.dirname(dir_name)) and os.path.isfile(os.path.join(os.path.dirname(dir_name), "Makefile")):
    parent_dir = os.path.dirname(dir_name)
    result = subprocess.run(["make"], cwd=parent_dir)
    makefile_found = True
    final_execution(result)

elif os.path.isdir(os.path.join(dir_name, "build")) and os.path.isfile(os.path.join(dir_name, "build", "Makefile")):
    build_dir = os.path.join(dir_name, "build")
    result = subprocess.run(["make"], cwd=build_dir)
    makefile_found = True
    final_execution(result)

#Makefile not found
else:
    match file_ext:
        case "c":
            print(f"{Colors.GREEN.value}Compiling C source file: {file_passed}{Colors.RESET.value}")
            print()
            result = subprocess.run(["gcc", file_passed, "-o", os.path.splitext(executable_name)[0]])
            final_execution(result)
            sys.exit(0)
        case "cpp":
            print(f"{Colors.GREEN.value}Compiling C++ source file: {file_passed}{Colors.RESET.value}")
            print()
            result = subprocess.run(["g++", file_passed, "-o", os.path.splitext(executable_name)[0]])
            final_execution(result)
            sys.exit(0)
        case _:
            print(f"Error: Unsupported file extension: {file_ext}")
            sys.exit(1)
