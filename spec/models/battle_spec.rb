require 'rails_helper'

describe Battle do
  before(:each) do
    @b1 = FactoryGirl.create(:option, :name => "Lymda")
    @b2 = FactoryGirl.create(:option, :name => "Bella")
    @attr = {
      :options => [@b1, @b2],
      :starts_at => DateTime.now,
      :duration => '60'
    }
  end

  it "should create a new instance given a valid set of attributes" do
    battle = Battle.new(@attr)
    expect(battle).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when starts_at is empty' do
      @attr.delete(:starts_at)
      battle = Battle.new(@attr)
      expect(battle).not_to be_valid
    end
  end

  describe 'validates number of options' do
    it 'should fails when number of options is less than 2' do
      battle = Battle.new(@attr.merge(:options => [@b1]))
      expect(battle).not_to be_valid
    end
    it 'should be ok when number of options is equal to 2' do
      battle = Battle.new(@attr.merge(:options => [@b1, @b2]))
      expect(battle).to be_valid
    end
    it 'should be ok when number of options is greater than 2' do
      @b3 = FactoryGirl.create(:option, :name => "Bruni")
      battle = Battle.new(@attr.merge(:options => [@b1, @b2, @b3]))
      expect(battle).to be_valid
    end
  end

  describe 'validate duration numericality' do
    it 'should fails for non integer' do
      battle = Battle.new(@attr.merge(:duration => '7.34'))
      expect(battle).not_to be_valid
    end
    it 'should fails for 0' do
      battle = Battle.new(@attr.merge(:duration => '0'))
      expect(battle).not_to be_valid
    end
    it 'should fails for negative values' do
      battle = Battle.new(@attr.merge(:duration => '-10'))
      expect(battle).not_to be_valid
    end
  end

  describe 'current' do
    it 'should return only battles which start_at is smaller and starts_at plus duration is greater than current time' do
      e1 = double()
      e2 = double()
      e3 = double()
      allow(e1).to receive(:starts_at).and_return(DateTime.new(2017,3,1,1,0))
      allow(e2).to receive(:starts_at).and_return(DateTime.new(2017,3,1,2,0))
      allow(e3).to receive(:starts_at).and_return(DateTime.new(2017,3,1,3,0))
      allow(e1).to receive(:duration).and_return(75)
      allow(e2).to receive(:duration).and_return(22*60)
      allow(e3).to receive(:duration).and_return(60)
      allow(DateTime).to receive(:current).and_return(DateTime.new(2017,3,1,2,30))
      allow(Battle).to receive(:all).and_return([e1, e2, e3])
      battles = Battle.current
      expect(battles).to include(e2)
      expect(battles).not_to include(e1, e3)
    end
  end

  describe 'current?' do
    it 'should return true if battle is on air' do
      e1 = double()
      e2 = Battle.new(@attr)
      e3 = double()
      allow(Battle).to receive(:current).and_return([e1, e2, e3])
      expect(e2.current?).to eq(true)
    end
    it 'should return false if battle is not on air' do
      e1 = double()
      e2 = Battle.new(@attr)
      e3 = double()
      allow(Battle).to receive(:current).and_return([e1, e3])
      expect(e2.current?).to eq(false)
    end
  end

  describe 'remaining_time' do
    it 'should return the remaining time for battle split in hours, minutes and seconds' do
      Timecop.freeze(Time.local(1994))
      battle = Battle.new(@attr.merge(
                                      :starts_at => DateTime.now - 1.hour,
                                      :duration  => 123
                                     ))
      expect(battle.remaining_time).to eq({
                                          hours: 1,
                                          minutes: 3,
                                          seconds: 0
                                         })
    end
  end

  describe 'in_future?' do
    it 'should return true if battle will happen in future' do
      Timecop.freeze(Time.local(2001))
      battle = Battle.new(@attr.merge(
                                      :starts_at => DateTime.now + 1.hour,
                                      :duration => 3*24*60
                                     ))
      expect(battle.in_future?).to eq(true)
    end
    it 'should return false if battle will happen in future' do
      Timecop.freeze(Time.local(2001))
      battle = Battle.new(@attr.merge(
                                      :starts_at => DateTime.now - 1.day,
                                      :duration => 20*60
                                     ))
      expect(battle.in_future?).to eq(false)
    end
  end

  describe 'results by option' do
    before(:each) do
      @b1 = FactoryGirl.create(:option, { name: "Potato" })
      @b2 = FactoryGirl.create(:option, { name: "Tomato" })
      @battle = FactoryGirl.create(:battle, {
        starts_at: DateTime.now - 1.day,
        duration: 24*60,
        number_of_options: 0,
        options: [@b1, @b2]
      })
    end
    it 'should return an empty array if there is no votes' do
      expect(@battle.results_by_option).to eq([])
    end
    it 'should returns an array with options and their votes' do
      FactoryGirl.create(:vote, { option_id: @b1.id })
      FactoryGirl.create(:vote, { option_id: @b1.id })
      FactoryGirl.create(:vote, { option_id: @b1.id })
      FactoryGirl.create(:vote, { option_id: @b2.id })
      FactoryGirl.create(:vote, { option_id: @b2.id })

      results = @battle.results_by_option
      expect(results).to eq([
        {
          value: 3,
          percent: (3*100.0/5).round(1),
          color: @b1.color,
          highlight: @b1.highlight,
          label: @b1.name,
          picture: @b1.picture
        },
        {
          value: 2,
          percent: (2*100.0/5).round(1),
          color: @b2.color,
          highlight: @b2.highlight,
          label: @b2.name,
          picture: @b2.picture
        }
      ])
    end
  end

  describe 'results by hour' do
    before(:each) do
      Timecop.freeze(Time.local(2021))
      @b1 = FactoryGirl.create(:option, { name: "Potato" })
      @b2 = FactoryGirl.create(:option, { name: "Tomato" })
      @battle = FactoryGirl.create(:battle, {
        starts_at: DateTime.now,
        duration: 4*60,
        number_of_options: 0,
        options: [@b1, @b2]
      })
    end
    it 'should returns an empty hash if battle is in the future' do
      Timecop.freeze(Time.local(2020))
      expect(@battle.results_by_hour).to eq({})
    end
    it 'should return votes for each hour since start when battle is current' do
      Timecop.freeze(Time.local(2021) + 1.minute)
      FactoryGirl.create(:vote, { option_id: @b1.id })
      FactoryGirl.create(:vote, { option_id: @b1.id })
      Timecop.freeze(Time.local(2021) + 1.hour + 1.minute)
      FactoryGirl.create(:vote, { option_id: @b1.id })
      FactoryGirl.create(:vote, { option_id: @b2.id })
      FactoryGirl.create(:vote, { option_id: @b2.id })
      Timecop.freeze(Time.local(2021) + 2.hour + 1.minute)
      FactoryGirl.create(:vote, { option_id: @b2.id })

      FactoryGirl.create(:vote) # Votes to other battles are not counted

      results = @battle.results_by_hour
      expect(results).to eq({
        labels: ['01/01/21 -  0h', '01/01/21 -  1h', '01/01/21 -  2h'],
        datasets: [{
          label:           "Battle #{@battle.id}",
          fillColor:       "rgba(255,107,10,0.5)",
          strokeColor:     "rgba(255,107,10,0.8)",
          highlightFill:   "rgba(255,107,10,0.75)",
          highlightStroke: "rgba(255,107,10,1)",
          data: [2, 3, 1]
        }]
      })
    end
    it 'should return votes for each hour of battle when it is over' do
      Timecop.freeze(Time.local(2021) + 1.minute)
      FactoryGirl.create(:vote, { option_id: @b1.id })
      FactoryGirl.create(:vote, { option_id: @b1.id })
      Timecop.freeze(Time.local(2021) + 1.hour + 1.minute)
      FactoryGirl.create(:vote, { option_id: @b1.id })
      FactoryGirl.create(:vote, { option_id: @b2.id })
      FactoryGirl.create(:vote, { option_id: @b2.id })
      Timecop.freeze(Time.local(2021) + 2.hour + 1.minute)
      FactoryGirl.create(:vote, { option_id: @b2.id })
      Timecop.freeze(Time.local(2021) + 3.hour + 1.minute)
      FactoryGirl.create(:vote, { option_id: @b1.id })
      FactoryGirl.create(:vote, { option_id: @b2.id })

      FactoryGirl.create(:vote) # Votes to other battles are not counted

      Timecop.freeze(Time.local(2021) + 10.hour)

      results = @battle.results_by_hour
      expect(results).to eq({
        labels: ['01/01/21 -  0h', '01/01/21 -  1h', '01/01/21 -  2h', '01/01/21 -  3h'],
        datasets: [{
          label:           "Battle #{@battle.id}",
          fillColor:       "rgba(255,107,10,0.5)",
          strokeColor:     "rgba(255,107,10,0.8)",
          highlightFill:   "rgba(255,107,10,0.75)",
          highlightStroke: "rgba(255,107,10,1)",
          data: [2, 3, 1, 2]
        }]
      })
    end
  end


end
