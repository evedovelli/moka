require 'rails_helper'

describe VotesController do
  before (:each) do
    @fake_user = FactoryGirl.create(:user)
    @fake_battle = FactoryGirl.create(:battle, user: @fake_user)
  end

  describe "When user is not logged in" do
    describe "create" do
      before :each do
        post :create, {format: 'js'}
      end
      it "should respond to js" do
        expect(response.content_type).to eq(Mime::JS)
      end
      it "should render the unsigned user template" do
        expect(response).to render_template('votes/unsigned_user')
      end
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
        post :create, { vote: { option_id: @fake_battle.options[0].id, user_id: @fake_user.id } }
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
          @fake_vote = FactoryGirl.create(:vote, user: @fake_user )
          allow(@fake_vote).to receive(:battle).and_return(@fake_battle)
          allow(Vote).to receive(:new).and_return(@fake_vote)
        end

        describe "no params" do
          before :each do
            post :create, {
              format: 'js'
            }
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the reload template" do
            expect(response).to render_template('votes/reload_form')
          end
          it "should make a new vote available to that template" do
            expect(assigns(:vote)).to eq(@fake_vote)
          end
        end

        describe "no option id" do
          before :each do
            post :create, {
              vote: {},
              format: 'js'
            }
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the reload template" do
            expect(response).to render_template('votes/reload_form')
          end
          it "should make a new vote available to that template" do
            expect(assigns(:vote)).to eq(@fake_vote)
          end
        end

        describe "option id in params" do
          before :each do
            allow(controller).to receive(:current_user).and_return(@fake_user)
          end
          it "should call new with correct vote and user" do
            expect(Vote).to receive(:new).with({"option_id" => @fake_battle.options[0].id, "user" => @fake_user})
            post :create, {
              vote: {option_id: @fake_battle.options[0].id},
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
          it 'should call vote_for with correct battle' do
            expect(@fake_user).to receive(:vote_for).with(@fake_battle).twice
            allow(controller).to receive(:current_user).and_return(@fake_user)
            post :create, {
              vote: { option_id: @fake_battle.options[0].id},
              format: 'js'
            }
          end

          describe "user already voted" do
            describe "same option" do
              before :each do
                allow(@fake_vote).to receive(:option_id).and_return(@fake_battle.options[0].id)
                allow(@fake_user).to receive(:vote_for).and_return(@fake_vote)
              end
              it "should respond to js" do
                post :create, {
                  vote: { option_id: @fake_battle.options[0].id},
                  format: 'js'
                }
                expect(response.content_type).to eq(Mime::JS)
              end
              it "should render the reload template" do
                post :create, {
                  vote: { option_id: @fake_battle.options[0].id},
                  format: 'js'
                }
                expect(response).to render_template('votes/reload_form')
              end
              it "should make a new vote available to that template" do
                post :create, {
                  vote: { option_id: @fake_battle.options[0].id},
                  format: 'js'
                }
                expect(assigns(:vote)).to eq(@fake_vote)
              end
              it "should not destroy vote" do
                expect(@fake_vote).not_to receive(:destroy)
                post :create, {
                  vote: { option_id: @fake_battle.options[0].id},
                  format: 'js'
                }
              end
            end

            describe "different option" do
              before :each do
                allow(@fake_vote).to receive(:option_id).and_return(42)
                allow(@fake_user).to receive(:vote_for).and_return(@fake_vote)
              end
              it "should destroy the existing vote" do
                expect(@fake_vote).to receive(:destroy)
                post :create, {
                  vote: { option_id: @fake_battle.options[0].id},
                  format: 'js'
                }
              end
              it "should save the new vote" do
                expect(@fake_vote).to receive(:save)
                post :create, {
                  vote: { option_id: @fake_battle.options[0].id},
                  format: 'js'
                }
              end
            end
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
              allow(@fake_vote).to receive(:error_message).and_return("Error voting")
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
            it "should make a error message available to that template" do
              expect(flash[:alert]).to match("Error voting")
            end
          end
        end
      end

    end

  end
end
