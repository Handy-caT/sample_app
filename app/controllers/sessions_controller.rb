class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      flash[:success] = 'Welcome back, ' + @user.name
      redirect_back_or @user
    else
      if !@user
        flash.now[:danger] = 'User with that email not found! Try again'
      else
        flash.now[:danger] = 'Invalid email and/or password! Try again'
      end

      render 'new'
    end

  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
