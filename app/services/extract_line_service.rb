class ExtractLineService
  SPLIT_PATTERN = "\r\n".freeze
  def self.split_line(str)
    str.split(SPLIT_PATTERN)
  end
end
