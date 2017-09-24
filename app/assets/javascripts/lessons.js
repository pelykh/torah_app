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

  if($('#subject_picker').length > 0) {
    let searchTimeout;
    fetchSubjects();

    function fetchSubjects(search) {
      $.get(`${window.location.origin}/lessons/fetch_subjects`, { search: search})
        .then((lessons) => {
          $('#subject_options').html(lessons);
        });
    }

    $('#subject_picker').on('keyup', (e) => {
      clearTimeout(searchTimeout);
      searchTimeout = setTimeout(() => {
        fetchSubjects(e.target.value);
      }, 1000);

    })

    $('#subject_picker').on('change', (e)=> {
      const id = $(`#subject_options option[value='${e.target.value}']`).data('id');
      console.log(id);
      $('#lesson_subject_id').val(id);
    });
  }
});
