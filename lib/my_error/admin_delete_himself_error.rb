module MyError
  class AdminDeleteHimselfError < StandardError
    def initialize
      super(:admin_delete_himself, 422, 'This app doesn\'t allow admin delete himself')
    end
  end
end