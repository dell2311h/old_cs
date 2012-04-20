# encoding: utf-8

class ClipUploader < CarrierWave::Uploader::Base

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:

  self.remove_previously_stored_files_after_update = false

  def store_dir
    "uploads/#{model.class.to_s.underscore.pluralize}/#{model.id}/#{mounted_as}/"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(m4v mp4)
  end
end

