  //TODO - below is necessary for authenticating ajax request
      //move this to a global file
jQuery(document).ajaxSend(function(event, request, settings) {
    if ( settings.type != 'GET' ) {
        settings.data = (settings.data ? settings.data + "&" : "")
            + "authenticity_token=" + encodeURIComponent( AUTH_TOKEN );
    }
});

jQuery(document).ready(function(){	
	//
    ko.ontologyModel = {}
	//on load  - load knockout models
    ko.ontologyModel.ontologies = ko.observableArray([]).extend({paging: 15})
    ko.ontologyModel.bioportal_checked = []
    ko.ontologyModel.imported = ko.observableArray([]).extend({paging: 15})
    ko.ontologyModel.imported_checked = []
    ko.applyBindings(ko.ontologyModel.ontologies, document.getElementById('bioportal_ontologies'))
    ko.applyBindings(ko.ontologyModel.imported, document.getElementById('imported_ontologies'))
    ko.callbacks = jQuery.Callbacks()

    ko.checkChecked = function(selector,arr){
        jQuery(selector + ' input[type="checkbox"]').each(function(ind,obj){
            if(jQuery.inArray(jQuery(obj).attr('data-id'),arr) !== -1){
                jQuery(obj).prop('checked',true)
            }
        })
    }
    ko.disableChecked = function(selector,arr){
         jQuery.each(arr,function(ind,obj){
            jQuery(selector + ' input[data-id="'+obj.bioportal_id+'"]').prop('disabled',true)
            jQuery(selector + ' input[data-id="'+obj.bioportal_id+'"]').prop('checked',false)
         })     
    }
    ko.callbacks.add(function(){
       ko.checkChecked('#ontology_list_table',ko.ontologyModel.bioportal_checked)
       ko.disableChecked('#ontology_list_table',ko.ontologyModel.imported())
    })

    /*jQuery.getJSON('/phenotypes',function(response){

    	jQuery.each(response.biojson, function(ind,obj){

    	  	ko.ontologyModel.ontologies.push(obj)
    	})  
        jQuery.each(response.imported, function(ind,obj){
            ko.ontologyModel.imported.push(obj)
        })
        ko.disableChecked('#ontology_list_table',ko.ontologyModel.imported())     

    })*/
    //

    jQuery('#ontology_list_table').on('change', 'input[type="checkbox"]', function(event){
        //event.preventDefault()
        if(!jQuery(event.target).prop('checked')){
            var ind = jQuery.inArray(jQuery(event.target).attr('data-id'), ko.ontologyModel.bioportal_checked)
            if(ind !== -1){
                ko.ontologyModel.bioportal_checked.splice(ind,1)
            }
        }else{
            var ind = jQuery.inArray(jQuery(event.target).attr('data-id'), ko.ontologyModel.bioportal_checked)
            if(ind === -1){
                ko.ontologyModel.bioportal_checked.push(jQuery(event.target).attr('data-id'))
            }
        }
    })
    jQuery('#import_button').click(function(event){
        event.preventDefault()
        jQuery.openFloatWindow('loading...', {modal: true})
        jQuery.post('/phenotypes/import_ontologies',{ontology_ids: ko.ontologyModel.bioportal_checked.join()},function(response){
            if(response.saved === true){
                jQuery.each(ko.ontologyModel.bioportal_checked,function(ind,obj){ 
                      
                    ko.ontologyModel.imported_checked.push(obj)
                    ko.ontologyModel.imported.push(ko.ontologyModel.ontologies()[ind])
                })
                jQuery.closeFloatWindow()
                ko.callbacks.fire()
            }
        }, 'json')
    }) 
    //
    jQuery('#remove_button').click(function(event){
        event.preventDefault()
    }) 

    jQuery('#new-cladename-tabs li.tab').click(function(target){
        //make all tabs active and hide all divs
        jQuery('#new-cladename-tabs li.tab').css({'background-color': '#ffe8ac', 'border-bottom': '1px solid #777'})
        jQuery('#new-cladename-content>div[id!="save-and-reference"]').css({'display':'none'});
        //show selected tab and div
        jQuery('#'+target.target.id + '-div').css({'display':'block'});
     
        jQuery('#'+target.target.id).css({'background-color': '#FFFAE1', 'border-bottom': '1px solid #FFFAE1'});

    })
})