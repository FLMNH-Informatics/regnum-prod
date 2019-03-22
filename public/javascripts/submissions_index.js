var SubmissionsIndex = SubmissionsIndex || {};

SubmissionsIndex.search = function(tableContainer, form){
    var formData = jQuery(form).serialize();
    if (form && form.action !== undefined && formData !== undefined){
        this.loadTable(tableContainer, form.action + '?' + formData);
    } else {
        if (formData === undefined) console.log("Error, serialized form data is undefined in call to SubmissionsIndex.search");
        if (form.action === undefined) console.log("Error, form action is undefined in call to SubmissionIndex.search");
    }
}

SubmissionsIndex.loadTable = function(tableContainer, target){
    if (target !== undefined && tableContainer !== undefined ){
        jQuery('.sortable-table-div').children('.sortable-table-loading').show();
        tableContainer.find('table').hide();
        jQuery('.sortable-table-holder').load(target, function(){
            tableContainer.find('table').show();
            tableContainer.find('a.button').button();
        });
    } else {
        if (target === undefined) console.log("Error, target is undefined in call to SubmissionsIndex.loadTable");
        if (tableContainer === undefined) console.log("Error, tableContainer is undefined in call to SubmissionsIndex.loadTable");
    }
};