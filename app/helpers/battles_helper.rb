module BattlesHelper
  def visible_battles(battles)
    return battles.reject{|b| b.hidden}
  end

  def option_size(total)
    case total
    when 1..3
      return 4
    when 4
      return 3
    else
      return 2
    end
  end

  def option_offset(total, this)
    case total
    when 2
      case this
      when 0
        return 2
      else
        return 0
      end

    when 3..4
      return 0

    when 5
      case this
      when 0
        return 1
      else
        return 0
      end

    else
      return 0

    end
  end
end
