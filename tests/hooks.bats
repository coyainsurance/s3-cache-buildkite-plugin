#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export AWS_STUB_DEBUG=/dev/tty
# export TAR_STUB_DEBUG=/dev/tty

@test "Pre-cache hooks" {
  export BUILDKITE_PLUGIN_S3_CACHE_LOAD_SETTINGS=""
  export BUILDKITE_PIPELINE_SLUG="test"
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_S3_CACHE_BUCKET="test"
  export BUILDKITE_PLUGIN_S3_CACHE_DIRECTORIES="tests/"
  export BUILDKITE_LABEL="This test build"
  export BUILDKITE_PLUGIN_S3_CACHE_FILE="/tmp/cache.tar.gz"
  export BUILDKITE_BUILD_CHECKOUT_PATH="$PWD"

  stub tar \
    "-zcf : touch /tmp/cache.tar.gz"

  stub aws \
    "s3 cp /tmp/cache.tar.gz s3://test/test/master/48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz : "

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "Running pre-cache hook"
  assert_output --partial "Im pre-cache"
  assert_output --partial "Compressing cache with tar"
  assert_output --partial "Uploading cache to"
  unstub tar
  unstub aws
}

@test "Post-cache hooks" {
  export BUILDKITE_PLUGIN_S3_CACHE_LOAD_SETTINGS=""
  export BUILDKITE_PIPELINE_SLUG="test"
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_S3_CACHE_BUCKET="test"
  export BUILDKITE_PLUGIN_S3_CACHE_DIRECTORIES="./cache"
  export BUILDKITE_LABEL="This test build"
  export BUILDKITE_BUILD_CHECKOUT_PATH="$PWD"

  stub aws \
    "s3 ls s3://test/test/master/48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz : echo 48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz" \
    "s3 ls s3://test/test/master/48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz : echo 48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz" \
    "s3 cp s3://test/test/master/48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz /tmp/48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz : "
  stub tar \
    "-xzf : "

  run "$PWD/hooks/post-checkout"

  assert_success
  assert_output --partial "Downloading cache from"
  assert_output --partial "Uncompressing cache"
  assert_output --partial "Running post-cache hook"
  assert_output --partial "Im post-cache"
  unstub aws
  unstub tar
}

@test "Cache hooks disable" {
  export BUILDKITE_PLUGIN_S3_CACHE_LOAD_SETTINGS=""
  export BUILDKITE_PIPELINE_SLUG="test"
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_S3_CACHE_BUCKET="test"
  export BUILDKITE_PLUGIN_S3_CACHE_DIRECTORIES="./cache"
  export BUILDKITE_LABEL="This test build"
  export BUILDKITE_BUILD_CHECKOUT_PATH="$PWD"
  export BUILDKITE_PLUGIN_S3_CACHE_HOOKS="asd"

  stub aws \
    "s3 ls s3://test/test/master/48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz : echo 48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz" \
    "s3 ls s3://test/test/master/48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz : echo 48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz" \
    "s3 cp s3://test/test/master/48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz /tmp/48ff2c8af2cb1b7b760080c23e4e1c92be6ee3cefef0ad8866d1d45b4485b195.tar.gz : "
  stub tar \
    "-xzf : "

  run "$PWD/hooks/post-checkout"

  assert_success
  assert_output --partial "Downloading cache from"
  assert_output --partial "Uncompressing cache"
  refute_output --partial "Running post-cache hook"
  refute_output --partial "Im post-cache"
  unstub aws
  unstub tar
}
