class ErrorCode
  ERR_DENY_EDIT_PERMISSION = {code: '001', msg: 'User doesn\'t have permission to edit this user'}.freeze
  ERR_USER_EDIT_FAIL = {code: '002', msg: 'Edit Fail!'}.freeze
  ERR_USER_DELETE_CURRENT_ADMIN = {code: '003', msg: 'Can\'t delete yourself with role as admin'}.freeze
  ERR_NON_EXISTED_RESTAURANT = {code: '004', msg: 'Restaurant for this new dish is not exist'}.freeze
  ERR_NON_EXISTED_DISH = {code: '005', msg: 'This dish is not exist'}.freeze
end