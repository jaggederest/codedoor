$('document').ready(function() {
  $('#user_country').on('change',
                       function() {
                         if (this.value == 'US') {
                           $('#user_state_container').show();
                         } else {
                           $('#user_state_container').hide();
                         }
                       });
});
