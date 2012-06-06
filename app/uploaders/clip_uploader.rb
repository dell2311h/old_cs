# encoding: utf-8

class ClipUploader < CarrierWave::Uploader::Base
  storage :file

  self.remove_previously_stored_files_after_update = false

  def store_dir
    "#{Settings.carrierwave.base_path}uploads/#{model.class.to_s.underscore.pluralize}/#{model.id}/#{mounted_as}/"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(m4v mp4)
  end
end
