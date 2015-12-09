$(document).on 'ajax:aborted:file', 'form', (e, inputs) ->
  j = 1
  form = $(@)
  setTimeout((-> $.rails.disableFormElements(form)), 50)
  $.map inputs, (input, i) ->
    fr = new FileReader()
    fr.readAsDataURL(input.files[0])
    fr.onload = ->
      form.append("<input type='hidden' name='#{input.name}' value='#{fr.result}' />")
      $.rails.handleRemote(form) if (inputs.length == j)
      j++
  return false
