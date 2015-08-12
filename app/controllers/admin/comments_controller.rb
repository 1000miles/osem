class Admin::CommentsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @comments = Comment.all
  end

  def self.unread
  end

  def posted
  end
end
