module UserPermissionUtility
  def check_modified_user_permission edit_user_id
    raise MyError::NonPermissionEditError unless (edit_user_id.to_s == session[:user_id].to_s || session[:is_admin])
  end
end