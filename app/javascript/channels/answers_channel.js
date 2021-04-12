import consumer from "./consumer"
$(document).on('turbolinks:load', function(){

  let template = require('./templates/answers.hbs')
  consumer.subscriptions.create({channel: "AnswersChannel", question_id: $(".question").data("id")}, {
  connected() {
    console.log("Connected to the question!");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('.answers').append(template(data))
    console.log(data);
    // Called when there's incoming data on the websocket for this channel
  }
});})
