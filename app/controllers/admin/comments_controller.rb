<<<<<<< HEAD
<<<<<<< HEAD
module Admin
  class CommentsController < Admin::BaseController
    load_and_authorize_resource

    def index
      # All available comments, grouped and sorted
      @comments = grouped_comments(accessible_ordered_comments)

      # Grouped, sorted, available comments, posted since current_user last login
      @unread_comments = grouped_comments(accessible_ordered_comments.find_since_last_login(current_user))

      # Grouped, sorted, available comments, posted by current_user
      @posted_comments = grouped_comments(accessible_ordered_comments.find_comments_by_user(current_user))
    end

    private

    # Returning all available comments, ordered by created_at: :desc and by event.title
    def accessible_ordered_comments
      Comment.accessible_by(current_ability).joins('INNER JOIN events ON commentable_id = events.id').order('events.title', 'comments.created_at DESC')
    end

# Grouping all comments by conference, and by event. It returns {:conference => {:event => [{comment_2}, {comment_1 }]}}
    def grouped_comments(remarks)
      remarks.group_by{ |comment| comment.commentable.conference }.map {|conference, comments| [conference, comments.group_by{|comment| comment.commentable}]}.to_h
    end
=======
class Admin::CommentsController < Admin::BaseController
  load_and_authorize_resource

  def index
<<<<<<< HEAD
    @comments = Comment.all
>>>>>>> 9f12201... create comments page & add routes
=======
    @comments = Comment.all.order(created_at: :desc)
    @unread_comments = unread
    @posted_comments = posted
>>>>>>> fd5f980... add comments partials (unread, all, posted) to comments tab panes view
  end
=======
module Admin
  class CommentsController < Admin::BaseController
    load_and_authorize_resource

    def index
      @ordered_events = Event.order(:title).all
    end
>>>>>>> 748ebee... solve rubocop offenses

    private

    def unread
      Comment.where(created_at: (current_user.last_sign_in_at..Time.now)).order(created_at: :desc)
    end

    def posted
      Comment.where(user_id: current_user.id).order(created_at: :desc)
    end
  end
end
