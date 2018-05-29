module OrderLunch
  class V1::Orders < Base
    resource :orders do
      desc 'Find orders of a date'
      params do
        requires :date, type: Date, desc: 'Query date'
      end

      get :list_orders, :date do
        params[:date].class
        date = params[:date]
        orders = Order.where("DATE(date)=?", date)
        orders.map { |o| OrderSerializer.new(o) }
      end
    end
  end
end
