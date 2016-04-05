module ApplicationHelper
  include Twitter::Autolink

  def is_active?(path)
    return "active" if current_page?(path)
  end

  def image_url(source)
    URI.join(root_url, image_path(source))
  end
end
