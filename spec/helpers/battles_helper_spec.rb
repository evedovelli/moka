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

  describe "option size" do
    it "should return 4 for 1 option" do
      expect(helper.option_size(1)).to eq(4)
    end
    it "should return 4 for 2 options" do
      expect(helper.option_size(2)).to eq(4)
    end
    it "should return 4 for 3 options" do
      expect(helper.option_size(3)).to eq(4)
    end
    it "should return 3 for 4 options" do
      expect(helper.option_size(4)).to eq(3)
    end
    it "should return 2 for 5 options" do
      expect(helper.option_size(5)).to eq(2)
    end
    it "should return 2 for 6 options" do
      expect(helper.option_size(6)).to eq(2)
    end
  end

  describe "option offset" do
    it "should return 0 for 1 option" do
      expect(helper.option_offset(1, "x")).to eq(0)
    end
    it "should return 2 for 1st option in 2 options" do
      expect(helper.option_offset(2, 0)).to eq(2)
    end
    it "should return 0 for 2nd option in 2 options" do
      expect(helper.option_offset(2, 1)).to eq(0)
    end
    it "should return 0 for 3 options" do
      expect(helper.option_offset(3, "x")).to eq(0)
    end
    it "should return 0 for 4 options" do
      expect(helper.option_offset(4, "x")).to eq(0)
    end
    it "should return 1 for 1st option in 5 options" do
      expect(helper.option_offset(5, 0)).to eq(1)
    end
    it "should return 0 for other options in 5 options" do
      expect(helper.option_offset(5, 1)).to eq(0)
      expect(helper.option_offset(5, 2)).to eq(0)
      expect(helper.option_offset(5, 3)).to eq(0)
      expect(helper.option_offset(5, 4)).to eq(0)
    end
    it "should return 0 for 6 options" do
      expect(helper.option_offset(6, "x")).to eq(0)
    end
  end

  describe "show battle icons" do
    it "should return all battle icons with extra class for voted one" do
      @battle = FactoryGirl.create(:battle, {
        starts_at: DateTime.now - 2.day,
        duration: 96*60,
        number_of_options: 3
      })
      user = FactoryGirl.create(:user, username: "u1", email: "user@u1.com")
      vote = FactoryGirl.create(:vote, option: @battle.options[2], user: user)
      expect(helper.show_battle_icons(@battle, vote)).to eq("<a href=\"/en/battles/1\" id=\"option#{@battle.options[0].id}-icon\">#{image_tag(@battle.options[0].picture.url(:icon), :class => "img-polaroid")}</a><a href=\"/en/battles/1\" id=\"option#{@battle.options[1].id}-icon\">#{image_tag(@battle.options[1].picture.url(:icon), :class => "img-polaroid")}</a><a href=\"/en/battles/1\" id=\"option#{@battle.options[2].id}-icon\">#{image_tag(@battle.options[2].picture.url(:icon), :class => "voted_battle img-polaroid")}</a>")
    end
  end
end
