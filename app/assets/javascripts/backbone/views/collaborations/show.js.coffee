App.Collaborations.Show = ->
  $form = $('form#new_collaboration')
  $('.answer-bt', '.topic').on 'click', (event) ->
    event.preventDefault()
    link = $(event.target)
    textarea = $('textarea', $form)
    parent = link.closest('.topic')
    $('.topic', '#collaborations').removeClass('answering')
    $form.addClass('answering')
    comment = parent.addClass('answering').find('.collaboration-body').first() # Puts comment form as answering and returns the comment
    textarea.val("@#{$('.user', parent).text()}: ") if parent.hasClass('answer')
    $('#collaboration_parent_id', $form).val(parent.data('id'))
    comment.append($form.hide().fadeIn()) # Moves the comment form with a nice fx
    textarea.focus()

  $('.cancel-button', $form).on 'click', (event) ->
    event.preventDefault()
    $('.topic', '#collaborations').removeClass('answering')
    $('#collaboration_parent_id', $form).removeAttr('value')
    $('#form-wrapper').append($form)