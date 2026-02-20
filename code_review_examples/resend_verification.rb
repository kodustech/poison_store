class ResendVerificationService
  RATE_LIMIT_WINDOW = 5.minutes
  MAX_ATTEMPTS_PER_WINDOW = 3
  TOKEN_EXPIRY = 2.hours

  def call(email:)
    normalized_email = email.to_s.strip.downcase

    if invalid_email_format?(normalized_email)
      return generic_success_response
    end

    if rate_limited?(normalized_email)
      return generic_success_response
    end

    user = User.find_by(email: normalized_email)

    if user.nil?
      return generic_success_response
    end

    if resend_cooldown_active?(user)
      return generic_success_response
    end

    token = generate_secure_token
    store_verification_token(user.id, token)
    send_verification_email(user, token)
    record_resend_attempt(normalized_email)
    update_user_cooldown(user)

    generic_success_response
  end

  private

  def generic_success_response
    { status: 200, json: { message: "Se o email existir em nossa base, você receberá um link de verificação." } }
  end

  def invalid_email_format?(email)
    email.blank? || !email.match?(/\A[^@\s]+@[^@\s]+\.[^@\s]+\z/)
  end

  def rate_limited?(email)
    key = "resend_verification:#{Digest::SHA256.hexdigest(email)}"
    count = Rails.cache.read(key).to_i
    count >= MAX_ATTEMPTS_PER_WINDOW
  end

  def record_resend_attempt(email)
    key = "resend_verification:#{Digest::SHA256.hexdigest(email)}"
    count = Rails.cache.read(key).to_i + 1
    Rails.cache.write(key, count, expires_in: RATE_LIMIT_WINDOW)
  end

  def resend_cooldown_active?(user)
    return false unless user.respond_to?(:verification_email_sent_at)
    return false if user.verification_email_sent_at.nil?

    user.verification_email_sent_at > 1.minute.ago
  end

  def update_user_cooldown(user)
    return unless user.respond_to?(:update_column)
    user.update_column(:verification_email_sent_at, Time.current)
  end

  def generate_secure_token
    SecureRandom.urlsafe_base64(32)
  end

  def store_verification_token(user_id, token)
    VerificationToken.create!(
      user_id: user_id,
      token: Digest::SHA256.hexdigest(token),
      expires_at: TOKEN_EXPIRY.from_now
    )
  end

  def send_verification_email(user, token)
    VerificationMailer.resend(user.email, token).deliver_later
  end
end
