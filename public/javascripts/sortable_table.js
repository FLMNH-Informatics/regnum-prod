jQuery(document).ready(function(){
	jQuery('.sortable-table-holder').click(function(event){
		event.preventDefault()
		switch(event.target.tagName.toLowerCase()){
		    case 'a':
              if(event.target.classList.contains('paginate_link') === true ){
                    jQuery('.sortable-table-holder').load(event.target.href)
              }

              if(event.target.classList.contains('table-header-link')){
                  jQuery('.sortable-table-holder').load(event.target.href) 
              }
              break

        case 'th':
              
              if(event.target.classList.contains('table-header-link')){
                  jQuery('.sortable-table-holder').load(event.target.children[0].href) 
              }
              break
        }
	})
})