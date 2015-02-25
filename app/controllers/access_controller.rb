class AccessController < ApplicationController
	before_action :prevent_login_signup, only: [:signup, :login]

  def signup
  	@user = User.new
  end

  def create
  	@user = User.create user_params
  	if @user.save
  		session[:user_id] = @user.id
  		redirect_to home_path, notice: "Successfully created"
  	else
  		render :signup
  	end
  end

  def attempt_login
  	if params[:username].present? && params[:password].present?
      found_user = User.where(username: params[:username]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
        	if authorized_user
						render :home, notice: "You've succesfully logged in!"
						else
						redirect_to login_path, notice: "Your password is invalid"
      		end
      	else
      		redirect_to login_path, notice: "Your username is invalid"
   		end
  	end
  end

  def home
  end

  def logout
  	session[:user_id] = nil
  	render :logout
  end

  def login

  end

  private
  def user_params
  	params.require(:user).permit(:username, :password, :password_digest)
  end

  def prevent_login_signup
  	if session[:user_id]
  		redirect_to home_path
  	end
  end
end
