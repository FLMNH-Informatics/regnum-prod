//define phyloregnum object/namespace
// 
function Phyloregnum(){
    var self = this;

    function Submission(submission) {
        function Submitter(user) {
            var self = this;
            self.fullname = user.first_name + ' ' + user.last_name;
            self.email = user.email;
        }

        var self = this;
        self.name = submission.name
        self.submitter = new Submitter(submission.user);
    }

    self.objIsEmpty = function(obj){ return Object.keys(obj).length === 0 && obj.constructor === Object }

    self.makeAuthor = function(author){
        author = author || {};
        return {
            'first_name': ko.observable(author.first_name || ''),
            'middle_name': ko.observable(author.middle_name || ''),
            'last_name': ko.observable(author.last_name || '')
        }
    }

    self.makeAuthors = function(authors){
        // if (!authors) console.log('authors is false: create_cladename.js line 18');
        authors = authors || [{}];
        var observableAuthors = authors.map(this.makeAuthor);
        var observableArray = ko.observableArray(observableAuthors);
        return observableArray;
    }

    self.makeSpecifier = function (specifier){
        if (typeof(specifier) === "string"){
            specifier = specifier === "new" ? {} : { specifier_type: specifier };
        }
        specifier = specifier || {};

        var ko_spec = {
            'specifier_type': ko.observable(specifier.specifier_type || 'species'),
            'authors': pr.makeAuthors(specifier.authors),
            'specifier_kind': ko.observable(specifier.specifier_kind || ''),
            'specifier_crown': ko.observable(specifier.specifier_crown || ''),
            'specifier_crown_link': ko.observable(self.crownSpecifierLink(specifier.specifier_crown) || ''),
            'specifier_crown_name': ko.observable(self.crownSpecifierName(specifier.specifier_crown) || ''),
            'specifier_character_name': ko.observable(specifier.specifier_character_name || ''),
            'specifier_character_description': ko.observable(specifier.specifier_character_definition || specifier.specifier_character_description || ''),
            'specifier_name': ko.observable(specifier.specifier_name || ''),
            'specifier_year': ko.observable(specifier.specifier_year || ''),
            'specifier_code': specifier.specifier_code || '',
            'specifier_url' : ko.observable(specifier.specifier_url || ''),
            'specimen_description': specifier.specimen_description || '',
            'collection_number': specifier.collection_number || '',
            'collectors': pr.makeAuthors(specifier.collectors),
            'ubio_id': specifier.ubio_id || '',
            'ncbi_id': specifier.ncbi_id || '',
            'treebase_id': specifier.treebase_id || ''
        };
        ko_spec.displayAuths = ko.pureComputed(self.displayAuthors, ko_spec);
        ko_spec.crownSpecifierLink = ko.pureComputed(self.crownSpecifierLink, ko_spec);
        return ko_spec;
    }

    self.makeSpecifiers = function (specifiers) {
        if (!specifiers) return ko.observableArray([])
        return ko.observableArray(specifiers.map(this.makeSpecifiers));
    }

    self.makeCitation = function(citation){
        citation = citation || {};
        var ko_cit = {
            'citation_type':    ko.observable(citation.citation_type || 'book'),
            'authors':          pr.makeAuthors(citation.authors),
            'editors':          pr.makeAuthors(citation.editors),
            'series_editors':   pr.makeAuthors(citation.series_editors),
            'title':            ko.observable(citation.title || ''),
            'section_title':    ko.observable(citation.section_title || ''),
            'publisher':        citation.publisher || '',
            'figure':           citation.figure || '',
            'year':             ko.observable(citation.year || ''),
            'edition':          citation.edition || '',
            'number':           citation.number || '',
            'journal':          citation.journal || '',
            'city':             citation.city || '',
            'volume':           ko.observable(citation.volume || ''),
            'pages':            ko.observable(citation.pages || ''),
            'keywords':         citation.keywords || '',
            'isbn':             citation.isbn || '',
            'doi':              citation.doi || '',
            'url':              citation.url || ''
        }
        ko_cit.displayAuths = ko.pureComputed(self.displayAuthors, ko_cit);
        return ko_cit;
    };

    self.makeCitations = function(citations){
        if (!citations) return ko.observableArray([]);
        return ko.observableArray(citations.map(this.makeCitation));
    }

    self.crownSpecifierLink = function(crownSpecifier){
        if (crownSpecifier === "" || crownSpecifier === undefined) return "";

        var specifier_submission_id = crownSpecifier.split("|regnum_id=")[1];
        return "/submissions/" + specifier_submission_id;
    }

    self.crownSpecifierName = function(crownSpecifier){
        if (crownSpecifier === "" || crownSpecifier === undefined) return "";

        var crownName = crownSpecifier.split("|regnum_id=")[0];
        return crownName;
    }


    self.displayAuthors = function(){
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
            .map(pr.author.initialize)
            .join(', ') + "... " + pr.author.initialize(auths[auths.length - 1]);
    }

    self.submissionModel = {
        checkSubmissionModel: {
            existingSubmissions: ko.observableArray([]),
            checkingName: ko.observable(false),
            nameUnique: ko.observable(true),
            checkName: function (newValue){
                var checkSubmissionModel = self.submissionModel.checkSubmissionModel;
                checkSubmissionModel.checkingName(true);
                jQuery.getJSON("/my_submission/check_name", { 'name': newValue, 'current_id': self.submissionModel.id() })
                    .done(function (data) {
                        if (data.length !== 0){
                            var existingSubmissions = jQuery.map(data, function(submission){
                                return new Submission(submission);
                            });
                            checkSubmissionModel.existingSubmissions(existingSubmissions);
                            checkSubmissionModel.nameUnique(false);
                            checkSubmissionModel.checkingName(false);
                            return;
                        }
                        checkSubmissionModel.existingSubmissions([]);
                        checkSubmissionModel.nameUnique(true);
                        checkSubmissionModel.checkingName(false);
                    });
            }
        }
    }

    self.isApomorphy = function(){
        return [ 'apomorphy-based_standard', 'apomorphy-modified_crown_clade' ].includes( self.submissionModel.clade_type() );
    }

    self.hasCrownSpecifier = function(){
        return self.submissionModel.specifiers().some(s =>
            s.specifier_type() === 'crown' && typeof(s.specifier_crown()) != 'undefined' && s.specifier_crown() !== '')
    }

    self.hasIncompleteCrownSpecifier = function(){
        return self.submissionModel.specifiers().some(s => s.specifier_type() == 'crown' && (typeof(s.specifier_crown()) == 'undefined' || s.specifier_crown() === '') );
    }

    self.isCrown = function(){
        var ct = self.submissionModel.clade_type();
        return ct == 'maximum-total-clade' || ct == 'crown-based_total_clade';
    }

    self.ko = {
        //json response loading map for ko.mapping
        mapping:  {
            ignore: ['displayAuths'],
            'authors': {
                ignore: ['displayAuths'],
                create: function(options){
                    if ( options.data && !self.objIsEmpty(options.data) ){
                        return pr.makeAuthor(options.data);
                    }
                    return self.makeAuthor()
                }
            },
            'specifiers': {
                create: function(options){
                    if ( options.data && !self.objIsEmpty(options.data) ){
                        return pr.makeSpecifier(options.data);
                    }
                    return self.makeSpecifier();
                }
            },
            'citations': {
                create: function(options){
                    var citations = options.data,
                        citationsViewModel = {
                            //can have multple citations
                            'phylogeny': self.makeCitations(citations.phylogeny).extend({paging: 5}),
                            'description': self.makeCitations(citations.description),
                            //have only one citation
                            'preexisting': citations.preexisting ? self.makeCitation(citations.preexisting) : ko.observable(),
                            'primary_phylogeny': citations.primary_phylogeny ? self.makeCitation(citations.primary_phylogeny) : ko.observable(),
                            'definitional': citations.definitional ? self.makeCitation(citations.definitional) : ko.observable()
                        };

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
                        var t = self.makeNameString(options)
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
    self.templates = {}
    self.templatesToLoad = [
        'citation',
        'specifier',
        'synonyms',
        'special_characters'
    ]


    self.emptyAttachmentFile = '<form id="remote-attachment-form"  enctype="multipart/form-data" action="/my_submission/add_attachment" method="post"><input type="file" id="new_remote_attachment" name="file" /></form>'

    //define button actions
    self.ba = {
        addCrownSpecifier: () => jQuery.showSpecifier('crown'),
        addApomorphySpecifier: () => jQuery.showSpecifier('apomorphy'),
        addSpecifier: () => jQuery.showSpecifier('new'),
        editSpecifier: function(specifier){
            jQuery.showSpecifier(specifier)
        },
        deleteSpecifier: function(specifier){
            if(confirm("Delete this specifier/qualifier?")){
                self.submissionModel.specifiers.remove(specifier)
                self.save_submission();
            }
        },
        addCitation: function(citation_for, obj, event){
            var citation = pr.makeCitation();
            switch (citation_for){
                case "phylogeny":
                case "description":
                    self.submissionModel.citations[citation_for].push(citation)
                    jQuery.showCitation(citation, citation_for, true)
                    break;
                default:
                    self.submissionModel.citations[citation_for](citation);
                    jQuery.showCitation(self.submissionModel.citations[citation_for]())
                    break;
            }
        },
        editCitation: function(citation_for, citation, event){
            jQuery.showCitation(citation, citation_for)
        },
        deleteCitation: function(citation_for,obj,event){
            if(confirm("Delete this citation?")){
                self.submissionModel.citations[citation_for].remove(obj)
                self.save_submission();
            }
        }
    }



    //build abbreviated symbolic clade definition
    self.makeDefinition = function(){
        var str = '',
            extstr = '',
            intstr = '',
            apostr = '',
            specifiers,
            internal = [], //not including apomorphs (they are always internal)
            external = [],
            crown = [],
            apomorph = [];

        jQuery.each(this.submissionModel.specifiers(), function(ind,obj){
            if(obj.specifier_type() === 'apomorphy') {
                apomorph.push(obj.specifier_character_name() + '(' + obj.specifier_name() + ')')
            }else if (obj.specifier_type() === 'crown'){
                crown.push("Crown specifier: " + obj.specifier_crown())
            }else{
                var kind = obj.specifier_kind() === undefined ? obj.kind() : obj.specifier_kind()
                switch(kind){
                    case 'internal extinct':
                    case 'internal extant':
                        internal.push(obj.specifier_name());
                        break;
                    case 'external extinct':
                    case 'external extant':
                        external.push(obj.specifier_name());
                        break;
                }
            }
        });


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
    self.makeNameString = function(options){
        var displayProp = function(val, prepend){
            prepend = prepend || ' ';
            if (val.trim().length > 0) return prepend + val;
            return '';
        },
            submission = options.parent,
            str = submission.name()  + ' ',
            citations = submission.citations;

        var preexisting;
        if (typeof(citations.preexisting) === 'function') {
            preexisting = citations.preexisting();
        } else if (typeof(citations.preexisting) === 'object'){
            preexisting = citations.preexisting;
        }

        if (submission.preexisting()){
            if (preexisting){
                str += preexisting.displayAuths()
                str += displayProp(preexisting.year())
            }else{
                str += ' **please add a preexisting citation** ';
            }
            str += " [" + submission.displayAuths() + "]";
            str += ', converted clade name.'
        }else{
            str += " [" + submission.displayAuths() + "]";
            var primary_phylogeny;
            if (typeof(citations.primary_phylogeny) === 'function') {
                primary_phylogeny = citations.primary_phylogeny();
            } else if (typeof(citations.primary_phylogeny) === 'object'){
                primary_phylogeny = citations.primary_phylogeny;
            }
            if(typeof(primary_phylogeny) === 'object'){
                str += displayProp(primary_phylogeny.year())
            }
            str += ', new clade name.'
        }

        return str
    }

    self.save_submission = function(action){
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
        
        var data = ko.mapping.toJSON(self.submissionModel, self.ko.mapping);

        return jQuery.ajax({
            type: 'POST',
            url: '/save',
            dataType: 'json',
            contentType: 'application/json',
            data: data,
            success: function(response) {
                if (subid === 'new') { document.location.href = '/my_submission/' + response.id }
                else {
                    //update specifiers if they were changed by rails
                    self.submissionModel.specifiers(response.specifiers.map(pr.makeSpecifier));
                    jQuery('#submission_id').val(response.id)

                }
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
    self.loadSubmission = function(id){
        jQuery('#submission_id').val(id)
        var location = "/" + document.location.pathname.slice(1).split("/")[0];
        jQuery.getJSON(location+ "/" + id, function(response){
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
            pr.submissionModel.name.subscribe(pr.submissionModel.checkSubmissionModel.checkName);
            pr.submissionModel.checkSubmissionModel.checkName(pr.submissionModel.name);
            ko.applyBindings(pr.submissionModel, document.getElementById('new-cladename-window'));
            jQuery.loadWidgets('#contents');
            jQuery('#modal-message-window').dialog('destroy');
        })
        return false
    }


    /*******************************
     * Author functions
     */



    self.author = {
        addAuthor: function(author_type, author, event){
            var invalid_msg = "Please enter a last name before adding additional " + author_type + ".";
            if (pr.author.isValidAuthor(author)){
                this[author_type].push(self.makeAuthor());
                pr.author.markAllValid(jQuery(event.target).parents('.author'));
            }else{
                event.target.nextElementSibling.nextElementSibling.innerHTML = invalid_msg;
            }
        },
        removeAuthor: function(author_type, author, event){
            if (author_type == "author"){
                var invalid_msg = "You must leave one remaining valid author. (Last name required)";
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
        isValidAuthor: function(author){
            return author.last_name().trim() !== ''; },
        isValidAuthorInput: function ($author) {
            var $author_inputs = $author.find('input');
            return $author_inputs.toArray().every(function (el) {
                var nameType = el.dataset.nameType;
                return !(nameType === 'last' && el.value.trim() === '')
            })
        },
        markAllValid: function ($author) {
            var me = this;
            $author.parent().children('.author').each(function(i, el){ me.markValid(jQuery(el)); })
        },
        markValid: function ($author){ $author.find('.author-validation-message').html(""); },
        validateAuthor: function ($author) {
            if (this.isValidAuthorInput($author)){
                this.markValid($author);
            }
        },
        initialize: function(author){
            var out = "";
            if (author.first_name().trim().length !== 0){
                out += author.first_name().trim()[0] + ". ";
            }
            if (author.middle_name() && author.middle_name().trim().length > 0)
                out += author.middle_name().trim()[0] + ". ";
            if (author.last_name().trim().length === 0){
                out += "Please update to include last name for author. ";
                return out;
            }else{
                out += author.last_name().trim();
            }

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
jQuery.showSpecifier = function(specifier, callback){
    var modalTitle = 'Edit specifier',
        exists = typeof(specifier) === 'object';

    if (!exists){
        modalTitle = "Add specifier";
        specifier = pr.makeSpecifier(specifier);
        pr.submissionModel.specifiers.push(specifier);
    }else{
        specifier = specifier;
    }

    //callback to setup observers
    var cback = function(){
        var bindingElement = document.getElementById('float-window-content-holder');

        if(exists){
            var ind = pr.submissionModel.specifiers.indexOf(specifier);
            jQuery('#specifier_table_entry_id').val(ind);
            jQuery('#new_specifier_type_container').hide();
        } else{
            if (specifier != 'new'){
                jQuery('#new_specifier_type').val(specifier)
            }
        }

        ko.cleanNode(bindingElement);
        ko.applyBindings(specifier, bindingElement);
    }

    var opts = {
        width: 550,
        title: modalTitle,
        buttons: [
            { text: 'Save',
                click: function(){
                    //in float_window_actions.js
                    //todo: handle attachments via some appropriate mechanism
                    jQuery.save_specifier()
                    jQuery.closeFloatWindow()
                }
            }]
    }

    jQuery.openFloatWindow(pr.templates['specifier'], opts, cback)//.show().sizeWindow()
    //
    if(callback != undefined){
        callback()
    }
}
//
jQuery.showCitation = function(citation, citation_for, is_new){
    var modal_title = (is_new ? 'Add' : 'Update') + ' reference',
        callback = function() {
            var bindingElement = document.getElementById('float-window-content-holder');
            jQuery('#new_citation_for').val(citation_for)

            jQuery.loadFloatWindowForm(citation)

            if(citation['attachment_path'] !== undefined ){
                var id = citation['attachment_id']
                jQuery('#citation-attachment-cell').html('<a href="'+citation['attachment_path']+'">View</a>&nbsp;|&nbsp;<a class="citation" href="/my_submission/remove_attachment/'+id+'">Remove</a>')
            }else{
                jQuery('#citation-attachment-cell').html(pr.emptyAttachmentFile)
            }
            ko.cleanNode(bindingElement);
            ko.applyBindings(citation, bindingElement)
    }

    switch (citation_for){
        case 'phylogeny': modal_title += ' for additional reference phylogeny'; break;
        case 'description': modal_title += ' for description'; break;
        case 'primary_phylogeny': modal_title += ' for primary phylogeny'; break;
        case 'preexisting': modal_title += ' for pre-existing name'; break;
        case 'definitional': modal_title += ' for definition'; break;
    }

    var opts = {
        width: 630,
        title: modal_title,
        buttons: [
            {
                text: 'Save',
                click: function(){
                    jQuery.save_citation()
                    jQuery.closeFloatWindow()
                }
            }
        ]};

    jQuery.openFloatWindow(pr.templates['citation'], opts, callback);
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
    });

    var id = jQuery("#submission_id").val();
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
        if(target.target.value === 'Submit for review'){
            if(confirm('You will no longer be able to edit this submission once\n it is submitted. Are you sure you want to submit?')){
                pr.save_submission("Submit")
            }
        }else{
            pr.save_submission("Save")
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

    //view synonyms link
    jQuery('#status').click(function(event){
        event.preventDefault()
        if(event.target.id === 'synonyms-link'){
            jQuery('#new-cladename-synonyms').show()
        }
    })



    /*CLADE TYPE & SPECIFIERS TAB*/

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
