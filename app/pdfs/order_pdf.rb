require 'prawn/table'

class OrderPdf < Prawn::Document
  def initialize(orders)
    super()
    self.font_families.update(
        'Arial' => {
            normal: Rails.root.join('app/assets/fonts/OpenSans-Regular.ttf'),
            italic: Rails.root.join('app/assets/fonts/OpenSans-Regular.ttf'),
            bold: Rails.root.join('app/assets/fonts/OpenSans-Regular.ttf'),
            bold_italic: Rails.root.join('app/assets/fonts/OpenSans-Regular.ttf')
        })
    self.font 'Arial'
    @orders = orders
    #header
    #text_content
    table_content
  end

  def table_content
    # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
    # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
    # Then I set the table column widths
    table order_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
    end
  end

  def order_rows
    [['#', 'User', 'Dishes', 'Note', 'Date']] +
        @orders.map do |order|
          [order.id.to_s, order.user.username.to_s, order.dishes.map(&:name).join(', ').to_s, order.note.to_s, order.date.to_date.to_s]
        end
  end
end