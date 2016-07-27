require 'rails_helper'

describe CommentsController do

  describe "When user is not logged in" do
    it "should be redirected to 'sign in' page if creating comment" do
      post :create, {option_id: "0", comment: {}}
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    describe "index" do
      before :each do
        @fake_option = FactoryGirl.create(:option)
        allow(Option).to receive(:find).and_return(@fake_option)
        get :index, {option_id: "0", format: 'js'}
      end
      it "should respond to js" do
        expect(response.content_type).to eq(Mime::JS)
      end
      it "should render the unsigned user template" do
        expect(response).to render_template('comments/unsigned_user')
      end
    end
    it "should be redirected to 'sign in' page if destroying comment" do
      delete :destroy, {option_id: "0", id: "0"}
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
  end

  describe "When user is logged in" do
    before (:each) do
      @fake_user = FactoryGirl.create(:user)
      sign_in @fake_user
    end

    describe "When user is not authorized" do
      before (:each) do
        @fake_option = FactoryGirl.create(:option)
        @fake_comment = FactoryGirl.create(:comment, option: @fake_option, user: @fake_user)
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      end
      it "should be redirected to root page if creating the comment" do
        post :create, {option_id: @fake_option.id, comment: {}}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if indexing the comments" do
        get :index, {option_id: @fake_option.id, :format => 'js'}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if creating the comment" do
        delete :destroy, {option_id: @fake_option.id, id: @fake_comment.id}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
    end

    describe "When user is authorized" do
      before (:each) do
        @fake_option = FactoryGirl.create(:option)
        allow(Option).to receive(:find).and_return(@fake_option)
        allow(controller).to receive(:authorize!).and_return(true)
      end

      describe "create" do
        before :each do
          @fake_comment = FactoryGirl.create(:comment, option: @fake_option, user: @fake_user)
        end
        it "should call find option with correct id" do
          expect(Option).to receive(:find).with("#{@fake_option.id}").and_return(@fake_option)
          post :create, {option_id: @fake_option.id, comment: {}, :format => 'js'}
        end
        it "should call new with correct params" do
          expect(@fake_comment).to receive(:save).and_return(false)
          expect(Comment).to receive(:new).with({"body" => "guard"}).and_return(@fake_comment)
          post :create, {option_id: @fake_option.id, comment: {body: "guard"}, :format => 'js'}
        end
        describe "on success" do
          before :each do
            allow(@fake_comment).to receive(:save).and_return(true)
            allow(Comment).to receive(:new).and_return(@fake_comment)
            post :create, {option_id: @fake_option.id, comment: {body: "guard"}, :format => 'js'}
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the create template" do
            expect(response).to render_template('create')
          end
          it "should make a new_comment available" do
            expect(assigns(:new_comment)).to eq(@fake_comment)
          end
          it "should make the comment available" do
            expect(assigns(:comment)).to eq(@fake_comment)
          end
          it "should make the option available" do
            expect(assigns(:option)).to eq(@fake_option)
          end
        end
        describe "on error" do
          before :each do
            allow(@fake_comment).to receive(:save).and_return(false)
            allow(Comment).to receive(:new).and_return(@fake_comment)
            post :create, {option_id: @fake_option.id, comment: {body: "guard"}, :format => 'js'}
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the create template" do
            expect(response).to render_template('reload_form')
          end
          it "should make the comment available" do
            expect(assigns(:comment)).to eq(@fake_comment)
          end
          it "should make the option available" do
            expect(assigns(:option)).to eq(@fake_option)
          end
        end
      end

      describe "index" do
        before :each do
          @fake_comment = FactoryGirl.create(:comment, option: @fake_option, user: @fake_user)
          allow(Comment).to receive(:new).and_return(@fake_comment)
        end
        it "should call find option with correct id" do
          expect(Option).to receive(:find).with("#{@fake_option.id}").and_return(@fake_option)
          get :index, {option_id: @fake_option.id, :format => 'js'}
        end
        it "should call ordered_comments with correct page" do
          expect(@fake_option).to receive(:ordered_comments).with("10").and_return([@fake_comment])
          get :index, {option_id: @fake_option.id, page: "10", :format => 'js'}
        end
        it "should respond to js" do
          get :index, {option_id: @fake_option.id, :format => 'js'}
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the index template" do
          get :index, {option_id: @fake_option.id, :format => 'js'}
          expect(response).to render_template('index')
        end
        it "should make a comment available" do
          get :index, {option_id: @fake_option.id, :format => 'js'}
          expect(assigns(:comment)).to eq(@fake_comment)
        end
        it "should make the option available" do
          get :index, {option_id: @fake_option.id, :format => 'js'}
          expect(assigns(:option)).to eq(@fake_option)
        end
        it "should make the list of comments available" do
          @comments = double("comments")
          expect(@fake_option).to receive(:ordered_comments).and_return(@comments)
          get :index, {option_id: @fake_option.id, :format => 'js'}
          expect(assigns(:comments)).to eq(@comments)
        end
      end

      describe "destroy" do
        before :each do
          @fake_comment = FactoryGirl.create(:comment, option: @fake_option, user: @fake_user)
          @fake_comments = double("fake_comments")
          allow(@fake_comments).to receive(:find).and_return(@fake_comment)
          allow(@fake_option).to receive(:comments).and_return(@fake_comments)
        end
        it "should call find option with correct id" do
          expect(Option).to receive(:find).with("#{@fake_option.id}").and_return(@fake_option)
          delete :destroy, {option_id: @fake_option.id, id: @fake_comment.id, :format => 'js'}
        end
        it "should call destroy for comment" do
          expect(@fake_comment).to receive(:destroy)
          delete :destroy, {option_id: @fake_option.id, id: @fake_comment.id, :format => 'js'}
        end
        it "should respond to js" do
          delete :destroy, {option_id: @fake_option.id, id: @fake_comment.id, :format => 'js'}
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the destroy template" do
          delete :destroy, {option_id: @fake_option.id, id: @fake_comment.id, :format => 'js'}
          expect(response).to render_template('destroy')
        end
        it "should make comment_id available" do
          delete :destroy, {option_id: @fake_option.id, id: @fake_comment.id, :format => 'js'}
          expect(assigns(:comment_id)).to eq(@fake_comment.id)
        end
        it "should make the option available" do
          delete :destroy, {option_id: @fake_option.id, id: @fake_comment.id, :format => 'js'}
          expect(assigns(:option)).to eq(@fake_option)
        end
      end

    end

  end

end
