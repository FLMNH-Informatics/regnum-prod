//define phyloregnum object/namespace
// 
function Phyloregnum(){
    //define phylo knockout properties
    var self = this
    //object for holding json data
    this.submissionModel = {
    }//

    this.emptyAuthorObj = {'first_name': '', 'middle_name': '', 'last_name': ''}
    this.emptyCitationObj = {'citation_type': 'book', 'citation_authors':ko.observableArray([ this.emptyAuthorObj ]), 'title': ' '}
    this.ko = {
        //json response loading map for ko.mapping
        mapping:  {
            'authors': {
                create: function(options){
                    if (options.data){
                        return ko.observableArray(self.ko.objToArray(options.data));
                    }
                    return ko.observableArray([{'first_name': '', 'middle_name': '', 'last_name': ''}])
                }
            },
            'specifiers': {
                create: function(options){
                    var specs = [];
                    jQuery.each(options.data, function(item,obj){
                        if(typeof obj=='object'){
                            item=obj;
                        }
                        if(item.kind_type){
                            item.specifier_kind_type=item.kind_type;
                        }
                        if(item.kind){
                            item.specifier_kind=item.kind;
                        }
                        if(typeof(item) != 'undefined' && typeof(item['specifier_type']) != 'undefined' && typeof(item['specifier_type_kind']) != 'undefined'){
                            if(typeof(item['specifier_kind'])=='undefined' || item['specifier_kind']==null ){
                                item['specifier_kind']='';
                            }else if(typeof(item['specifier_kind_type'])=='undefined' || item['specifier_kind_type']==null ){
                                itadd_aem['specifier_kind_type']='';
                            }

                        }
                        specs.push(item)
                    });

                    return ko.observableArray(self.ko.objToArray(specs)).extend({paging: 5});
                }
            },
            'citations': {
                create: function(options){
                    //initalize citations
                    debugger;
                    //existing ones will overwrite these
                    var cits = {
                        'phylogeny': ko.observableArray([]).extend({paging: 5}),
                        'primary-phylogeny': ko.observableArray([self.emptyCitationObj]),
                        'description': ko.observableArray([self.emptyCitationObj]),
                        'preexisting': ko.observableArray([{'authors': ko.observableArray([ this.emptyAuthorObj ])}])
                    }
                    //now load existing ones from response into cits hash
                    jQuery.each(options.data, function(ind,val){
                        if(val[0] != undefined && val['0'] != undefined){
                            if(typeof(val[0].citation_type) != 'undefined' && typeof(val['0'].citation_type) != 'undefined'){
                                if(ind === 'phylogeny'){
                                    cits[ind] = ko.observableArray(self.ko.objToArray(val)).extend({paging: 5})
                                }else{
                                    cits[ind] = ko.observableArray(self.ko.objToArray(val))
                                }

                                /todo: check for Array.isArray(val);
                                val.forEach( function(citation, index){
                                    if (citation.hasOwnProperty('authors')){
                                        cits[ind]()[index].authors = self.ko.objToArray(citation.authors);
                                    }
                                })
                            }
                        }
                    })
                    return cits
                }
            },
            'abbreviation': {
                create: function(options){
                    return ko.computed(function(){
                        return self.makeDefinition()
                    }, self)
                }
            },
            'name_string': {
                create: function(options){
                    return ko.computed(function(){
                        var t = self.makeReference(options)
                        return t
                    }, self)
                }
            }
        },
        //
        objToArray:function(obj){
            var arr = []
            jQuery.each(obj,function(ind,object){
                arr.push(object)
            })
            return arr
        },
        //trick to forcing update of items on screen 
        //with knockout.js without observing values of each item
        replaceObservedArrayItem: function(id, oa, item){
            var pushBack = oa().splice(id, oa().length - id)
            pushBack.shift()
            oa.push(item)
            jQuery.each(pushBack, function(ind,val){
                oa.push(val)
            })
        }
    }
    //
    this.templates = {}
    this.templatesToLoad = [
        'book_citation',
        'book_section_citation',
        'journal_citation',
        'species_specifier',
        'specimen_specifier',
        'apomorphy_specifier',
        'synonyms',
        'special_characters'
    ]


    this.emptyAttachmentFile = '<form id="remote-attachment-form"  enctype="multipart/form-data" action="/my_submission/add_attachment" method="post"><input type="file" id="new_remote_attachment" name="file" /></form>'

    //define button actions
        this.ba = {
            addSpecifier: function(){
                jQuery.showSpecifier('new')
            },
            editSpecifier: function(obj){
                jQuery.showSpecifier(obj)
            },
            deleteSpecifier: function(obj){
                if(confirm("Delete this specifier/qualifier?")){
                    self.submissionModel.specifiers.remove(obj)
                }
            },
            addCitation: function(cfor,obj,event){
                jQuery.showCitation('new',cfor)
            },
            editCitation: function(cfor,obj,event){
                jQuery.showCitation(obj,cfor)
            },
            deleteCitation: function(cfor,obj,event){
                if(confirm("Delete this citation?")){
                    self.submissionModel.citations[cfor].remove(obj)
                }
            }
    }//



    //build abbreviated symbolic clade definition
    this.makeDefinition = function(){

        var str = '' //final output
        var extstr = ''
        var intstr = ''
        var apostr = ''
        //specifiers
        var internal = [] //not including apomorphs (they are always internal)
        var external = []
        var apomorph = []
        //

        jQuery.each(this.submissionModel.specifiers(), function(ind,obj){
            if(obj.specifier_type === 'apomorphy'){
                apomorph.push(obj.specifier_character_name+'(' + obj.specifier_name + ')' )
            }else{
                var kind = obj.specifier_kind === undefined ? obj.kind : obj.specifier_kind
                switch(kind){
                    case 'internal extinct':
                        internal.push(obj.specifier_name)
                        break
                    case 'internal extant':
                        internal.push(obj.specifier_name)
                        break
                    case 'external extinct':
                        external.push(obj.specifier_name)
                        break
                    case 'external extant':
                        external.push(obj.specifier_name)
                        break
                }
            }
        })//


        var gt = '&gt;&nbsp;'
            , lt = '&lt;&nbsp;'
            , nabla = '&nabla;';

        switch(this.submissionModel.clade_type()){
            // <  = &lt;    > = &gt;
            case 'node-based_standard':
                str = lt//'<'
                break
            case 'node-based_crown_clade':
                str = lt// '<'
                break
            case 'node-based_crown_clade_branch-modified':
                str =  gt+nabla// '>∇'
                break
            case 'node-based_crown_clade_apomorphy-modified':
                str = gt+nabla// '>∇'
                break
            case 'branch-based_standard':
                str = gt// '>'
                break
            case 'branch-based_total_clade':
                str = gt// '>'
                break
            case 'branch-based_total_clade_explicit':
                str = gt//'>'
                break
            case 'apomorphy-based_standard':
                str = gt//'>'
                break
        }//

        apostr += apomorph.join(' &amp; ')
        intstr += internal.join(' &amp; ')
        extstr += external.join(' V ')

        str += apostr + (apostr == '' || intstr == '' ? '' : ' & ') + intstr + (extstr == '' ? '' : ' ~ ' + extstr)
        return str
    }

    //make cladename citation reference
    this.makeReference = function(options){

        var isUndefined = function(val){
            if(typeof(val) == 'undefined' || val == ''){
                return ''
            }else{
                return val
            }
        }
        var formatVolume = function(val){
            if(isUndefined(val) === ''){
                return ''
            }else{
                return '(Vol. ' + val + ')' + ': '
            }
        }
        var obj = options.parent
        var str = obj.name()  + ' '
        var cit = obj.citations
        if(typeof(cit.preexisting()[0]) == 'object'){
            str += obj.preexisting_authors() + ' '
            str += (isUndefined(cit.preexisting()[0]['year']) == '' ? '' : cit.preexisting()[0]['year'] + ': ') //isUndefined(cit.preexisting['year']) + ': '  
            str += (isUndefined(cit.preexisting()[0]['volume']) == '' ? '' : ('(Vol. ' + cit.preexisting()[0]['volume'] + ')' + ': ') )
            str += (isUndefined(cit.preexisting()[0]['pages']) == '' ? '' : cit.preexisting()[0]['pages'])
            // todo: str += ' [' + obj.authors() + ']'
            str += ', converted clade name'
        }else{
            //var d = new Date()

            str += obj.authors() + ' '
            if(typeof(cit.description()[0]) == 'object'){
                str += (isUndefined(cit.description()[0]['year']) == '' ? '' : cit.description()[0]['year'] + ': ' )//isUndefined(cit.description['year']) + ': ' 
                str += (isUndefined(cit.description()[0]['volume']) == '' ? '' : ('(Vol. ' + cit.description()[0]['volume'] + ')' + ': ') ) //formatVolume(cit.description['volume']) + isUndefined(cit.description['pages'])
                str += (isUndefined(cit.description()[0]['pages']) == '' ? '' : cit.description()[0]['pages'])
            }
            str += ', new clade name'
        }

        return str
    }

    this.save_submission = function(action){
        jQuery('#spinner').show()

        switch(action){
            case 'Save':
                self.submissionModel.subaction = 'save'
                break;
            case 'Submit':
                self.submissionModel.subaction = 'submit'
                break;
        }
        var subid = jQuery('#submission_id').val()
        //return the asynch object so any calls to save can
        //be chained with other deferred methods


        return jQuery.post('/save', ko.mapping.toJS(self.submissionModel), function(response){
            if(subid==='new'){
                document.location.href = '/my_submission/'+ response.submission_id
            }else{
                jQuery('#submission_id').val(response.submission_id)
            }
        },'json').done(function(){
            if(action === 'Submit'){
                document.location.href = '/my_submission'
            }
            jQuery('#spinner').hide()
        })
    }

    //load submission data for complete page loads
    //passing in submission id
    this.loadSubmission = function(id){
        jQuery('#submission_id').val(id)
        jQuery.getJSON('/my_submission/'+id,function(response){
            var submission = response.submission ? response.submission : response;

            submission.submsion_id = id
            //set save action
            submission.subaction = ''
            ///ko key mapping

            pr.submissionModel = ko.mapping.fromJS(submission,pr.ko.mapping)
            jQuery.each(pr.submissionModel, function(k,v){

                if((typeof(v)=='function'&&v()=='null')||v==null){
                    pr.submissionModel[k]('');
                }
            })

            ko.applyBindings(pr.submissionModel, document.getElementById('new-cladename-content'))
            jQuery('.temp-id').html(parseInt(id).pad(10));

            jQuery.loadWidgets('#contents')
            jQuery('#modal-message-window').dialog('destroy')
        })
        return false
    }


    /*******************************
     * Author functions
     */



    this.author = {
        addAuthor: function($author, event){
            debugger;
            var invalid_msg = "Please enter a first name and last name before adding an additional author.";
            if ($author.hasOwnProperty('first_name')){
                if (pr.author.isValidAuthor($author)){
                    pr.submissionModel.authors.push({first_name: '', middle_name: '', last_name: ''});
                    pr.author.markAllValid(jQuery(event.target).parents('.author'));
                }else{
                    event.target.nextElementSibling.nextElementSibling.innerHTML = invalid_msg;
                }
            }else{
                if (this.isValidAuthor($author)){
                    var clone = $author.clone(true,true);
                    clone.find('input').each( function(index, element){ element.value = ""; } );
                    clone.find(".author-validation-message").html("");
                    $author.after(clone);
                    this.markAllValid($author);
                }else{
                    $author.find(".author-validation-message").html(invalid_msg);
                }
            }
        },
        removeAuthor: function($author, event){
            var invalid_msg = "You must leave one remaining valid author. (First and last name required)";
            if ($author.hasOwnProperty('first_name')){
                var invalid_remove = pr.submissionModel.authors().every(function(auth){
                    if (auth === $author){ return true; }
                    return (auth.first_name.trim() === "" || auth.last_name.trim() === "");
                })
                if (invalid_remove){
                    event.target.nextElementSibling.innerHTML = invalid_msg;
                }else{
                    pr.author.markAllValid(jQuery(event.target).parents('.author'));
                    pr.submissionModel.authors.remove($author);
                }
            }else{
                var me = this,
                    $all_authors = $author.parent().children('.author'),
                    invalid_remove = $all_authors.toArray().every(function (el){
                        if (el === $author[0]){
                            return true;
                        }
                        return !me.isValidAuthor(jQuery(el));
                    });

                if (invalid_remove){
                    $author.find(".author-validation-message").html(invalid_msg);
                }else{
                    $author.remove();
                    this.markAllValid($author);
                }
            }
        },
        isValidAuthor: function ($author) {
            if ($author.hasOwnProperty('first_name')){
                return !($author.first_name.trim() === "" || $author.last_name.trim() === "")
            }
            var $author_inputs = $author.find('input');
            return $author_inputs.toArray().every(function (el) {
                var nameType = el.dataset.nameType;
                return !((nameType === 'first' || nameType === 'last') && el.value.trim() === '')
            })
        },
        markAllValid: function ($author) {
            var me = this;
            $author.parent().children('.author').each(function(i, el){ me.markValid(jQuery(el)); })
        },
        markValid: function ($author){ $author.find('.author-validation-message').html(""); },
        validateAuthor: function ($author) {
            if (this.isValidAuthor($author)){
                this.markValid($author);
            }
        }
    }


}
//initialize Phyloregnum object
//with pr shortcut
var pr = new Phyloregnum()




