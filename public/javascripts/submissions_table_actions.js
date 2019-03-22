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
        }
    })
});