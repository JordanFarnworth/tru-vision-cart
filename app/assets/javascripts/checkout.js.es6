$(document).ready(() => {
  if ($('#new_order').length > 0) {
    // checkout page

    $('.billing_address').hide()
    $('#billing-address').change((event) => {
      if($(event.target).is(':checked')) {
        $('.billing_address').show()
      } else {
        $('.billing_address').hide()
      }
    })

    $('#place-order').on('click', (event) => {
      var data = {
        billing_address: {},
        order: {},
        credit_card: {},
       authenticity_token: $('#authenticity_token').val()
     };
      $('input:visible').map((field) => {
        var i = $('input:visible')[field];
        let id = $(i).attr('id');
        if (id === 'billing-address') return;
        let theClass;
        if (!id) {
          theClass = $(i).attr('class').replace('-', '_');
        }
        let key = id ? id : theClass
        const keys = ['order', 'billing_address'];
        var isAssigned = false;
        keys.map((uid) => {
          if(_.include(key, uid)) {
            data[uid][key] = $(i).val();
            isAssigned = true
          }
        })
        if (!isAssigned) {
          data.order[key] = $(i).val();
        }
      })

      $.ajax(
        {
          url: '/checkout',
          type: 'post',
          data: data,
          error: (resp) => {
            debugger
          },
          success: (resp) => {
            window.location.href = resp.path
          }
        }
      )
    })

  // end checkout page
  }
})
