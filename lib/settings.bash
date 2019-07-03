if [[ -n "${BUILDKITE_PLUGIN_S3_CACHE_LOAD_SETTINGS-"true"}" ]]; then
  # Set optimized S3 Settings
  aws configure set default.s3.max_concurrent_requests 20
  aws configure set default.s3.max_queue_size 10000
  aws configure set default.s3.multipart_threshold 64MB
  aws configure set default.s3.multipart_chunksize 16MB
  aws configure set default.s3.use_accelerate_endpoint false
  aws configure set default.s3.addressing_style path
fi
