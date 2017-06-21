$(document).ready(() => {
  if ($('#new_order').length > 0) {
    // checkout page

    const getSearchParameters = () => {
      var prmstr = window.location.search.substr(1);
      return prmstr != null && prmstr != "" ? transformToAssocArray(prmstr) : {};
    }

    const transformToAssocArray = ( prmstr ) => {
        var params = {};
        var prmarr = prmstr.split("&");
        for ( var i = 0; i < prmarr.length; i++) {
            var tmparr = prmarr[i].split("=");
            params[tmparr[0]] = tmparr[1];
        }
        return params;
    }

    const params = getSearchParameters();
    $('#coupon-code').hide();
    $('#coupon-code').val(params.code)

    // remove url params
      try {
        window.history.pushState("object or string", "Title", "/"+window.location.href.substring(window.location.href.lastIndexOf('/') + 1).split("?")[0]);
      } catch (e) {
        console.log('not an html 5 browser')
      } finally {
        // nothing
      }
    //

    if(!$('.billing_address').is(':checked')) $('.billing_address').hide()
    $('#billing-address').change((event) => {
      if($(event.target).is(':checked')) {
        $('.billing_address').show()
      } else {
        $('.billing_address').hide()
      }
    })

    $('#errors').hide()
    $('#place-order').on('click', (event) => {
      var data = {
        billing_address: {'test': 'test'},
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
        data.order.coupon_code = $('#coupon-code').val();
      })

      $.ajax(
        {
          url: '/checkout',
          type: 'post',
          data: data,
          success: (resp) => {
            window.location.href = resp.path
          }
        }
      ).then(function fulfillHandler(data) {
          window.location.href = resp.path
        },
        function rejectHandler(jqXHR, textStatus, errorThrown) {
          jqXHR.responseJSON.errors.forEach((error) => {
            $('#errors').show()
            $('#errors').append(`<h4>${error}</h4>`);
          })
        }).catch((data) => {
          console.log("something broke in checkout ajx")
      })
    })

  // end checkout page
  }
})
