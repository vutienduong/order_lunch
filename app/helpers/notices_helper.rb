module NoticesHelper
  def change_new_line(content)
    content.gsub('\r\n', '&#13;&#10;')
  end
end
