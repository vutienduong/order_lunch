module MyError
  class UpdateFailError < CustomError
    def initialize
      super(:update_fail, 422, 'Update fail')
    end
  end
end