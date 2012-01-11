module SessionsHelper
# =============================================================
# = be sure to use self. prefix for class level variable here =
# = for some reason they won't get set without it!!           =
# =============================================================
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !self.current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def deny_access
    redirect_to signin_path, :notice => "Please sign in to access this page." 
  end
  
  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

end
