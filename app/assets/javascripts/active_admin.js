//
//
//= require active_admin/base
//
//

// On mouse over
$('.idea_show').live('mouseover',function(){
  var parents = $(this).parents('tr');

  //
  // Due to active_admin even class, I have to put a class to
  // switch over hover effects (yeah, I know, not the most
  // smart piece of code )
  //
  if (parents.hasClass('even')) {
   parents.removeClass('even').addClass('is_even');
  }

  // Here we are inserting the hover fx class
  parents.addClass('row_selected');

  // Fadin an Idea Preview, in order to best processin'
  $(this).siblings('.idea_hidden').fadeIn(90);
});


// On mouse leave
$('.idea_show').live('mouseout', function(){
  var parents = $(this).parents('tr');

  if ( parents.hasClass('is_even') ) {
    // Put the class again
    parents.addClass('even');
    // Removing the mark
    parents.parents('tr').removeClass('is_even');
  }

  // The row isn't hovered anymore, so goodbye
  parents.removeClass('row_selected');

  // Fade out the idea preview
  $(this).siblings('.idea_hidden').fadeOut(90);
});


// Form submits through ajax, for every "mini-form"
$('.form_idea').live('change',function(){
  var self = $(this);
  $.ajax({
    type: "PUT",
    // As backwards compatibility, every field has a form
    data: $(this).parents('form').serialize(),
    url: $(this).attr('data-url'),
    beforeSend: function(xhr){

      // Without this, you can't send data to the server.
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      self.parents('tr').animate({opacity: "0.5"}, 1000);
    },
    success: function(data){
      self.parents('tr').animate({opacity: "1"}, 1000);
    },
    error: function(data){
      console.log(data);
    }
  });
});
