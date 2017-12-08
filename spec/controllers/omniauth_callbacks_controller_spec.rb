require "rails_helper"

RSpec.fdescribe Users::OmniauthCallbacksController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:service) {FactoryBot.create(:service)}
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

  describe "#guest user" do
    context "when facebook email doesn't exist in the system" do
      before(:each) do
        facebook_auth_hash
        get :facebook
        @user = User.where(email: "user@email.com").first
      end

      # it { @user.should_not be_nil }
      it "@user should not be nil" do
        expect(@user).to_not eq(nil)
      end


      it "should create service with facebook id" do
        service = @user.services.where(provider: "facebook", uid: "123456").first
        expect(service).to_not eq(nil)
      end

      # it { should be_user_signed_in }
      it "should be signed in as the user" do
        # expect(@user).to_be user_signed_in
        expect be_user_signed_in
      end

      # it { response.should redirect_to tasks_path }
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

      it { flash[:alert].should == "An Account already exists, pelase connect with #{facebook_auth_hash.provider.titleize} accout"}

      it { response.should redirect_to new_user_session_path }
    end
  end
  #
  # describe "#logged in user" do
  #   context "when user don't have facebook service" do
  #     before(:each) do
  #       facebook_auth_hash
  #
  #       User.create!(name: "User", email: "user@email.com", password: "password")
  #       sign_in user
  #
  #       get :user_facebook_omniauth_callback
  #     end
  #
  #     it "should add facebook service to current user" do
  #       user = User.where(:email => "user@example.com").first
  #       user.should_not be_nil
  #       fb_service = user.services.where(:provider => "facebook").first
  #       fb_service.should_not be_nil
  #       fb_service.uid.should == "123456"
  #     end
  #
  #     it { should be_user_signed_in }
  #
  #     it { response.should redirect_to services_path }
  #
  #     it { flash[:notice].should == "Facebook is connected with your account."}
  #   end
  #
  #   context "when user already connect with facebook" do
  #     before(:each) do
  #       facebook_auth_hash
  #
  #       User.create!(name: "User", email: "user@email.com", password: "password")
  #       user.services.create!(:provider => "facebook", :uid => "123456")
  #       sign_in user
  #
  #       get :facebook
  #     end
  #
  #     it "should not add new facebook service" do
  #       user = User.where(:email => "user@email.com").first
  #       user.should_not be_nil
  #       fb_services = user.services.where(:provider => "facebook")
  #       fb_services.count.should == 1
  #     end
  #
  #     it { should be_user_signed_in }
  #
  #     it { flash[:notice].should == "Signed in successfully." }
  #
  #     it { response.should redirect_to tasks_path }
  #
    # end
    # end

end
