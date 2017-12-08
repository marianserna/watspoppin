require "rails_helper"

RSpec.fdescribe Users::OmniauthCallbacksController, type: :controller do
  # let(:user) { FactoryBot.create(:user) }
  # let(:service) {FactoryBot.create(:service)}
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  # let(:service) {user.services.where(provider: auth.provider, uid: auth.uid).first}
  #
  # describe "#set_user" do
  #
  #   it "should have a current_user" do
  #     sign_in user
  #     expect(subject.current_user).to_not eq(nil)
  #   end
  #
  #   it "should log user out" do
  #     sign_out user
  #     expect(subject.current_user).to eq(nil)
  #   end
  # end

  describe "#New user" do
    context "when facebook email doesn't exist in the system" do
      before(:each) do
        facebook_auth_hash
        get :facebook
        @user = User.where(email: "user@email.com").first
      end

      # it { @user.should_not be_nil }
      it "user should not be nil" do
        expect(@user).to_not eq(nil)
      end


      it "should create service with facebook id" do
        service = @user.services.where(provider: "facebook", uid: "123456").first
        expect(service).to_not eq(nil)
      end

      it "should be signed in as the user" do
        expect be_user_signed_in
      end

      it "redirect_to root" do
        expect(response).to redirect_to root_path
      end
    end

    context "when facebook email already exist in the system" do
      before(:each) do
        facebook_auth_hash

        User.create!(name: "User", email: "user@email.com", password: "password")
        get :facebook
      end

      it "flashes an alert message" do
        expect(flash[:alert]).to eq("An Account already exists, pelase connect with #{facebook_auth_hash.provider.titleize} accout")
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#logged in user" do
    context "when user don't have facebook service" do
      before(:each) do
        facebook_auth_hash
        user = User.create!(name: "User", email: "user@email.com", password: "password")
        sign_in user
        get :facebook
      end

      it "should add facebook service to current user" do
        user = User.where(email: "user@email.com").first

        expect(user).to_not be_nil

        fb_service = user.services.where(provider: "facebook").first

        expect(fb_service).to_not be_nil

        expect(fb_service.uid).to eq("123456")
      end

      it "should be signed in as the user" do
        expect be_user_signed_in
      end

      it "redirects to Profile page" do
        expect(response).to redirect_to edit_user_registration_path
      end

      it "flashes a notice - Facebook Connected" do
        expect(flash[:notice]).to eq("Your #{facebook_auth_hash.provider} is now Connected")
      end

    end


    context "when user already connect with facebook" do
      before(:each) do
        facebook_auth_hash

        user = User.create!(name: "User", email: "user@email.com", password: "password")
        user.services.create!(:provider => "facebook", :uid => "123456")
        sign_in user
        get :facebook
      end

      it "don't add new facebook service" do
        user = User.where(:email => "user@email.com").first

        expect(user).to_not be_nil

        fb_service = user.services.where(:provider => "facebook")

        expect(fb_service.count).to eq(1)
      end

      it "should still sign user in" do
        expect be_user_signed_in
      end

      it "flashes a notice - Facebook Connected" do
        expect(flash[:notice]).to eq("Your #{facebook_auth_hash.provider} is now Connected")
      end

      it "redirect to user profile page" do
        expect(response).to redirect_to edit_user_registration_path
      end
    end
  end
end
