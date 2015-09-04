$(document).on 'ajax:aborted:file', 'form', (e, inputs) ->
  j = 1
  form = $(@)
  $.map inputs, (input, i) ->
    $.map input.files, (file, k) ->
      fr = new FileReader()
      fr.readAsDataURL(file)
      fr.onload = ->
        form.append("<input type='hidden' name='#{input.name}' value='#{fr.result}' />")
        $.rails.handleRemote(form) if (input.files.length == j)
        j++
  return false
