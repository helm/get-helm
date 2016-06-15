#!/usr/bin/env bash

# Invoking this script:
#
# curl https://get.helm.sh | sh
#
# - download helmc.zip file
# - extract zip file (into current directory)
# - making sure helmc is executable
# - explain what was done
#

set -eo pipefail -o nounset

function check_platform_arch {
  local supported="linux-amd64 linux-i386 darwin-amd64 darwin-i386"

  if ! echo "${supported}" | tr ' ' '\n' | grep -q "${PLATFORM}-${ARCH}"; then
    cat <<EOF

${PROGRAM} is not currently supported on ${PLATFORM}-${ARCH}.

See https://github.com/helm/helm-classic for more information.

EOF
  fi
}

PROGRAM="helmc"
PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
HELM_BIN_URL_BASE="https://storage.googleapis.com/helm-classic"

if [ "${ARCH}" == "x86_64" ]; then
  ARCH="amd64"
fi

check_platform_arch

HELM_BIN="helmc-latest-${PLATFORM}-${ARCH}"

echo "Downloading ${HELM_BIN} from Google Cloud Storage..."
curl -o ${PROGRAM} -s "${HELM_BIN_URL_BASE}/${HELM_BIN}"

chmod +x "${PROGRAM}"

cat <<EOF

${PROGRAM} is now available in your current directory.

To learn more about helm classic, execute:

    $ ./helmc

EOF
