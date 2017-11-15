jQuery(document).on('turbolinks:load', () => {
  if ($('#organizations-list').length > 0) {
    const getData = (page) => ({
      page: page,
      search: {
        name: $('#name').val()
      },
      filters: {
        order_by: $('#order_by').val()
      }
    });

    new InfinityList({
      selector: "#organizations-list",
      url: "/organizations/fetch",
      getData: getData,
      per_page: 10
    });
  }
});
