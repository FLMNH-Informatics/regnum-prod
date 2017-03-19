document.head.appendChild(new Element('script', {type: 'text/javascript', src: '/javascripts/autocomplete.js'}));

var checkedTr;
var windowTopDefault;
var windowLeftDefault;

jQuery(document).ready(function(){
    jQuery('tr.states, tr.phenotypes').hide();

    jQuery('.listmain').on('click', function(event){
        switch(event.target.id){
            case 'new-character':
                create_character();
                break;
            case 'delete-character':
                delete_character();
                break;
            case 'new-state':
                create_state()
                break;
            case 'delete-state':
                delete_state();   
                break;
            case 'new-phenotype':
                create_phenotype();
                break;
            case 'delete-phenotype':
                delete_phenotype();
                break;

        }
    });
})
window.onload = function() {
    windowTopDefault = $$('.characters').first().cumulativeOffset().top;
    windowLeftDefault = $$('.characters').first().cumulativeOffset().left;

   // $('overlay').hide();
   // $('div_char_window').hide();

    $('auto_complete').hide();

//    new Draggable('div_char_window', { zindex: 1000 });

    // hide all states and phenotypes rows initially
   /*$$('tr.states, tr.phenotypes').each(function(tr){
        tr.hide()
    });*/
    jQuery('tr.states').hide()
    jQuery('tr.states').prev().addClass('closed');

    jQuery('tr.phenotypes').hide()
    jQuery('tr.phenotypes').prev().addClass('closed');
    //jQuery('tr.open').removeClass('open').addClass('closed');
    // onclick for table cells with character data shows next (states) row
    jQuery('#characters-table-holder').on('click', function(event){
        if(event.target.classList.contains('row-control')){
            
            var row = jQuery(event.target).parents('tr')[0];
      
            if(row.classList.contains('open')){
                
                jQuery(row).removeClass('open').addClass('closed');
            }else{
                jQuery(row).removeClass('closed').addClass('open');
            }
            jQuery(event.target).parents('tr').next().toggle();
            //if(jQuery(event.target).parents('tr').classList.contains('closed')){
                //jQuery(event.target).parents('tr.closed').addClass('open').removeClass('closed');
           // }else{
                //jQuery(event.target).parents('tr.open').addClass('closed').removeClass('open');
           // }
        }
    })
   /* $$('.characters tr[data-id] > td, .states tr[data-id] > td').each(function(td){
        if(td.previous()) {
        // exclude first cell in row
            td.onclick = show_hide_details;
        }
            //show_hide_details(true, td); // hide all states rows initially
    });
*/
    // hide inapplicable options initially
    show_hide_options(false, false, false);
}

// show/hide next (states/phenotypes) row
function show_hide_details(event, td){
    var textRow = (td || this).up();
    var detailRow = textRow.next();
    if (detailRow && (detailRow.hasClassName('states') || detailRow.hasClassName('phenotypes')))
        if (detailRow.visible() && event) {
            textRow.className = 'closed';
            detailRow.hide();
        }
        else {
            textRow.className = 'open';
            detailRow.show();
        }
}

// show/hide options
function show_hide_options(character, state, phenotype){
    $$('li.characterOption').each(function(li){
        show_hide_option(li, character);
    });
    $$('li.stateOption').each(function(li){
        show_hide_option(li, state);
    });
    $$('li.phenotypeOption').each(function(li){
        show_hide_option(li, phenotype);
    });
}

function show_hide_option(li, show){
    if (show)
        li.show();
    else
        li.hide();
}

function selectCharacter(radio) {
    show_hide_options(true, false, false);
    select(radio);
}

function selectState(radio) {
    show_hide_options(false, true, false);
    select(radio);
}

function selectPhenotype(radio) {
    show_hide_options(false, false, true);
    select(radio);
}

function select(radio) {
    show_hide_details(null, radio.up());
    checkedTr = radio.up().up();
}

//onclick="phenotypes(this,'<%=character.id%>')">

// show new character/state/phenotype window
function window_show(useChecked){
    var window = $('div_char_window');
    //var checkedTr = $$('.characters input:checked[type="radio"]').first().up().up();
    if (useChecked && checkedTr) {
        checkedTr.setStyle({zIndex: 999, position: 'relative'});
        var parentTr = checkedTr.up('tr');
        if (parentTr)
            parentTr.previous().setStyle({zIndex: 999, position: 'relative'});
    }
    window.style.top = (useChecked && checkedTr ? checkedTr.cumulativeOffset().top + checkedTr.offsetHeight : windowTopDefault) + 'px';
    window.style.left = (useChecked && checkedTr ? checkedTr.cumulativeOffset().left : windowLeftDefault) + 'px';
    Effect.multiple(['overlay', window], Effect.Appear, {duration:0.15});
}

