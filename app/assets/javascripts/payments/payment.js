$('document').ready(function() {
  $('form').on('submit', function() {
    creditCardData = {
      credit_card: $(this).find('#credit_card').val(),
      expiration_month: $(this).find('#expiration_month').val(),
      expiration_year: $(this).find('#expiration_year').val(),
      security_code: $(this).find('#security_code').val()
    };
    balanced.card.create(creditCardData, function(response) {
      console.log(response);
    });
    return false;
  });
});

