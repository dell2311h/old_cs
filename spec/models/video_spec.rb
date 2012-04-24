require 'spec_helper'

describe Video do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:event_id) }
  it { should validate_presence_of(:name) }
  it { should belong_to(:user) }
  it { should belong_to(:event) }

  it { should have_attached_file(:clip) }
  it { should validate_attachment_presence(:clip) }
  it { should validate_attachment_content_type(:clip).
                allowing('video/mp4')}

  context "chunked uploading" do
    it { should respond_to(:directory_fullpath) }
    it { should respond_to(:tmpfile_fullpath) }
    it { should respond_to(:make_uploads_folder!) }
    it { should respond_to(:remove_attached_data!) }
    it { should respond_to(:append_chunk_to_file!) }
    it { should respond_to(:append_binary_to_file!) }
    it { should respond_to(:tmpfile_md5_checksum) }
    it { should respond_to(:tmpfile_size) }
    it { should respond_to(:finalize_upload_by!) }
    it { should respond_to(:set_chunk_id!) }
  end
end

