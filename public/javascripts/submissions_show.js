jQuery(document).ready(function(){

    //control for opening closing expanders

    jQuery('#submission_button').click(function(event){
        event.target.value == 'edit' ? event.target.value = 'save' : event.target.value = 'edit'
        var all = jQuery('.value_text')
        jQuery.merge(all, jQuery('.value_textarea'))
        jQuery.merge(all, jQuery('.value_checkbox'))
        jQuery.merge(all, jQuery('.value_select'))
        all.each(function(ind,obj){
            var name = obj.id.split('cell_')[1]
            var cl = obj.className.split('value_')[1]
            var out = ''
            switch(cl){
                case 'text':
                    out = '<input type="text" name="sub['+name+']"value="'+obj.innerHTML+'"/>'
                    break
                case 'textarea':
                    out = '<textarea cols="40" rows="8" name="sub['+name+']">'+obj.innerHTML+'</textarea>'
                    break
                case 'checkbox':
                    out = '<input type="checkbox" name="sub['+name+']" '+ (obj.innerHTML=='true'? 'checked' : '') +'/>'
                    break

            }
            obj.innerHTML = out
        })

        /*jQuery.each(jQuery('.value_text'),function(ind,obj){
            var name = obj.id.split('cell_')

        })*/
    })
    /*
    jQuery('#sub_save_button').click(function(event){
        event.preventDefault()
        jQuery('#'+event.target.up('form').id).ajaxSubmit(function(response){
            document.location.href = '/submissions'
        })

    })*/
})