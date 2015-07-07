module SnippetsHelper
  def get_different_lang(language)
    if Snippet::LANGUAGES.size <= 1
      nil
    else
      loop do
        another_lang = Snippet::LANGUAGES.to_a.sample(1)[0][0]
        if another_lang != language
          return another_lang
        end
      end
    end
  end

  def fake_uploaded_file(filepath, mime_type)
    uploaded_file = Rack::Test::UploadedFile.new(filepath, mime_type)
    ActionDispatch::Http::UploadedFile.new({filename: uploaded_file.original_filename, tempfile: uploaded_file.tempfile})
  end
end
