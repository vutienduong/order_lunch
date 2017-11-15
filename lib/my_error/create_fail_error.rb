module MyError
  class CreateFailError < CustomError
    def initialize msg = 'Create fail'
      super(:create_fail, 422, msg)
    end
  end
end