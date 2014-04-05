class SessionsController < Devise::SessionsController
  
  #After a user signs in, redirects them to the predetermined path
  def after_sign_in_path_for(resource)
    if resource.role == "Admin"
      users_path
    elsif (resource.role == "PoiManager" || resource.role == "POIManager") && resource.verified == true
     home_path(resource.id)
    else
      root_path
    end
  end
end