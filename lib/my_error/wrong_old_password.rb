module MyError
  class WrongOldPassword < CustomError
    def initialize msg = 'Old password is wrong, try again'
      super(:old_password_wrong, 422, msg)
    end
  end
end