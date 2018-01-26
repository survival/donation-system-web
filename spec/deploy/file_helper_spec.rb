# frozen_string_literal: true

require 'spec_helper'

require_relative '../../lib/deploy/file_helper'

RSpec.describe Deploy::FileHelper do
  let(:args) do
    {
      filepath: 'css/main.css',
      local_directory: 'local',
      upstream_directory: 'upstream'
    }
  end
  let(:helper) { described_class.new(args) }

  before do
    allow(Digest::MD5).to receive_message_chain(:file, :hexdigest)
      .and_return('abc1234')
  end

  describe '#append_digest' do
    it 'copies file to one with digested filename' do
      expect(FileUtils).to receive(:cp)
        .with('local/css/main.css', 'local/css/main_abc1234.css')
      helper.append_digest
    end

    it 'adds digest to filename if there were no problems copying' do
      path = Tempfile.new('temp.css').path
      temp_args = args.merge(
        filepath: File.basename(path),
        local_directory: File.dirname(path)
      )
      helper = described_class.new(temp_args)
      expect(helper.append_digest).to be_empty
    end

    it 'does not copy or digest if file path not found' do
      helper = described_class.new(args.merge(filepath: 'i-dont-exist'))
      message = described_class::ERROR_MESSAGES[:digesting_error]
      expect(helper.append_digest).to include(/#{message}/)
    end
  end

  describe '#undo_append_digest' do
    let(:temp_args) do
      path = Tempfile.new('temp.js').path
      args.merge(
        filepath: File.basename(path),
        local_directory: File.dirname(path)
      )
    end
    let(:helper) { described_class.new(temp_args) }

    it 'works if digested file exists' do
      helper.append_digest
      expect(helper.undo_append_digest).to be_empty
    end

    it 'deletes digested file' do
      expect(File).to receive(:delete).with(/temp_abc1234.js/)
      helper.undo_append_digest
    end

    it 'has errors if digested file does not exist' do
      message = described_class::ERROR_MESSAGES[:deleting_error]
      expect(helper.undo_append_digest).to include(/#{message}/)
    end
  end

  it 'knows the local digested filepath' do
    local = 'local/css/main_abc1234.css'
    expect(helper.local_digested_filepath).to eq(local)
  end

  it 'knows the upstream digested filepath' do
    upstream = 'upstream/css/main_abc1234.css'
    expect(helper.upstream_digested_filepath).to eq(upstream)
  end

  it 'adds digest if file has no extension' do
    helper = described_class.new(args.merge(filepath: 'extensionless_name'))
    digested = 'local/extensionless_name_abc1234'
    expect(helper.local_digested_filepath).to eq(digested)
  end
end
