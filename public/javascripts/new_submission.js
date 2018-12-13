jQuery(document).ready(function () {
    function Submission(submission) {
        function Submitter(user){
            var self = this;
            self.fullname = user.first_name + ' ' + user.last_name;
            self.email = user.email;
        }

        var self = this;
        self.name = submission.name
        self.submitter = new Submitter(submission.user);
    }

    function NewSubmissionViewModel() {
        var self = this;
        self.existing_submissions = ko.observableArray([]);
        self.acceptDuplicate = ko.observable(false);
        self.new_submission = {
            name:           ko.observable(""),
            'opt-out':        ko.observable(false),
            reason: ko.observable(""),
        };

        self.optOutValid = function(){
            return !(self.new_submission['opt-out']()) || (self.new_submission.reason().trim().length > 0);
        };

        self.duplicateValid = function(){
            return ( self.existing_submissions().length === 0 || self.acceptDuplicate() );
        };

        self.nameValid = function() {
            return self.new_submission.name().trim().length > 0;
        };

        self.isValid = ko.computed(function() {
            return self.optOutValid()
                && self.nameValid()
                && self.duplicateValid();
        }, this);

        self.checkSubmission = function(){
            jQuery.getJSON("my_submission/check_name", self.new_submission)
                .done(function(data){
                    if (data.length !== 0){
                        var existing_submissions = jQuery.map(data, function(submission){ return new Submission(submission) });
                        self.existing_submissions(existing_submissions);
                        return;
                    }
                    self.existing_submissions([]);
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
});