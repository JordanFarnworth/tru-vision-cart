$(document).on('turbolinks:load', () => {
  if ($('#new_order').length > 0) {
    $('.billing_address').hide()
    $('#billing-address').change((event) => {
      if($(event.target).is(':checked')) {
        $('.billing_address').show()
      } else {
        $('.billing_address').hide()
      }
    })
  }
})
