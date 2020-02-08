module TokenGeneratorHelper
  @@hmac_secret = Settings.api.jwt_secret

  def generate_token_for_user(user)
    exp = (Time.now + 200.years).to_i
    exp_payload = { user: user.id, exp: exp }
    JWT.encode(exp_payload, @@hmac_secret, 'HS256')
  end

  def verify_token(token)
    decoded_token = JWT.decode(token, @@hmac_secret)
    payload, header = decoded_token
    payload["user"]
  end
end
