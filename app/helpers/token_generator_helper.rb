module TokenGeneratorHelper
  @@hmac_secret = Settings.api.jwt_secret

  def generate_token_for_user(user)
    puts @@hmac_secret
    exp = (Time.now + 200.years).to_i
    exp_payload = { user: user.id, exp: exp }
    JWT.encode(exp_payload, @@hmac_secret, 'HS256')
  end

  def verify_token(token)
    decoded_token = JWT.decode(token, @@hmac_secret)
    puts decoded_token.inspect
    payload, header = decoded_token
    payload["user"]
  end
end
