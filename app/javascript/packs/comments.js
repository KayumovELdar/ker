$(document).on('turbolinks:load', function() {

  $('form.new-comment').on('ajax:success', function(e) {
    let commentsList = $($(this)[0].parentNode).find('.comments')[0]
    let data = e.detail[0]
    let commentBody = data.comment.body
    let comment = '<li> '+ commentBody +' </li>'
    let commentHTML = $($.parseHTML(comment)).html()

    commentsList.append(commentHTML)
  })
});
