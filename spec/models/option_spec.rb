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

  describe 'number of votes' do
    it 'should return the number of votes for this option' do
      option = Option.new(@attr)
      votes = FactoryGirl.create_list(:vote, 20, {option: option})
      expect(option.number_of_votes).to eq(20)
    end
  end

end
