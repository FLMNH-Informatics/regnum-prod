jQuery(document).ready(function () {
    function Submission(submission) {
        function Submitter(user){
            var self = this;
            self.first_name = user.first_name;
            self.last_name = user.last_name;
            self.email = user.email;
        }

        var self = this;
        self.name = submission.name
        self.submitter = new Submitter(submission.user);
    }

    function NewSubmissionViewModel() {
        var self = this;
        self.existing_submissions = ko.observableArray([]);
        self.new_submission = {
            name:           ko.observable(""),
            'opt-out':        ko.observable(false),
            reason: ko.observable(""),
        };

        self.checkSubmission = function(){
            debugger;
            jQuery.getJSON("my_submission/check_name", self.new_submission)
                .done(function(data){
                    debugger;
                    if (data.length !== 0){
                        var existing_submissions = jQuery.map(data, function(submission){ return new Submission(submission) });
                        self.existing_submissions(existing_submissions);
                        return;
                    }
                    self.submitNewSubmission();
                });
        };

        self.submitNewSubmission = function(){
            jQuery.post('/save', self.new_submission)
                .done(function(response){
                    document.location.href = '/my_submission/' + response.submission_id;
                });
        };
    }

    ko.applyBindings(new NewSubmissionViewModel());

//     jQuery('#opt-out').click(function (event) {
//         var t = jQuery('#opt-out-table');
//         if (event.target.checked === true) {
//             t.slideDown('fast');
//         } else {
//             t.slideUp();
//         }
//     })
//
//     jQuery('#create_button').click(function (event) {
//         event.preventDefault()
//         var alt = ''
//         if (jQuery('#name').val().length < 1) {
//             alt += 'Name required. '
//         }
//         if (jQuery('#opt-out').prop('checked') === true && jQuery('#reason').val().length < 3) {
//             alt += 'Opt-out reason required.'
//         }
//
//         if (alt.length > 0) {
//             alert(alt)
//         } else {
//             var serialized = jQuery(event.target.form).serialize();
//             debugger;
//             jQuery.get('my_submission/check_name', serialized, function(response){
//                 debugger;
//                 'hi';
//             })
//             debugger;
//             'hi';
//             // jQuery.post('/save', serialized, function (res) {
//             //     document.location.href = '/my_submission/' + res.submission_id;
//             // }, 'json')
//             //event.target.form.submit()
//         }
//     })
});