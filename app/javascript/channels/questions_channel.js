import consumer from "./consumer"

$(document).on('turbolinks:load',function(){
  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('Connected to questions')
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      $('.questions').html(data)
      console.log('received', data)
      // Called when there's incoming data on the websocket for this channel
    },

    speak: function() {
      return this.perform('speak');
    }
  });
});
