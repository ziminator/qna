$(document).on('turbolinks:load', function(){
   $('.question').on('click', '.edit-question-link', function(e) {
       e.preventDefault();
       $(this).hide();
       questionId = $(this).data('questionID');
       $('form#edit-question-form' + questionID).show();
   })
});
