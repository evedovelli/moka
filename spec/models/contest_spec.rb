require 'rails_helper'

describe Contest do
  before(:each) do
    @b1 = FactoryGirl.create(:stuff, :name => "Lymda")
    @b2 = FactoryGirl.create(:stuff, :name => "Bella")
    @attr = {
      :stuffs => [@b1, @b2],
      :starts_at => DateTime.now,
      :finishes_at => DateTime.now + 7.days
    }
  end

  it "should create a new instance given a valid set of attributes" do
    contest = Contest.new(@attr)
    expect(contest).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when starts_at is empty' do
      @attr.delete(:starts_at)
      contest = Contest.new(@attr)
      expect(contest).not_to be_valid
    end
    it 'should fails when finishes_at is empty' do
      @attr.delete(:finishes_at)
      contest = Contest.new(@attr)
      expect(contest).not_to be_valid
    end
  end

  describe 'validates number of stuffs' do
    it 'should fails when number of stuffs is less than 2' do
      contest = Contest.new(@attr.merge(:stuffs => [@b1]))
      expect(contest).not_to be_valid
    end
    it 'should be ok when number of stuffs is equal to 2' do
      contest = Contest.new(@attr.merge(:stuffs => [@b1, @b2]))
      expect(contest).to be_valid
    end
    it 'should be ok when number of stuffs is greater than 2' do
      @b3 = FactoryGirl.create(:stuff, :name => "Bruni")
      contest = Contest.new(@attr.merge(:stuffs => [@b1, @b2, @b3]))
      expect(contest).to be_valid
    end
  end

  describe 'validates timings' do
    it 'should fails when finishes earlier than starts' do
      contest = Contest.new(@attr.merge(:starts_at => DateTime.now, :finishes_at => DateTime.now - 1.day))
      expect(contest).not_to be_valid
    end
    it 'should fails when finishes later than starts' do
      contest = Contest.new(@attr.merge(:starts_at => DateTime.now, :finishes_at => DateTime.now + 1.day))
      expect(contest).to be_valid
    end
  end

  describe 'current' do
    it 'should return only contests which start_at is smaller and finishes_at is greater than current time' do
      e1 = double()
      e2 = double()
      e3 = double()
      allow(e1).to receive(:starts_at).and_return(DateTime.new(2017,3,1,1,0))
      allow(e2).to receive(:starts_at).and_return(DateTime.new(2017,3,1,2,0))
      allow(e3).to receive(:starts_at).and_return(DateTime.new(2017,3,1,3,0))
      allow(e1).to receive(:finishes_at).and_return(DateTime.new(2017,3,1,2,15))
      allow(e2).to receive(:finishes_at).and_return(DateTime.new(2017,3,2,0,0))
      allow(e3).to receive(:finishes_at).and_return(DateTime.new(2017,3,1,4,0))
      allow(DateTime).to receive(:current).and_return(DateTime.new(2017,3,1,2,30))
      allow(Contest).to receive(:all).and_return([e1, e2, e3])
      contests = Contest.current
      expect(contests).to include(e2)
      expect(contests).not_to include(e1, e3)
    end
  end

  describe 'current?' do
    it 'should return true if contest is on air' do
      e1 = double()
      e2 = Contest.new(@attr)
      e3 = double()
      allow(Contest).to receive(:current).and_return([e1, e2, e3])
      expect(e2.current?).to eq(true)
    end
    it 'should return false if contest is not on air' do
      e1 = double()
      e2 = Contest.new(@attr)
      e3 = double()
      allow(Contest).to receive(:current).and_return([e1, e3])
      expect(e2.current?).to eq(false)
    end
  end

  describe 'remaining_time' do
    it 'should return the remaining time for contest split in hours, minutes and seconds' do
      Timecop.freeze(Time.local(1994))
      contest = Contest.new(@attr.merge(
                                          :starts_at => DateTime.now - 1.hour,
                                          :finishes_at => DateTime.now + 1.hour + 3.minute + 20.seconds
                                         ))
      expect(contest.remaining_time).to eq({
                                             hours: 1,
                                             minutes: 3,
                                             seconds: 20
                                            })
    end
  end

  describe 'in_future?' do
    it 'should return true if contest will happen in future' do
      Timecop.freeze(Time.local(2001))
      contest = Contest.new(@attr.merge(
                                          :starts_at => DateTime.now + 1.hour,
                                          :finishes_at => DateTime.now + 3.days + 3.hours
                                         ))
      expect(contest.in_future?).to eq(true)
    end
    it 'should return false if contest will happen in future' do
      Timecop.freeze(Time.local(2001))
      contest = Contest.new(@attr.merge(
                                          :starts_at => DateTime.now - 1.day,
                                          :finishes_at => DateTime.now - 3.hours
                                         ))
        expect(contest.in_future?).to eq(false)
    end
  end

  describe 'results by stuff' do
    before(:each) do
      @b1 = FactoryGirl.create(:stuff, { name: "Julia", picture: 1 })
      @b2 = FactoryGirl.create(:stuff, { name: "Jacques", picture: 2 })
      @contest = FactoryGirl.create(:contest, {
        starts_at:   DateTime.now - 1.day,
        finishes_at: DateTime.now + 1.day,
        stuff_ids: [@b1.id, @b2.id]
      })
    end
    it 'should return an empty array if there is no votes' do
      expect(@contest.results_by_stuff).to eq([])
    end
    it 'should returns an array with stuffs and their votes' do
      FactoryGirl.create(:vote, { stuff_id: @b1.id, contest_id: @contest.id })
      FactoryGirl.create(:vote, { stuff_id: @b1.id, contest_id: @contest.id })
      FactoryGirl.create(:vote, { stuff_id: @b1.id, contest_id: @contest.id })
      FactoryGirl.create(:vote, { stuff_id: @b2.id, contest_id: @contest.id })
      FactoryGirl.create(:vote, { stuff_id: @b2.id, contest_id: @contest.id })

      results = @contest.results_by_stuff
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
      @b1 = FactoryGirl.create(:stuff, { name: "Julia", picture: 1 })
      @b2 = FactoryGirl.create(:stuff, { name: "Jacques", picture: 2 })
      @contest = FactoryGirl.create(:contest, {
        starts_at:   DateTime.now,
        finishes_at: DateTime.now + 4.hours,
        stuff_ids: [@b1.id, @b2.id]
      })
    end
    it 'should returns an empty hash if contest is in the future' do
      Timecop.freeze(Time.local(2020))
      expect(@contest.results_by_hour).to eq({})
    end
    it 'should return votes for each hour since start when contest is current' do
      Timecop.freeze(Time.local(2021) + 1.minute)
      FactoryGirl.create(:vote, { stuff_id: @b1.id, contest_id: @contest.id })
      FactoryGirl.create(:vote, { stuff_id: @b1.id, contest_id: @contest.id })
      Timecop.freeze(Time.local(2021) + 1.hour + 1.minute)
      FactoryGirl.create(:vote, { stuff_id: @b1.id, contest_id: @contest.id })
      FactoryGirl.create(:vote, { stuff_id: @b2.id, contest_id: @contest.id })
      FactoryGirl.create(:vote, { stuff_id: @b2.id, contest_id: @contest.id })
      Timecop.freeze(Time.local(2021) + 2.hour + 1.minute)
      FactoryGirl.create(:vote, { stuff_id: @b2.id, contest_id: @contest.id })

      FactoryGirl.create(:vote) # Votes to other contests are not counted

      results = @contest.results_by_hour
      expect(results).to eq({
        labels: ['01/01/21 -  0h', '01/01/21 -  1h', '01/01/21 -  2h'],
        datasets: [{
          label:           "Contest #{@contest.id}",
          fillColor:       "rgba(255,107,10,0.5)",
          strokeColor:     "rgba(255,107,10,0.8)",
          highlightFill:   "rgba(255,107,10,0.75)",
          highlightStroke: "rgba(255,107,10,1)",
          data: [2, 3, 1]
        }]
      })
    end
    it 'should return votes for each hour of contest when it is over' do
      Timecop.freeze(Time.local(2021) + 1.minute)
      FactoryGirl.create(:vote, { stuff_id: @b1.id, contest_id: @contest.id })
      FactoryGirl.create(:vote, { stuff_id: @b1.id, contest_id: @contest.id })
      Timecop.freeze(Time.local(2021) + 1.hour + 1.minute)
      FactoryGirl.create(:vote, { stuff_id: @b1.id, contest_id: @contest.id })
      FactoryGirl.create(:vote, { stuff_id: @b2.id, contest_id: @contest.id })
      FactoryGirl.create(:vote, { stuff_id: @b2.id, contest_id: @contest.id })
      Timecop.freeze(Time.local(2021) + 2.hour + 1.minute)
      FactoryGirl.create(:vote, { stuff_id: @b2.id, contest_id: @contest.id })
      Timecop.freeze(Time.local(2021) + 3.hour + 1.minute)
      FactoryGirl.create(:vote, { stuff_id: @b1.id, contest_id: @contest.id })
      FactoryGirl.create(:vote, { stuff_id: @b2.id, contest_id: @contest.id })

      FactoryGirl.create(:vote) # Votes to other contests are not counted

      Timecop.freeze(Time.local(2021) + 10.hour)

      results = @contest.results_by_hour
      expect(results).to eq({
        labels: ['01/01/21 -  0h', '01/01/21 -  1h', '01/01/21 -  2h', '01/01/21 -  3h'],
        datasets: [{
          label:           "Contest #{@contest.id}",
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
