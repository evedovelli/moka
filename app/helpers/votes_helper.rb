module VotesHelper
  def get_stuff_span_poll(number_of_stuffs, stuff)
    case number_of_stuffs
    when 2
      if stuff == 1
        "span4 offset1"
      else
        "span4 offset2"
      end
    when 3
      "span4"
    when 4
      if stuff == 1 or stuff == 3
        "span4 offset1"
      else
        "span4 offset2"
      end
    else
      "span4"
    end
  end
end

