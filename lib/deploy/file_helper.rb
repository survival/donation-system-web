# frozen_string_literal: true

require 'date'

require_relative '../error_messages'

module Deploy
  class FileHelper
    include ErrorMessages

    def initialize(filepath:, local_directory:, upstream_directory:)
      @filepath = filepath
      @local_directory = local_directory
      @upstream_directory = upstream_directory
      @errors = errors
    end

    def append_digest
      FileUtils.cp(local_filepath, local_digested_filepath)
      []
    rescue Errno::ENOENT
      [join(ERROR_MESSAGES[:digesting_error], local_digested_filepath)]
    end

    def undo_append_digest
      File.delete(local_digested_filepath)
      []
    rescue Errno::ENOENT
      [join(ERROR_MESSAGES[:deleting_error], local_digested_filepath)]
    end

    def local_digested_filepath
      File.join(local_directory, digested_filepath)
    end

    def upstream_digested_filepath
      File.join(upstream_directory, digested_filepath)
    end

    private

    attr_reader :local_directory, :upstream_directory, :filepath, :errors

    def local_filepath
      File.join(local_directory, filepath)
    end

    def digested_filepath
      digest = Digest::MD5.file(local_filepath).hexdigest
      extname = File.extname(filepath)
      basepath = filepath.dup
      basepath.slice!(extname)
      @digested_filepath ||= basepath + "_#{digest}" + extname
    end
  end
end
