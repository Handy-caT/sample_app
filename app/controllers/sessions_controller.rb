class SessionsController < ApplicationController
  def new
  end

  def create

    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])

    else
      if !user
        flash.now[:danger] = 'User with that email not found! Try again'
      else
        flash.now[:danger] = 'Invalid email and/or password! Try again'
      end

      render 'new'
    end


  end

end
