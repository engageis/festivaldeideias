App.Collaborations.Show = ->
  collaborationsForm = new App.Collaborations.Form();
  window.location = $('a.return-to-idea-link').attr 'href'