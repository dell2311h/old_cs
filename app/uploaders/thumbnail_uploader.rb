# encoding: utf-8

class ThumbnailUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process :quality => Settings.thumbnail.quality

  def store_dir
    "images/#{model.class.to_s.underscore.pluralize}/#{model.id}"
  end

  def filename
    "original.#{model.thumbnail.file.extension}" if original_filename
  end

  version :normal do
    def store_dir
      "images/#{model.class.to_s.underscore.pluralize}/#{model.id}/normal"
    end

    version :small do
      def full_filename (for_file = model.thumbnail.file)
        "small.jpg"
      end
      process :convert => 'jpg'
      process :resize_to_fill => [Settings.thumbnail.small.width, Settings.thumbnail.small.height]
    end

    version :medium do
      def full_filename (for_file = model.thumbnail.file)
        "medium.jpg"
      end
      process :convert => 'jpg'
      process :resize_to_fill => [Settings.thumbnail.medium.width, Settings.thumbnail.medium.height]
    end
  end

  version :doublesized do
    def store_dir
      "images/#{model.class.to_s.underscore.pluralize}/#{model.id}/doublesized"
    end

    version :small do
      def full_filename (for_file = model.thumbnail.file)
        "small.jpg"
      end
      process :convert => 'jpg'
      process :resize_to_fill => [Settings.thumbnail.small.width*2, Settings.thumbnail.small.height*2]
    end

    version :medium do
      def full_filename (for_file = model.thumbnail.file)
        "medium.jpg"
      end
      process :convert => 'jpg'
      process :resize_to_fill => [Settings.thumbnail.medium.width*2, Settings.thumbnail.medium.height*2]
    end
  end

end

