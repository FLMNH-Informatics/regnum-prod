jQuery(document).ready(function () {

  jQuery('.search-button').click(function (event) {
    event.preventDefault()
    jQuery(event.target.form).ajaxSubmit(function (response) {
      jQuery('.sortable-table-holder').html(response)
    })
  });

  jQuery('#user-table-holder tbody tr.user-row').click(function (event) {
    event.preventDefault()
    if (event.target.tagName.toLowerCase() != 'input') {
      return;
    }
    var button = event.target.value
      , do_it = confirm("Are you sure you want to " + button + " this user?");

    if (!do_it) {
      return;
    }

    if (button == "delete" || button == "enable" || button == "disable"){
      event.target.form.submit();
      return;
    }

    jQuery(event.target.form)
      .ajaxSubmit(function (response) {
        switch (button) {
          case 'edit':
            var opts = {
              width: 300,
              height: 500,
              title: 'Edit User',
              buttons: [
                {
                  text: 'Save', click: function () {
                    jQuery('#float-window-content-holder form')
                      .ajaxSubmit(function (response) {
                        jQuery('#user-table-holder')
                          .html(response);
                        jQuery.closeFloatWindow();
                      })
                  }
                }
              ]
            }
            jQuery.openFloatWindow(response, opts);

            break;
          case 'disable':
            jQuery('#user-table-holder').html(response);
            break;
          case 'enable':
            jQuery('#user-table-holder').html(response);
            break;
        }
      });
  });

  jQuery('#user_window_content').click(function (event) {
    event.preventDefault()
    if (event.target.attributes.type.value === 'submit') {
      jQuery('#user_window_content form').ajaxSubmit(function (response) {
        jQuery('#user_window').hide()
        jQuery('#user-table-holder').html(response)
      });
    }

    if (event.target.attributes.type.value === 'button') {
      response.redirect("/admin")
    }
  })
})