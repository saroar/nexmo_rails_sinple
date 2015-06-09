class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :verification_code_confirmation

  validates :phone_number, presence: true, format: { with: /\A[\d]{11}\Z/, message: '半角数字11桁で入力してください' }, on: :update

  def send_verification_code!
    self.verification_code = 4.times.map { Random.rand(9) + 1 }.join
    self.verified_at = nil
    self.save!
    Nexmo::Client.new.send_message(from: 'Ruby', to: phone_number_to_send, text: send_message_text, type: 'unicode')
  end

  def call_verification_code!
    res = Nexmo::Client.new.initiate_tts_call(from: 'Ruby', to: phone_number_to_send, lg: 'ja-jp', text: "認証コード: #{self.verification_code.split(//).join(',')} この番号を画面に入力してください。nexmo-sample", type: 'unicode')
    Rails.logger.info res
  end

  def phone_number_to_send
    "81#{self.phone_number.gsub('-', '')[1..10]}"
  end

  def send_message_text
    <<EOF
認証コード: #{self.verification_code}
この番号を画面に入力してください。
nexmo-sample
EOF
  end

  def verified?
    !!self.verified_at
  end

  def verify_and_save
    if self.verification_code == self.verification_code_confirmation
      self.verified_at = Time.now unless self.verified?
      self.save
    else
      errors.add(:verification_code_confirmation, '認証コードが違います。')
      false
    end
  end

end
