class TagsController < ApplicationController
  def show
    @tag = Tag.find_by(id: params[:id])
    raise raise MyError::NonExistRecordError.new('This tag is not exist') unless @tag
  end
end