//requires cladename tools plugin

jQuery.characterHelperOn = false
jQuery.characterHelperChar = ''

jQuery.openCharacterWindow = function(options, callback){
	opts = {
		title: 'Special Characters Viewer &nbsp;<a class="help-link" style="color:blue" href="#">?</a>',
		width: 550,
		height: 240,
		show: 'drop',
		hide: 'explode',
        close: function(){
            jQuery.characterHelperOn = false
            jQuery.characterHelperChar = '' 
        }
	}
	jQuery.extend(opts,options)
	//jQuery.loadCharacterWindow(content)
	jQuery("#character-window-holder").dialog(opts)
	if(callback !== undefined){
		callback()
	}
    jQuery('#character-window-holder').prev().on('click', '.help-link', function(event){       
        event.preventDefault()
        var msg = "Use these UTF-8 characters to help with characters that do not appear correctly in your browser."
        msg += ' You can either copy and paste the character or click on the corresponding button'
        msg += ' and the cursor will place that character in any text input box at the position that you click on'
        jQuery('#modal-message-window .content').html(msg)
        jQuery('#modal-message-window').dialog({modal: true, title: 'Special Characters Help'})
    })
}
//
jQuery.closeCharacterWindow = function(callback){
    jQuery("#character-window-holder").dialog("destroy")
    //jQuery("#character-window-content-holder").html(" ")
    jQuery.characterHelperOn = false
    jQuery.characterHelperChar = ''
    if(callback !== undefined){
		callback()
	}
}
//
jQuery.loadCharacterWindow = function(content){
	  jQuery("#character-window-content-holder").html(content)
}

jQuery.createCharacterWindow = function(callback){
    var template = '<div id="character-window-holder" class="float-window" style="display:none;">'
    template += '<div id="character-window-content-holder">'
    template += '</div>'
    template += '</div>'
    jQuery('body').append(template)

    if(callback !== undefined){
        callback()
    }
}
//run
jQuery(document).ready(function(){
    jQuery.createCharacterWindow(function(){
        jQuery('#character-window-holder').on('click','input[type="button"]',function(event){
            if(jQuery.characterHelperOn === true && jQuery.characterHelperChar === event.target.value){
                jQuery.characterHelperOn = false
                jQuery.characterHelperChar = ''
                jQuery(event.target).css('border-color','#CDC3B7')
            }else{
                if(jQuery.characterHelperChar != ''){
                    jQuery('#special-characters-window .character-button[value="'+jQuery.characterHelperChar+'"]').css('border-color','#CDC3B7')
                }
                jQuery.characterHelperOn = true
                jQuery.characterHelperChar = event.target.value
                jQuery(event.target).css('border-color','red')
            }           
        })

         //detect clicks on input type elements
        jQuery('body').on('click','textarea',function(event){
        	if(jQuery.characterHelperOn === true ){
                //method in cladename_tools
                jQuery(event.target).insertAtCaret(jQuery.characterHelperChar)

            }
        })
        jQuery('body').on('click','input[type="text"]',function(event){
            if(jQuery.characterHelperOn === true ){
                //method in cladename_tools
                jQuery(event.target).insertAtCaret(jQuery.characterHelperChar)
            }
        })
    })

})
