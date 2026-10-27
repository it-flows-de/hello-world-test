# hello-world-test

Minimal interactive Bash script that prints a greeting taken from a config file.
It exists to test the whole script process: config handling, signed Git tags,
GitHub upload and automated updates on a server.

## How it works

The script reads `hello-world-test.config` from its own directory, checks file
permissions and `CONFIG_VERSION`, and prints a greeting plus its own version.
It does no logging, has no lock file and no monitoring.

## Requirements

- Bash on a current Debian release
- Runs as a normal user, no root needed

## Installation

See [INSTALL.md](INSTALL.md).

## Configuration

Copy `hello-world-test.config.example` to `hello-world-test.config`, edit it and
set permissions to `660`. The example file is commented and documents every
parameter. The config is never committed to Git.

| Parameter | Block | Meaning | Default |
|---|---|---|---|
| `CONFIG_VERSION` | - | Config format version, must match the script | `1` |
| `GREETING_NAME` | required | Who is greeted | `World` |
| `GREETING_SUFFIX` | optional | Extra line after the greeting, empty = not used | empty |
| `GREETING_TEXT` | default | The greeting word | `Hello` |

## Usage

```
hello-world-test.sh [--help]
```

## Exit codes

| Code | Meaning |
|---|---|
| 0 | OK |
| 2 | Wrong option |
| 3 | Config error (missing file, wrong permissions, wrong `CONFIG_VERSION`, `GREETING_NAME` not set) |
