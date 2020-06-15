jQuery.save_citation = function(){
    //CITATION/REFERENCE Attachments
    if( jQuery('#new_remote_attachment').val() && jQuery('#new_remote_attachment').val() !== ''){
        //first save whole submission to ensure
        //a submission path for the attachment
        //add deferred callback for attachments
        var sid = jQuery('#submission_id').val()
        var type = jQuery('#new_citation_for').val()
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
                  pr.submissionModel.citations[type]['0']['attachment_path'] = response.path
                  pr.submissionModel.citations[type]['0']['attachment_id'] = response.id
                }
                //must save here if attachment to ensure asynch object completes before save
                pr.save_submission('Save')
            }
        })

    }else{
        pr.save_submission('Save')
    }
};


jQuery.save_specifier = function(){
    //todo: handle attachments
    if(jQuery('#new_remote_attachment').val() && jQuery('#new_remote_attachment').val() !== ''){
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
};


jQuery(document).ready(function(){
	//setup data on form for citations.

    //delegate clicks on float window
    jQuery('#float-window-content-holder').click(function(event) {
        if (event.target.classList.contains('outlink') === true) {
            var res = event.target.id.split('_outlink_img')[0]
            var search = ''
            if (res === 'treebase_tree') {
                search = jQuery('#new_name').val()
            } else {
                search = jQuery('#new_specifier_name').val()
            }

            jQuery('#modal-window').openSearchDialog(res)
            jQuery('#specifier-resource-list').loadSearchDialog(res, search)
        }
    });
});