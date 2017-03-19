
function updateId(element, term){
    $(element.readAttribute("data-input")).value = term.readAttribute("data-id")
}
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
/*
var elementID = "";
function myPopupRelocate(){
  var scrolledX, scrolledY;
  if (self.pageYOffset) {
    scrolledX = self.pageXOffset;
    scrolledY = self.pageYOffset;
  }
  else
    if (document.documentElement && document.documentElement.scrollTop) {
      scrolledX = document.documentElement.scrollLeft;
      scrolledY = document.documentElement.scrollTop;
    }
  else
    if (document.body) {
      scrolledX = document.body.scrollLeft;
      scrolledY = document.body.scrollTop;
    }

  var centerX, centerY;
  if (self.innerHeight) {
    centerX = self.innerWidth;
    centerY = self.innerHeight;
  }
  else
    if (document.documentElement && document.documentElement.clientHeight) {
      centerX = document.documentElement.clientWidth;
      centerY = document.documentElement.clientHeight;
    }
  else
    if (document.body) {
      centerX = document.body.clientWidth;
      centerY = document.body.clientHeight;
    }
  topleft(scrolledX, scrolledY, centerX, centerY);
}

function topleft(scrolledX, scrolledY, centerX, centerY){
  var X = 350;
  var Y = 300
  if (elementID == "newformdiv" || elementID == "div_coll") {
    X = X - 700;
    Y = Y - 50
  }

  var leftOffset = scrolledX + (centerX - X) / 2;
  var topOffset = scrolledY + (centerY - Y) / 2;

  document.getElementById(elementID).style.top = topOffset + "px";
  document.getElementById(elementID).style.left = leftOffset + "px";
}

window.onload = function(){
  if($('div_citation').style.display=='block')
    positionWindow('div_citation');
  if($('div_new_citation').style.display=='block')
    positionWindow('div_new_citation');
}
function cit_det(citation_id){
  onClick = $('div_citation').show();
  elementID = "div_citation";
  new Ajax.Updater({
    success: 'div_citation',
    failure: 'div_citation'
  }, '/citations/' + citation_id, {
    asynchronous: true,
    evalScripts: true,
    method: 'get',
    parameters: {
      ajax: true
    }
  });
  myPopupRelocate();
  document.getElementById("div_citation").style.display = "block";
  document.body.onscroll = myPopupRelocate;
}

function create_citation(a){

    new Ajax.Updater({ success: 'div_create_new_citation', failure: 'div_create_new_citation' }, '/citations/new', {method:'get',
      parameters: { citation_type: a }
    });

}

function show_div_new_citation(){
  onClick = $('div_new_citation').show();
  elementID = "div_new_citation";
  myPopupRelocate();
  document.getElementById("div_new_citation").style.display = "block";
  document.body.onscroll = myPopupRelocate;
}
function oBM(url) {
  testwindow = window.open("/tags/new?" + url, "mywindow", "scrollbars=1,width=500,height=200");
  if (window.screen) {
    var aw = screen.availWidth;
    var ah = screen.availHeight;
    testwindow.moveTo(aw / 2, ah / 2);
  }
}

function checkForCheckedItems() {
  var sel_list_items = $('sel_list').select('input[name=\"sel_items[]\"]');
  if(sel_list_items.size() > 0) {
    sel_list_items.each(function(element) {
      if($('item_select_'+element.value) != null) {
        $('item_select_'+element.value).checked = true;
        add_selected_class($('list_item_'+element.value));
      }
    });
  }
}

Function.prototype.sleep = function (millisecond_delay) {
	if(window.sleep_delay != undefined) clearTimeout(window.sleep_delay);
	var function_object = this;
	window.sleep_delay = setTimeout(function_object, millisecond_delay);
};

function keyCode(chrStr) {
  var chrCode = chrStr.charCodeAt(0);
  if(chrCode >= 65 && chrCode < 91) {
    return chrCode
  } else if(chrCode >= 97 && chrCode < 123) {
    return chrCode - 32;
  }
}



 function tabstatus(a,b){

      $('l1').className = 'top_tab1 active';
      $('l2').className = 'top_tab1 active';
      $('l3').className = 'top_tab1 active';
      $('l4').className = 'top_tab1 active';
      $(a).className = 'top_tab1 current';

      $('1').style.display='none';
      $('2').style.display='none';
      $('3').style.display='none';
      $('4').style.display='none';
      $(b).style.display='block';


    }
 

function ubio_search(field_name,operation_name){
    var ubio = $('ubio_popup');
    ubio.update("<p>Searching <img src='/images/ubioLogo.png'></p><img class='hourglass' src='/images/hourglass.gif'>");
    ubio.show();
    new Ajax.Updater(
     ubio,
     '/cladename/ubio_search/', {
    asynchronous: true,
    evalScripts: true,
    method: 'get',
    parameters: {
      name: $(field_name).value,
      caller:operation_name
    }
  });
  }

  function ncbi_search(field_name,operation_name){
      var ncbi = $('ncbi_popup');
      ncbi.update("<p>Searching <img src='/images/ncbiLogo.GIF'></p><img class='hourglass' src='/images/hourglass.gif'>");
      ncbi.show();
    new Ajax.Updater(
        ncbi,
        '/cladename/ncbi_search/', {
    asynchronous: true,
    evalScripts: true,
    method: 'get',
    parameters: {
      name: $(field_name).value,
      caller:operation_name
    }
  });
  }

  function treebase_search(field_name,operation_name){
      var treebase = $('treebase_popup');
      treebase.update("<p>Searching TreeBASE <img src='/images/treebase.gif'></p><img class='hourglass' src='/images/hourglass.gif'>");
      treebase.show();
    new Ajax.Updater(
        treebase,
        '/cladename/treebase_search/', {
    asynchronous: true,
    evalScripts: true,
    method: 'get',
    parameters: {
      name: $(field_name).value,
      caller:operation_name
    }
  });
  }

  function ubio_id_desc(id,retun_div,operation_name,header_flag){
      
      new Ajax.Updater({
    success: retun_div,
    failure: retun_div
  }, '/cladename/ubio_namebank_search', {
    asynchronous: true,
    evalScripts: true,
    method: 'get',
    parameters: {
      id: id,
      header:header_flag,
      caller:operation_name
    }
  });
  }

  function ncbi_id_desc(id,retun_textbox){
     $('ncbi_url').setAttribute('href','http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=Info&id='+id)
     $(retun_textbox).value = id;
  }

  function search_ubio(search_text ){
      new Ajax.Updater({
    success: 'menulist1',
    failure: 'ubio_popup'
  }, '/cladename/ubio_namebank_id_import', {
    asynchronous: true,
    evalScripts: true,
    method: 'post',
    parameters: {
        name_string:$('name_string').value,
        ubio_id:$('name_bank_id').value,
        citation_xml:$('citation_xml').value,
        full_name_string:$('full_name_string').value,
        caller:operation_name
    }
  });
  }

  function set_ubio_id(id,retun_textbox){
    $(retun_textbox).value = id;
  }

  function set_treebase_id(id,retun_textbox){
    $('treebase_url').setAttribute('href','http://treebase.nescent.org/treebase-web/search/taxonSearch.html?query=tb.identifier.tree='+id)
    $(retun_textbox).value = id;
  }


  function set_textfiled(namebankid,namestring,operation_name)
  {
//     $('searchbox').value = namestring;
     new Ajax.Request( '/cladename/ubio_namebank_id_import', {
      asynchronous: true,
      requestHeaders: { Accept: 'application/json' },
      method: 'post',
      parameters: {
          name_string:$('name_string').value,
          ubio_id:$('name_bank_id').value,
          citation_xml:$('citation_xml').value,
          full_name_string:$('full_name_string').value,
          caller:operation_name
       },
     onSuccess: function(transport) {
       //$('species_name').value = transport.responseJSON.species_name;
       $('author').value = transport.responseJSON.author;
       $('ubio').value = transport.responseJSON.ubio_id;
     }
     });

  }

  function search_query(){
             new Ajax.Updater({
    success: 'search',
    failure: 'search'
  }, '/search/search.js', {
    asynchronous: true,
    evalScripts: true,
    method: 'post',
    parameters: {
        name:$('searchbox').value      
    }
  });
  }


  function warn()
  {
     return false;
  }


  function remove_user(a)
  {
  }


  function delete_record(path){
    new Ajax.Request(path, {
      method: 'delete',
     onSuccess: function(response) {
     }
  });
  }

  function outlink_ncbi(id){
    window.open('http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=Info&id='+id);
  }

  function outlink_ubio(id){
    window.open('http://www.ubio.org/browser/details.php?namebankID='+id);
  }

  function outlink_treebase(id){
    window.open('http://treebase.nescent.org/treebase-web/search/taxonSearch.html?query=tb.identifier.tree='+id);
  }

  function phenoscape(query){


   new Ajax.Updater({
    success: 'ubio_popup',
    failure: 'ubio_popup'
  }, '/my_submission/cladename/pheno_search.js', {
    asynchronous: true,
    evalScripts: true,
    method: 'get',
    parameters: {
        search_term : query
    }
  });
    
//    if (query && query.length > 0){
//      window.open('http://www.phenoregnum.org/characters?query='+query);
//    }
  }

  function pheno_entity(id){
    new Ajax.Updater({
    success: 'ubio_popup',
    failure: 'ubio_popup'
  }, '/my_submission/cladename/pheno_entity.js', {
    asynchronous: true,
    evalScripts: true,
    method: 'get',
    parameters: {
        character_id : id
    }
  });
  }

  function update_char(value){
    $('pheno_entity').value = value
  }

  function specimen_select(id,token){
    if( $('idvalue').value !=''){
        var a1;
        if($('otherspan') != null && $('otherspan').style.display == 'block'){
            a1 =' specimen '+ $('source').options[$('source').selectedIndex].value +' '+ $('idvalue').value+','+$('other').value;
        }else{
            a1 =' specimen '+ $('source').options[$('source').selectedIndex].value +' '+ $('idvalue').value;
        }
        new Ajax.Updater('specimen_table', '/cladename/display_speciesrow',
            { asynchronous:true,
                evalScripts:true,
                insertion:'bottom',
                onSuccess:function(request){
                    $('speciesdiv').style.display='none';
                },
                parameters:"id="+id+a1+ '&authenticity_token='+token
            });
            return false;
        }else{
            alert('Choose status to Select this Specimen Name')
        }
  }

 function species_select(id,token){
   if( $('idvalue').value !='')
   {
     var a1;
     if($('otherspan') != null && $('otherspan').style.display == 'block'){
       a1 =' species '+ $('source').options[$('source').selectedIndex].value +' '+ $('idvalue').value+','+$('other').value;
     }else{
       a1 =' species '+ $('source').options[$('source').selectedIndex].value +' '+ $('idvalue').value;
     };
     new Ajax.Updater('species_table', '/cladename/display_speciesrow', 
       {
         asynchronous:true,
         evalScripts:true,
         insertion:'bottom',
         onSuccess:function(request){
           document.getElementById('speciesdiv').style.display='none';},
           parameters:'id='+id+a1+ '&authenticity_token='+token
         }
       );
       return false;
     }else{
       alert('Choose status to Select this Taxon Name');
     }
 }

 function construct_div(div_id,size,a){
    for(i=0;i<size;i++){
     var newdiv = document.createElement('div');
     var divIdName = div_id+(i+1);
     newdiv.setAttribute('id',divIdName);
     newdiv.setAttribute('class','padleft');
     newdiv.innerHTML = a[i];
     $(div_id).appendChild(newdiv);
   }
  }
 function remove_div(div_id,size){
   for(i=0;i<size;i++){
    var olddiv = $(div_id+(i+1));
    $(div_id).removeChild(olddiv);
   }
 }

 function mark_as_selected(new_selection){
    if (previous_selection != null &&  $(previous_selection) != null){
      $(previous_selection).style.fontWeight = "normal";
      $(previous_selection).style.color = "#0066CC"
    }
    $(new_selection).style.fontWeight = "bold";
    $(new_selection).style.color="red"
    //This is useful to a form in definitiontype.html.erb; Irrelavent in other cases; contvalue is a hidden field in the form that stores the id of the selected node.
    if( $('contvalue')){
      $('contvalue').value = $(new_selection).innerHTML
    }
    previous_selection = new_selection;
    var temp = new_selection.split( "_" );
    //idvalue is a hidden field in the form that stores the id of the selected node.
    $('idvalue').value = temp[0]
    //alert($('contvalue').value+";"+ $('idvalue').value);
    //change_status = 1
  }

  function construct_children(a){
    var image = $(a).down('img');
    if(a == "1"){

      if($('11') == null){
       a = new Array();
       a[0] = '<span id="11" class="pm" >*</span>'+'<span id="11_" style="color:rgb(0, 102, 204)" class="pm" onclick="mark_as_selected(this.id)">Standard </span>';
       a[1]='<span id="12" class="pm" style="color:rgb(0, 102, 204)"  onclick="construct_children(this.id);"><img src="/images/closed.gif"></span>'+'<span > Crown Clade </span>';
       construct_div('d1',2,a);
       image.src = "/images/open.gif";
      }else{
        remove_div('d1',2);
        image.src = "/images/closed.gif";
      }
    }else if (a == "12"){
      if($('121') == null){
        a = new Array();
        a[0] = '<span id="121" class="pm" >*</span><span id="121_" style="color:rgb(0, 102, 204)" class="pm" onclick="mark_as_selected(this.id)")>Standard (warning: all specifiers need to be extant or Recent)</span>';
        a[1]='<span id="122" class="pm" >*</span><span id="122_" style="color:rgb(0, 102, 204)" class="pm" onclick="mark_as_selected(this.id)">Branch-modified</span>';
        a[2]='<span id="123" class="pm" >*</span><span id="123_" style="color:rgb(0, 102, 204)" class="pm" onclick="mark_as_selected(this.id)">Apomorphy-modified</span>';
        construct_div('d12',3,a);
          image.src = "/images/open.gif";
      }else{
        remove_div('d12',3);
          image.src = "/images/closed.gif";
      }
    }else if(a == "2"){
      if($('21') == null){
        a = new Array();
        a[0] = '<span id="21" class="pm" >*</span><span id="21_" style="color:rgb(0, 102, 204)" class="pm" onclick="mark_as_selected(this.id)">Standard</span>';
        a[1]='<span id="22" style="color:rgb(0, 102, 204)" class="pm" onclick="construct_children(this.id);"><img src="/images/closed.gif"></span><span class="pm"> Total Clade</span>';
        construct_div('d2',2,a);
          image.src = "/images/open.gif";
      }else{
        remove_div('d2',2);
          image.src = "/images/closed.gif";
      }
    }else if(a == "22"){
      if($('221') == null){
        a = new Array();
        a[0] = '<span id="221" class="pm" >*</span><span id="221_" style="color:rgb(0, 102, 204)" class="pm" onclick="mark_as_selected(this.id)">Standard (warning: all specifiers need to be extant or Recent)</span>';
        a[1]='<span id="222" class="pm" >*</span><span id="222_" style="color:rgb(0, 102, 204)" class="pm" onclick="mark_as_selected(this.id)">Explicit </span>';
        construct_div('d22',2,a);
          image.src = "/images/open.gif";
      }else{
        remove_div('d22',2);
          image.src = "/images/closed.gif";
      }
    }
}
//tab switcher
/*
document.observe("dom:loaded" , function(){
    $$('#new-cladename-tabs>li').each(function(obj){
      obj.observe('click', function(target){
         $$('#new-cladename-tabs>li').each(function(li){
             li.setStyle({backgroundColor: '#ffe8ac', borderBottom: '1px solid #777'});
         })

         $$('#new-cladename-content>div').each(function(div){
             div.setStyle({display:'none'});
         });
         $(target.target.id + '-div').setStyle({display:'block'});

         $(target.target.id).setStyle({backgroundColor: '#FFFAE1', borderBottom: '1px solid #FFFAE1'});
      })
    })
})
  */