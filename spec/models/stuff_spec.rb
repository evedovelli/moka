require 'rails_helper'

describe Stuff do
  before(:each) do
    @attr = {
      :name => "Lymda",
      :picture => 4
    }
  end

  it "should create a new instance given a valid set of attributes" do
    stuff = Stuff.new(@attr)
    expect(stuff).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when name is empty' do
      @attr.delete(:name)
      stuff = Stuff.new(@attr)
      expect(stuff).not_to be_valid
    end
    it 'should fails when picture is empty' do
      @attr.delete(:picture)
      stuff = Stuff.new(@attr)
      expect(stuff).not_to be_valid
    end
  end

  describe 'validateas numericality of picture' do
    it 'should fails when not integer' do
      stuff = Stuff.new(@attr.merge(:picture => 2.5))
      expect(stuff).not_to be_valid
    end
    it 'should fails when greater than 4' do
      stuff = Stuff.new(@attr.merge(:picture => 5))
      expect(stuff).not_to be_valid
    end
    it 'should fails when less than 1' do
      stuff = Stuff.new(@attr.merge(:picture => 0))
      expect(stuff).not_to be_valid
    end
  end

  describe 'color' do
    it 'should return a color code for the stuff according to his picture' do
      stuff = Stuff.new(@attr.merge(:picture => 2))
      expect(stuff.color).to match("#46BFBD")
    end
  end

  describe 'color' do
    it 'should return a highlight color code for the stuff according to his picture' do
      stuff = Stuff.new(@attr.merge(:picture => 3))
      expect(stuff.highlight).to match("#FFC870")
    end
  end

end
