import consumer from "./consumer"

$(document).on('turbolinks:load',function() {
  let template = require('./templates/question.hbs')
  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      console.log('Connected to questions')
    },

    disconnected() {
    },

    received(data) {
      if (gon.user_id != data.user_id)
      {
        const Handlebars = require("handlebars");
        let resource = Handlebars.compile(template);
        $('.questions').append(resource(data))
      }
    }

    speak: function() {
      return this.perform('speak');
    }
  });
});
