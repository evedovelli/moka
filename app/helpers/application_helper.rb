module ApplicationHelper
  include Twitter::Autolink

  def is_active?(path)
    return "active" if current_page?(path)
  end
end
