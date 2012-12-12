# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  storage :postgresql_lo
  # process :resize_to_fit => [77, 77]
  def extension_white_list
    %w(jpg jpeg gif png)
  end

end