// close new character/state/phenotype window
function window_close(){
    Effect.multiple(['div_char_window', 'overlay'], Effect.Fade, {duration:0.15});
    if (checkedTr) {
        checkedTr.setStyle({zIndex: 'auto', position: 'static'});
        var parentTr = checkedTr.up('tr');
        if (parentTr)
            parentTr.previous().setStyle({zIndex: 'auto', position: 'static'});
    }
}

function delete_checked(){
    if (checkedTr) {
        var detailTr = checkedTr.next();
        if (detailTr && (detailTr.hasClassName('states') || detailTr.hasClassName('phenotypes')))
            detailTr.remove();
        if (checkedTr.siblings().length == 1) {
            var parent = checkedTr.up('.states, .phenotypes');
            if (parent) {
                parent.previous().removeClassName('open');
                parent.remove();
            }
        }
        checkedTr.remove();
    }
}

function character_states(obj){
    window.location = '/characters/'+obj.readAttribute('data-id')+'/states'
}

function phenotypes(obj, id){
    window.location = '/characters/'+id+'/states/'+obj.readAttribute('data-id')+'/phenotypes'
}

function create_character(){
    jQuery.get('/characters/new',function(resp){
        jQuery.openFloatWindow(resp);
    })
    /*new Ajax.Updater('div_char_window','/characters/new', {
        method: 'get',
        asynchronous:true,
        evalScripts:true,
        onSuccess: window_show()
    });*/
}

function delete_character(){
    if (confirm("Are you sure you want to delete selected character?"))
        new Ajax.Request('/characters/destroy_character', {
            method: 'POST',
            asynchronous:true,
            evalScripts:true,
            parameters:{ 'id' : checkedTr.readAttribute('data-id') },
            onSuccess: delete_checked()
        });
}

function create_state(){
    jQuery.get('/characters/'+checkedTr.readAttribute('data-id')+'/states/new',function(resp){
        jQuery.openFloatWindow(resp);
    })
    /*new Ajax.Updater('div_char_window','/characters/'+checkedTr.readAttribute('data-id')+'/states/new', {
        method: 'get',
        asynchronous:true,
        evalScripts:true,
        onSuccess: window_show(true)
    });*/
}

function delete_state(){
    if (confirm("Are you sure you want to delete selected state?"))
        new Ajax.Request('/characters/destroy_state', {
            method: 'POST',
            asynchronous:true,
            evalScripts:true,
            parameters:{ 'id' : checkedTr.readAttribute('data-id') },
            onSuccess: delete_checked()
        });
}

function create_phenotype(){
    $('contents').insert($('auto_complete'));
    $('contents').insert($('auto_complete_tooltip'));
    /*var window = $('div_char_window');
    new Ajax.Updater(window,'/phenotypes/new', {
        method: 'get',
        asynchronous:true,
        evalScripts:true,
        parameters:{ 'state_id' : checkedTr.readAttribute('data-id') },
        onSuccess: window_show(true),
        onComplete: function(transport){
            window.insert($('auto_complete'));
            window.insert($('auto_complete_tooltip'));
        }
    });*/

    jQuery.get('/phenotypes/new',{ 'state_id' : checkedTr.readAttribute('data-id') }, function(resp){
        jQuery.openFloatWindow(resp,function(){
            window.insert($('auto_complete'));
            window.insert($('auto_complete_tooltip'));    
        });
    
    })
}
function phenotype_selection(select, state_id){
    /*new Ajax.Updater('phenotype_details','/phenotypes/get_form_fields?index='+select.options[select.selectedIndex].value,{
        method: 'get',
        asynchronous:true,
        evalScripts:true,
        parameters:{ 'state_id' : state_id }
    });*/
    jQuery.get('/phenotypes/get_form_fields',{ 'index': select.options[select.selectedIndex].value, 'state_id' : state_id }, function(resp){
        jQuery('#phenotype_details').html(resp);
    })
}

function delete_phenotype(){
    if (confirm("Are you sure you want to delete selected phenotype?"))
        new Ajax.Request('/characters/destroy_phenotype', {
            method: 'POST',
            asynchronous:true,
            evalScripts:true,
            parameters:{ 'id' : checkedTr.readAttribute('data-id') },
            onSuccess: delete_checked()
        });
}
