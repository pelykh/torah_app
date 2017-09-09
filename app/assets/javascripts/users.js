jQuery(document).on('turbolinks:load', () => {
  if($('#users-list').length > 0) {
    fetchUsers(1, {});

    function fetchUsers(page, options) {
      $.get(`${window.location.origin}/users/fetch_users/`, {
        page: page,
        filters: options.filters,
        sort: options.sort
      }).done((users) => {
          $('#users-list').append(users);
      });
    }

    function fetchFilteredUsers() {
      $('#users-list').empty();
      fetchUsers(1, {
        filters: {
          online: $('#online-checkbox').prop('checked')
        },
        sort: $('#sort').val()
      });
    }

    $('#filters #online-checkbox, #sort').change(fetchFilteredUsers);
  }
});
