//initializes float window content/form window

jQuery.openFloatWindow = function(content, options, callback){
	opts = {
		show: 'drop',
		hide: 'drop',
		close: function(){
			jQuery.unloadWidgets('#float-window-holder')
		}
	}
	jQuery.extend(opts,options)
	jQuery.loadFloatWindow(content)
	jQuery("#float-window-holder").dialog(opts)
	if(callback != undefined){
		callback()
	}
}
//
jQuery.closeFloatWindow = function(callback){
    jQuery("#float-window-holder").dialog("destroy")
    jQuery("#float-window-content-holder").html(" ")
    if(callback != undefined){
		callback()
	}
}
//
jQuery.loadFloatWindow = function(content){
	jQuery("#float-window-content-holder").html(content)
}
//
jQuery.loadFloatWindowForm = function(data){
    jQuery("#float-window-content-holder").loadFormData(data, 'new_')
}
//

