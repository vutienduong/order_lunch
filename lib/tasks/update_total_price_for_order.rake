namespace :order do
  desc 'Update total_price for those nil in order'
  task update_nil_total_price: :environment do
    Order.where(total_price: nil) do |order|
      temp_total_price = order.dishes.pluck(:price).sum
      order.update(total_price: temp_total_price)
      puts "Update order ##{order.id} with total price #{order.reload.total_price}"
    end
  end
end
