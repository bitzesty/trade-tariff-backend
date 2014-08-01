# For API access
dummy_api_user = User.new
dummy_api_user.email = "dummyapiuser@domain.com"
dummy_api_user.uid = "#{rand(10000)}"
dummy_api_user.name = "Dummy API user created by gds-sso"
dummy_api_user.permissions = ["signin"]
dummy_api_user.save
