jQuery(document).on('turbolinks:load', () => {
  $('#subjects-list').on('click', '.like-button', likeSubject);
  $('#subjects-list').on('click', '.unlike-button', unlikeSubject);

  function likeSubject(e) {
    e.preventDefault();
    const id = e.target.dataset.id;
    $.post(`${window.location.origin}/add_subject/${id}`)
      .done((response) => {
        $(e.target).html('Unlike');
        $(e.target).toggleClass('like-button unlike-button');
      });
  }

  function unlikeSubject(e) {
    e.preventDefault();
    const id = e.target.dataset.id;
    $.ajax({ url: `${window.location.origin}/remove_subject/${id}`, method: 'DELETE'})
      .done((response) => {
        $(e.target).html('Like');
        $(e.target).toggleClass('unlike-button like-button');
      });
  }
});
