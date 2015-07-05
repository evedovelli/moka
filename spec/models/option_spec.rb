require 'rails_helper'

describe Option do
  before(:each) do
    @attr = {
      :name => "Chips",
      :picture => File.new(Rails.root + 'spec/fixtures/images/chips.png')
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

  describe 'validates attached picture' do
    it 'should validates attachment content type' do
      option = Option.new(@attr.merge(:picture => File.new(Rails.root + 'spec/fixtures/images/no_image.txt')))
      expect(option).not_to be_valid
    end
  end

  describe 'color' do
    it 'should return a color code for the option according to his id' do
      @attr[:id] = 2
      option = Option.new(@attr)
      expect(option.color).to match("#46BFBD")
    end
  end

  describe 'color' do
    it 'should return a highlight color code for the option according to his id' do
      @attr[:id] = 3
      option = Option.new(@attr)
      expect(option.highlight).to match("#FFC870")
    end
  end

end
