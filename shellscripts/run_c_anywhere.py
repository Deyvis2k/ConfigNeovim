#!/usr/bin/env python3

import os
import sys
import subprocess
import shlex
import json
import time
from enum import Enum
from pathlib import Path
from typing import Dict, List, Optional, Any
from dataclasses import dataclass

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

@dataclass
class TaskConfig:
    """Represents a task configuration"""
    label: str
    type: str
    command: str
    cwd: str
    args: List[str]
    group: Optional[str] = None
    presentation: Optional[Dict[str, Any]] = None
    options: Optional[Dict[str, Any]] = None
    problem_matcher: Optional[str] = None

class Logger:
    """Enhanced logging with timestamps and better formatting"""
    
    @staticmethod
    def _get_timestamp() -> str:
        return time.strftime("[%H:%M:%S]", time.localtime())
    
    @staticmethod
    def error(*args, **kwargs):
        timestamp = Logger._get_timestamp()
        print(f"{Colors.GRAY.value}{timestamp}{Colors.RESET.value} {Colors.RED.value}ERROR:{Colors.RESET.value}", *args, **kwargs)
    
    @staticmethod
    def info(*args, **kwargs):
        timestamp = Logger._get_timestamp()
        print(f"{Colors.GRAY.value}{timestamp}{Colors.RESET.value} {TextFormat.BOLD.value}{Colors.GREEN.value}INFO:{Colors.RESET.value}", *args, **kwargs)
    
    @staticmethod
    def warning(*args, **kwargs):
        timestamp = Logger._get_timestamp()
        print(f"{Colors.GRAY.value}{timestamp}{Colors.RESET.value} {Colors.YELLOW.value}WARNING:{Colors.RESET.value}", *args, **kwargs)
    
    @staticmethod
    def debug(*args, **kwargs):
        timestamp = Logger._get_timestamp()
        print(f"{Colors.GRAY.value}{timestamp}{Colors.RESET.value} {Colors.BLUE.value}DEBUG:{Colors.RESET.value}", *args, **kwargs)
    
    @staticmethod
    def success(*args, **kwargs):
        timestamp = Logger._get_timestamp()
        print(f"{Colors.GRAY.value}{timestamp}{Colors.RESET.value} {Colors.GREEN.value}SUCCESS:{Colors.RESET.value}", *args, **kwargs)

