class Notice < ActiveRecord::Base
  has_one :author, class_name: "User"
end
