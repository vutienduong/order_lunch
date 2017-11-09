def fill_login_form_with (form, email, password)
  within(form) do
    fill_in 'Email', with: email
    fill_in 'Password', with: password
  end
end

def debug(content)
  p '===================================='
  p content
  p '===================================='
end