require 'rails_helper'
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

      describe "Resource Option" do
        it "should be able to manage options" do
          expect(@ability).to be_able_to(:manage, Option)
        end
      end

      describe "Resource Battle" do
        it "should be able to manage battles" do
          expect(@ability).to be_able_to(:manage, Battle)
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

      describe "Resource Option" do
        before :each do
          @option = FactoryGirl.create(:option)
        end
        it "should be able to read options" do
          expect(@ability).to be_able_to(:read, Option)
        end
        it "should not be able to create options" do
          expect(@ability).not_to be_able_to(:create, Option)
        end
        it "should not be able to destroy options" do
          expect(@ability).not_to be_able_to(:destroy, @option)
        end
        it "should not be able to update options" do
          expect(@ability).not_to be_able_to(:update, @option)
        end
      end

      describe "Resource Battle" do
        before :each do
          t = Time.local(2015, 10, 21, 07, 28, 0)
          Timecop.travel(t)
          @battle = FactoryGirl.create(:battle,
                                       :starts_at => DateTime.now - 1.day,
                                       :duration => 48*60)
        end
        it "should be able to show current battles" do
          expect(@ability).to be_able_to(:show, @battle)
        end
        it "should be able to show past battles" do
          t = Time.local(2015, 10, 26, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).to be_able_to(:show, @battle)
        end
        it "should not be able to show future battles" do
          t = Time.local(2015, 10, 18, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).not_to be_able_to(:show, @battle)
        end
        it "should not be able to index battles" do
          expect(@ability).not_to be_able_to(:index, Battle)
        end
        it "should not be able to create battles" do
          expect(@ability).not_to be_able_to(:create, Battle)
        end
        it "should not be able to update battles" do
          expect(@ability).not_to be_able_to(:update, @battle)
        end
        it "should not be able to destroy battles" do
          expect(@ability).not_to be_able_to(:destroy, @battle)
        end
      end
    end

  end

end
