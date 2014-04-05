class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #Ryan Pepin Drew Justus 2014
    protect_from_forgery with: :null_session
  
  
  
end

