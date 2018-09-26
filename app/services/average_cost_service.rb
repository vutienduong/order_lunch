class AverageCostService
  attr_accessor :user_id, :month

  STANDARD_ERROR = [{
    avg: "Error Calculating",
    sum: "Error Calculating",
    count: "Error Calculating"
  }.with_indifferent_access]

  def initialize(user_id, month = nil)
    @user_id = user_id
    @month = month
  end

  def self.call(*args)
    new(*args).call
  end

  def call
    current_date = month ? Date.parse("2018-#{month}-01") : Date.current

    start_date = current_date.beginning_of_month.to_s
    end_date = current_date.end_of_month.to_s

    query = <<-SQL
      select avg(total_price) as avg,
             sum(total_price) as sum,
             count(total_price) as count
      from orders as o
      where o.user_id = #{user_id} and
            o.date > date('#{start_date}') and
            o.date < date('#{end_date}');
      SQL

    ActiveRecord::Base.connection.execute(query)
  rescue StandardError => _e
    STANDARD_ERROR
  end
end
