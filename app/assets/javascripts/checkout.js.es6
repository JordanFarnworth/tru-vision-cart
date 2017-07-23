
$(document).ready(() => {
  if ($('#new_order').length > 0) {
    // checkout page

    window.errors = []

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

    // sales tax
    const updateSalesTax = () => {
      $('#sales-tax-label').html('<i class="fa fa-spinner fa-pulse fa-fw"></i>')
      $('#sales-tax').html('<i class="fa fa-spinner fa-pulse fa-fw"></i>')
      const country = $('#billing_address_country').is(":visible") ? $('#billing_address_country').val() : $('#order_country').val();
      $.ajax(
        {
          url: `/sales_tax?zip=${$('#order_zip').val()}&country=${country}`,
          type: 'get'
        }
      ).then(function fulfillHandler(data) {
        $('#sales-tax-label').html('Estimated Tax')
        $('#sales-tax-number').html(`$${data.tax_amount.toFixed(2)}`)
        $('#sales-tax-total').html(`$${data.new_total.toFixed(2)}`)
        },
        function rejectHandler(jqXHR, textStatus, errorThrown) {
          if(jqXHR.responseJSON.errors.length){
            jqXHR.responseJSON.errors.forEach((error) => {
              $('#errors').show()
              $('#errors').append(`<h4>${error}</h4>`);
            })
          } else {
            window.errors.push('Invalid zip for selected country')
            $('#sales-tax-label').html('invalid zip')
            $('#sales-tax-number').html('invalid zip')
          }
        }).catch((data) => {
          window.errors.push('Invalid zip for selected country')
          $('#sales-tax-label').html('invalid zip')
          $('#sales-tax-number').html('invalid zip')
      })
    }

    $('#order_zip').change((event) => {
      if($('#billing_address_zip').is(":visible")){
        return;
      }
      updateSalesTax()
    })

    $('#billing_address_zip').change((event) => {
      updateSalesTax()
    })

    $('#order_country').change((event) => {
      if($('#billing_address_country').is(":visible")){
        return;
      }
      updateSalesTax()
    })

    $('#billing_address_country').change((event) => {
      updateSalesTax()
    })
    // sales tax

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
      data.order.order_country = $('#order_country').val()
      if($('#billing_address_country').is(':visible')) {
        data.billing_address.billing_address_country = $('#billing_address_country').val()
      }

      if(window.errors.length > 0) {
        window.errors.forEach((error) => {
          $('#errors').append(`<h4>${error}</h4>`);
        })
        // clear errors for next try
        window.errors = []
        $('#errors').show()
      }
      if(window.errors.length < 1) {
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
            if(jqXHR.responseJSON.errors.length){
              jqXHR.responseJSON.errors.forEach((error) => {
                $('#errors').show()
                $('#errors').append(`<h4>${error}</h4>`);
              })
            } else {

            }
          }).catch((data) => {
            console.log("something broke in checkout ajx")
        })
      }
    })

  // end checkout page
  }
})
