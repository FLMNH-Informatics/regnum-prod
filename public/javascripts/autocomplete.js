var tooltipTimer = null;

//$('auto_complete').hide();
$('auto_complete_tooltip').hide();
// prevent autocompleter from being hidden when clicking in tooltip
$('auto_complete_tooltip').observe('mousedown', function(event) {Event.stop(event);});


function onAcRender(ac) {
    clearTimeout(tooltipTimer);
//    var tooltip = $('auto_complete_tooltip');
//    if (tooltip.visible())
//    new Effect.Fade(tooltip,{duration:0.15});
    $('auto_complete_tooltip').hide();  // this has to work smooth, let's not give the browser too much work
//    var idx = ac.index;
    tooltipTimer = setTimeout(function() {showTooltipForAc(ac, ac.index)}, 800);
}

// positions and shows update and tooltip  
// relative to element placed in a window 
function onAcShowInWindow(element, update) {
	onAcShow (element, update, element.getOffsetParent().getOffsetParent().getOffsetParent());
}

// positions and shows update, positions tooltip relative to
// element placed in a (optional) given position parent
function onAcShow(element, update, parent) {
    var tooltip = $('auto_complete_tooltip');
    var elementBottom = element.cumulativeOffset().top + element.offsetHeight;
    var parentOffsetTop = parent ? parent.cumulativeOffset().top : 0;
    var parentOffsetLeft = parent ? parent.cumulativeOffset().left : 0;
    update.style.top = tooltip.style.top = elementBottom - parentOffsetTop + 'px';
    update.style.left = element.cumulativeOffset().left - parentOffsetLeft + 'px';
    // tooltip left is set in showTooltipForAc() in case the width of update changed
    // tooltip.style.left = element.cumulativeOffset().left - parentOffsetLeft + update.getWidth() + 'px';
    var maxHeight = Math.max(docHeight() - elementBottom - (parent ? 8 : 5), 200);
    update.style.maxHeight = maxHeight + 'px';
    update.style.zIndex = '500';
    tooltip.style.zIndex = '500';
    tooltip.style.maxHeight = maxHeight - 12 + 'px';
	Effect.Appear(update,{duration:0.15});
};

function docHeight() {
    var body = document.body, html = document.documentElement;
    return Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
}

function onAcHide(element, update) {
    clearTimeout(tooltipTimer);
    $('auto_complete_tooltip').hide();
	Effect.Fade(update,{duration:0.15});
//    Effect.multiple([$('auto_complete_tooltip'), update], Effect.Fade, {duration:0.15});
	}

function showTooltipForAc(ac, idx) {
    if (changed(ac, idx)) return;
    var conceptId = ac.getEntry(idx).readAttribute('data-id');
    var onComplete = function(tooltip) {
        if (changed(ac, idx)) return;
        // left is set here in case the width of update changed
        tooltip.style.left = ac.update.offsetLeft + ac.update.offsetWidth + 'px';
        tooltip.show(); // this has to work smooth, let's not give the browser too much work
        //Effect.Appear(tooltip,{duration:0.2})
//      tooltip.style.top = current.viewportOffset().top - current.getOffsetParent().getOffsetParent().viewportOffset().top + 'px';
//      tooltip.style.top = current.getOffsetParent().viewportOffset().top - current.getOffsetParent().getOffsetParent().viewportOffset().top + 'px';
//      tooltip.style.left = current.viewportOffset().left + current.getOffsetParent().getWidth() - current.getOffsetParent().getOffsetParent().viewportOffset().left + 'px';   //alert('11');
//      tooltip.style.top = ac.update.offsetTop + 'px';
    };
    updateTooltip(conceptId, ac, onComplete);
}

function showTooltipForLink(a) {
    var onComplete = function(tooltip) {
        var aBottom = a.cumulativeOffset().top + a.offsetHeight;
        tooltip.style.top = aBottom + 'px';
        tooltip.style.left = a.cumulativeOffset().left + 'px';
        tooltip.style.maxHeight = Math.max(docHeight() - aBottom - 17, 200) + 'px';
        tooltip.appear({duration:0.2});
    };
    updateTooltip(a.readAttribute('data-id'), null, onComplete);
    a.focus();
    a.observe('blur', function(event) { hideTooltip(a); });
    a.observe('keydown', function(event) {
        if(event.keyCode == Event.KEY_ESC)
            hideTooltip(a);
    });
}

function hideTooltip(a) {
    $('auto_complete_tooltip').fade({duration:0.2});
    a.stopObserving();
}

function changed(ac, idx) {
    return !ac.active || ac.index != idx;
}

function updateTooltip(conceptId, ac, onComplete) {
    new Ajax.Updater('auto_complete_tooltip','/ontologies/get_concept', {
        method: 'get',
        asynchronous: true,
        parameters: { 'conceptId' : conceptId },
        onComplete: function(transport){
            var tooltip = $('auto_complete_tooltip');
//            if (tooltip.innerHTML.length == 0) return;
            if (ac) {
                var term = tooltip.down('h2');
                term.onclick = function() {
                    ac.element.value = term.innerHTML;
                    ac.active = false;
                    ac.hide();
                    if (ac.options.afterUpdateElement)
                        ac.options.afterUpdateElement(ac.element, term);
                };
            }
            tooltip.select('a').each(function(a){
                //a.href = 'javascript:void(0)'
                a.onclick = function() { updateTooltip(a.readAttribute('data-id'), ac) };
            });
            if (onComplete)
                onComplete(tooltip);
        }
    });
}
