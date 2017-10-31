jQuery(document).on('turbolinks:load', () => {
  $('#get-notifications').on('click', () => {
    $.ajax({
            url: "/notifications?limit=5",
            dataType: "JSON",
            method: "GET"
        })
      .then((notifications) => {
        const items = notifications.map((n) => `<li class="dropdown-item"><a href="${n.link}">${n.message}</a></li>`);
        $('#notifications-small-list').html(items.join(' '));
        $.post('/notifications/mark_as_read')
          .then(() => {
            $('#unread-notifications-count').html('0');
          });
      });
  });
});
