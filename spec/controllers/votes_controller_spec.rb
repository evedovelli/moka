require 'rails_helper'

describe VotesController do
  before (:each) do
    @fake_battle = FactoryGirl.create(:battle)
  end

  describe "When user is not authorized" do
    before (:each) do
      allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
    end
    it "should be redirected to root page if accessing new page" do
      allow(Battle).to receive(:current).and_return([@fake_battle])
      get :new
      expect(flash[:alert]).to match("Access denied.")
      expect(response).to redirect_to(root_url)
    end
    it "should be redirected to root page if creating vote" do
      allow(Battle).to receive(:find).and_return(@fake_battle)
      post :create, { vote: {"option_id" => @fake_battle.options[0].id} }
      expect(flash[:alert]).to match("Access denied.")
      expect(response).to redirect_to(root_url)
    end
  end

  describe "When user is authorized" do
    before (:each) do
      allow(controller).to receive(:authorize!).and_return(true)
    end

    describe "new" do
      it "should search current battle" do
        expect(Battle).to receive(:current).and_return([])
        get :new
      end
      it "should respond to HTML" do
        allow(Battle).to receive(:current).and_return([@fake_battle])
        get :new
        expect(response.content_type).to eq(Mime::HTML)
      end
      it "should render the no_battle template if there is no battle" do
        allow(Battle).to receive(:current).and_return([])
        get :new
        expect(response).to render_template('no_battle')
      end
      it "should render the new template" do
        allow(Battle).to receive(:current).and_return([@fake_battle])
        get :new
        expect(response).to render_template('new')
      end
      it "should make a new vote available to that template" do
        allow(Battle).to receive(:current).and_return([@fake_battle])
        get :new
        expect(assigns(:vote)).to be_new_record
      end
      it "should make current battle available to that template" do
        allow(Battle).to receive(:current).and_return([@fake_battle])
        get :new
        expect(assigns(:battle)).to eq(@fake_battle)
      end
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
          vote: {"option_id" => @fake_battle.options[0].id},
          format: 'js'
        }
      end
      describe "in success" do
        before :each do
          @results = double("results")
          allow(@fake_battle).to receive(:results_by_option).and_return(@results)
          allow(@fake_vote).to receive(:save).and_return(true)
          allow(@fake_vote).to receive(:battle).and_return(@fake_battle)
          post :create, {
            vote: {"option_id" => @fake_battle.options[0].id},
            format: 'js'
          }
        end
        it "should respond to js" do
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the create template" do
          expect(response).to render_template('create')
        end
        it "should make registered vote available to that template" do
          expect(assigns(:registered_vote)).to eq(@fake_vote)
        end
        it "should make battle available to that template" do
          expect(assigns(:battle)).to eq(@fake_battle)
        end
        it "should make new vote available to that template" do
          expect(assigns(:vote)).to eq(@fake_vote)
        end
        it "should make partial results available to that template" do
          expect(assigns(:results_by_option)).to eq(@results)
        end
        it "should make the number of options available to that template" do
          expect(assigns(:number_of_options)).to eq(@fake_battle.options.count)
        end
        it "should make the remaining time of battle available to that template" do
          expect(assigns(:remaining_time)).to eq(@fake_battle.remaining_time.stringify_keys)
        end
      end
      describe "in error" do
        before :each do
          allow(@fake_vote).to receive(:save).and_return(false)
          @battle = FactoryGirl.create(:battle)
          allow(Battle).to receive(:current).and_return([@battle])
          post :create, {
            vote: {"option_id" => @fake_battle.options[0].id},
            format: 'js'
          }
        end
        it "should respond to js" do
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the reload_form for template" do
          expect(response).to render_template('reload_form')
        end
        it "should make battle available to that template" do
          expect(assigns(:battle)).to eq(@battle)
        end
        it "should make new vote available to that template" do
          expect(assigns(:vote)).to eq(@fake_vote)
        end
      end
    end

  end
end
