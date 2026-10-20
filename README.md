# Linux Bash Monitoring Toolkit

A collection of Bash utilities for Linux system administration, system information reporting, and filesystem analysis.

The project demonstrates modular shell scripting, Linux system inspection, filesystem operations, input validation, error handling, automated testing, and CI-based code quality checks.

## Table of Contents

- [Features](#features)
  - [System Information Report](#system-information-report)
  - [Directory Analyzer](#directory-analyzer)
- [Technology Stack](#technology-stack)
- [Repository Structure](#repository-structure)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [System Information Report](#system-information-report-1)
  - [Directory Analyzer](#directory-analyzer-1)
- [Testing and Code Quality](#testing-and-code-quality)
- [Implementation Highlights](#implementation-highlights)
- [Scope and Limitations](#scope-and-limitations)
- [Future Improvements](#future-improvements)
- [License](#license)

## Features

### System Information Report

`bin/system-report.sh` collects and displays a snapshot of the current Linux system:

- Hostname, current user, operating system, and timestamp
- Time zone and system uptime
- Global IPv4 address with CIDR prefix and default gateway
- Total and used memory, plus available memory
- Total, used, and available space on the root filesystem

Supported output formats:

- **Text:** human-readable output with optional terminal colors.
- **JSON:** structured output suitable for consumption by other scripts and tools.
- **File export:** save the generated report to a specified path.

### Directory Analyzer

`bin/directory-analyzer.sh` inspects a directory and generates a summary containing:

- Total number of directories and files
- Counts of configuration, text, executable, log, and archive files
- Number of symbolic links
- Largest subdirectories by disk usage
- Largest files by logical size, including MIME types
- Largest executable files
- Script execution time

The analyzer supports paths containing spaces and reports permission-related issues when some entries cannot be inspected.

## Technology Stack

- **Shell scripting:** Bash
- **Operating system:** Linux
- **System utilities:** `ip`, `free`, `uptime`, `df`
- **Filesystem utilities:** `find`, `du`, `sort`, `stat`, `numfmt`
- **Text processing:** `awk`, `grep`, `sed`, `wc`
- **Automated testing:** Bats
- **Static analysis:** ShellCheck
- **Data validation in tests:** Python 3
- **CI/CD:** GitHub Actions

## Repository Structure

```text
linux_bash_monitoring/
├── bin/
│   ├── system-report.sh
│   └── directory-analyzer.sh
├── lib/
│   └── system-info.sh
├── tests/
│   ├── system-report.bats
│   └── directory-analyzer.bats
├── .github/
│   └── workflows/
│       └── bash-quality.yml
├── .gitignore
└── README.md
```

## Requirements

- Linux
- Bash 4.0 or newer
- GNU core utilities and GNU findutils
- `iproute2`
- `procps`
- `file`

Python 3, Bats, and ShellCheck are required for development and testing, but Python is not needed to run the utilities themselves.

The tools are designed for Linux environments such as Ubuntu. Git Bash on Windows is not a supported runtime environment.

## Installation

On Ubuntu or Debian, install the runtime dependencies:

```bash
sudo apt update
sudo apt install -y bash coreutils findutils iproute2 procps file
```

Clone the repository:

```bash
git clone https://github.com/vtarykin/linux_bash_monitoring.git
cd linux_bash_monitoring
```

Make the scripts executable:

```bash
chmod +x bin/*.sh
```

For development and testing:

```bash
sudo apt install -y bats shellcheck python3
```

## Usage

### System Information Report

Display a human-readable system report:

```bash
./bin/system-report.sh
```

Disable terminal colors:

```bash
./bin/system-report.sh --no-color
```

Generate a JSON report:

```bash
./bin/system-report.sh --format json
```

Save the text report to a file:

```bash
./bin/system-report.sh --output system-report.status
```

Save the JSON report to a file:

```bash
./bin/system-report.sh --format json --output system-report.json
```

Validate a saved JSON report:

```bash
python3 -m json.tool system-report.json
```

Display command-line help:

```bash
./bin/system-report.sh --help
```

The JSON output contains system attributes as structured key-value pairs. Numeric measurements are represented as JSON numbers when available; unavailable measurements are represented as strings.

### Directory Analyzer

Analyze a directory:

```bash
./bin/directory-analyzer.sh /var/log
```

Analyze a path containing spaces:

```bash
./bin/directory-analyzer.sh "/home/user/My Documents"
```

Display command-line help:

```bash
./bin/directory-analyzer.sh --help
```

The analyzer rejects the filesystem root `/` to prevent an unintended scan of the entire filesystem.

## Testing and Code Quality

Run all automated tests:

```bash
bats tests/
```

Run ShellCheck:

```bash
shellcheck -x bin/*.sh
```

Check Bash syntax:

```bash
for file in bin/*.sh lib/*.sh; do
    bash -n "$file"
done
```

The Bats test suite validates command-line behavior, report generation, JSON validity, file export, directory analysis, and error handling.

The GitHub Actions workflow runs syntax checks, ShellCheck, and automated tests on pushes and pull requests.

## Implementation Highlights

- Modular Bash functions and a shared system information library
- Command-line option parsing and validation
- Linux system information collection from standard utilities and `/proc`
- Structured JSON output for integration with other tools
- Filesystem traversal, file size ranking, and MIME type identification
- Handling of filenames containing spaces
- Temporary file management and exit status handling
- Automated tests and static analysis
- Continuous integration through GitHub Actions

## Scope and Limitations

The tools perform on-demand system inspection; they do not provide continuous monitoring, alert delivery, historical metrics storage, or a metrics backend.

Filesystem results may be incomplete when the executing user cannot access some entries. The analyzer reports permission-related errors when detected.

The utilities rely on Linux-specific system information sources and GNU command-line tools. They are intended as lightweight administration utilities rather than a replacement for a full monitoring platform.

## Future Improvements

- Add configurable thresholds for disk and memory usage.
- Support scheduled report generation through systemd timers.
- Add structured output to the directory analyzer.
- Extend automated tests to cover command failures and permission restrictions.
- Add optional integration with established Linux monitoring systems.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
