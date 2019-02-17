class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_by_user, only: %i(edit show update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.page(params[:page]).per Settings.page 
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "wel_app"
      redirect_to @user
    else
      flash[:danger] = t "error"
      render :new
    end
  end

  def show
    return if @user
    flash[:fails] = t "fails"
    redirect_to signup_path
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "profiled"
      redirect_to @user
    else
      flash[:fails] = t "no_update"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_deleted"
      redirect_to users_url
    else
      flash[:fails] = t "can't_delete"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return false if logged_in?
    store_location
    flash[:danger] = t "please"
    redirect_to login_url
  end

  def find_by_user
    return if @user = User.find_by(id: params[:id])
    flash[:fails] = t "not_find"
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
