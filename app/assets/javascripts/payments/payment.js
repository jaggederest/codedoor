$('document').ready(function() {
  $('form').on('submit', function() {
    creditCardData = {
      card_number: $(this).find('#credit_card').val(),
      expiration_month: $(this).find('#expiration_month').val(),
      expiration_year: $(this).find('#expiration_year').val(),
      security_code: $(this).find('#security_code').val()
    };

    var user = $(this).find('#user_id').val()

    balanced.card.create(creditCardData, function(response) {
      $.post("/users/"+user+"/payment_info", response, function(response) {
        window.location.href = response.redirect_to
      });
    });
    return false;
  });
  $('#payment_info_paypal').on('click', function() {
    $('#payform').hide();
  });
  $('#payment_info_balanced').on('click', function() {
    $('#payform').show();
  });
});
