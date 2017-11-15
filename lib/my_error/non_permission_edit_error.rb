module MyError
  class NonPermissionEditError < CustomError
    def initialize
      super(:non_permission_edit_user, 422, 'User don\'t have permission to edit this user')
    end
  end
end