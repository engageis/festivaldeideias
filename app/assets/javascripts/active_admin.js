//
//
//= require active_admin/base
//= require jquery-ui
//= require tinymce
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
  var csrf_token = $('meta[name="csrf-token"]').attr('content');
  var csrf_param = $('meta[name="csrf-param"]').attr('content');
  $(this).append("<input name='"+csrf_param+"' value='"+csrf_token+"' type='hidden' />");
  $.ajax({
    type: "PUT",
    // As backwards compatibility, every field has a form
    data: $(this).parents('form').serialize(),
    url: $(this).attr('data-url'),
    beforeSend: function(xhr){
      // Without this, you can't send data to the server.
      xhr.setRequestHeader('X-CSRF-Token', csrf_token);
      self.parents('tr').animate({opacity: "0.5"}, 1000);
    },
    success: function (data) {
      self.parents('tr').animate({opacity: "1"}, 1000);
    },
    error: function (data) {
      console.log(data);
    }
  });
});

// WYSIWYG Editor
$(function () {
  tinymce.init({
    mode : "textareas",
    theme : "advanced",
    plugins : "autolink,lists,spellchecker,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",
    editor_selector: 'mceEditor',

    // Theme options
    theme_advanced_buttons1 : "save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect",
    theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
    theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
    theme_advanced_buttons4 : "insertlayer,moveforward,movebackward,absolute,|,styleprops,spellchecker,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,blockquote,pagebreak,|,insertfile,insertimage",
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_statusbar_location : "bottom",
    theme_advanced_resizing : true,

    // Skin options
    skin : "o2k7",
    skin_variant : "silver",

    // Drop lists for link/image/media/template dialogs
    template_external_list_url : "js/template_list.js",
    external_link_list_url : "js/link_list.js",
    external_image_list_url : "js/image_list.js",
    media_external_list_url : "js/media_list.js",
  });
});


$(function () {
  var fixHelper, sortableTable, updateUrl;

  // Para garantir que a linha da tabela permaneça no seu tamanho
  // original durante o "sort".
  fixHelper = function(e, ui) {
    ui.children().each(function() { $(this).width($(this).width()); });
    return ui;
  };
  updateUrl = $('#update-url').attr("data-update-url");
  sortableTable = $('.admin_pages .index_table tbody');

  sortableTable.sortable({
    helper: fixHelper,
    axis: "y" // Só será possível mover no sentido vertical
    }).disableSelection();

  sortableTable.bind("sortupdate", function (event, ui) {
    var list = $(this);
    list.find("tr").each(function (i) {
      // Renomeia a classe do TR de acordo com sua nova posição
      this.className = i % 2 == 0 ? "odd" : "even"; // Parece errado, mas não é. A contagem começa no zero.
    });
    $.post(updateUrl, list.sortable('serialize'));
  });

});
