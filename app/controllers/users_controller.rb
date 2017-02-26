class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user, only: [:show, :edit, :update]

  # GET /users
  # GET /users.json
  def index
    redirect_to root_url
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        UserMailer.registration_confirmation(@user).deliver
        flash[:success] = 'Welcome to Ressit! Please confirm your email
        address to begin uploading keystores.'
        login @user
        format.html { redirect_to keystores_path }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      login user
      flash[:success] = 'Your email has been confirmed. Welcome!'
      redirect_to keystores_path
    else
      flash.now[:error] = 'Invalid action.'
      redirect_to root_url
    end
  end

  private


  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def authenticate_user
    @user = User.find(params[:id])
    if !(@user && logged_in? && current_user.id == @user.id)
      flash.now[:error] = 'Not authorized.'
      redirect_to root_url
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
