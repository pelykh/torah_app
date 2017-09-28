// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require jquery.timepicker.js
//= require Datepair
//= require jquery.datepair.js
//= require bootstrap-datepicker
//= require_tree .

jQuery(document).on('turbolinks:load', function() {
  if ($('#subjects-list').length > 0) {
    $('#subjects-list').on('click', '.glyphicon-chevron-down', (e) => {
      $(e.target).toggleClass('glyphicon-chevron-down glyphicon-chevron-up');
    });

    $('#subjects-list').on('click', '.glyphicon-chevron-up', (e) => {
      $(e.target).toggleClass('glyphicon-chevron-up glyphicon-chevron-down');
    });
  }

  if($('#new_lesson').length > 0) {
    function getDisabledTimeRangesForStart(date) {
      return unavailabilityTime(date).concat(lessonsTimeOnStart(date))
    }

    function getDisabledTimeRangesForEnd(date) {
      return unavailabilityTime(date).concat(lessonsTimeOnEnd(date))
    }

    function unavailabilityTime(date) {
      const availableAt = $(`#${weekDay(date)}`).html().split('-');
      return [["12:00AM", availableAt[0]], [availableAt[1], "11:59PM"]]
    }

    function lessonsTime(date) {
      return ($('#lessons-time').data('lessons')).map((l) => {
        return [new Date(l['starts_at']), new Date(l['ends_at']), l["recurring"]]
      })
    }

    function compareDates(d1,d2) {
      return d1.getDate() == d2.getDate() &&
             d1.getMonth() == d2.getMonth() &&
             d1.getFullYear() == d2.getFullYear()
    }

    function lessonsTimeOnStart(date) {
      const lessons = lessonsTime(date).filter((l) => {
        return compareDates(l[0], date) ||
               (l[0].getDay() == date.getDay() && l[2])
      })

      const timeFormat = { hour: 'numeric',minute:'numeric', hour12: true }
      return lessons? lessons.map((l) => {
        if (compareDates(l[0], l[1])) {
          return [l[0].toLocaleString('en-US', timeFormat),
                 l[1].toLocaleString('en-US', timeFormat)]
        }
        return [
        l[0].toLocaleString('en-US', timeFormat),
        "11:59PM"
      ]}) : []
    }

    function lessonsTimeOnEnd(date) {
      const lessons = lessonsTime(date).filter((l) => {
        return compareDates(l[1], date) ||
               (l[1].getDay() == date.getDay() && l[2])
      })

      const timeFormat = { hour: 'numeric',minute:'numeric', hour12: true }
      return lessons? lessons.map((l) => {
        if (compareDates(l[0], l[1])) {
          return [l[0].toLocaleString('en-US', timeFormat),
                 l[1].toLocaleString('en-US', timeFormat)]
        }
        return [
        "12:00AM",
        l[1].toLocaleString('en-US', timeFormat)
      ]}) : []
    }

    function weekDay(d) {
      return ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'sunday'][d.getDay()]
    }

    function changeTimeRanges() {
      console.log($('.lesson .date.end').val())
      const endDate = new Date($('.lesson .date.end').val())
      const startDate = new Date($('.lesson .date.start').val())
      $('.lesson .time.start').timepicker('option', 'disableTimeRanges', getDisabledTimeRangesForStart(startDate));
      $('.lesson .time.end').timepicker('option', 'disableTimeRanges', getDisabledTimeRangesForEnd(endDate));
    }

    $('.lesson .time.start').timepicker({
      showDuration: true,
      timeFormat: 'g:iA',
      disableTimeRanges: getDisabledTimeRangesForStart(new Date)
    });

    $('.lesson .time.end').timepicker({
      showDuration: true,
      timeFormat: 'g:iA',
      disableTimeRanges: getDisabledTimeRangesForEnd(new Date)
    });

    $('.lesson .time').timepicker('setTime', new Date);

    $('input.date').datepicker({
        format: 'yyyy-m-d',
        autoclose: true,
        startDate: '-0d',
        todayHighlight: true
    });

    $('.lesson .date').datepicker('setDate', new Date);

    $('.day').datepair();
    $('.lesson').datepair();
    $('.lesson .date').on('change', changeTimeRanges);
  }

  if ($('#edit_user').length > 0) {
    $('input.time').timepicker({
      showDuration: true,
      timeFormat: 'g:iA',
      disableTextInput: true
    });

    $('input.date').datepicker({
        format: 'yyyy-m-d',
        autoclose: true,
        startDate: '-0d',
        todayHighlight: true
    });

    $('.day').datepair();
    $('.lesson').datepair();
  }
});
