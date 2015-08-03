class AddSubjectAndCommentTemplateToEmailSettings < ActiveRecord::Migration
  def change
  	comment_subject = 'A new comment has been posted for {eventitle}'
  	comment_template = %q(Dear {name},

  	User {comment_user} posted a new comment for event {eventtitle} of {conference}.

  	" {comment_body}" 

  	To reply to this comment, please go to {comment_reply}

  	Kind regards,
  	Your {conference}
  	)

  	add_column :email_settings, :send_on_comment, :boolean, default: true
  	add_column :email_settings, :comment_subject, :string, default: comment_subject
  	add_column :email_settings, :comment_template, :text, default: comment_template

  	EmailSettings.all.each do |email_setting|
  		email_setting.comment_subject = comment_subject
  		email_setting.comment_template = comment_template
  		email_setting.save!
  	end
  end
end
