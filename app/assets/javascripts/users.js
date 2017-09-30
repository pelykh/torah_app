jQuery(document).on('turbolinks:load', () => {
  if($('#users-list').length > 0) {
    fetchUsers(1);

    function fetchUsers(page) {
      const data = {
        page: page,
        search: {
          name: $('#name').val(),
          country: $('#country').val(),
          city: $('#city').val(),
          state: $('#state').val()
        },
        filters: {
          online: $('#online').prop('checked'),
          order_by: $('#order_by').val()
        }
      }

      $.get(`${window.location.origin}/users/fetch_users/`, data).done((users) => {
        $('#users-list').empty();
        $('#users-list').append(users);
      });
    }

    $('#search-form').change(() => fetchUsers(1));
    $('#order_by').change(() => fetchUsers(1));
  }
});
