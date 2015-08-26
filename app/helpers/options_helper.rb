module OptionsHelper
  def fill_if_voted(option_id, content)
    if @voted_for && @voted_for[option_id]
      return content
    end
    return ""
  end
end
