/*
* REQUIRES jQuery Form plugin.
*
*jQuery phyloregnum clade tools plugin
*
* */
(function(){
    //
    //
    //
    jQuery.fn.sizeWindow = function(){
        var width = jQuery(this).find('.sized-content:first').css('min-width').match(/[0-9]*/)
        var height = jQuery(this).find('.sized-content:first').css('min-height')
   
        jQuery(this).css({'width': (parseInt(width[0]) + 70) + 'px'})
        jQuery(this).css({'height': height})
        return this
    }
    //
    //
    jQuery.fn.loadFormData = function(dataHash, idPrefix){
    //very likely to prefix inputs
        var data = dataHash  //should be a hash
        if(idPrefix == 'undefined'){
            idPrefix = ''
        }
        //this.clearForm()
        //would like to have this load values
        //based on tag name attribute instead
        //TODO: fix this so it only searches with in window for inputs
        jQuery.each(data, function(key,val){
            jQuery('#float-window-content-holder #'+idPrefix+key).val(val)
        })
    }
    //
    //
    jQuery.fn.hideInputs = function(all,hide){
        all.each(function(key){
            hide.indexOf(key) > -1 ? jQuery('.'+key).hide() : jQuery('.'+key).show();
        })
    }
    //
    //
    jQuery.fn.loadSearchDialog = function(res,search){
        //var tit = title == 'undefined' ? res : title
        this.html('<img src="/images/ajax-loader.gif" />')
        jQuery('#dialog_resource').val(res)
        jQuery('#dialog_search').val(search)
        jQuery('#dialog-search-button').attr("disabled", "disabled")
        var me = this
        jQuery('#resource_search_form').ajaxSubmit(function(response){
            me.html(response)
            jQuery('#dialog-search-button').removeAttr("disabled")
        })
        return this
    }
    //
    //
    jQuery.fn.openSearchDialog = function(title){
        var tit = title === undefined ? '' : title
        this.dialog({
            modal: true,
            height: 400,
            width: 700,
            title: tit,
            close: function(){
                jQuery('#specifier-resource-list').html('<img src="/images/ajax-loader.gif" />')
            }
        })
    }
    //
    //
    jQuery.fn.showCitation = function(dataHash){
        this.find('form').loadFormData(dataHash, 'new_')
        this.show()
    }
    //
    //taken from code in stackoverflow for special characters panel
    jQuery.fn.insertAtCaret = function(myValue){
        return this.each(function(i) {
            if (document.selection) {
              //For browsers like Internet Explorer
              this.focus();
              sel = document.selection.createRange();
              sel.text = myValue;
              this.focus();
            }
            else if (this.selectionStart || this.selectionStart == '0') {
              //For browsers like Firefox and Webkit based
              var startPos = this.selectionStart;
              var endPos = this.selectionEnd;
              var scrollTop = this.scrollTop;
              this.value = this.value.substring(0, startPos)+myValue+this.value.substring(endPos,this.value.length);
              this.focus();
              this.selectionStart = startPos + myValue.length;
              this.selectionEnd = startPos + myValue.length;
              this.scrollTop = scrollTop;
            } else {
              this.value += myValue;
              this.focus();
            }
            //trigger change on element for
            //ko observers
            jQuery(this).trigger("change")
        })
    }
    //
})(jQuery);
