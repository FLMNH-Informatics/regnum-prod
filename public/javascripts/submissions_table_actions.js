jQuery(document).ready(function(){
    jQuery('.sortable-table-holder td button').click(function(event){
        event.preventDefault();
        switch(event.target.innerHTML){
            case 'Delete':
                if(confirm('Are you sure you want to delete this submission?')){
                    var action = event.target.form.action
                    jQuery.post(action,jQuery(event.target.form).serialize(),function(response){
                        jQuery('.sortable-table-holder').html(response)
                    })
                }
                break;
            case 'View':
                var id = jQuery(event.target).parents('tr')[0].id

                jQuery.get('/search/'+id, function(response){
                    jQuery.openFloatWindow(response,{
                        height: 600,
                        width: 820,
                        title: 'Clade Name'
                    },function(){ jQuery.loadWidgets('#float-window-content-holder') })
                }, 'html')
                break;
        }
    })
});