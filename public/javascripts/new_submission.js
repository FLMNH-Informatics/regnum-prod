jQuery(document).ready(function () {
    function NewSubmissionViewModel() {

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

        var self = this;
        self.existing_submissions = ko.observableArray([]);
        self.acceptDuplicate = ko.observable(false);
        self.checkingName = ko.observable(false);
        self.nameUnique = ko.observable(true);
        self.new_submission = {
            name: ko.observable(""),
            'opt-out': ko.observable(false),
            reason: ko.observable(""),
            submission_id: 'new'
        };


        self.new_submission.name.subscribe(function (newValue) {
            self.checkingName(true);
            jQuery.getJSON("my_submission/check_name", {'name': newValue})
                .done(function (data) {
                    if (data.length !== 0) {
                        var existing_submissions = jQuery.map(data, function (submission) {
                            return new Submission(submission)
                        });
                        self.existing_submissions(existing_submissions);
                        self.nameUnique(false);
                        self.checkingName(false);
                        return;
                    }
                    self.existing_submissions([]);
                    self.acceptDuplicate(false);
                    self.nameUnique(true);
                    self.checkingName(false);
                })
        });

        self.optOutValid = function () {
            return !(self.new_submission['opt-out']()) || (self.new_submission.reason().trim().length > 0);
        };

        self.duplicateValid = function () {
            return (self.existing_submissions().length === 0 || self.acceptDuplicate());
        };

        self.nameValid = function () {
            return self.new_submission.name().trim().length > 0;
        };

        self.isValid = ko.computed(function () {
            return self.optOutValid()
                && self.nameValid()
                && self.duplicateValid();
        }, this);

        self.submitNewSubmission = function () {
            var data = ko.mapping.toJSON(self.new_submission);
            jQuery.ajax({
                type: 'POST',
                url: '/create',
                data: data,
                contentType: 'application/json'
            }).done(function (response) {
                document.location.href = '/my_submission/' + response.submission_id;
            });
        };

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
    }

    ko.applyBindings(new NewSubmissionViewModel());
});