$(document).ready(() => {
  if ($('.cart-page').length > 0) {

    $('#coupon-code').on('input', (event) => {
      const code = $(event.target).val();
      $('#checkout-button').attr('href', `/checkout?code=${code}`)
    })

    // apply coupon
      $('.apply-coupon').on('click', () => {
        sweetAlert("Yay!", `Coupon Code Applied`);
      })
    // apply coupon

    // remove url params
      try {
        window.history.pushState("object or string", "Title", "/"+window.location.href.substring(window.location.href.lastIndexOf('/') + 1).split("?")[0]);
      } catch (e) {
        console.log('not an html 5 browser')
      } finally {
        // nothing
      }
    //

    // max quantity check
    if ($('.has-error').length > 0) {
      sweetAlert("Oops...", `${$('.has-error').val()}`, "error");
    }
    // max quantity check

    // quantity selector
    $('.quantity-selector').change((event) => {
      const sku = $(event.target).find(':selected').attr('data-sku');
      const quantity = $(event.target).val();
      const samples = {
        'TRUV-Control-30Day-Preferred': 1,
        'TRUV-Control-30Day-Wholesale': 1,
        'TRUV-Control-7Day': 2
      }
      if(samples[sku] && quantity > samples[sku]) {
        sweetAlert("Oops...", `You are only able to add ${samples[sku]} of this product to your order due to limited supply`, "error");
        $(event.target).val(`${samples[sku]}`);
        return
      }
      $.ajax(
        {
          url: '/cart_update',
          type: 'post',
          data: {
            sku: sku,
            quantity: quantity,
            authenticity_token: $('#authenticity_token').val(),
          }
        }
      ).then(function fulfillHandler(data) {
          location.reload()
        },
        function rejectHandler(jqXHR, textStatus, errorThrown) {
          console.log(`${errorThrown}`)
        }).catch((data) => {
          console.log("something broke in cart_update in cart.js ajx")
      })
    })
    // quantity selector

    // remove product
    $('.remove-product').on('click', (event) => {
      const sku = $(event.target).attr('data-sku');
      $.ajax(
        {
          url: '/remove_product',
          type: 'post',
          data: {
            sku: sku,
            authenticity_token: $('#authenticity_token').val()
          }
        }
      ).then(function fulfillHandler(data) {
          location.reload()
        },
        function rejectHandler(jqXHR, textStatus, errorThrown) {
          console.log(`${errorThrown}`)
        }).catch((data) => {
          console.log("something broke in cart_update in cart.js ajx")
      })
    })
    // remove product
  }
});
