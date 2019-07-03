# Reads either a value or a list from plugin config
function plugin_read_list() {
  prefix_read_list "BUILDKITE_PLUGIN_S3_CACHE_$1"
}

# Reads either a value or a list from the given env prefix
function prefix_read_list() {
  local prefix="$1"
  local parameter="${prefix}_0"

  if [[ -n "${!parameter:-}" ]]; then
    local i=0
    local parameter="${prefix}_${i}"
    while [[ -n "${!parameter:-}" ]]; do
      echo "${!parameter}"
      i=$((i + 1))
      parameter="${prefix}_${i}"
    done
  elif [[ -n "${!prefix:-}" ]]; then
    echo "${!prefix}"
  fi
}

if [[ "${BUILDKITE_PLUGIN_S3_CACHE_DEBUG:-false}" =~ (true|on|1) ]]; then
  echo "--- :hammer: Enabling debug mode"
  set -x
fi

UNIQUE=${BUILDKITE_PLUGIN_S3_CACHE_UNIQUE:-${BUILDKITE_LABEL}}
FILENAME=$(echo "$UNIQUE" | sha256sum | cut -d" " -f 1)

export CACHE_FILE="${BUILDKITE_PLUGIN_S3_CACHE_FILE:-"/tmp/${FILENAME}.tar.gz"}"
