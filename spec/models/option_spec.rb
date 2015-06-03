require 'rails_helper'

describe Option do
  before(:each) do
    @attr = {
      :name => "Lymda",
      :picture => 4
    }
  end

  it "should create a new instance given a valid set of attributes" do
    option = Option.new(@attr)
    expect(option).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when name is empty' do
      @attr.delete(:name)
      option = Option.new(@attr)
      expect(option).not_to be_valid
    end
    it 'should fails when picture is empty' do
      @attr.delete(:picture)
      option = Option.new(@attr)
      expect(option).not_to be_valid
    end
  end

  describe 'validateas numericality of picture' do
    it 'should fails when not integer' do
      option = Option.new(@attr.merge(:picture => 2.5))
      expect(option).not_to be_valid
    end
    it 'should fails when greater than 4' do
      option = Option.new(@attr.merge(:picture => 5))
      expect(option).not_to be_valid
    end
    it 'should fails when less than 1' do
      option = Option.new(@attr.merge(:picture => 0))
      expect(option).not_to be_valid
    end
  end

  describe 'color' do
    it 'should return a color code for the option according to his picture' do
      option = Option.new(@attr.merge(:picture => 2))
      expect(option.color).to match("#46BFBD")
    end
  end

  describe 'color' do
    it 'should return a highlight color code for the option according to his picture' do
      option = Option.new(@attr.merge(:picture => 3))
      expect(option.highlight).to match("#FFC870")
    end
  end

end
