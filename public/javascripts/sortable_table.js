jQuery(document).ready(function(){
	jQuery('.sortable-table-holder th').click(function(event){
	    var tableContainer = jQuery('.sortable-table-holder');
		event.preventDefault();
		switch(event.target.tagName.toLowerCase()){
		    case 'a':
		        var classes = event.target.classList;
                if(classes.contains('paginate_link') || classes.contains('table-header-link')){
                    SubmissionsIndex.loadTable(tableContainer, event.target.href);
                }
                break;

        case 'th':
              if(event.target.classList.contains('table-header-link')){
                  var target = jQuery(event.target).children('a').attr('href');
                  SubmissionsIndex.loadTable(tableContainer, target);
              }
              break;
        }
	});
});