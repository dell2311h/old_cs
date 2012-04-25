require 'spec_helper'

describe Video do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:event_id) }
  it { should validate_presence_of(:uuid) }
  it { should belong_to(:user) }
  it { should belong_to(:event) }

  context "chunked uploads" do
    subject { Video.new }
    it { should respond_to(:directory_fullpath) }
    it { should respond_to(:tmpfile_fullpath) }
    it { should respond_to(:make_uploads_folder!) }
    it { should respond_to(:remove_attached_data!) }
    it { should respond_to(:append_chunk_to_file!) }
    it { should respond_to(:append_binary_to_file!) }
    it { should respond_to(:tmpfile_md5_checksum) }
    it { should respond_to(:tmpfile_size) }
    it { should respond_to(:finalize_upload_by!) }
  end
end

