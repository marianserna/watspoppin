module ControllerMacros

  # def login_user
  #   before(:each) do
  #     @request.env["devise.mapping"] = Devise.mappings[:user]
  #     user = FactoryBot.create(:user)
  #     # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
  #     sign_in user
  #   end
  # end
  #
  # def logout_user
  #   before(:each) do
  #     @request.env["devise.mapping"] = Devise.mappings[:user]
  #     user = FactoryBot.create(:user)
  #     # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
  #     sign_out user
  #   end
  # end

  def twitter_auth_hash
    # This a Devise specific thing for functional tests. See https://github.com/plataformatec/devise/issues/closed#issue/608
    # OmniAuth.config.test_mode = true
    request.env["devise.mapping"] = Devise.mappings[:user]
     request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
      {
    :provider => "twitter",
    :uid => "123456",
    :info => {
      :nickname => "Nickname",
      :email => "user@email.com",
      :name => "John Doe",
      :location => "Anytown, USA",
      :image => "http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
      :description => "a very normal guy.",
      :urls => {
        :Website => nil,
        :Twitter => "https://twitter.com/johndpublic"
      }
    },
    :credentials => {
      :token => "token", # The OAuth 2.0 access token
      :secret => "secret"
    }})
  end


  def facebook_auth_hash
    # OmniAuth.config.test_mode = true
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
    {
      :provider => "facebook",
      :uid => "123456",
      :info => {
        :nickname => "Nickname",
        :email => "user@email.com",
        :name => "John Doe",
        :location => "Anytown, USA",
        :image => "http://si0.twimg.com/sticky/default_profile_images/default_profile_2_normal.png",
        :description => "a very normal guy.",
        :urls => {
          :Website => nil,
          :Twitter => "https://facebook.com/johndpublic"
        }
      },
      :credentials => {
        :token => "token", # The OAuth 2.0 access token
        :secret => "secret"
    }})
  end
end