class TaskRunner:
    """Enhanced task runner with VS Code-like features"""
    
    def __init__(self, config_dir: str = ".nvim_bany"):
        self.config_dir = Path(config_dir)
        self.cwd = Path.cwd()
        self.config_path = self.cwd / self.config_dir
        
        # Ensure config directory exists
        self.config_path.mkdir(exist_ok=True)
    
    def _load_json_config(self, file_path: Path) -> Dict[str, Any]:
        """Load and validate JSON configuration file"""
        try:
            if not file_path.exists():
                Logger.error(f"Configuration file not found: {file_path}")
                return {}
            
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                
            if not data:
                Logger.error(f"Empty configuration file: {file_path}")
                return {}
                
            return data
            
        except json.JSONDecodeError as e:
            Logger.error(f"Invalid JSON in {file_path}: {e}")
            return {}
        except Exception as e:
            Logger.error(f"Error reading {file_path}: {e}")
            return {}
    
    def _parse_task_config(self, task_data: Dict[str, Any]) -> Optional[TaskConfig]:
        """Parse task configuration with validation"""
        try:
            return TaskConfig(
                label=task_data.get("label", "Unknown Task"),
                type=task_data.get("type", "shell"),
                command=task_data["command"],
                cwd=task_data.get("cwd", "."),
                args=task_data.get("args", []),
                group=task_data.get("group"),
                presentation=task_data.get("presentation"),
                options=task_data.get("options"),
                problem_matcher=task_data.get("problemMatcher")
            )
        except KeyError as e:
            Logger.error(f"Missing required field in task configuration: {e}")
            return None
    
    def _execute_command(self, task: TaskConfig, show_output: bool = True) -> tuple[int, str, str]:
        """Execute a command with enhanced error handling and real-time output"""
        # Resolve working directory
        work_dir = self.cwd / task.cwd
        
        if not work_dir.exists():
            Logger.error(f"Working directory does not exist: {work_dir}")
            return 1, "", f"Working directory not found: {work_dir}"
        
        # Check if command is a local executable and adjust path
        command = task.command
        if not command.startswith('./') and not command.startswith('/') and not any(cmd in command for cmd in ['&&', '||', '|', ';']):
            # Check if executable exists in working directory
            local_executable = work_dir / command
            if local_executable.exists() and local_executable.is_file():
                # Make sure it's executable
                if not os.access(local_executable, os.X_OK):
                    Logger.warning(f"Making '{command}' executable")
                    os.chmod(local_executable, 0o755)
                command = f"./{command}"
                Logger.debug(f"Using local executable: {command}")
            else:
                # Check if it might be a PATH command
                try:
                    subprocess.run(['which', command], check=True, capture_output=True)
                    Logger.debug(f"Using PATH command: {command}")
                except subprocess.CalledProcessError:
                    Logger.warning(f"Command '{command}' not found in PATH or working directory")
        
        # Build command with arguments
        if task.args:
            if isinstance(task.args, list):
                full_command = f"{command} {' '.join(shlex.quote(str(arg)) for arg in task.args)}"
            else:
                full_command = f"{command} {task.args}"
        else:
            full_command = command
        
        Logger.info(f"Executing task '{task.label}'")
        Logger.debug(f"Command: {full_command}")
        Logger.debug(f"Working directory: {work_dir}")
        
        # Determine execution mode based on task presentation settings
        realtime_output = True
        if task.presentation:
            # Check if task wants captured output (like build tasks with problem matchers)
            reveal = task.presentation.get("reveal", "always")
            if reveal == "silent" or task.problem_matcher:
                realtime_output = False
        
        # For build tasks, usually we want captured output for error parsing
        if task.group == "build" and not task.presentation:
            realtime_output = False
        
        try:
            # Set up environment
            env = os.environ.copy()
            if task.options and "env" in task.options:
                env.update(task.options["env"])
            
            start_time = time.time()
            
            if realtime_output and show_output:
                # Real-time output for interactive programs
                Logger.debug("Using real-time output mode")
                result = subprocess.run(
                    full_command,
                    cwd=work_dir,
                    shell=True,
                    env=env,
                    timeout=task.options.get("timeout") if task.options else None
                )
                stdout, stderr = "", ""
            else:
                # Captured output for build tasks or when specifically requested
                Logger.debug("Using captured output mode")
                result = subprocess.run(
                    full_command,
                    cwd=work_dir,
                    shell=True,
                    capture_output=True,
                    text=True,
                    env=env,
                    timeout=task.options.get("timeout") if task.options else None
                )
                stdout, stderr = result.stdout or "", result.stderr or ""
                
                # Show captured output if requested
                if show_output:
                    if stdout:
                        print(stdout.rstrip())
                    if stderr:
                        print(stderr.rstrip(), file=sys.stderr)
            
            end_time = time.time()
            duration = end_time - start_time
            
            if result.returncode == 0:
                Logger.success(f"Task '{task.label}' completed successfully in {duration:.2f}s")
            else:
                Logger.error(f"Task '{task.label}' failed with exit code {result.returncode}")
            
            return result.returncode, stdout, stderr
            
        except subprocess.TimeoutExpired:
            Logger.error(f"Task '{task.label}' timed out")
            return 124, "", "Command timed out"
        except KeyboardInterrupt:
            Logger.warning("Task interrupted by user")
            return 130, "", "Interrupted by user"
        except Exception as e:
            Logger.error(f"Error executing task '{task.label}': {e}")
            return 1, "", str(e)
    
    def run_task(self, task_file: str = "task.json") -> bool:
        """Run tasks from configuration file"""
        config_file = self.config_path / task_file
        data = self._load_json_config(config_file)
        
        if not data:
            return False
        
        # Support both "task" and "tasks" keys for compatibility
        tasks_data = data.get("tasks", data.get("task", []))
        
        if not tasks_data:
            Logger.error("No tasks found in configuration")
            return False
        
        success = True
        for task_data in tasks_data:
            task = self._parse_task_config(task_data)
            if not task:
                success = False
                continue
            
            returncode, stdout, stderr = self._execute_command(task)
            if returncode != 0:
                success = False
                break
        
        return success
    
    def run_build(self, build_file: str = "build.json") -> bool:
        """Run build tasks from configuration file"""
        config_file = self.config_path / build_file
        data = self._load_json_config(config_file)
        
        if not data:
            return False
        
        # Support both "build" and "builds" keys for compatibility
        builds_data = data.get("builds", data.get("build", []))
        
        if not builds_data:
            Logger.error("No build configurations found")
            return False
        
        success = True
        for build_data in builds_data:
            task = self._parse_task_config(build_data)
            if not task:
                success = False
                continue
            
            returncode, stdout, stderr = self._execute_command(task)
            if returncode != 0:
                success = False
                break
        
        return success
    
    def list_tasks(self) -> None:
        """List available tasks"""
        tasks_file = self.config_path / "task.json"
        build_file = self.config_path / "build.json"
        
        print(f"{TextFormat.BOLD.value}Available Tasks:{TextFormat.RESET.value}")
        
        # List build tasks
        if build_file.exists():
            data = self._load_json_config(build_file)
            builds = data.get("builds", data.get("build", []))
            if builds:
                print(f"\n{Colors.CYAN.value}Build Tasks:{Colors.RESET.value}")
                for i, build_data in enumerate(builds):
                    label = build_data.get("label", f"build-{i}")
                    command = build_data.get("command", "")
                    print(f"  • {label}: {command}")
        
        # List run tasks
        if tasks_file.exists():
            data = self._load_json_config(tasks_file)
            tasks = data.get("tasks", data.get("task", []))
            if tasks:
                print(f"\n{Colors.GREEN.value}Run Tasks:{Colors.RESET.value}")
                for i, task_data in enumerate(tasks):
                    label = task_data.get("label", f"task-{i}")
                    command = task_data.get("command", "")
                    print(f"  • {label}: {command}")
    
    def create_sample_config(self) -> None:
        """Create sample configuration files"""
        # Sample tasks.json
        tasks_config = {
            "tasks": [
                {
                    "label": "run-program",
                    "type": "shell",
                    "command": "./program",
                    "cwd": "build",
                    "args": [],
                    "group": "run",
                    "presentation": {
                        "echo": True,
                        "reveal": "always",
                        "focus": False,
                        "panel": "shared"
                    },
                    "problemMatcher": "$gcc"
                }
            ]
        }
        
        # Sample build.json
        build_config = {
            "builds": [
                {
                    "label": "build-project",
                    "type": "shell",
                    "command": "gcc",
                    "cwd": ".",
                    "args": ["-o", "build/program", "src/main.c"],
                    "group": "build",
                    "presentation": {
                        "echo": True,
                        "reveal": "always",
                        "focus": False,
                        "panel": "shared"
                    },
                    "problemMatcher": "$gcc"
                }
            ]
        }
        
        # Write configuration files
        tasks_file = self.config_path / "task.json"
        build_file = self.config_path / "build.json"
        
        with open(tasks_file, 'w', encoding='utf-8') as f:
            json.dump(tasks_config, f, indent=4)
        
        with open(build_file, 'w', encoding='utf-8') as f:
            json.dump(build_config, f, indent=4)
        
        Logger.info(f"Sample configuration files created in {self.config_path}")

