jQuery(document).on('turbolinks:load', () => {
  if($('#lessons-list').length > 0) {
    function fetchLessons() {
      $.get(`${window.location.origin}/fetch_lessons`)
        .then((lessons) => {
          $('#lessons-list').append(lessons);
        })
    }

    fetchLessons();
  }

  if($('#new_lesson').length > 0) {
    const timeFormat = { hour: 'numeric', minute:'numeric', hour12: true }

    function getDisabledTimeRangesForStart(date) {
      console.log(unavailabilityTimeOnStart(date).concat(lessonsTimeOnStart(date)))
      return unavailabilityTimeOnStart(date).concat(lessonsTimeOnStart(date))
    }

    function getDisabledTimeRangesForEnd(date) {
      console.log(unavailabilityTimeOnEnd(date).concat(lessonsTimeOnEnd(date)))
      return unavailabilityTimeOnEnd(date).concat(lessonsTimeOnEnd(date))
    }

    function unavailabilityTimeOnEnd(date) {
      const availability = userAvailability().concat(currentUserAvailability()).filter((e) => {
        return e[1].getDay() == date.getDay()
      })

      let result = []

      availability.forEach((e) => {
        if (compareDates(e[0], e[1])) {
          result.push(["12:00AM", e[0].toLocaleString('en-US', timeFormat)])
        }
        result.push([e[1].toLocaleString('en-US', timeFormat), "12:00AM"])
      });

      return result;
    }

    function unavailabilityTimeOnStart(date) {
      const availability = userAvailability().concat(currentUserAvailability()).filter((e) => {
        return e[0].getDay() == date.getDay()
      })

      let result = []

      availability.forEach((e) => {
        if (compareDates(e[0], e[1])) {
          result.push([e[1].toLocaleString('en-US', timeFormat), "12:00AM"])
        }
        result.push(["12:00AM", e[0].toLocaleString('en-US', timeFormat)])
      })

      return result;
    }


    function userAvailability() {
      return $('#user-availability').data('availability').map((e) => {
        const a = e.split('..');
        return [new Date(a[0]), new Date(a[1])];
      })
    }

    function currentUserAvailability() {
      return $('#current-user-availability').data('availability').map((e) => {
        const a = e.split('..');
        return [new Date(a[0]), new Date(a[1])];
      })
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
});
