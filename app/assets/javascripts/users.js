jQuery(document).on('turbolinks:load', () => {
  if($('#users-list').length > 0) {
    console.log('users-list');
    fetchUsers(1);

    function fetchUsers(page) {
      console.log('fetch users');
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

      console.log('data', data);

      $.get(`${window.location.origin}/users/fetch_users/`, data).done((users) => {
        $('#users-list').empty();
        $('#users-list').append(users);
      });
    }

    $('#search-form').change(() => fetchUsers(1));
    $('#order_by').change(() => fetchUsers(1));
  }
});
