class Task < ActiveRecord::Base
  require 'googleauth'
  require 'google/apis/calendar_v3'
  belongs_to :user
  belongs_to :order
  
  private
    def get_calendar
      calendar = Google::Apis::CalendarV3::CalendarService.new
      scope = ['https://www.googleapis.com/auth/calendar']
      calendar.authorization = Google::Auth.get_application_default(scope)
      calendar.fetch_access_token!
      calendar
    end
    def gcal_event_add
      if !self.user.gcal?
        return nil
      end
      @client = google_apiclient
      service = @client.discovered_api('calendar', 'v3')
      puts "Adding event to #{self.user.name} calendar #{self.user.gcal}"
      @result = @client.execute(
        api_method: service.events.insert,
        parameters: {'calendarId' => self.user.gcal},
        body: JSON.dump(self.order.as_event),
        headers: {'Content-Type' => 'application/json'}
      )
      self.gcalid = @result.data.id
      puts "Created task #{@result.data.id}"
      
    end

    def gcal_event_update
      puts "Updating task #{self.gcalid}"
      if self.user and self.gcalid?
        @client = google_apiclient
        service = @client.discovered_api('calendar', 'v3')
        puts "Updating event #{self.gcalid} to #{self.user.name} calendar #{self.user.gcal}"
        @result = @client.execute(
          api_method: service.events.update,
          parameters: {'calendarId' => self.user.gcal, 'eventId' => self.gcalid},
          body: JSON.dump(self.order.as_event),
          headers: {'Content-Type' => 'application/json'}
        )
        puts @result.data
        puts "Returned #{@result.data.updated}"
      end
    end

    def gcal_event_delete
      if self.user
        @client = google_apiclient
        service = @client.discovered_api('calendar', 'v3')
        result = @client.execute(
          api_method: service.events.delete,
          parameters: {'calendarId' => self.user.gcal, 'eventId' => self.gcalid }
        )
        puts "Removed event."
      end
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
