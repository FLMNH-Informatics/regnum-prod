jQuery(document).ready(function(){

    search();

    jQuery('#search_button').click(function(event){
        event.preventDefault();
        search();
    })
    
    jQuery('.sortable-table-holder').click(function(event){
       
        switch(event.target.tagName.toLowerCase()){

            case 'td':
               
                var id = jQuery(event.target).parents('tr')[0].id
               
                jQuery.get('/search/'+id, function(response){
                   jQuery.openFloatWindow(response,{
                      height: 600,
                      width: 820,
                      title: 'Clade Name'
                   },function(){ debugger; jQuery.loadWidgets('#float-window-content-holder') })
                }, 'html')

                break
            case 'input':
                event.preventDefault()
                if(event.target.type == 'submit'){
                    jQuery('.sortable-table-holder').load('/search', jQuery('#search_form').serialize())
                }
                break

        }
    })
    //jQuery('#login-box').draggable() 
    jQuery('#sign-in-link').click(function(event){
        event.preventDefault()
        jQuery('#login-box').dialog({
            title: 'Please sign in',
            modal: true,
            height:180,
            show: {effect: 'drop', direction: 'down'},
            hide: {effect: 'drop', direction: 'up'},
            width:220
        })  
    })

    function search(){
        jQuery('.sortable-table-holder').load('/search', jQuery('#search_form').serialize())
    }

    /*jQuery('#sign-up-link').click(function(event){
        event.preventDefault()
        jQuery.get(event.target.href,function(response){
            jQuery.openFloatWindow(response,{title: 'Create Account', width: 440, modal: true})
        })
        
    })*/
    //
    
})