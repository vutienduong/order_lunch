require 'prawn/table'

class ManagePagePdf < Prawn::Document
  def initialize(presenter)
    super()
    self.font_families.update(
        'Arial' => {
            normal: Rails.root.join('app/assets/fonts/OpenSans-Regular.ttf'),
            italic: Rails.root.join('app/assets/fonts/OpenSans-Regular.ttf'),
            bold: Rails.root.join('app/assets/fonts/OpenSans-Regular.ttf'),
            bold_italic: Rails.root.join('app/assets/fonts/OpenSans-Regular.ttf')
        })
    self.font 'Arial'
    @presenter = presenter
    #header
    #text_content
    table_content
  end

  def text_content
    y_position = cursor
    bounding_box([0, y_position], :width => 270, :height => 100) do
      text '', size: 15, style: :bold
    end
  end

  def date_title
    text Date.today.to_s, size: 15, style: :bold
  end

  def table_content
    # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
    # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
    # Then I set the table column widths

    date_title

    text "List Orders", size: 15, style: :bold

    table rows_orders do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
    end
    text_content

    text "List Dishes", size: 15, style: :bold

    table rows_dishes do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
    end
    text_content

    text "List Costs", size: 15, style: :bold

    table rows_costs do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
    end
  end

  def _setting_table_style row
    row(0).font_style = :bold
    self.header = true
    self.row_colors = ['DDDDDD', 'FFFFFF']
  end

  def rows_orders
    [['#', 'Username', 'Dishes', 'Note', 'Total Price']] +
        @presenter[:today_order].map do |order|
          [order.id.to_s,
           order.user.username.to_s,
           order.dishes.map(&:name).join(', ').to_s,
           order.note.to_s,
           order.dishes.inject(0) {|sum, e| sum + e.price}.to_s]
        end
  end

  def rows_dishes
    [['Dish', 'Restaurant', 'Number', 'Total Price']] +
        @presenter[:counted_dishes].map do |dish, count|
          [dish.name.to_s,
           dish.restaurant.name.to_s,
           count.to_s,
           (dish.price * count).to_s]
        end
  end

  def rows_costs
    ths = [['Restaurant', 'Phone', 'Total Price', '']]
    ths2 = ['', 'Dish', 'Count', 'Total Price']
    blank = [''] * 4
    vertical = ['---'] * 4
    idx = 1
    @presenter[:all_costs].inject(ths) do |rs, e|
      restaurant = e.first
      details = e.last
      res_row = [restaurant.name.to_s,
                 restaurant.phone.to_s,
                 details[:cost].to_s,
                 '']

      dish_rows = details[:dishes].map do |dish, cost|
        ['', dish.name.to_s,
         "(#{cost[:count]})",
         cost[:cost].to_s]
      end
      dish_rows = dish_rows.insert 0, ths2
      dish_rows = dish_rows.insert 0, vertical
      dish_rows = dish_rows.insert 0, res_row
      dish_rows = dish_rows.insert 0, blank unless idx == 1
      idx += 1
      rs += dish_rows
    end +
        [['', '', 'TOTAL COST', @presenter[:total_cost].to_s]] +
        [['', '', 'BUDGET', @presenter[:budget].to_s]]
  end
end