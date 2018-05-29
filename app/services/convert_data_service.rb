class ConvertDataService
  def self.two_array_to_hash(arr1, arr2, key_arr)
    key1 = key_arr.first
    key2 = key_arr[1]

    if arr1.length != arr2.length || arr1.blank?
      return []
    end

    result = []
    arr1.each_with_index do |i, v|
      result << { key1 => v, key2 => arr2[i] }
    end

    return result
  end
end
