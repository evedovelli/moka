require 'uri'

module BattlesHelper
  def visible_battles(battles, filter)
    battles.reject!{|b| b.hidden}
    if filter == "finished"
      battles.reject!{|b| not b.finished?}
    elsif filter == "current"
      battles.reject!{|b| not b.current?}
    end
    return battles
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

  def share_on_facebook(url)
    return "onClick=\"window.open('http://www.facebook.com/sharer.php?u=#{url}&appId=#{ENV['FACEBOOK_KEY']}','Facebook','width=600,height=300,left='+(screen.availWidth/2-300)+',top='+(screen.availHeight/2-150)+''); return false;\"".html_safe
  end

  def share_on_twitter(url, text)
    return "onClick=\"window.open('http://twitter.com/share?url=#{url}&amp;text=#{text}','Twitter share','width=600,height=300,left='+(screen.availWidth/2-300)+',top='+(screen.availHeight/2-150)+''); return false;\"".html_safe
  end

  def share_on_google_plus(url)
    return "onClick=\"window.open('https://plus.google.com/share?url=#{url}','Google plus','width=585,height=666,left='+(screen.availWidth/2-292)+',top='+(screen.availHeight/2-333)+''); return false;\"".html_safe
  end

  def twitter_text(battle)
    return URI.encode(battle.title)
  end
end
