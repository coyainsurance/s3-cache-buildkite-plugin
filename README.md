# S3 Cache Buildkite Plugin

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for uploading and downloading artifacts.

## Configuration

### `directories`
List of directories to cache

### `bucket`
Bucket name to use for cache storage. This plugin will interpolate as
`"s3://${BUILDKITE_PLUGIN_S3_CACHE_BUCKET}/${BUILDKITE_PIPELINE_SLUG}/${BUILDKITE_BRANCH}/${FILENAME}.tar.gz"`

Examples:
- `company-bucket/cache` (to us a subdir)
- `company-bucket`

### `unique`
String used to generate a unique name for this job

Default: `${BUILDKITE_LABEL}`

Example: `${BUILDKITE_MESSAGE}` or `${BUILDKITE_COMMAND}`

### `file`
Target file to zip the cache. Defaults to a hashed name in `/tmp`

### `load_settings`
If non-empty, will load s3 optimized configuration

## License
MIT (see [LICENSE](LICENSE))
