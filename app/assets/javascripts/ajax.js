$(document).ajaxSend(function(r, s) {
  $('.ajax-load').show();
});

$(document).ajaxStop(function(r, s) {
  $('.ajax-load').fadeOut('fast');
});
