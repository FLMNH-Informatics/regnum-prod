jQuery(document).ready(function() {
    jQuery('#search').click(function (event) {
        event.preventDefault();
        var tableContainer = jQuery('.sortable-table-holder');
        SubmissionsIndex.search(tableContainer, event.target.form);
    })
});