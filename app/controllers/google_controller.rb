class GoogleController < ApplicationController
  def redirect
    client = Signet::OAuth2::Client.new(client_options)

    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]

    response = client.fetch_access_token!

    session[:authorization] = response

    redirect_to tasks_url
  end

  def new_event
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    task = Task.find(params[:task_id])

    event = Google::Apis::CalendarV3::Event.new(
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: task.created_at.iso8601),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: task.deadline.iso8601),
      summary: task.name
    )
    service.insert_event('primary', event)

    redirect_to tasks_url, notice: "Task was successfully added to your Calendar."
  rescue Signet::AuthorizationError
    redirect_to redirect_url
  end

  private

  def client_options
    {
        client_id: "210753147838-a43v6a6ante902iflv1op3bttebqb5ao.apps.googleusercontent.com",
        client_secret: "26FzhINJ73AL7GHLCXc4BjRm",
        authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
        redirect_uri: callback_url
    }
  end
end