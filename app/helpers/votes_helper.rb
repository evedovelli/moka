module VotesHelper
  def get_option_span_poll(number_of_options, option)
    case number_of_options
    when 2
      if option == 1
        "span4 offset1"
      else
        "span4 offset2"
      end
    when 3
      "span4"
    when 4
      if option == 1 or option == 3
        "span4 offset1"
      else
        "span4 offset2"
      end
    else
      "span4"
    end
  end
end

