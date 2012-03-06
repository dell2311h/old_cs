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
end
