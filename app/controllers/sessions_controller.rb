class SessionsController < ApplicationController
  def new
  end

  def create
    # firstly find user by email and create session which we assing to user
    user = User.find_by(email: params[:session][:email])
    # and if user exists and we pass process of authentication with the given password
    if user && user.authenticate(params[:session][:password])
        # log the user and redirect him to user's show page
        if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ?  remember(user) : forget(user)
        redirect_back_or user
      else
        message = "Account hasn't been activated yet. "
        message += "Check your email for the activation link"
        flash[:warning] = message
        redirect_to root_url
      end
      else
        # create error message   -> .now allows us to show the error message just one time now
        flash.now[:danger] = 'Invalid email/password combination'
    render 'new'
  end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
