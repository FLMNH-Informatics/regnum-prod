jQuery.save_citation = function(){
        //var inputs = cit
        //inputs.push(jQuery('#new-citation-form-entry input[type="file"]')[0])
        var cit = jQuery.merge(jQuery('#float-window-content-holder #new-citation-form-entry input[type="text"]'),jQuery('#float-window-content-holder #new-citation-form-entry select'))
                       
        var type = jQuery('#new_citation_for').val()
        var id = jQuery('#phylogeny_table_citation_id').val()  //name type for citation
        var citation = {}
        cit.each(function(obj,val){
            citation[val.attributes.name.value] = val.value
        })
        switch(type){
      
            case 'phylogeny':
                
                if(id != 'new' ){
                    pr.ko.replaceObservedArrayItem(parseInt(id), pr.submissionModel.citations.phylogeny, citation)  
                    id = parseInt(id)                
                }else{
                
                    pr.submissionModel.citations.phylogeny.push(citation) 
                    id = pr.submissionModel.citations.phylogeny().length - 1   
                }
                break
            default:
                //all other citation type has only one
                pr.submissionModel.citations[type].removeAll()
                pr.submissionModel.citations[type].push(citation)    
                break
        }

        //CITATION/REFERENCE Attachments
        if(jQuery('#new_remote_attachment').val() !== ''){
            //first save whole submission to ensure
            //a submission path for the attachment
            //add deferred callback for attachments
            var sid = jQuery('#submission_id').val()
            var d = {submission_id: sid, type: type, authenticity_token: encodeURIComponent( AUTH_TOKEN )}
          
            jQuery('#remote-attachment-form').ajaxSubmit({
                data: d ,
                dataType: 'json',
                success: function(response){
                    if(type === 'phylogeny'){                      
                      //var id = parseInt(jQuery('#phylogeny_table_citation_id').val())
                      pr.submissionModel.citations.phylogeny()[parseInt(id)]['attachment_path'] = response.path
                      pr.submissionModel.citations.phylogeny()[parseInt(id)]['attachment_id'] = response.id
                    }else{                        
                      pr.submissionModel.citations[type]()['0']['attachment_path'] = response.path
                      pr.submissionModel.citations[type]()['0']['attachment_id'] = response.id
                    }
                    //must save here if attachment to ensure asynch object completes before save
                    pr.save_submission('Save')
                }
            })             
            
        }else{
            pr.save_submission('Save')
        }
       


        
        //close citation window

}


jQuery.save_specifier = function(){
    var table = jQuery('#new-cladename-specifier')          
    var inputs = jQuery.merge(jQuery('#float-window-content-holder #new-specifier-form input[type!="button"]'), jQuery('#float-window-content-holder #new-specifier-form select'))
    var specifier = {}
    inputs.each(function(ind,obj){
       //if(obj.name != ''){

         specifier[obj.name]  = obj.value
       //}
    })
     
    if(typeof specifier['specifier_kind'] == 'undefined'){
        specifier['specifier_kind']='';
    }
    if(typeof specifier['specifier_kind_type'] == 'undefined'){
        specifier['specifier_kind_type']='';
    }
    var id = jQuery('#specifier_table_entry_id').val()
    if(id == 'new'){

       pr.submissionModel.specifiers.push(specifier)

       id = pr.submissionModel.specifiers().length - 1
    }else{
       id = parseInt(id)
       pr.ko.replaceObservedArrayItem(parseInt(id), pr.submissionModel.specifiers, specifier)
    }

    if(jQuery('#new_remote_attachment').val() !== ''){
        //first save whole submission to ensure
        //a submission path for the attachment
        //add deferred callback for attachments

        var sid = jQuery('#submission_id').val();
        var d = {submission_id: sid, authenticity_token: encodeURIComponent( AUTH_TOKEN )};
        jQuery('#remote-attachment-form').ajaxSubmit({
            data: d ,
            dataType: 'json',
            success: function(response){                   
                pr.submissionModel.specifiers()[parseInt(id)]['attachment_path'] = response.path
                pr.submissionModel.specifiers()[parseInt(id)]['attachment_id'] = response.id
                pr.save_submission('Save')
            }
        })         
    }else{
        pr.save_submission('Save')
    }
    //jQuery.makeSpecifierTable()    
}
//jQuery.specifierModel = {}
jQuery(document).ready(function(){
	//setup data on form for citations.

    //delegate clicks on float window
    jQuery('#float-window-content-holder').click(function(event){
	    if(event.target.classList.contains('outlink') === true){
	        var res =  event.target.id.split('_outlink_img')[0]
	        var search = ''
	        if(res === 'treebase_tree'){
	            search = jQuery('#new_name').val()
	        }else{
	            search = jQuery('#new_specifier_name').val() 
	        }
	        
	        jQuery('#modal-window').openSearchDialog(res)
	        jQuery('#specifier-resource-list').loadSearchDialog(res,search)
	    }
        switch(event.target.tagName.toLowerCase()){

            case 'a':
            
                switch(event.target.innerHTML){
                    case 'View':
                        event.preventDefault()
                        window.open(event.target.href,'Phyloregnum Attachment' )
                        break
                    case 'Remove':
                        event.preventDefault()

                        jQuery.post(event.target.href,function(response){
                            if(event.target.classList.contains('specifier')){
                                var pid = parseInt(jQuery("#specifier_table_entry_id").val())
                                delete(pr.submissionModel.specifiers()[pid]['attachment_id'])
                                delete(pr.submissionModel.specifiers()[pid]['attachment_path'])
                                jQuery('#specifier-attachment-cell').html(pr.emptyAttachmentFile)
                            }
                            if(event.target.classList.contains('citation')){
                                var cit = jQuery('#new_citation_for').val()
                                 
                                if(cit==='phylogeny'){
                                    var pid = parseInt(jQuery("#phylogeny_table_citation_id").val())

                                    delete(pr.submissionModel.citations.phylogeny()[pid]['attachment_id'])
                                    delete(pr.submissionModel.citations.phylogeny()[pid]['attachment_path'])
                                }else{
                                    delete(pr.submissionModel.citations[cit]()[0]['attachment_id'])
                                    delete(pr.submissionModel.citations[cit]()[0]['attachment_path'])
                                }
                               
                                jQuery('#citation-attachment-cell').html(pr.emptyAttachmentFile)
                            }
                            
                            pr.save_submission()
                        })
                        break
                       
                }
                break

        }

    })
    //delegate select element changes
    jQuery('#float-window-content-holder').on('change','select',function(event){
        switch(event.target.name){
            //citation
            case 'citation_type':             
                var cfor = jQuery('#new_citation_for').val()
                var inputs = jQuery.getFormInputs('#float-window-content-holder')
                jQuery.loadFloatWindow(pr.templates[event.target.value + '_citation'])
                jQuery('#new_citation_for').val(cfor)
                jQuery.fillInputs(inputs)
         
                if(cfor === 'preexisting'){
                    jQuery('.treebase-outlink').hide()
                }
                break
            //specifiers
            case 'specifier_type':
                var sfor = jQuery("#specifier_table_entry_id").val()
                var inputs = jQuery.getFormInputs('#float-window-content-holder')
                jQuery.loadFloatWindow(pr.templates[event.target.value + '_specifier'])
                jQuery("#specifier_table_entry_id").val(sfor)
                jQuery.fillInputs(inputs)
                break
        }
    })
})