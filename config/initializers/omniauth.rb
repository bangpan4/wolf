OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '373775596388383', 'a24bac215aa4721fe21c44a5eb84f78c'
end