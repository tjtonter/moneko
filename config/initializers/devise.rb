Devise.setup do |config|
  config.secret_key = '38501c30fd5d0b02cbe6c3cf1ab94d894f51fa31a3eb6b83f984683853f247a610a9cc82b607eaf04e36141c1ec47e2978fa7ab80592023d045b9be5b317c1cc'

  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  require 'devise/orm/active_record'
  require 'omniauth-google-oauth2'
  config.omniauth :google_oauth2, Rails.application.secrets.secret_token,
    Rails.application.secrets.secret_key_base,
    { access_type: "offline", approval_prompt: "", 
      scope: 'userinfo.email,calendar' }
  config.authentication_keys = [ :login ]
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.reconfirmable = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end
