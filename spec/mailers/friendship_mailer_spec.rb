require "rails_helper"

RSpec.describe FriendshipMailer, :type => :mailer do
  describe 'new follower' do
    describe 'default locale' do
      before(:each) do
        ActionMailer::Base.perform_deliveries = true
        ActionMailer::Base.deliveries = []

        @user = FactoryGirl.create(:user, name: "Finn")
        @follower = FactoryGirl.create(:user, username: "friend", email: "friend@friend.com")
      end
      after(:each) do
        ActionMailer::Base.deliveries.clear
      end

      let(:mail) { FriendshipMailer.new_follower(@follower, @user) }

      it 'should sends an email' do
        expect {
                 FriendshipMailer.new_follower(@follower, @user).deliver
               }.to change {
                             ActionMailer::Base.deliveries.count
                           }.by(1)
      end
      it 'should renders the subject' do
        expect(mail.subject).to eql('friend is now following you on Batalharia')
      end
      it 'should renders the receiver email' do
        expect(mail.to).to eql([@user.email])
      end
      it 'should renders the sender email' do
        expect(mail.from).to eql(['notification@batalharia.com'])
      end
      it 'should contains URL for Batalharia' do
        expect(mail.body.encoded).to match(url_for(:host => "batalharia.com",
                                                   :controller => "users",
                                                   :action => "home"
                                                  ))
      end
      it 'should contains hello message' do
        expect(mail.body.encoded).to match('Hello Finn,')
      end
      it 'should contains follower URL' do
        expect(mail.body.encoded).to match(url_for(:host => 'batalharia.com',
                                                   :controller => "users",
                                                   :action => "show",
                                                   :id => @follower.username))
      end
      it 'should contains follow back message' do
        expect(mail.body.encoded).to match("friend is now following you on Batalharia.")
      end
      it 'should contains visit profile message' do
        expect(mail.body.encoded).to match("Visit friend profile")
      end
      it 'should contains text message' do
        link = url_for(:host => 'batalharia.com',
                       :controller => "users",
                       :action => "show",
                       :id => @follower.username)
        expect(mail.body.encoded).to match("Click on #{link} to visit friend profile")
      end
      it 'should contains logo attached' do
        expect(mail.attachments.count).to eq(1)
        attachment = mail.attachments[0]
        expect(attachment).to be_a_kind_of(Mail::Part)
        expect(attachment.content_type).to start_with('image/png')
        expect(attachment.filename).to match('logo_short.png')
      end
    end

    describe 'locale from user' do
      before(:each) do
        ActionMailer::Base.perform_deliveries = true
        ActionMailer::Base.deliveries = []

        @user = FactoryGirl.create(:user, name: "Finn")
        @follower = FactoryGirl.create(:user, username: "friend", email: "friend@friend.com")
        allow(@user).to receive(:language).and_return("pt-BR")
      end
      after(:each) do
        ActionMailer::Base.deliveries.clear
      end

      let(:mail) { FriendshipMailer.new_follower(@follower, @user) }

      it 'should renders the subject' do
        expect(mail.subject).to eql('friend começou a seguir você no Batalharia')
      end
      it 'should renders the sender email' do
        expect(mail.from).to eql(['notification@batalharia.com'])
      end
      it 'should contains URL for Batalharia' do
        expect(mail.body.encoded).to match(url_for(:host => "batalharia.com",
                                                   :controller => "users",
                                                   :action => "home"
                                                  ))
      end
      it 'should contains follower URL' do
        expect(mail.body.encoded).to match(url_for(:host => 'batalharia.com',
                                                   :controller => "users",
                                                   :action => "show",
                                                   :id => @follower.username))
      end
      it 'should contains follow back message' do
        expect(mail.body.encoded).to match("a seguir")
      end
      it 'should contains visit profile message' do
        expect(mail.body.encoded).to match("Visite o perfil de friend")
      end
    end
  end

  describe 'facebook friend sign up' do
    describe 'default locale' do
      before(:each) do
        ActionMailer::Base.perform_deliveries = true
        ActionMailer::Base.deliveries = []

        @user = FactoryGirl.create(:user, name: "Finn")
        @friend = FactoryGirl.create(:user, username: "friend", email: "friend@friend.com")
      end
      after(:each) do
        ActionMailer::Base.deliveries.clear
      end

      let(:mail) { FriendshipMailer.facebook_friend_sign_up(@friend, @user) }

      it 'should sends an email' do
        expect {
                 FriendshipMailer.facebook_friend_sign_up(@friend, @user).deliver
               }.to change {
                             ActionMailer::Base.deliveries.count
                           }.by(1)
      end
      it 'should renders the subject' do
        expect(mail.subject).to eql('Your Facebook friend friend has just signed up to Batalharia')
      end
      it 'should renders the receiver email' do
        expect(mail.to).to eql([@user.email])
      end
      it 'should renders the sender email' do
        expect(mail.from).to eql(['notification@batalharia.com'])
      end
      it 'should contains URL for Batalharia' do
        expect(mail.body.encoded).to match(url_for(:host => "batalharia.com",
                                                   :controller => "users",
                                                   :action => "home"
                                                  ))
      end
      it 'should contains hello message' do
        expect(mail.body.encoded).to match('Hello Finn,')
      end
      it 'should contains friend URL' do
        expect(mail.body.encoded).to match(url_for(:host => 'batalharia.com',
                                                   :controller => "users",
                                                   :action => "show",
                                                   :id => @friend.username))
      end
      it 'should contains follow friend message' do
        expect(mail.body.encoded).to match('Follow <a href="http://batalharia.com/en/users/friend" style="color:#ff5555">friend</a> and don\'t miss any of <a href="http://batalharia.com/en/users/friend" style="color:#ff5555">friend</a> battles on <span style="color:#ff5555; font-size:17px; letter-spacing:0.3px; font-weight:bold">Batalharia</span>')
      end
      it 'should contains visit profile message' do
        expect(mail.body.encoded).to match("Visit friend profile")
      end
      it 'should contains text message' do
        link = url_for(:host => 'batalharia.com',
                       :controller => "users",
                       :action => "show",
                       :id => @friend.username)
        expect(mail.body.encoded).to match("Click on #{link} to visit friend profile")
      end
      it 'should contains logo attached' do
        expect(mail.attachments.count).to eq(1)
        attachment = mail.attachments[0]
        expect(attachment).to be_a_kind_of(Mail::Part)
        expect(attachment.content_type).to start_with('image/png')
        expect(attachment.filename).to match('logo_short.png')
      end
    end

    describe 'locale from user' do
      before(:each) do
        ActionMailer::Base.perform_deliveries = true
        ActionMailer::Base.deliveries = []

        @user = FactoryGirl.create(:user, name: "Finn")
        @friend = FactoryGirl.create(:user, username: "friend", name: "Mafalda", email: "friend@friend.com")
        allow(@user).to receive(:language).and_return("pt-BR")
      end
      after(:each) do
        ActionMailer::Base.deliveries.clear
      end

      let(:mail) { FriendshipMailer.facebook_friend_sign_up(@friend, @user) }

      it 'should renders the subject' do
        expect(mail.subject).to eql('Seu amigo do Facebook Mafalda acaba de entrar para o Batalharia')
      end
      it 'should renders the sender email' do
        expect(mail.from).to eql(['notification@batalharia.com'])
      end
      it 'should contains URL for Batalharia' do
        expect(mail.body.encoded).to match(url_for(:host => "batalharia.com",
                                                   :controller => "users",
                                                   :action => "home"
                                                  ))
      end
      it 'should contains friend URL' do
        expect(mail.body.encoded).to match(url_for(:host => 'batalharia.com',
                                                   :controller => "users",
                                                   :action => "show",
                                                   :id => @friend.username))
      end
      it 'should contains follow friend message' do
        expect(mail.body.encoded).to match('perca nenhuma de suas batalhas no')
      end
      it 'should contains visit profile message' do
        expect(mail.body.encoded).to match("Visite o perfil de Mafalda")
      end
    end
  end
end
