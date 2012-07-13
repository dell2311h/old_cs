# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  FORMAT = 'jpeg'

  storage :file

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process :quality => Settings.avatar.quality
  process :convert => FORMAT

  def store_dir
    "images/#{model.class.to_s.underscore.pluralize}/#{model.id}"
  end

  def filename
    "original.#{FORMAT}" if original_filename
  end

  version :normal do
    def store_dir
      "images/#{model.class.to_s.underscore.pluralize}/#{model.id}/normal"
    end

    version :small do
      def full_filename (for_file = model.avatar.file)
        "small.#{FORMAT}"
      end
      process :convert => FORMAT
      process :resize_to_fill => [Settings.avatar.small.width, Settings.avatar.small.height]
    end

    version :medium do
      def full_filename (for_file = model.avatar.file)
        "medium.#{FORMAT}"
      end
      process :convert => FORMAT
      process :resize_to_fill => [Settings.avatar.medium.width, Settings.avatar.medium.height]
    end
  end

  version :doublesized do
    def store_dir
      "images/#{model.class.to_s.underscore.pluralize}/#{model.id}/doublesized"
    end

    version :small do
      def full_filename (for_file = model.avatar.file)
        "small.#{FORMAT}"
      end
      process :convert => FORMAT
      process :resize_to_fill => [Settings.avatar.small.width*2, Settings.avatar.small.height*2]
    end

    version :medium do
      def full_filename (for_file = model.avatar.file)
        "medium.#{FORMAT}"
      end
      process :convert => FORMAT
      process :resize_to_fill => [Settings.avatar.medium.width*2, Settings.avatar.medium.height*2]
    end
  end
end
