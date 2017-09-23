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
});
