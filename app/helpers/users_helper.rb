module UsersHelper
  def current_path_is?(path)
    name = path.split('/').last
    request.env['PATH_INFO'].include? name
  end
end
