class EmailSettings < ActiveRecord::Base
  attr_accessible :send_on_registration, :send_on_accepted, :send_on_rejected,
                  :send_on_confirmed_without_registration, :registration_email_template,
                  :accepted_email_template, :rejected_email_template, :confirmed_email_template,
                  :registration_subject, :accepted_subject, :rejected_subject,
                  :confirmed_without_registration_subject,
                  :send_on_updated_conference_dates, :updated_conference_dates_subject,
                  :updated_conference_dates_template, :send_on_updated_conference_registration_dates,
                  :updated_conference_registration_dates_subject, :updated_conference_registration_dates_template,
                  :send_on_venue_update, :venue_update_subject, :venue_update_template,
                  :send_on_call_for_papers_dates_updates, :send_on_call_for_papers_schedule_public,
                  :call_for_papers_schedule_public_subject, :call_for_papers_dates_updates_subject,
                  :call_for_papers_schedule_public_template, :call_for_papers_dates_updates_template,
                  # make template for comment after create and comment after update accessible
                  :comment_subject, :comment_template, :send_on_comment

  def get_values(conference, user, event = nil, comment = nil)
    h = {
      'email' => user.email,
      'name' => user.name,
      'conference' => conference.title,
      'conference_start_date' => conference.start_date,
      'conference_end_date' => conference.end_date,
      'registrationlink' => Rails.application.routes.url_helpers.conference_conference_registrations_url(
                            conference.short_title, host: CONFIG['url_for_emails']),
      'conference_splash_link' => Rails.application.routes.url_helpers.conference_url(
                                  conference.short_title, host: CONFIG['url_for_emails']),

      'schedule_link' => Rails.application.routes.url_helpers.schedule_conference_url(
                         conference.short_title, host: CONFIG['url_for_emails'])
    }

    if conference.call_for_paper
      h['cfp_start_date'] = conference.call_for_paper.start_date
      h['cfp_end_date'] = conference.call_for_paper.end_date
    else
      h['cfp_start_date'] = 'Unknown'
      h['cfp_end_date'] = 'Unknown'
    end

    if conference.venue
      h['venue'] = conference.venue.name
      h['venue_address'] = conference.venue.address
    else
      h['venue'] = 'Unknown'
      h['venue_address'] = 'Unknown'
    end

    if conference.registration_period
      h['registration_start_date'] = conference.registration_period.start_date
      h['registration_end_date'] = conference.registration_period.end_date
    end

    if event
      h['eventtitle'] = event.title
      h['proposalslink'] = Rails.application.routes.url_helpers.conference_proposal_index_url(
                           conference.short_title, host: CONFIG['url_for_emails'])
    end
    
    # if there is a comment for an event, apply the hash for comment parts (body, user, reply) which is needed in email view
    if comment
      h['comment_body'] = comment.body # show comment within comment body
      h['comment_user'] = comment.user.name # show user name of commentor
      h['comment_reply'] = Rails.application.routes.url_helpers.admin_conference_event_url(
                            conference.short_title, event, host: CONFIG['url_for_emails']) # show link & title of conference
    end
  end

  def generate_event_mail(event, event_template)
    values = get_values(event.conference, event.submitter, event)
    parse_template(event_template, values)
  end

  def generate_email_on_conf_updates(conference, user, conf_update_template)
    values = get_values(conference, user)
    parse_template(conf_update_template, values)
  end

  private

  def parse_template(text, values)
    values.each do |key, value|
      if value.kind_of?(Date)
        text = text.gsub "{#{key}}", value.strftime('%Y-%m-%d') unless text.blank?
      else
        text = text.gsub "{#{key}}", value unless text.blank? || value.blank?
      end
    end
    text
  end

# generate a subject when a comment is created & pass all related parameters (subject, event)
  def generate_subject_on_comment_create(comment_subject, event)
    parse_template(comment_subject, eventtitle: event.title) # parse the template with subject & event title
  end

# generate an email when a comment is posted & pass all related parameters
  def generate_email_on_comment_create(conference, event, comment, user, comment_template)
    values = get_values(conference, user, event, comment) # get the values with related parameters
    # parse the template with template name & given values
    parse_template(comment_template, values)
  end

end
