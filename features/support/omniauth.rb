Before('@omniauth_test') do
  OmniAuth.config.test_mode = true

  # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
  OmniAuth.config.mock_auth[:facebook] = {
    "provider"=>"facebook",
    "uid"=>"547955110",
    "credentials"=>{"token"=>"fake_token"},
    "info"=>{"nickname"=>nil,
             "email"=>"runeroniek@gmail.com",
             "first_name"=>"Luiz",
             "last_name"=>"Fonseca",
             "name"=>"Luiz Fonseca",
             "image"=>"http://graph.facebook.com/100000428222603/picture?type=square"
            }
  }
end

After('@omniauth_test') do
  OmniAuth.config.test_mode = false
end