//functions for Jquery Namespace

//returns link to outlink resource 
jQuery.outlinkBuilder = function(ofor,oid){
    var link = ''
    if(ofor !== '' && oid !== ''){

        switch(ofor){
            case 'treebase':                        // FIXME - proper link
                link = '<a class="outlink-link" href="http://purl.org/phylo/treebase/phylows/tree/TB2:'+oid+'">TreeBASE ID: <img class="outlink-arrow" src="/images/outlink-arrow.gif" /></a>'
                break;
            case 'ubio':
                link = '<a class="outlink-link" href="http://www.ubio.org/browser/details.php?namebankID='+oid+'">UBIO ID: <img class="outlink-arrow" src="/images/outlink-arrow.gif" /></a>'
                break;
            case 'ncbi':
                link = '<a class="outlink-link" href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id='+oid+'">NCBI ID: <img class="outlink-arrow" src="/images/outlink-arrow.gif" /></a>'
                break;
            case 'treebase_tree':
                link = '<a class="outlink-link" href="http://purl.org/phylo/treebase/phylows/tree/TB2:'+oid+'">TreeBASE Tree ID: <img class="outlink-arrow" src="/images/outlink-arrow.gif" /></a>'
                break;
            default:
                link = 'unknown'
                break;
        }
    }else{
        link = 'unknown'
    }
    return link
}
//
//
jQuery.citationType = function(type){
    var typeFor = (type === undefined || type === '') ? 'book' : type
    return typeFor + '_citation'
}
/*
*
*
*/
jQuery.showSpecifier = function(sfor,callback){


    var type_val = jQuery('#new_type').val(),
        exclude_apomorphy = [
            'minimum-clade_standard',
            'minimum-clade_directly_specified_ancestor',
            'maximum-clade_standard',
            'maximum-crown-clade',
            'minimum-crown-clade',
            'maximum-crown-clade',
            'maximum-total-clade',
            'crown-based_total_clade'],
        apomorphy_only = [
            'apomorphy-based_standard',
            'apomorphy-modified_crown_clade'
        ];

    function getTemplate(type){
        var template = pr.templates['species_specifier'];
        if (apomorphy_only.includes(type)){
            template = pr.templates['apomorphy_specifier'];
        }

        return template;
    }

    var template = getTemplate(type_val);
    // if (exclude_apomorphy.includes(type_val)){
    //     $type.children('#apomorphy-option').attr('disabled','disabled');
    // }
    // if (apomorphy_only.includes(type_val)){
    //     $type.children('#species-option').remove();
    //     $type.children('#specimen-option').remove();
    //     $type.trigger('change');
    // }



    //template
    if(sfor !== 'new'){
        var ty = sfor.specifier_type
        temp = pr.templates[ty +'_specifier']
    }
    var opts = {
        width: 550,
        title: 'Add Specifier',
        buttons: [
            { text: 'Save',
                click: function(){
                    jQuery.save_specifier()
                    jQuery.closeFloatWindow()
                }
            }]
    }
    //callback to setup observers
    var cback = function(){
        jQuery('#window-for-text').html((sfor == 'new' ? 'New' : 'Edit') + ' Specifier/Qualifier')
        var temp = ''
        if(sfor == 'new'){
            temp = getTemplate(jQuery('#new_type').val());
        }else{
            var ind = pr.submissionModel.specifiers.indexOf(sfor)
            //jQuery.specifierType(data[parseInt(sfor)].type)
            jQuery('#specifier_table_entry_id').val(ind)
            jQuery.each(sfor,function(ind,obj){
                jQuery('#new_'+ind).val(obj)
            })
            if(pr.submissionModel.specifiers()[ind]['attachment_path'] !== undefined ){
                var id = pr.submissionModel.specifiers()[ind]['attachment_id']
                jQuery('#specifier-attachment-cell').html('<a href="'+pr.submissionModel.specifiers()[ind]['attachment_path']+'">View</a>&nbsp;|&nbsp;<a class="specifier" href="/my_submission/remove_attachment/'+id+'">Remove</a>')
            }else{
                jQuery('#specifier-attachment-cell').html(pr.emptyAttachmentFile)
            }
        }

        var $type = jQuery('#new_specifier_type')
        if (exclude_apomorphy.includes(type_val)){
            $type.children('#apomorphy-option').attr('disabled','disabled');
        }
        if (apomorphy_only.includes(type_val)){
            $type.children('#species-option').remove();
            $type.children('#specimen-option').remove();
        }
    }
    //

    jQuery.openFloatWindow(template, opts, cback)//.show().sizeWindow()
    //
    if(callback != undefined){
        callback()
    }
}
//
jQuery.showCitation = function(cobj,cfor,callback){
    if(typeof(cobj) == 'undefined'){
        cobj = pr.emptyCitationObj
    }
    var cback = function(){
        jQuery('#new_citation_for').val(cfor)

        jQuery.loadFloatWindowForm(cobj)
        if(cfor === 'phylogeny'){
            if(cobj === 'new'){
                jQuery('#phylogeny_table_citation_id').val('new')
            }else{

                jQuery('#phylogeny_table_citation_id').val(pr.submissionModel.citations.phylogeny.indexOf(cobj).toString())
            }
        }
        if(cobj['attachment_path'] !== undefined ){
            var id = cobj['attachment_id']
            jQuery('#citation-attachment-cell').html('<a href="'+cobj['attachment_path']+'">View</a>&nbsp;|&nbsp;<a class="citation" href="/my_submission/remove_attachment/'+id+'">Remove</a>')
        }else{
            jQuery('#citation-attachment-cell').html(pr.emptyAttachmentFile)
        }

        if(cfor !== "primary-phylogeny"){
            jQuery(".primary_only").remove();
        }
// debugger;
        ko.applyBindings(pr.submissionModel.citations[cfor]()[0], document.getElementById('float-window-content-holder'))
    }
    ///{
    var opts = {width: 630, title: 'Add/Edit Reference', buttons: [
            { text: 'Save',
                click: function(){
                    jQuery.save_citation()
                    jQuery.closeFloatWindow()
                }
            }
        ]}
    ///
    var type = cobj.citation_type


    jQuery.openFloatWindow(pr.templates[jQuery.citationType(type)],opts,cback)//.show()//.sizeWindow()
    //execute callback if provided
    if(callback != undefined){
        callback()
    }
}


