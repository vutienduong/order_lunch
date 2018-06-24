class Orders::RetrieveService
  def self.find_order_by_user_id_and_date(user_id, date)
    Order.where('DATE(date)=?', date).where('user_id = ?', user_id).first
  end
end
