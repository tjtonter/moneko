class Task < ActiveRecord::Base
  require 'google/api_client'
  belongs_to :user
  belongs_to :order
  before_create :gcal_event_add
  before_destroy :gcal_event_delete
  after_touch :gcal_event_update
  GOOGLE_ID = "445337145466-rgarqo6icknoop3n195t5prauovs5ecp.apps.googleusercontent.com"
  GOOGLE_EMAIL = "445337145466-rgarqo6icknoop3n195t5prauovs5ecp@developer.gserviceaccount.com"

  private
  def gcal_event_add
      if self.user.gcal?
        @client = google_apiclient
        service = @client.discovered_api('calendar', 'v3')
        event = {
          'summary' => self.order.title,
          'description' => self.order.description,
          'start' => {
            'dateTime' => self.order.begin_at.to_datetime.rfc3339
          },
          'end' => {
            'dateTime' => self.order.end_at.to_datetime.rfc3339
          }
        }
        puts "Adding event to #{self.user.name} calendar #{self.user.gcal}"
        @result = @client.execute(
          api_method: service.events.insert,
          parameters: {'calendarId' => self.user.gcal},
          body: JSON.dump(event),
          headers: {'Content-Type' => 'application/json'}
        )
        self.gcalid = @result.data.id
      end
    end

    def gcal_event_update
      puts "Updating task #{self.gcalid}"
      if self.user.gcal? and self.gcalid?
        @client = google_apiclient
        service = @client.discovered_api('calendar', 'v3')
        event = @client.execute(
          api_method: service.events.get,
          parameters: {'calendarId' => self.user.gcal, 'eventId' => self.gcalid }
        )

        event = {
          'summary' => self.order.title,
          'description' => self.order.description,
          'sequence' => event.data.sequence+1,
          'start' => {
            'dateTime' => self.order.begin_at.to_datetime.rfc3339
          },
          'end' => {
            'dateTime' => self.order.end_at.to_datetime.rfc3339
          }
        }
        puts "Updating event #{self.gcalid} to #{self.user.name} calendar #{self.user.gcal}"
        @result = @client.execute(
          api_method: service.events.update,
          parameters: {'calendarId' => self.user.gcal, 'eventId' => self.gcalid},
          body: JSON.dump(event),
          headers: {'Content-Type' => 'application/json'}
        )
      
        puts "This is the new event: #{event}"
        puts "Returned #{@result.data.updated}"
      end
    end

    def gcal_event_delete
      if self.user.gcal?
        @client = google_apiclient
        service = @client.discovered_api('calendar', 'v3')
        result = @client.execute(
          api_method: service.events.delete,
          parameters: {'calendarId' => self.user.gcal, 'eventId' => self.gcalid }
        )
        puts "Removed event."
      end
    end

    def google_apiclient
      @client = Google::APIClient.new(application_name: 'Moneko', application_version: '0.1')
      key = Google::APIClient::KeyUtils.load_from_pkcs12('moneko.p12', 'notasecret')
      @client.authorization = Signet::OAuth2::Client.new(
        :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
        :audience => 'https://accounts.google.com/o/oauth2/token',
        :scope => 'https://www.googleapis.com/auth/calendar',
        :issuer => GOOGLE_EMAIL, 
        :signing_key => key
      )
      @client.authorization.fetch_access_token!
      @client
    end

    def gcal_event_insert(client, order, user)
      service = @client.discovered_api('calendar', 'v3')
      event = {
        'summary' => order.title,
        'description' => order.description,
        'start' => {
          'dateTime' => order.begin_at.to_datetime.rfc3339
        },
        'end' => {
          'dateTime' => order.end_at.to_datetime.rfc3339
        }
      }
      puts "Adding event to #{user.name} calendar #{user.gcal}"
      @result = @client.execute(
        api_method: service.events.insert,
        parameters: {'calendarId' => user.gcal},
        body: JSON.dump(event),
        headers: {'Content-Type' => 'application/json'}
      )
      @result.data.id
  end
end
