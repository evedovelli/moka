module BattlesHelper
  def visible_battles(battles)
    return battles.reject{|b| b.hidden}
  end
end
