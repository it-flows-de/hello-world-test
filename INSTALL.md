# Installation: hello-world-test

Interactive Bash script, runs as a normal user (no root needed for the script itself).
All commands are meant to be pasted into **one terminal session**. The variables from
step 0 and step 3 only exist in that session. If you open a new terminal, repeat
step 0 and run `source "${CONFIG_FILE}"` again.

## 0. Variables

```bash
SCRIPT_HOME=/usr/local/scripts
SCRIPT_NAME=hello-world-test
SCRIPT_DIR="${SCRIPT_HOME}/${SCRIPT_NAME}"
CONFIG_FILE="${SCRIPT_DIR}/${SCRIPT_NAME}.config"
TAG=v1.0.0
```

`SCRIPT_HOME` is only used in this guide. The script itself finds its own
directory at runtime.

## 1. Prerequisites

```bash
sudo apt install git
```

For the release path (step 2, variant A) the file
`/etc/get-scriptupdate/allowed_signers` must exist. It is set up according to
`script-release-setup.md`.

## 2. Script directory and files

The base directory belongs to the normal user, so no `sudo` is needed below it.

```bash
sudo mkdir -p "${SCRIPT_HOME}"
sudo chown "$USER": "${SCRIPT_HOME}"
```

Note: a script that is later run as root must not live in a directory that other
users can write to.

### Variant A: release path (signed tag)

```bash
git clone "https://github.com/it-flows-de/${SCRIPT_NAME}.git" "${SCRIPT_DIR}"
cd "${SCRIPT_DIR}"
git -c gpg.ssh.allowedSignersFile=/etc/get-scriptupdate/allowed_signers verify-tag "${TAG}" && git checkout "${TAG}"
```

The checkout only runs if the signature check succeeds. The executable bit
comes from the repository, no `chmod` is needed.

### Variant B: development path (only before the first release)

Create the files and copy the content from the ZIP with an editor of your choice:

```bash
mkdir -p "${SCRIPT_DIR}"
cd "${SCRIPT_DIR}"
touch "${SCRIPT_NAME}.sh" "${SCRIPT_NAME}.config.example" .gitignore README.md INSTALL.md
chmod 755 "${SCRIPT_NAME}.sh"
```

## 3. Config

```bash
cd "${SCRIPT_DIR}"
cp "${SCRIPT_NAME}.config.example" "${SCRIPT_NAME}.config"
vi "${CONFIG_FILE}"
chmod 660 "${CONFIG_FILE}"
source "${CONFIG_FILE}"
echo "GREETING_NAME=${GREETING_NAME} GREETING_TEXT=${GREETING_TEXT} GREETING_SUFFIX=${GREETING_SUFFIX}"
```

The config is sourced by bash and is therefore code. It must never be committed
to Git (`.gitignore` excludes `*.config`).

## 4. Test

Help:

```bash
"${SCRIPT_DIR}/${SCRIPT_NAME}.sh" --help
```

Normal run (expected: greeting, version line, exit code 0):

```bash
"${SCRIPT_DIR}/${SCRIPT_NAME}.sh"; echo "exit code: $?"
```

Error case: wrong permissions on the config (expected: error message, exit code 3):

```bash
chmod 664 "${CONFIG_FILE}"
"${SCRIPT_DIR}/${SCRIPT_NAME}.sh"; echo "exit code: $?"
chmod 660 "${CONFIG_FILE}"
```

## Troubleshooting

| Exit code | Meaning | What to check |
|---|---|---|
| 0 | OK | - |
| 2 | Wrong option | Run with `--help` |
| 3 | Config error | Config exists, permissions are `660`, `CONFIG_VERSION` matches, `GREETING_NAME` is set |
