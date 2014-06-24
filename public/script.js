$(function() {
  $("#cancel").click(function() {
    $(".resettable").addClass('hidden');
    $(this).parent("form").get(0).reset();
  });
  $("#login_form").submit(function(e) {
    var form = $(this),
      button = form.find('[type="submit"]'),
      cancel = form.find('#cancel'),
      email = form.find('[name="email"]'),
      code = form.find('[name="code"]');
    if (!form.data('processing')) {
      form.data('processing', true);
      button.attr('disabled', 'disabled');
      $.ajax({
        type: "POST",
        url: form.attr("action"),
        data: form.serialize(),
        dataType: "json",
        success: function(data) {
          if (data.success) {
            email.attr('disabled', 'disabled');
            code.removeClass('hidden');
            cancel.removeClass('hidden');
          };
          alert(data.response);
        },
        error: function(error) {
          alert(error.responseText);
        },
        complete: function(data) {
          button.removeAttr('disabled');
          form.removeData('processing');
        }
      });
      e.preventDefault();
    };
  });
});
