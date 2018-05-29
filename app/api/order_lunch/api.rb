module OrderLunch
  class API < Grape::API
    version 'v1', using: :header, vendor: 'order lunch'
    format :json
    prefix :api

    resource :orders do
      desc 'Find orders of a date'
      params do
        requires :date, type: Date, desc: 'Query date'
      end

      get :list_orders, :date do
        Order.where("DATE(date)=?", params[:date])
      end
    end

    resource :users do
      desc 'Get all emails'
      get :list do
        User.limit(10).pluck(:email)
      end
    end
  end
end
