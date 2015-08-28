module Admin
  class CommentsController < Admin::BaseController
    load_and_authorize_resource

    def index
      @ordered_events = Event.order(:title).all
    end

    private

    def unread
      Comment.where(created_at: (current_user.last_sign_in_at..Time.now)).order(created_at: :desc)
    end

    def posted
      Comment.where(user_id: current_user.id).order(created_at: :desc)
    end
  end
end
