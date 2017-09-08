jQuery(document).on('turbolinks:load', () => {
  if($('#users-list').length > 0) {
    fetchUsers(1, {});

    function fetchUsers(page, filters) {
      $.get(`${window.location.origin}/users/fetch_users/`, {
        page: page,
        filters: filters
      }).done((users) => {
          $('#users-list').append(users);
      });
    }

    function fetchFilteredUsers() {
      $('#users-list').empty();
      fetchUsers(1, {
        online: $('#online-checkbox').prop('checked')
      });
    }

    $('#filters #online-checkbox').change(fetchFilteredUsers);
  }
});
