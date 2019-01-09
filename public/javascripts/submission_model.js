jQuery(document).ready(function () {
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
});