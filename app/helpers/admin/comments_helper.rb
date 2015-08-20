module Admin
  module CommentsHelper
    def unread_comments
        Comment.limit(5).order(created_at: :desc)
    end

    # not ready
    def group_comments
      Comment.events.select(:find_comments_for_commentable).group(:event_title)
    end
  end
end
