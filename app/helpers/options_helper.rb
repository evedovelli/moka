module OptionsHelper
  def fill_if_voted(option_id, content)
    if @voted_for && @voted_for[option_id]
      return content
    end
    return ""
  end

  def fill_if_victorious(option_id, content, current)
    if @victorious && @victorious[option_id] && (not current)
      return content
    end
    return ""
  end
end
