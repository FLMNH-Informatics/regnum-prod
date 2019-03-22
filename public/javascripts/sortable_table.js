jQuery(document).ready(function(){
	jQuery('.sortable-table-holder').click(function(event){
	    var tableContainer = jQuery('.sortable-table-holder');
	    function loadTable(event, target){
	        if (target !== undefined){
                jQuery('.sortable-table-div').children('.sortable-table-loading').show();
                tableContainer.find('table').hide();
                jQuery('.sortable-table-holder').load(target, function(){ tableContainer.find('table').show(); });
            }
        }
		event.preventDefault();
		switch(event.target.tagName.toLowerCase()){
		    case 'a':
		        var classes = event.target.classList;
                if(classes.contains('paginate_link') || classes.contains('table-header-link')){
                    loadTable(event, event.target.href);
                }
                break;

        case 'th':
              if(event.target.classList.contains('table-header-link')){
                  var target = jQuery(event.target).children('a').attr('href');
                  loadTable(event, target);
              }
              break;
        }
	})
})