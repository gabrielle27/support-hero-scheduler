dateIsCurrent = (eventDate) ->
  today = new Date
  today = moment(today.setHours(0, 0, 0, 0))
  !eventDate.start.isBefore(today)

eventTransform = (eventData) ->
  eventData.title = eventData.event_type + ': ' + eventData.name
  eventData.start = eventData.support_date
  eventData

scheduleEventClickResponse = (calEvent) ->
  $.ajax(url: '/signed_in').done (data) ->
    if data
      if data.id == calEvent.employee_id
        add_conflict calEvent
      else
        swap_request_dialog calEvent
    return
  return

swapRequestClickResponse = (calEvent) ->
  $.ajax(url: '/signed_in').done (data) ->
    if data.id == calEvent.employee_id
      confirm_swap_dialog calEvent
    return
  return

eventClickResponse = (calEvent, jsEvent, view) ->
  if dateIsCurrent(calEvent)
    if calEvent.event_type == 'schedule'
      scheduleEventClickResponse calEvent
    else if calEvent.event_type == 'swap request'
      swapRequestClickResponse calEvent
  return

add_conflict = (calEvent) ->
  $.prompt 'Select yes to reschedule for a different day.',
    title: 'Are you unable to work on this day?'
    buttons:
      'Yes, Reschedule': true
      'No, Leave Schedule As Is': false
    focus: 1
    submit: (e, v, m, f) ->
      if v
        $.post('/conflicts', support_date: calEvent.start.format('YYYY-MM-DD')).done (data) ->
          if data.success
            $('#calendar').fullCalendar 'refetchEvents'
            $.get '/employee/current_hero', (hero) ->
              if hero
                $('.current-hero').html hero.name
              return
          else
            if $.isArray(data.errors)
              $.prompt data.errors.join(', ')
            else
              $.prompt 'Something went wrong, please try again'
          return
      $.prompt.close()
      return
  return

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

confirm_swap_dialog = (calEvent) ->
  $.prompt calEvent.src_name + ' would like to swap support hero duty for ' + calEvent.src_support_date + ' with you.',
    title: 'Confirm Swap Request'
    buttons:
      'Yes, Swap': true
      'No, Leave Schedule As Is': false
    focus: 1
    submit: (e, v, m, f) ->
      if v
        $.ajax(
          url: '/swap_requests/' + calEvent.id
          method: 'PUT').done (data) ->
          if data.success
            $('#calendar').fullCalendar 'refetchEvents'
            $.get '/employee/current_hero', (hero) ->
              if hero
                $('.current-hero').html hero.name
              return
          else
            $.prompt 'Something went wrong, please try again'
          return
      $.prompt.close()
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
    eventClick: eventClickResponse


