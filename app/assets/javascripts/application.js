// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

jQuery(document).on("turbolinks:load", function() {
  var token

  function getToken(chatroom_id) {
    return $.get("video_token/" + chatroom_id)
  }

  function makeCall(chatroom_id, token) {
    Twilio.Video.connect(token, {name:'chatroom_' + chatroom_id}).then(function(room) {
      console.log('Successfully joined a Room: ', room)
      showWebcamPreview()

      room.participants.forEach(participant => {
        participant.on('trackAdded', function(track){
          showTrack(track)
        })
        showParticipantWebcam(participant)
      });

      room.on('participantConnected', function(participant) {
        console.log('A remote Participant connected: ', participant)
        participant.on('trackAdded', function(track){
          showTrack(track)
        })
      })

      room.on('participantConnected', function(participant) {
        console.log('A remote Participant connected: ', participant)
        showParticipantWebcam(participant)
      })
    }, function(error) {
        console.error('Unable to connect to Room: ' +  error.message)
    })
  }

  function showTrack(track) {
    document.getElementById('participant-webcams').appendChild(track.attach())
  }

  function showWebcamPreview() {
    Twilio.Video.createLocalTracks().then(function(localTracks) {
      var localMediaContainer = document.getElementById('webcam-preview');
      localTracks.forEach(function(track) {
        localMediaContainer.appendChild(track.attach())
      })
    })
  }

  function showParticipantWebcam(participant) {
    participant.tracks.forEach(track => {
      showTrack(track)
    })
  }

  $("#call-button").on("click", function(e) {
    var chatroom_id = $("#messages").data('chatroom-id')

    getToken(chatroom_id).then(function(data) {
      makeCall(chatroom_id, data.token)
    })


  })
})
