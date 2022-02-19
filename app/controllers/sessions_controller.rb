class SessionsController < ApplicationController
  def new

  end

  def create

    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
      flash[:success] = 'Welcome back, ' + user.name
    else
      if !user
        flash.now[:danger] = 'User with that email not found! Try again'
      else
        flash.now[:danger] = 'Invalid email and/or password! Try again'
      end

      render 'new'
    end

  end

  def destroy
    log_out
    redirect_to root_url
  end

end
