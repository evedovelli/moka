require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  before :each do
    @user = FactoryGirl.create(:user)
  end

  describe "user" do
    describe "admin user" do
      before :each do
        @user.add_role :admin
        @ability = Ability.new(@user)
      end

      describe "Resource User" do
        before :each do
          @other_user = FactoryGirl.create(:user, email: "another@ex.com", username: "second")
        end
        it "should be able to manage its User" do
          expect(@ability).to be_able_to(:manage, @user)
        end
        it "should be able to manage other User" do
          expect(@ability).to be_able_to(:manage, @other_user)
        end
      end

      describe "Resource Stuff" do
        it "should be able to manage stuffs" do
          expect(@ability).to be_able_to(:manage, Stuff)
        end
      end

      describe "Resource Contest" do
        it "should be able to manage contests" do
          expect(@ability).to be_able_to(:manage, Contest)
        end
      end
    end

    describe "other user" do
      before :each do
        @ability = Ability.new(@user)
      end

      describe "Resource User" do
        before :each do
          @other_user = FactoryGirl.create(:user, email: "another@ex.com", username: "second")
        end
        it "should be able to manage its User" do
          expect(@ability).to be_able_to(:manage, @user)
        end
        it "should not be able to manage other User" do
          expect(@ability).not_to be_able_to(:manage, @other_user)
        end
      end

      describe "Resource Stuff" do
        before :each do
          @stuff = FactoryGirl.create(:stuff)
        end
        it "should be able to read stuffs" do
          expect(@ability).to be_able_to(:read, Stuff)
        end
        it "should not be able to create stuffs" do
          expect(@ability).not_to be_able_to(:create, Stuff)
        end
        it "should not be able to destroy stuffs" do
          expect(@ability).not_to be_able_to(:destroy, @stuff)
        end
        it "should not be able to update stuffs" do
          expect(@ability).not_to be_able_to(:update, @stuff)
        end
      end

      describe "Resource Contest" do
        before :each do
          t = Time.local(2015, 10, 21, 07, 28, 0)
          Timecop.travel(t)
          @contest = FactoryGirl.create(:contest,
                                         :starts_at   => DateTime.now - 1.day,
                                         :finishes_at => DateTime.now + 1.day)
        end
        it "should be able to show current contests" do
          expect(@ability).to be_able_to(:show, @contest)
        end
        it "should be able to show past contests" do
          t = Time.local(2015, 10, 26, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).to be_able_to(:show, @contest)
        end
        it "should not be able to show future contests" do
          t = Time.local(2015, 10, 18, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).not_to be_able_to(:show, @contest)
        end
        it "should not be able to index contests" do
          expect(@ability).not_to be_able_to(:index, Contest)
        end
        it "should not be able to create contests" do
          expect(@ability).not_to be_able_to(:create, Contest)
        end
        it "should not be able to update contests" do
          expect(@ability).not_to be_able_to(:update, @contest)
        end
        it "should not be able to destroy contests" do
          expect(@ability).not_to be_able_to(:destroy, @contest)
        end
      end
    end

  end

end
