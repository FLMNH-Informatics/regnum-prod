jQuery(document).ready(function(){

    jQuery('.search-button').click(function(event){
        event.preventDefault()
        jQuery(event.target.form).ajaxSubmit(function(response){
            jQuery('.sortable-table-holder').html(response)
        })
    })
    jQuery('.sortable-table-holder').click(function(event){
        event.preventDefault()
        switch(event.target.tagName.toLowerCase()){
            case 'input':
              var button = event.target.value
                , do_it = true;
              if (button == "delete"){
                do_it = confirm("Are you sure you want to delete this user?")
              }
              if (do_it){
                jQuery(event.target.form).ajaxSubmit(function(response){
                  switch(button){
                      case 'edit':
                          var opts = {
                              width: 300,
                              height: 500,
                              title: 'Edit User',
                              buttons: [
                                  {text: 'Save', click: function(){
                                      jQuery('#float-window-content-holder form').ajaxSubmit( function(response){
                                         jQuery('#user-table-holder').html(response)
                                         jQuery.closeFloatWindow()
                                      })
                                  }}
                              ]
                          }
                          jQuery.openFloatWindow(response,opts)

                          break
                      case 'delete':
                          jQuery('.sortable-table-holder').html(response)
                          break
                      case 'disable':
                          jQuery('#user-table-holder').html(response)
                          break
                      case 'enable':
                          jQuery('#user-table-holder').html(response)
                          break
                  }
                })
              }
              break

        }
    })

    jQuery('#user_window_content').click(function(event){
        event.preventDefault()
        if(event.target.attributes.type.value === 'submit'){

            jQuery('#user_window_content form').ajaxSubmit( function(response){
                jQuery('#user_window').hide()
                jQuery('#user-table-holder').html(response)
            })
        }
    })
})