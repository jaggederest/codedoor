$('document').ready(function() {
  var refreshProgrammerRates = function() {
    var rate = $('#hourly_rate_to_programmer').val();
    var isInteger = parseInt(rate, '10').toString() == rate;
    if (isInteger) {
      $('#daily_rate_to_programmer_value').text(rate * 8);
      $('#hourly_fee_to_codedoor_value').text((rate / 8.0).toFixed(2));
      $('#daily_fee_to_codedoor_value').text(rate);
      $('#hourly_rate_to_client_value').text((rate * 9.0 / 8.0).toFixed(2));
      $('#daily_rate_to_client_value').text(rate * 9);
    } else {
      $('#daily_rate_to_programmer_value').text('');
      $('#hourly_fee_to_codedoor_value').text('');
      $('#daily_fee_to_codedoor_value').text('');
      $('#hourly_rate_to_client_value').text('');
      $('#daily_rate_to_client_value').text('');
    }

    if ($('form input[name="programmer[availability]"]:checked').val() == 'part-time') {
      $('#full-time-explanation').hide();
      $('#daily_rate_to_programmer').hide();
      $('#daily_fee_to_codedoor').hide();
      $('#daily_rate_to_client').hide();
    } else {
      $('#full-time-explanation').show();
      $('#daily_rate_to_programmer').show();
      $('#daily_fee_to_codedoor').show();
      $('#daily_rate_to_client').show();
    }
  };

  $('#hourly_rate_to_programmer').on('blur', refreshProgrammerRates);
  $('[name="programmer[availability]"]').on('change', refreshProgrammerRates);
  refreshProgrammerRates();
});
