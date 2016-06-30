module ApplicationHelper
	
	  # Tell devise which resource we're using.
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
