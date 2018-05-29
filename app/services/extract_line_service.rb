class ExtractLineService
  SPLIT_PATTERN = "\r\n".freeze
  def self.split_line(str)
    return [] if str.blank?
    str.split(SPLIT_PATTERN)
  end
end
