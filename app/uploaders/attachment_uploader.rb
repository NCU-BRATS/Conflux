# encoding: utf-8
require 'mimetype_fu'
require 'linguist'
class AttachmentUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
  # Choose what kind of storage to use for this uploader:
  # :file if you wanna save file to your local storage
  # :dropbox if you wanna save file to your dropbox storage
  storage :file
  # storage :fog

  process :save_size_in_model

  version :thumbnail, :if => :is_image? do
    process :resize_to_limit => [600, 600] # resize image to make sure image size is lower than 600 * 600
  end

  def save_size_in_model
    model.size = file.size
  end

  def is_image?(attachment)
    if attachment.respond_to?(:content_type)
      attachment.content_type.start_with?('image')
    elsif attachment.is_a?(Hash) && attachment.has_key?('mime_type')
      attachment["mime_type"].start_with?('image')
    end
  end
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def cache_with_file_type_magic!( new_file = sanitized_file )
    case new_file
      when ActionDispatch::Http::UploadedFile
        real_content_type = get_file_type(new_file)
        new_file = CarrierWave::SanitizedFile.new(new_file)
        new_file.content_type = real_content_type
      when CarrierWave::Uploader::Download::RemoteFile then nil
      else nil
    end

    cache_without_file_type_magic!(new_file)
  end

  alias_method_chain :cache!, :file_type_magic

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  def get_file_type( file )
    opened_file = File.new(file.path)
    begin
      real_content_type = File.mime_type?(opened_file).split(';').first
      return real_content_type unless real_content_type.start_with?('text')

      file_blob = Linguist::FileBlob.new(file.path)
      return file_blob.language.name unless file_blob.language.nil?

      probable_languages = Snippet::LANGUAGES.map { |language, ext| Linguist::Language[language.to_s]}
      classified_rank = Linguist::Classifier.call(file_blob,  probable_languages)
      return classified_rank.first.name
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
