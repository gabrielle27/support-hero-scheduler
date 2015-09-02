eventTransform = (eventData) ->
  eventData.title = eventData.event_type + ': ' + eventData.name
  eventData.start = eventData.support_date
  eventData

$(document).ready ->
  $("#employee").on "change", ->
    window.location.href = "/schedules/" + $(this).children("option:selected").val()

  $('#schedule_load_link').on 'click', (e) ->
    e.preventDefault()
    schedule_loader.dialog 'open'
    return

  schedule_loader = $('#schedule_load_form').dialog(
    autoOpen: false
    height: 300
    width: 350
    modal: true
    buttons:
      Submit: ->
        $('#schedule_load_form form').submit()
        return
      Cancel: ->
        schedule_loader.dialog 'close'
        return
  )
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


