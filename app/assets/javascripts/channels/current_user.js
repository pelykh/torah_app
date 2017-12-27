jQuery(document).on('turbolinks:load', function() {
  //createVideoCallDiv({user: "user", chatroom: {url: "/chatrooms/1"}});

  App.current_user = App.cable.subscriptions.create({
      channel: 'CurrentUserChannel'
    }, {
    received: function(data) {
      if(data.type == 'video_call') {
        createVideoCallDiv(data);
      } else {
        const counter = $('#unread-notifications-count');
        counter.html(1 + Number(counter.text()));
      }
    }
  });

  function createVideoCallDiv(data) {
    const div = `
      <div id='video-call-ring'>
        <p>${data.user} is calling you</p>
        <a href='${data.chatroom.url}' class='btn btn-success'>Go to chatroom</a>
        <a id='cancel-video-call' class='btn btn-danger'>Cancel</a>
      </div>
    `
    $('body').append(div);
    $('#cancel-video-call').on('click', () => $('#video-call-ring').remove());
  }
});
