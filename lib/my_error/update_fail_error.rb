module MyError
  class UpdateFailError < CustomError
    def initialize msg = 'Update fail'
      super(:update_fail, 422, msg)
    end
  end
end