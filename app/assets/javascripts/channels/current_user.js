jQuery(document).on('turbolinks:load', function() {
  App.cable.subscriptions.create({
    channel: 'CurrentUserChannel'
  }, {});
});
