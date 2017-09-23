jQuery(document).on('turbolinks:load', () => {
  if($('#lessons-list').length > 0) {
    console.log("im here")
    function fetchLessons() {
      $.get(`${window.location.origin}/fetch_lessons`)
        .then((lessons) => {
          $('#lessons-list').append(lessons);
        })
    }

    fetchLessons();
  }
});
