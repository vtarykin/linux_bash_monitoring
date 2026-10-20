# Linux Bash Monitoring Toolkit

A collection of Bash utilities for Linux system administration, system information reporting, and filesystem analysis.

The project demonstrates modular shell scripting, Linux system inspection, command-line input validation, filesystem operations, error handling, and automated code quality checks.

## Table of Contents

- [Features](#features)
  - [System Information Report](#system-information-report)
  - [Directory Analyzer](#directory-analyzer)
- [Technology Stack](#technology-stack)
- [Repository Structure](#repository-structure)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Generate a System Report](#generate-a-system-report)
  - [Analyze a Directory](#analyze-a-directory)
- [Testing and Code Quality](#testing-and-code-quality)
- [Implementation Highlights](#implementation-highlights)
- [Scope and Limitations](#scope-and-limitations)
- [Future Improvements](#future-improvements)

## Features

### System Information Report

`bin/system-report.sh` collects and displays a snapshot of the current Linux system:

- Hostname, current user, operating system, and timestamp
- Time zone and system uptime
- Global IPv4 address with CIDR prefix and default gateway
- Total and used RAM, plus available memory
- Total, used, and available space on the root filesystem

The report supports colorized terminal output and optional export to a plain-text file.

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

- **Shell:** Bash
- **Operating system:** Linux
- **System utilities:** `ip`, `free`, `uptime`, `df`
- **Filesystem utilities:** `find`, `du`, `sort`, `stat`, `numfmt`
- **Text processing:** `awk`, `grep`, `sed`, `wc`
- **Automated testing:** Bats
- **Static analysis:** ShellCheck
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
- Bats and ShellCheck for development and testing

The scripts are intended for Linux environments such as Ubuntu. Git Bash on Windows is not a supported runtime environment.

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

For development and testing, install Bats and ShellCheck:

```bash
sudo apt install -y bats shellcheck
```

## Usage

### Generate a System Report

Display system information:

```bash
./bin/system-report.sh
```

Disable terminal colors:

```bash
./bin/system-report.sh --no-color
```

Save the report to a file:

```bash
./bin/system-report.sh --output system-report.status
```

Display command-line help:

```bash
./bin/system-report.sh --help
```

The report includes system identity, uptime, network information, memory usage, and root filesystem capacity.

### Analyze a Directory

Analyze a directory:

```bash
./bin/directory-analyzer.sh /var/log
```

Paths containing spaces are supported:

```bash
./bin/directory-analyzer.sh "/home/user/My Documents"
```

Display usage information:

```bash
./bin/directory-analyzer.sh --help
```

The analyzer reports directory and file counts, categorizes files by extension or executable status, and identifies the largest directories and files.

The filesystem root `/` is rejected to avoid an unintended scan of the entire filesystem.

## Testing and Code Quality

Run the automated test suite:

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

The GitHub Actions workflow runs syntax checks, ShellCheck, and automated tests on pushes and pull requests.

## Implementation Highlights

- Modular Bash functions and a shared system information library
- Command-line option handling and input validation
- Linux system information collection from standard system utilities and `/proc`
- Filesystem traversal, file size ranking, and MIME type identification
- Handling of filenames containing spaces
- Temporary file management and exit status handling
- Automated tests with Bats
- Static analysis with ShellCheck
- Continuous integration through GitHub Actions

## Scope and Limitations

The tools perform on-demand inspection; they do not provide continuous monitoring, alert delivery, historical metrics storage, or a metrics backend.

Filesystem analysis is subject to operating system permissions. Results may be incomplete when the executing user cannot access some entries; the analyzer reports permission-related errors when detected.

The tools are designed for Linux and rely on Linux-specific system information sources and GNU command-line utilities.

## Future Improvements

- Add structured output formats such as JSON.
- Extend automated tests to cover command failures and permission restrictions.
- Add configurable thresholds for disk and memory usage.
- Support scheduled report generation through systemd timers.
- Add optional integration with established Linux monitoring systems.
