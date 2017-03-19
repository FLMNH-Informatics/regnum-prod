jQuery(document).ready(function(){
	jQuery('#opt-out').click(function(event){
	    var t = jQuery('#opt-out-table');
        if(event.target.checked === true ){
            t.slideDown('fast');
        }else{
            t.slideUp();
        }
	})

	jQuery('#create_button').click(function(event){
		event.preventDefault()
		var alt = ''
		if(jQuery('#name').val().length < 1){
			alt += 'Name required. '
		}
		if(jQuery('#opt-out').prop('checked') === true && jQuery('#reason').val().length < 3){
			alt += 'Opt-out reason required.'
		}

		if(alt.length > 0){
			alert(alt)
		}else{
			jQuery.post('/save', jQuery(event.target.form).serialize(), function(res){
         document.location.href = '/my_submission/'+ res.submission_id;
			},'json')
			//event.target.form.submit()
		}
	})
})