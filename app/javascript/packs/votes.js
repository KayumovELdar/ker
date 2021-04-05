$(document).on('turbolinks:load', function() {

  $('.vote').on('ajax:success', function(e) {
    e.preventDefault()

    const rating = e.detail[0].rating
    console.log(rating)
    $(this).addClass('hidden')
    $($(this)[0].parentNode).find('.delete-vote').removeClass('hidden')
    $($(this)[0].parentNode).find('.rating').html(rating)

  })

  $('.delete-vote').on('ajax:success', function(e) {
    e.preventDefault()

    const rating = e.detail[0].rating
    console.log(e)
    console.log(rating)
    $(this).addClass('hidden')
    $($(this)[0].parentNode).find('.vote').removeClass('hidden')
    console.log($($(this)[0].parentNode).find('.rating'))

    $($(this)[0].parentNode).find('.rating').html(rating)

  })
})
