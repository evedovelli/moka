include ActionDispatch::TestProcess

### UTILITY METHODS ###

def create_path(image_name)
  filepath = Rails.root.join('spec', 'fixtures', 'images', image_name).to_path
  if filepath.match(/^[A-Z]:\//)
    filepath.gsub!(/\//, "\\")
  end
  return filepath
end

def attach_option_picture(image_name)
  if image_name != ""
    filepath = create_path(image_name)
    page.execute_script("$('.upload_picture').show();")
    attach_file(find(".upload_picture")[:id], filepath)
    page.execute_script("$('.upload_picture').hide();")
  end
end

