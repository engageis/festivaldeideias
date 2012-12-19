App.Collaborations.Show = ->
  $form = $('form#new_collaboration')
  textarea = $('textarea', $form)
  $('.answer-bt', '.topic').on 'click', (event) ->
    event.preventDefault()
    link = $(event.target)
    parent = link.closest('.topic')
    $('.topic', '#collaborations').removeClass('answering')
    $form.addClass('answering')
    comment = parent.addClass('answering').find('.collaboration-body').first() # Puts comment form as answering and returns the comment
    textarea.val("@#{$('.user', parent).text()}: ") if parent.hasClass('answer')
    parent_id = parent.parent().closest('.topic').data('id') || parent.data('id')
    console.log parent.parent().closest('.topic').data('id')
    console.log parent.data('id')
    $('#collaboration_parent_id', $form).val(parent_id)
    comment.append($form.hide().fadeIn()) # Moves the comment form with a nice fx
    textarea.focus()

  $('.cancel-button', $form).on 'click', (event) ->
    event.preventDefault()
    $('.topic', '#collaborations').removeClass('answering')
    $('#collaboration_parent_id', $form).removeAttr('value')
    textarea.val('')
    $('#form-wrapper').append($form)