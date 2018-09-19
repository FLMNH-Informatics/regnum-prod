//define phyloregnum object/namespace
// 
function Phyloregnum(){
    var self = this

    this.objIsEmpty = function(obj){ return Object.keys(obj).length === 0 && obj.constructor === Object }

    this.makeAuthor = function(author){
        author = author || {};
        return {
            'first_name': ko.observable(author.first_name || ''),
            'middle_name': ko.observable(author.middle_name || ''),
            'last_name': ko.observable(author.last_name || '')
        }
    }

    this.makeAuthors = function(authors){
        if (!authors) console.log('authors is false: create_cladename.js line 18')
        authors = authors || [{}];
        var observableAuthors = authors.map(this.makeAuthor);
        var observableArray = ko.observableArray(observableAuthors);
        return observableArray;
    }

    this.makeCitation = function(citation){
        citation = citation || {};
        var ko_cit = {
            'citation_type': ko.observable(citation.citation_type || 'book'),
            'authors': pr.makeAuthors(citation.authors),
            'editors': pr.makeAuthors(citation.editors),
            'series_editors': pr.makeAuthors(citation.series_editors),
            'title': ko.observable(citation.title || ''),
            'publisher': citation.publisher || '',
            'figure': citation.figure || '',
            'year': ko.observable(citation.year || ''),
            'edition': citation.edition || '',
            'number': citation.number || '',
            'journal': citation.journal || '',
            'city': citation.city || '',
            'volume': ko.observable(citation.volume || ''),
            'pages': ko.observable(citation.pages || ''),
            'keywords': citation.keywords || '',
            'isbn': citation.isbn || '',
            'doi': citation.doi || '',
            'url': citation.url || ''
        }
        ko_cit.displayAuths = ko.pureComputed(self.displayAuthors, ko_cit);
        return ko_cit;
    };

    this.makeCitations = function(citations){
        if (!citations) console.log('citations is false/empty')
        citations = citations || [{}]
        var observableCitations = citations.map(this.makeCitation);
        var observableArray = ko.observableArray(observableCitations);
        return observableArray;
    }

    this.displayAuthors = function(){
        var auths = this.authors();

        switch (auths.length){
            case 0:     return "";                                             break;
            case 1:     return pr.author.initialize(auths[0]);                 break;
            case 2:     return auths.map(pr.author.initialize).join(" & ");    break;
        }
        if (auths.length <= 7){
            return auths
                .slice(0, auths.length - 1)
                .map(pr.author.initialize)
                .join(', ') + " & " + pr.author.initialize(auths[auths.length - 1]);
        }
        return auths
            .slice(0, 6)
            .map(pr.author.initailize)
            .join(', ') + "... " + pr.author.initialize(auths[auths.length - 1]);
    }

    this.getEmptyCitation = function(){
        return {
            'citation_type': ko.observable('book'),
            'authors': ko.observableArray([self.makeAuthor()]),
            'editors': ko.observableArray([self.makeAuthor()]),
            'series_editors': ko.observableArray([self.makeAuthor()]),
            'title': '',
            'publisher': '',
            'figure': '',
            'year': '',
            'edition': '',
            'number': '',
            'journal': '',
            'city': '',
            'volume': '',
            'pages': '',
            'keywords': '',
            'isbn': '',
            'doi': '',
            'url': ''
        }
    }

    this.submissionModel = {
        // 'authors': self.makeAuthors([{}]),
        displayAuths: ko.pureComputed(self.displayAuthors, this)
    }

    this.ko = {
        //json response loading map for ko.mapping
        mapping:  {
            'authors': {
                create: function(options){
                    if ( options.data && !self.objIsEmpty(options.data) ){
                        return pr.makeAuthor(options.data);
                    }
                    return self.makeAuthor()
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
                                item['specifier_kind_type']='';
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
                    //existing ones will overwrite these
                    var citations = options.data;
                    var citationsViewModel = {
                        //can have multpile citations
                        'phylogeny': self.makeCitations(citations.phylogeny).extend({paging: 5}),
                        'description': self.makeCitations(citations.description),
                        //have only one citation
                        'primary_phylogeny': self.makeCitation(citations.primary_phylogeny),
                        'preexisting': self.makeCitation(citations.preexisting)
                    }
                    //now load existing ones from response into citationsViewModel hash
                    // jQuery.each(options.data, function(key,val) {
                    //     if (val != undefined) {
                    //         switch (key) {
                    //             case 'phylogeny':
                    //             case 'description':
                    //                 //these can have multiple citations
                    //                 var citations = Array.isArray(val) ? val : self.ko.objToArray(val);
                    //                 citationsViewModel[key] = (key === 'phylogeny') ?
                    //                     ko.observableArray(citations).extend({paging: 5}) : ko.observableArray(citations);
                    //                 citations.forEach(function (citation, i) {
                    //                     citationsViewModel[key]()[i].authors = pr.makeAuthors(citation.authors)
                    //                     citationsViewModel[key]()[i].editors = pr.makeAuthors(citation.editors)
                    //                     citationsViewModel[key]()[i].series_editors = pr.makeAuthors(citation.series_editors)
                    //                 });
                    //                 break;
                    //             case 'primary_phylogeny':
                    //             case 'preexisting':
                    //                 //these only have one citation
                    //                 citationsViewModel[key] = val;
                    //                 citationsViewModel[key].authors = pr.makeAuthors(val.authors); //ko.observableArray(val.authors);
                    //                 citationsViewModel[key].editors = pr.makeAuthors(val.editors); //ko.observableArray(val.editors);
                    //                 citationsViewModel[key].series_editors = pr.makeAuthors(val.series_editors); //ko.observableArray(val.editors);
                    //                 break;
                    //         }
                    //         citationsViewModel[key].citation_type = ko.observable(val.citation_type || '');
                    //         citationsViewModel[key].displayAuths = ko.pureComputed(self.displayAuthors, citationsViewModel[key]);
                    //     }
                    // })
                    return citationsViewModel;
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
        'citation',
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
return "def here";
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
        var submission = options.parent
        var str = submission.name()  + ' '
        var citations = submission.citations
        if(submission.preexisting()){
            str += citations.preexisting.displayAuths()
            if (citations.preexisting.year().trim().length > 0)     str += ' ' + citations.preexisting.year() //(isUndefined(citations.preexisting['year']) == '' ? '' : citations.preexisting['year'] + ': ') //isUndefined(cit.preexisting['year']) + ': '
            if (citations.preexisting.volume().trim().length > 0)   str += ' ' + citations.preexisting.volume()//(isUndefined(citations.preexisting['volume']) == '' ? '' : ('(Vol. ' + citations.preexisting['volume'] + ')' + ': ') )
            if (citations.preexisting.pages().trim().length > 0)    str += ' ' + citations.preexisting.pages()//(isUndefined(citations.preexisting['pages']) == '' ? '' : citations.preexisting['pages'])
            // todo: str += ' [' + submission.authors() + ']'
            str += ', converted clade name'
        }else{
            str += submission.displayAuths()
            if(typeof(citations.description()[0]) == 'object'){
                if (citations.phylogeny.year().trim().length > 0)   str += ' ' + citations.phylogeny.year()//(isUndefined(citations.description()[0]['year']) == '' ? '' : cit.description()[0]['year'] + ': ' )//isUndefined(cit.description['year']) + ': '
                if (citations.phylogeny.volume().trim().length > 0) str += ' ' + citations.phylogeny.volume()//(isUndefined(citations.description()[0]['volume']) == '' ? '' : ('(Vol. ' + cit.description()[0]['volume'] + ')' + ': ') ) //formatVolume(cit.description['volume']) + isUndefined(cit.description['pages'])
                if (citations.phylogeny.pages().trim().length > 0)  str += ' ' + citations.phylogeny.pages()//(isUndefined(citations.description()[0]['pages']) == '' ? '' : cit.description()[0]['pages'])
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

        var data = ko.mapping.toJSON(self.submissionModel);

        return jQuery.ajax({
            type: 'POST',
            url: '/save',
            dataType: 'json',
            contentType: 'application/json',
            data: data,
            success: function(response) {
                if (subid === 'new') { document.location.href = '/my_submission/' + response.submission_id }
                else { jQuery('#submission_id').val(response.submission_id) }
            }
        }).done(function(){
            if (action === 'Submit')
                document.location.href = '/my_submission'
            jQuery('#spinner').hide()
            // var ko_node = document.getElementById('new-cladename-content');
            // ko.cleanNode(ko_node)
            // ko.applyBindings(pr.submissionModel, ko_node);
        });
    }

    //load submission data for complete page loads
    //passing in submission id
    this.loadSubmission = function(id){
        jQuery('#submission_id').val(id)
        jQuery.getJSON('/my_submission/'+id,function(response){
            var submission = response.submission ? response.submission : response;

            submission.submission_id = id
            //set save action
            submission.subaction = ''
            ///ko key mapping
            pr.submissionModel.displayAuths = ko.pureComputed(self.displayAuthors, pr.submissionModel);
            pr.submissionModel = ko.mapping.fromJS(submission, pr.ko.mapping, pr.submissionModel);
            if (pr.submissionModel.authors().length === 0) pr.submissionModel.authors.push(self.makeAuthor());

            jQuery.each(pr.submissionModel, function(k,v){
                if((typeof(v)=='function' && v()=='null')||v==null){
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
        addAuthor: function(author_type, author, event){
            var invalid_msg = "Please enter a first name and last name before adding an additional.";
            if (pr.author.isValidAuthor(author)){
                this[author_type].push(self.makeAuthor());
                pr.author.markAllValid(jQuery(event.target).parents('.author'));
            }else{
                event.target.nextElementSibling.nextElementSibling.innerHTML = invalid_msg;
            }
        },
        removeAuthor: function(author_type, author, event){
            if (author_type == "author"){
                var invalid_msg = "You must leave one remaining valid author. (First and last name required)";
                var invalid_remove = pr.submissionModel.authors().every(function(existing_author){
                    if (existing_author === author){ return true; }
                    return (existing_author.first_name.trim() === "" || existing_author.last_name.trim() === "");
                })
                if (invalid_remove){
                    event.target.nextElementSibling.innerHTML = invalid_msg;
                }else{
                    pr.author.markAllValid(jQuery(event.target).parents('.author'));
                    this.authors.remove(author);
                }
            }else{
                this[author_type].remove(author);
                if (this[author_type]().length === 0)
                    this[author_type].push(self.makeAuthor());
            }

        },
        isValidAuthor: function ($author) {
            if ($author.hasOwnProperty('first_name')){
                return !($author.first_name().trim() === "" || $author.last_name().trim() === "")
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
        },
        initialize: function(author){
            var out = "";
            if (author.last_name().trim().length === 0){
                out += "Please update to include last name for author. ";
            }else{
                out += author.last_name().trim() + ", ";
            }
            if (author.first_name().trim().length === 0){
                out += "Please update to include first name for author. "
                return out;
            }else{
                out += author.first_name().trim()[0] + ".";
            }
            if (author.middle_name() && author.middle_name().trim().length > 0)
                out += " " + author.middle_name().trim()[0] + ".";
            return out;
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
jQuery.showCitation = function(citation,cfor,callback){
    var modal_title = 'Update reference';
    if(typeof(citation) == 'undefined'){
        modal_title = 'Add reference'
        citation = pr.getEmptyCitation()
    }
    var cback = function(){
        var bindingElement = document.getElementById('float-window-content-holder');
        jQuery('#new_citation_for').val(cfor)

        jQuery.loadFloatWindowForm(citation)

        if(cfor === 'phylogeny'){
            if(citation === 'new'){
                jQuery('#phylogeny_table_citation_id').val('new')
                citation = pr.getEmptyCitation();
                pr.submissionModel.citations[cfor]().push(citation);
            }else{
                jQuery('#phylogeny_table_citation_id').val(pr.submissionModel.citations.phylogeny.indexOf(citation).toString())
            }
        }

        if(citation['attachment_path'] !== undefined ){
            var id = citation['attachment_id']
            jQuery('#citation-attachment-cell').html('<a href="'+citation['attachment_path']+'">View</a>&nbsp;|&nbsp;<a class="citation" href="/my_submission/remove_attachment/'+id+'">Remove</a>')
        }else{
            jQuery('#citation-attachment-cell').html(pr.emptyAttachmentFile)
        }

        if(cfor !== "primary_phylogeny"){
            jQuery(".primary_only").remove();
        }
        ko.cleanNode(bindingElement);
        ko.applyBindings(citation, bindingElement)
    }

    switch (cfor){
        case 'phylogeny': modal_title += ' for additional reference phylogeny'; break;
        case 'description': modal_title += ' for description'; break;
        case 'primary_phylogeny': modal_title += ' for primary phylogeny'; break;
        case 'preexisting': modal_title += ' for pre-existing name'; break;
    }

    var opts = {width: 630, title: modal_title, buttons: [
            { text: 'Save',
                click: function(){
                    jQuery.save_citation()
                    jQuery.closeFloatWindow()
                }
            }
        ]}
    ///
    var type = citation.citation_type


    // jQuery.openFloatWindow(pr.templates[jQuery.citationType(type)],opts,cback)//.show()//.sizeWindow()
    jQuery.openFloatWindow(pr.templates['citation'],opts,cback)//.show()//.sizeWindow()
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
        pr.save_submission()
    })
    //action for save and submit buttons
    jQuery('#new-cladename-save-submit input[type="button"]').click(function(target){
        if(target.target.value === 'Submit'){
            if(confirm('You will no longer be able to edit this submission once\n it is submitted. Are you sure you want to submit?')){
                pr.save_submission(target.target.value)
            }
        }else{
            pr.save_submission(target.target.value)
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