def print_help():
    """Print help information"""
    help_text = f"""
{TextFormat.BOLD.value}VS Code-like Task Runner{TextFormat.RESET.value}

{TextFormat.BOLD.value}USAGE:{TextFormat.RESET.value}
    {sys.argv[0]} <command> [options]

{TextFormat.BOLD.value}COMMANDS:{TextFormat.RESET.value}
    run             Run tasks from tasks.json
    build           Run build tasks from build.json
    build and run   Build project then run tasks
    list            List all available tasks
    init            Create sample configuration files
    help            Show this help message

{TextFormat.BOLD.value}EXAMPLES:{TextFormat.RESET.value}
    {sys.argv[0]} build
    {sys.argv[0]} run
    {sys.argv[0]} build and run
    {sys.argv[0]} list
    {sys.argv[0]} init

{TextFormat.BOLD.value}CONFIGURATION:{TextFormat.RESET.value}
    Configuration files should be placed in .nvim_bany/ directory:
    • tasks.json - Runtime tasks
    • build.json - Build tasks

{TextFormat.BOLD.value}CONFIGURATION FORMAT:{TextFormat.RESET.value}
    {{
        "tasks": [
            {{
                "label": "task-name",
                "type": "shell",
                "command": "command-to-run",
                "cwd": "working-directory",
                "args": ["arg1", "arg2"],
                "group": "build|run",
                "options": {{
                    "env": {{"VAR": "value"}},
                    "timeout": 30
                }}
            }}
        ]
    }}
"""
    print(help_text)

def main():
    """Main entry point"""
    runner = TaskRunner()
    
    if len(sys.argv) < 2:
        Logger.error("No command specified")
        print_help()
        sys.exit(1)
    
    command = sys.argv[1].strip().lower()
    
    try:
        if command == "run":
            Logger.info("Running tasks...")
            success = runner.run_task()
            sys.exit(0 if success else 1)
            
        elif command == "build":
            Logger.info("Building project...")
            success = runner.run_build()
            sys.exit(0 if success else 1)
            
        elif command in ["build and run", "build_and_run"]:
            Logger.info("Building and running...")
            build_success = runner.run_build()
            if build_success:
                run_success = runner.run_task()
                sys.exit(0 if run_success else 1)
            else:
                Logger.error("Build failed, skipping run")
                sys.exit(1)
                
        elif command == "list":
            runner.list_tasks()
            
        elif command == "init":
            runner.create_sample_config()
            
        elif command in ["help", "--help", "-h"]:
            print_help()
            
        else:
            Logger.error(f"Unknown command: {command}")
            print_help()
            sys.exit(1)
            
    except KeyboardInterrupt:
        Logger.warning("Operation cancelled by user")
        sys.exit(130)
    except Exception as e:
        Logger.error(f"Unexpected error: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
