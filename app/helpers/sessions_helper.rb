module SessionsHelper
  # logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

 # remember user in persistent session
 def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

# returns true in case current user == user
def current_user?(user)
  user == current_user
end


  # returns logged in user
 def current_user
 #   if @current_user.nil?
 #  # in case we'haven't yet current user, we  grab data from cookie in browser and find user by id
 #   @current_user =  User.find_by(id: session[:user_id])
 # else
 #   @current_user
 # end
  # if browser hasn't been closed yet
  if (user_id = session[:user_id])
  @current_user ||= User.find_by(id: user_id)
  # otherwise
elsif  (user_id = cookies.signed[:user_id])
   user = User.find_by(id: user_id)
    if user && user.authenticated?(:remember, cookies[:remember_token])
      log_in user
      @current_user = user
    end
  end
 end

 # return true if we have user else false
  def logged_in?
  !current_user.nil?
  end

# forgets persistent session
def forget(user)
  user.forget()
  cookies.delete(:user_id)
  cookies.delete(:remember_token)
end

 # logs out current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    # session[:user_id] = nil
    @current_user = nil
  end

# redirect to stored location
def redirect_back_or(default)
  redirect_to(session[:forwarding_url] || default)
  session.delete([:forwarding_url])
end

 # store path where user is going before log in
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

end
