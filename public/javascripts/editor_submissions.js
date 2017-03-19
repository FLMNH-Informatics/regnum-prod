jQuery(document).ready(function(){
    jQuery('#search-button').click(function(event){
        event.preventDefault()
        jQuery('.sortable-table-holder').load('/submissions', jQuery(event.target.form).serialize())
    })

    jQuery('.sortable-table-holder').click(function(event){
        
        switch(event.target.tagName.toLowerCase()){
            case 'td':
                //document.location = '/submissions/'+event.target.up('tr').id
                break
            case 'input':
                event.preventDefault()
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
                    case 'review':
                      
                        var action = event.target.form.action
               
                        jQuery.get(action, function(response){
                           jQuery.openFloatWindow(response,{
                              height: 700,
                              width: 820,
                              title: 'Reviewing Submission'
                           },function(){ jQuery.loadWidgets('#float-window-holder')}) 
                        }, 'html')


                }

                break
        }
    })

    jQuery('#float-window-holder').click(function(event){
        
        if(event.target.value === 'Save'){
            event.preventDefault()
             
            jQuery.post(event.target.form.action,
               jQuery(event.target.form).serialize(),
               function(response){
                    jQuery.closeFloatWindow()
                    jQuery('#submissions_table_div').html(response)
                }        
            )
        }
        if(event.target.id === 'status-expander'){
            jQuery('.status-change-table').toggle()
        }
    })

})