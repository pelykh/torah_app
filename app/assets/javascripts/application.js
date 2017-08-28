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
        createParticipantDivifNeeded(participant)
        participant.on('trackAdded', function(track){
          showTrackifNeeded(participant, track)
        })
      });

      room.on('participantConnected', function(participant) {
        console.log('A remote Participant connected: ', participant)
        createParticipantDivifNeeded(participant)
        participant.on('trackAdded', function(track){
          showTrackifNeeded(participant, track)
        })
      })

      room.on('participantDisonnected', function(participant) {
        console.log('A remote Participant disconnected: ', participant)
        $(`.webcam[data-identity='${participant.identity}']`).remove()
      })
    }, function(error) {
        console.error('Unable to connect to Room: ' +  error.message)
    })
  }

  function showTrackifNeeded(participant, track) {
    var webcamDiv = $(`.webcam[data-identity='${participant.identity}']`)
    webcamDiv.find("video").remove()
    webcamDiv.find("audio").remove()
    webcamDiv.append(track.attach())
  }

  function participantWebcamDiv(participant) {
    var webcam = document.createElement("div")
    webcam.dataset.identity = participant.identity
    webcam.className = "webcam"
    return webcam
  }

  function showWebcamPreview() {
    var webcamDiv = $("#webcam-preview")
    if (webcamDiv.has("video").length)
      return false
    Twilio.Video.createLocalTracks().then(function(localTracks) {
      localTracks.forEach(function(track) {
        webcamDiv.append(track.attach())
      })
    })
  }

  function createParticipantDivifNeeded(participant) {
    if ($(`.webcam[data-identity='${participant.identity}']`).length)
      return false
    $("#participants-webcams").append(participantWebcamDiv(participant))
  }

  $("#call-button").on("click", function(e) {
    var chatroom_id = $("#messages").data('chatroom-id')

    getToken(chatroom_id).then(function(data) {
      makeCall(chatroom_id, data.token)
      App.global_chat.start_video_call(chatroom_id)
    })
  })

  $("#messages").on("click", ".video-call-link", function(){
    var chatroom_id = $("#messages").data("chatroom-id")

    getToken(chatroom_id).then(function(data) {
      makeCall(chatroom_id, data.token)
    })
  })
})
