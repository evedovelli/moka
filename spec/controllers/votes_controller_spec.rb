require 'rails_helper'

describe VotesController do
  before (:each) do
    @fake_user = FactoryGirl.create(:user)
    @fake_battle = FactoryGirl.create(:battle, user: @fake_user)
  end

  describe "When user is not logged in" do
    it "should be redirected to 'sign in' page if creating a vote" do
      post :create, { vote: { option_id: @fake_battle.options[0].id} }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
  end

  describe "When user is logged in" do
    before (:each) do
      sign_in @fake_user
    end

    describe "When user is not authorized" do
      before (:each) do
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      end
      it "should be redirected to root page if creating vote" do
        allow(Battle).to receive(:find).and_return(@fake_battle)
        post :create, { vote: { option_id: @fake_battle.options[0].id} }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
    end

    describe "When user is authorized" do
      before (:each) do
        allow(controller).to receive(:authorize!).and_return(true)
      end

      describe "create" do
        before :each do
          @fake_vote = FactoryGirl.create(:vote)
          allow(@fake_vote).to receive(:battle).and_return(@fake_battle)
          allow(Vote).to receive(:new).and_return(@fake_vote)
        end
        it "should call new with correct vote" do
          expect(Vote).to receive(:new).with({"option_id" => @fake_battle.options[0].id})
          post :create, {
            vote: { option_id: @fake_battle.options[0].id},
            format: 'js'
          }
        end
        it 'should make the voted option id available' do
          post :create, {
            vote: { option_id: @fake_battle.options[0].id},
            format: 'js'
          }
          expect(assigns(:selected_option_id)).to eq(@fake_battle.options[0].id)
        end
        describe "in success" do
          before :each do
            @results = double("results")
            allow(@fake_vote).to receive(:save).and_return(true)
            allow(@fake_vote).to receive(:battle).and_return(@fake_battle)
            post :create, {
              vote: { option_id: @fake_battle.options[0].id},
              format: 'js'
            }
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the create template" do
            expect(response).to render_template('create')
          end
          it "should make battle available to that template" do
            expect(assigns(:battle)).to eq(@fake_battle)
          end
          it "should make a new vote available to that template" do
            expect(assigns(:vote)).to eq(@fake_vote)
          end
        end
        describe "in error" do
          before :each do
            allow(@fake_vote).to receive(:save).and_return(false)
            @battle = FactoryGirl.create(:battle)
            post :create, {
              vote: { option_id: @fake_battle.options[0].id},
              format: 'js'
            }
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the reload_form for template" do
            expect(response).to render_template('reload_form')
          end
          it "should make a new vote available to that template" do
            expect(assigns(:vote)).to eq(@fake_vote)
          end
        end
      end

    end

  end
end
