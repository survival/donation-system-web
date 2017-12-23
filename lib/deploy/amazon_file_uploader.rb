# frozen_string_literal: true

require 'aws-sdk-s3'

require_relative '../error_messages'

module Deploy
  class AmazonFileUploader
    include ErrorMessages
    MIME_TYPES = {
      css: 'text/css',
      js: 'application/javascript',
      default: 'text/plain'
    }.freeze
    ACL = 'public-read'

    def initialize(options:, bucket_name:, local_filepath:, upstream_filepath:)
      @options = options
      @bucket_name = bucket_name
      @local_filepath = local_filepath
      @upstream_filepath = upstream_filepath
      @errors = []
    end

    def upload
      validate_credentials
      validate_bucket_existence
      upload_file if errors.empty?
      errors
    end

    private

    attr_reader :options, :bucket_name, :local_filepath, :upstream_filepath,
                :errors

    def validate_credentials
      message = join(ERROR_MESSAGES[:missing_s3_credentials], options)
      errors << message unless bucket
    end

    def validate_bucket_existence
      message = join(ERROR_MESSAGES[:missing_bucket], bucket)
      errors << message unless bucket&.exists?
    end

    def upload_file
      rescue_errors do
        object = bucket.object(upstream_filepath)
        object.upload_file(local_filepath, content_type: content_type, acl: ACL)
      end
    end

    def rescue_errors
      yield
    rescue Errno::ENOENT
      add_missing_file_error
      false
    rescue Aws::S3::MultipartUploadError
      add_multipart_error
      false
    rescue StandardError => error
      add_generic_error(error)
      false
    end

    def content_type
      extension_as_symbol = File.extname(upstream_filepath).delete('.').to_sym
      MIME_TYPES.fetch(extension_as_symbol, MIME_TYPES[:default])
    end

    def add_missing_file_error
      errors << join(ERROR_MESSAGES[:missing_local_file], local_filepath)
    end

    def add_multipart_error
      errors << join(ERROR_MESSAGES[:multipart_upload_error], upstream_filepath)
    end

    def add_generic_error(error)
      errors << join(ERROR_MESSAGES[:generic_error], error.message)
    end

    def bucket
      @bucket ||= Aws::S3::Resource.new(options).bucket(bucket_name)
    rescue Aws::Sigv4::Errors::MissingCredentialsError
      nil
    end
  end
end
