module MyError
  class BlankNewPassword < CustomError
    def initialize msg = 'New password is blank, please fill it before confirm.'
      super(:blank_new_password, 422, msg)
    end
  end
end