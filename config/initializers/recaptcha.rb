Recaptcha.configure do |config|
  config.public_key  = '6LeDPAcTAAAAAGY3eiGdP0YMfithON0ZmCaG3ICd'
  config.private_key = '6LeDPAcTAAAAAKrSQJ7GLlaJi-foEc9TDchAI5WH'
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
  # Uncomment if you want to use the newer version of the API,
  # only works for versions >= 0.3.7:
  # config.api_version = 'v2'

  config.skip_verify_env = ["test", "development"]
end
