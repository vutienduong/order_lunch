require 'csv'
module CSVExport
  def all_orders_to_csv fetch_date = Date.today, options = {}
    headers = [
        "Id", "Username", "Dishes", "Note", "Total price"
    ]

    records = Order.where("DATE(date)=?", fetch_date)
    csv_output = CSV.generate(options) do |csv|
      csv << headers
      records.each do |order|
        id                    = order.id
        username              = order.user.username
        dishes                = order.dishes.map(&:name).join(" , ")
        note                  = order.note
        total_price           = order.dishes.inject(0) {|sum, e| sum + e.price}

        csv << [
            id, username, dishes, note, total_price
        ]
      end
    end
    csv_output
  end
end