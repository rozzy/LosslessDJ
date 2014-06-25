$(function() {
  $("#cancel").click(function() {
    $(".resettable").addClass('hidden');
    var form = $(this).parent("form");
    form.find("[readonly]").removeAttr('readonly');
    form.find("[disabled]").removeAttr('disabled');
    form.find('[name="email"]').focus();
    form.find('button[type="submit"]').val("Email me authorization link");
  });
  $("#login_form").submit(function(e) {
    var form = $(this),
      button = form.find('[type="submit"]'),
      cancel = form.find('#cancel'),
      email = form.find('[name="email"]'),
      code = form.find('[name="code"]'),
      message = form.find('.response_status'),
      errorCallback = function(error) {
        message.removeClass('hidden');
        form.get(0).reset();
        email.focus();
        message.text(error.response || error.responseText).addClass('error');
      };
    if (!form.data('processing')) {
      form.data('processing', true);
      button.attr('disabled', 'disabled');
      $.ajax({
        type: "POST",
        url: form.attr("action"),
        data: form.serialize(),
        dataType: "json",
        success: function(data) {
          console.log(data)
          form.data('processing', false);
          if (!!data.success) {
            if (data.reload) setTimeout(location.reload, 1000);
            message.text(data.response).removeClass('error').removeClass('hidden');
            email.attr('readonly', 'readonly');
            code.removeClass('hidden');
            cancel.removeClass('hidden');
            button.val('Send code');
          } else errorCallback(data);
        },
        error: errorCallback,
        complete: function(data) {
          button.removeAttr('disabled');
          form.removeData('processing');
        }
      });
      e.preventDefault();
    };
  });
});
