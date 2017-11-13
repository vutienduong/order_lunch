module CommentSteps
  def have_comment(text)
    have_selector(".comment", :text => text)
  end
end