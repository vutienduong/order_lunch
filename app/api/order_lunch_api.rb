class OrderLunchAPI < Grape::API
  mount OrderLunch::V1::Users
  mount OrderLunch::V1::Orders
end
