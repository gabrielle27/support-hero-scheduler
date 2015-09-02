eventTransform = (eventData) ->
  eventData.title = eventData.event_type + ': ' + eventData.name
  eventData.start = eventData.support_date
  eventData

$(document).ready ->
  $("#employee").on "change", ->
    window.location.href = "/schedules/" + $(this).children("option:selected").val()

  $('#calendar').fullCalendar
    weekends: false
    eventSources: [
      {
        url: '/schedules/feed'
        data: employee_id: $('#employee').val()
      }
      { url: '/holidays/feed' }
      { url: '/swap_requests/feed' }
      {
        url: '/conflicts/feed'
        data: employee_id: $('#employee').val()
      }
    ]
    lazyFetching: false
    eventDataTransform: eventTransform


