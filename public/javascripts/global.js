//add some useful phunkshuns to jq namespace
jQuery(document).ajaxSend(function(event, request, settings) {
    if ( settings.type != 'GET' && settings.url != '/my_submission/add_attachment') {
        settings.data = (settings.data ? settings.data + "&" : "")
            + "authenticity_token=" + encodeURIComponent( AUTH_TOKEN );
    }
});
//extend number class to make temp id function
Number.prototype.pad = function(size){
      if(typeof(size) !== "number"){size = 2;}
      var s = String(this)
      while (s.length < size) s = "0" + s
      return s
}
//return text content from ajax get request
jQuery.getContent = function(path){
	var out = ''
	jQuery.get(path,function(response){
        out = response
	}, 'html')
	return out
}
//get inputs/selects within an selector(s)
//advise using element id for selector to avoid issues
//returns jq array of jq objects
jQuery.getFormInputs = function(formHolderId){
	var inputs = jQuery.merge(jQuery(formHolderId +' input[type!="button"]'), jQuery(formHolderId +' select'))
	return inputs
}
//iterate through array of jq objects and load
//values for available ones on screen.
//helps save input values between form type changes
//not very useful but is a view helper
jQuery.fillInputs = function(jqhash){
	jQuery.each(jqhash, function(key){
        jQuery('#'+jqhash[key].id).val(jqhash[key].value)
    })
}

//for loading widgets on ajax loaded content
//param provides optional ancestor selector to narrow the search
jQuery.loadWidgets = function(focus){
    var str = focus == undefined ? '' : focus 
	jQuery(str+' .accordion').accordion({active: false, collapsible: true})
}

jQuery.unloadWidgets = function(focus){
	var str = focus == undefined ? '' : focus 
	jQuery(str+' .accordion').accordion('destroy')
}
//not used yet... -if performance is slow
jQuery.refreshWidgets = function(focus){
	var str = focus == undefined ? '' : focus 
	jQuery(str+' .accordion').accordion('refresh')
}
//
jQuery(document).ready(function(){
	//load button widgets
	jQuery('.button').button()
	jQuery('#contents').on('click', 'a.expander', function(event){
	    jQuery('#'+event.target.id+'-div').slideToggle()
	    jQuery('#'+event.target.id).html(jQuery('#'+event.target.id).html() == '[+]' ? '[&#8211;]':'[&#43;]')
	})
    //delegate global float window actions - stick with this format for <ul> tab widgets in the float window
	jQuery('#float-window-holder').on('click', 'li.section-tab', function(event){
		jQuery('#float-window-holder #view-tabs>li.section-tab').css({'background-color': '#ffe8ac', 'border-bottom': '1px solid #777'})
        //show selected tab and div  
        //widgets must be loaded/unloaded on each tab click cause they wont size properly on non displayed items   
        jQuery('#'+event.target.id).css({'background-color': '#FFFAE1', 'border-bottom': '1px solid #FFFAE1'});
		jQuery(event.target).parents('ul').siblings('.section-tab-div').hide(0,function(){jQuery.unloadWidgets('#float-window-holder')})
        jQuery('#'+event.target.id+'-div').show(0,function(){jQuery.loadWidgets('#float-window-holder')})
	})
})

