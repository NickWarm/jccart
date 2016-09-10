module ApplicationHelper
  def get_cart_count
    if session[:cart]
      return session[:cart].length
    else
      return 0  
    end
  end
end
