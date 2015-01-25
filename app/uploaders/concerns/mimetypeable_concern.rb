module CarrierWave

  module MimetypeableConcern
    extend ActiveSupport::Concern

    included do
      alias_method_chain :cache!, :file_type_magic
      begin
        require 'mimetype_fu'
        require 'linguist'
      rescue LoadError => e
        e.message << '(You may need to install the mimetype-fu and github-linguist gem)'
        raise e
      end
    end

    def cache_with_file_type_magic!( new_file = sanitized_file )
      real_content_type = get_file_type(new_file)
      new_file = CarrierWave::SanitizedFile.new(new_file)
      new_file.content_type = real_content_type
      cache_without_file_type_magic!(new_file)
    end

    def get_file_type( file )
      opened_file = File.new(file.path)
      begin
        real_content_type = File.mime_type?(opened_file).split(';').first
        return real_content_type unless real_content_type.start_with?('text')

        file_blob = Linguist::FileBlob.new(file.path)
        return file_blob.language.name unless file_blob.language.nil?

        probable_languages = Attachment::Snippet::LANGUAGES.map {|language| Linguist::Language[language]}
        classified_rank = Linguist::Classifier.call(file_blob,  probable_languages)
        return classified_rank.first.name
      end
    end

  end

end
