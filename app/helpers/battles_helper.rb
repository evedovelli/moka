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

  def show_battle_icons(battle, vote)
    battle_icons = ""
    battle.options.each do |option|
      if vote.option == option
        battle_icons += link_to(image_tag(option.picture.url(:icon), :class => "voted_battle img-polaroid"), battle_path(battle), :id => "option#{option.id}-icon")
      else
        battle_icons += link_to(image_tag(option.picture.url(:icon), :class => "img-polaroid"), battle_path(battle), :id => "option#{option.id}-icon")
      end
    end
    return battle_icons.html_safe
  end
end
