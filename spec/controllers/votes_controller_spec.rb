require 'rails_helper'

describe VotesController do
  before (:each) do
    @fake_contest = FactoryGirl.create(:contest)
  end

  describe "When user is not authorized" do
    before (:each) do
      allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
    end
    it "should be redirected to root page if accessing new page" do
      allow(Contest).to receive(:current).and_return([@fake_contest])
      get :new
      expect(flash[:alert]).to match("Access denied.")
      expect(response).to redirect_to(root_url)
    end
    it "should be redirected to root page if creating template" do
      allow(Contest).to receive(:find).and_return(@fake_contest)
      post :create, { :vote => {}, :contest_id => 1 }
      expect(flash[:alert]).to match("Access denied.")
      expect(response).to redirect_to(root_url)
    end
  end

  describe "When user is authorized" do
    before (:each) do
      allow(controller).to receive(:authorize!).and_return(true)
    end

    describe "new" do
      it "should search current contest" do
        expect(Contest).to receive(:current).and_return([])
        get :new
      end
      it "should respond to HTML" do
        allow(Contest).to receive(:current).and_return([@fake_contest])
        get :new
        expect(response.content_type).to eq(Mime::HTML)
      end
      it "should render the no_contest template if there is no contest" do
        allow(Contest).to receive(:current).and_return([])
        get :new
        expect(response).to render_template('no_contest')
      end
      it "should render the new template" do
        allow(Contest).to receive(:current).and_return([@fake_contest])
        get :new
        expect(response).to render_template('new')
      end
      it "should make a new vote available to that template" do
        allow(Contest).to receive(:current).and_return([@fake_contest])
        get :new
        expect(assigns(:vote)).to be_new_record
      end
      it "should make current contest available to that template" do
        allow(Contest).to receive(:current).and_return([@fake_contest])
        get :new
        expect(assigns(:contest)).to eq(@fake_contest)
      end
    end

    describe "create" do
      before :each do
        @fake_vote = FactoryGirl.create(:vote)
        allow(Vote).to receive(:new).and_return(@fake_vote)
      end
      it "should search contest with correct id" do
        expect(Contest).to receive(:find).with("#{@fake_contest.id}")
        post :create, {
          contest_id: @fake_contest.id,
          vote: {},
          format: 'js'
        }
      end
      it "should call new with correct vote" do
        expect(Vote).to receive(:new).with({"teste" => "teste"})
        post :create, {
          contest_id: @fake_contest.id,
          vote: {"teste" => "teste"},
          format: 'js'
        }
      end
      describe "in success" do
        before :each do
          allow(@fake_vote).to receive(:save).and_return(true)
          allow(Contest).to receive(:find).and_return(@fake_contest)
          @results = double("results")
          allow(@fake_contest).to receive(:results_by_stuff).and_return(@results)
          post :create, {
            contest_id: @fake_contest.id,
            vote: {},
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
        it "should make contest available to that template" do
          expect(assigns(:contest)).to eq(@fake_contest)
        end
        it "should make new vote available to that template" do
          expect(assigns(:vote)).to eq(@fake_vote)
        end
        it "should make partial results available to that template" do
          expect(assigns(:results_by_stuff)).to eq(@results)
        end
        it "should make the number of stuffs available to that template" do
          expect(assigns(:number_of_stuffs)).to eq(@fake_contest.stuffs.count)
        end
        it "should make the remaining time of contest available to that template" do
          expect(assigns(:remaining_time)).to eq(@fake_contest.remaining_time.stringify_keys)
        end
      end
      describe "in error" do
        before :each do
          allow(@fake_vote).to receive(:save).and_return(false)
          post :create, {
            contest_id: @fake_contest.id,
            vote: {},
            format: 'js'
          }
        end
        it "should respond to js" do
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the reload_form for template" do
          expect(response).to render_template('reload_form')
        end
        it "should make contest available to that template" do
          expect(assigns(:contest)).to eq(@fake_contest)
        end
        it "should make new vote available to that template" do
          expect(assigns(:vote)).to eq(@fake_vote)
        end
      end
    end

  end
end
