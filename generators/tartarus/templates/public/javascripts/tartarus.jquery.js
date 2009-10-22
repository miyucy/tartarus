(function($) {
  $(function() {
    $('.togglable').each(function() {
      var toggle_data = $(this).find('.toggle_data');
      $(this).find('.toggle_link').click(function() { toggle_data.toggle(); })
    });
  });
})(jQuery);