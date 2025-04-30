$(document).ready(function () {
    $('body').on('click', '.causeValidation', function () {
        $('.error-message').remove();
        var grp = $(this).parent().attr("class");
        $.each(Page_Validators, function () {
            if (this.validationGroup == grp || grp == "") {
                this.style.display = 'none';
                var $control = $('#' + this.controltovalidate);
                if (!this.isvalid) {
                    $control.parent().addClass('validation-error');
                    $control.parent().append('<SPAN class=error-message>' + this.errormessage + '</SPAN>');
                    //window.scrollTo(0, 0);
                    $control.focus(function () {
                        $('.error-message', $(this).parent()).remove();
                        $(this).parent().removeClass('validation-error');
                    });
                    $control.parent().focus(function () {
                        $('.error-message', $(this).parent()).remove();
                        $(this).parent().removeClass('validation-error');
                    });
                    $control.click(function () {
                        $('.error-message', $(this).parent()).remove();
                        $(this).parent().removeClass('validation-error');
                    });

                }
            }
        });
    });
});  