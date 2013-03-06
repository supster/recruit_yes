module SessionsHelper

  def sign_in(user)
    #sign the user in
    cookies.permanent[:remember_token] = user.remember_token
    current_user = user                                    
  end

  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def signed_in?
     !current_user.nil? 
  end
  
  def sign_out
    current_user = nil
    cookies.delete(:remember_token)
    session.delete(:linkedin_token) 
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
  def redirect_back_or(default)
    return_to = session[:return_to]
    session.delete(:return_to)
    redirect_to(return_to || default)
  end
end
