# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  def store_dir
    "images/#{model.class.to_s.underscore}/#{model.id}"
  end

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

  version :medium do
    process :resize_to_fill => [Settings.avatar.width*3, Settings.avatar.height*3]
  end

  version :iphone do
    process :resize_to_fill => [Settings.avatar.width*2, Settings.avatar.height*2]
  end

  version :thumb do
    process :resize_to_fill => [Settings.avatar.width, Settings.avatar.height]
  end

end
