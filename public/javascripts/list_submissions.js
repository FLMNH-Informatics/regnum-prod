jQuery(document).ready(function(){
    jQuery('.search-button').click(function(event){
        event.preventDefault()
        jQuery('.sortable-table-holder').load('/my_submission', jQuery('#search-form').serialize())
    })

    jQuery('.sortable-table-holder').click(function(event){
        var me = this
        var idLocked = function(id){
           return id.indexOf('_locked') > -1 ? true : false
        }
        event.preventDefault()
        switch(event.target.tagName.toLowerCase()){
            case 'input':
                switch(event.target.value){
                    case 'delete':
                        if(confirm('Are you sure you want to delete this submission?')){
                           var action = event.target.form.action
                           jQuery.post(action,jQuery(event.target.form).serialize(),function(response){
                               jQuery('.sortable-table-holder').html(response)
                           })
                        }
                        break
                    case 'edit':
                        event.target.form.submit() 
                        break
                    case 'view':
                        var action = event.target.form.action
                        jQuery.get(action, function(response){
                            jQuery.openFloatWindow(response,{
                                height: 600,
                                width: 820,
                                title: 'Clade Name'
                            },function(){jQuery.loadWidgets('#float-window-content-holder')}) 
                        }, 'html')
                        break

                }
                break

        }

    })
})
