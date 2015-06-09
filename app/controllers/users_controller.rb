class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def edit_phone_number

  end

  def update_phone_number
    if @user.update(user_params)
      @user.send_verification_code!
      redirect_to verification_code_users_url, notice: '認証コードをSMSで送信しました。'
    else
      render :edit_phone_number
    end
  end

  def call_verification_code
    @user.call_verification_code!
    redirect_to verification_code_users_url, notice: '認証コードを電話でお知らせします。'
  end

  def verification_code
  end

  def verification
    @user.assign_attributes(verification_params)
    if @user.verify_and_save
      redirect_to root_url, notice: '電話番号の認証が完了しました。'
    else
      render :verification_code
    end
  end

  private
  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.fetch(:user, {}).permit(:phone_number)
  end

  def verification_params
    params.fetch(:user, {}).permit(:verification_code_confirmation)
  end
end
