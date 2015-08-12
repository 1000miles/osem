module Admin::CommentsHelper
  def unread_comments #dropdown-toggle
    Comment.limit(5).order(created_at: :desc)
  end
end
