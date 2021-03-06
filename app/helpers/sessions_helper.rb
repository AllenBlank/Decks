module SessionsHelper
  # this helper ought to be included in the application controller for use
  # in all controllers
  
  
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Logs out the given user.
  def log_out
    session[:user_id] = nil
  end

  # Returns the current logged-in user (if any).
  def current_user
    if session[:user_id] && !User.where(id: session[:user_id]).empty?
      @current_user = User.find(session[:user_id])
    else
      log_out
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  # Returns true if the user is admin, false otherwise.
  def is_admin?
    logged_in? && current_user && current_user.admin
  end
  
  # a before_action check for use across controllers, kick non-admins back to root and give them the error
  def check_is_admin
    unless is_admin?
      bounce_chumps "You're not an admin."
    end
  end
  
  # same...
  def check_logged_in
    unless logged_in?
      bounce_chumps "Please sign in."
    end
  end
  
  # helper for my helper, kick user back to url, display error msg
  def bounce_chumps(msg, url=root_url)
    flash[:danger] = msg
    redirect_to root_url
  end
  
  def current_deck
    if session[:deck] && !Deck.where(id: session[:deck]).empty?
      @current_deck = Deck.find(session[:deck])
    else
      nil
    end
  end
  
  def set_current_deck deck
    session[:deck] = deck.id
  end
  
end