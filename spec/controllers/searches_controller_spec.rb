require 'rails_helper'

RSpec.describe SearchesController, :type => :controller do

  describe "search" do
    describe "invalid" do
      it "should be redirected to root when no search" do
        get :search, {commit: "user"}
        expect(flash[:alert]).to match("Invalid search")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root when search is empty" do
        get :search, {search: "", commit: "user"}
        expect(flash[:alert]).to match("Invalid search")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root when no commit" do
        get :search, {search: "bob"}
        expect(flash[:alert]).to match("Invalid search")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root when commit is empty" do
        get :search, {search: "bob", commit: ""}
        expect(flash[:alert]).to match("Invalid search")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root when commit is invalid" do
        get :search, {search: "bob", commit: "invalid"}
        expect(flash[:alert]).to match("Invalid search")
        expect(response).to redirect_to(root_url)
      end
    end
    describe "valid" do
      it "should be redirected to users path when commit is user" do
        get :search, {search: "bob", commit: "user"}
        expect(response).to redirect_to(users_path(search: "bob"))
      end
      it "should be redirected to hashtag path when commit is hashtag" do
        get :search, {search: "bob", commit: "hashtag"}
        expect(response).to redirect_to(hashtag_path(hashtag: "bob"))
      end
    end
  end

end
