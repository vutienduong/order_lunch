module MyError
  class NonExistRecordError < CustomError
    def initialize msg = 'Non exist record'
      super(:non_exist_record, 422, msg)
    end
  end
end