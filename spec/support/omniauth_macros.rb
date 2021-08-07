module OmniauthMacros

  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        'provider' => 'github',
        'uid' => '123545',
        'info' => {
            'email' => 'mail@mail.net'
        }
    )

    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
        'provider' => 'vkontakte',
        'uid' => '123545',
        'info' => {
            'email' => 'mail@mail.net'
        }
    )
  end
end
