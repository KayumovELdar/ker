$(document).on('turbolinks:load', function () {
    $('.questiond').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        const answerId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    })
});
