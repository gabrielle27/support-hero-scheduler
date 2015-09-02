eventTransform = (eventData) ->
  eventData.title = eventData.event_type + ': ' + eventData.name
  eventData.start = eventData.support_date
  eventData

swap_request_dialog = (calEvent) ->
  $.ajax(url: '/employee/dates').done (data) ->
    if data and data.length
      $.each data, ->
        $('#src_schedule_id').append $(document.createElement('option')).val(@id).html(@support_date)
        return
      $('.swap-date').html calEvent.start.format('YYYY-MM-DD')
      $('#target_schedule_id').val calEvent.id
      schedule_swapper.dialog 'open'
    return
  return
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

  schedule_swapper = $('#schedule_swap_form').dialog(
    autoOpen: false
    height: 300
    width: 350
    modal: true
    buttons:
      Submit: ->
        $('#schedule_swap_form form').submit()
        schedule_swapper.dialog 'close'
        $('#calendar').fullCalendar 'refetchEvents'
        return
      Cancel: ->
        schedule_swapper.dialog 'close'
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


