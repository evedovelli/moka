require "spec_helper"

describe BattlesHelper, :type => :helper do
  describe "visible battles" do
    it "should return all non hidden battles" do
      battles = FactoryGirl.create_list(:battle, 10)
      expected_battles = Array.new(battles)
      battle = FactoryGirl.create(:battle)
      battle.hide
      expect(helper.visible_battles(battles.push(battle))).to eq(expected_battles)
    end
  end
end