/*
*
*
*
*
*
* $.loadSubmission ( id=Submission ID)
* */

//
//new cladename Save or Submit


////////////////////////////////////////////////////////////////////////////////////
//MAIN WATCHES   - In order of appearance on new submission
jQuery(document).ready(function(){

    jQuery('#modal-message-window').dialog({modal: true, width: 300, height: 200})

    jQuery.each(pr.templatesToLoad,function(key){
        jQuery.get('/templates/load?template='+pr.templatesToLoad[key],function(response){
            pr.templates[pr.templatesToLoad[key]] = response
        })
    })
////////////////////////////actions executed on page load///////////////////////////
    /* Execute on page load */

    var pathArray = window.location.pathname.split('/')
    var id = pathArray[pathArray.length-1]
    //load submission if id given in url(restful url)
    if(!isNaN(id)){
        pr.loadSubmission(id)
    }

//////////////////////////////setup jquery observers////////////////////////////////

    //Author controls clicks

    jQuery('.author-controls a').click(function(event){
        debugger;
        event.preventDefault();
        var target = event.target,
            $author = jQuery(target).parents('.author');

        switch (event.target.className){
            case "add-another-author":
                pr.author.addAuthor($author);
                break;
            case "remove-author":
                pr.author.removeAuthor($author);
                break;
        }
    })

    //Author textbox changes
    jQuery('.author-first-name, .author-last-name').on('keyup change', function(){
        pr.author.validateAuthor(jQuery(this).parents('.author'));
    })




    //new cladename tabs click
    jQuery('#new-cladename-tabs>li.tab').click(function(target){
        //make all tabs active and hide all divs
        jQuery('#new-cladename-tabs>li.tab').css({'background-color': '#ffe8ac', 'border-bottom': '1px solid #777'})
        jQuery('#new-cladename-content>div[id!="save-and-reference"]').css({'display':'none'});
        //show selected tab and div
        jQuery('#'+target.target.id + '-div').css({'display':'block'});
        jQuery('#'+target.target.id).css({'background-color': '#FFFAE1', 'border-bottom': '1px solid #FFFAE1'});
        //build reference string on tab click
        // jQuery.makeReference()
        pr.save_submission()
    })
    //action for save and submit buttons
    jQuery('#new-cladename-save-submit input[type="button"]').click(function(target){
        if(target.target.value === 'Submit'){
            if(confirm('You will no longer be able to edit this submission once\n it is submitted. Are you sure you want to submit?')){
                pr.save_submission(target.target.value)
                //jQuery.makeReference()
            }
        }else{
            pr.save_submission(target.target.value)
            //jQuery.makeReference()
        }
    })

    jQuery('#character-window-button').click(function(event){
        jQuery.loadCharacterWindow(pr.templates['special_characters'])
        jQuery.openCharacterWindow({},function(){
            jQuery('#special-characters-window .character-button').button()
            jQuery('#special-characters-window .button').button()
        })
    })
    //status change list

    /*CLADE NAME TAB*/
    //name box synonym search
    jQuery('#new_name').keyup(function(event){
        var name = event.target.value //jQuery('#new_name').val()
        var out = ''
        if(name.length >= 1 ){
            jQuery.post('/name/'+name, function(response){
                if(response.length < 1){
                    out = '<span style="color:darkgreen">Valid name</span>'
                    jQuery('#new-establish-box').removeClass('disabled')
                    jQuery('#new_establish').removeAttr('disabled')
                }else{
                    //when name(s) exists

                    out = '<a id="synonyms-link" href="" >View Synonyms</a>'
                    var text = '<table id="synonyms-table">'
                    text += '<tr><th>Name</th><th>Authors</th><th>Established?</th></tr>'
                    jQuery.each(response, function(ind,obj){
                        text += '<tr><td>'+obj.submission.name+'</td><td>'+obj.submission.authors+'</td><td>'
                        text += (obj.submission.established === null || obj.submission.established === false ? 'No' : 'Yes') +'</td></tr>'
                        //only if name is established
                        if(obj.submission.established === true){
                            jQuery('#new-establish-box').addClass('disabled')
                            jQuery('#new_establish').attr('disabled','true').attr('checked', false)
                        }
                    })
                    text += '</table>'
                    jQuery('#synonyms-window-content').html(text)
                }
                jQuery('#status').html(out)

            },'json')
        }

    })

    //view synonyms link
    jQuery('#status').click(function(event){
        event.preventDefault()
        if(event.target.id === 'synonyms-link'){
            jQuery('#new-cladename-synonyms').show()
        }
    })



    /*CLADE TYPE & SPECIFIERS TAB*/
    jQuery('#new_type').on('change', function(){
        var type = this.value;
        jQuery('#definition_type_definitions').children('p').hide();
        jQuery('#' + type + '_def').show();
    })

    //on citation save button

    /*DEFINITION TAB*/


    //outlink modal windows

    //filter clicks on specifier resource list
    jQuery('#specifier-resource-list').click(function(event){
        if(event.target.tagName.toLowerCase() === 'tr'  || event.target.tagName.toLowerCase() === 'td'){
            var res = jQuery('input#dialog_resource').val()
            var value = jQuery(event.target).parentsUntil('tbody','tr')[0].id
            jQuery('#new_'+res+'_id').val(value)
            jQuery('#modal-window').dialog("destroy")
            jQuery('#specifier-resource-list').html('<img src="/images/ajax-loader.gif" />')
            var link = jQuery.outlinkBuilder(res,value)
            jQuery('#'+res+'_id_link').html(link)
        }
        if(event.target.classList.contains('expander')){
            jQuery(event.target).parents('tr').next('tr').toggle()
        }
    })
    //
    jQuery('#dialog-search-button').click(function(event){
        event.preventDefault()
        var res =  jQuery('#dialog_resource').val()
        var search = jQuery('#dialog_search').val()
        jQuery('#specifier-resource-list').loadSearchDialog(res,search)
    })

})