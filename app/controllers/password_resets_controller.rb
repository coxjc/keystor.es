class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].upcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, 'Password cannot be blank!')
      render 'edit'
    elsif @user.update_attributes(user_params)
      @user.update_attributes(:reset_digest => nil, :reset_sent_at => nil)
      flash[:success] = 'Password has been set!'
      redirect_to login_url
    else
      render 'edit'
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email].upcase)
  end

  def valid_user
    unless @user && @user.email_confirmed? && @user.reset_digest== params[:id]
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = 'Password reset expired.'
      redirect_to new_password_reset_url
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end