PxToEmView = require './px-to-em-view'
{CompositeDisposable} = require 'atom'

module.exports = PxToEm =
   pxToEmView: null
   modalPanel: null
   subscriptions: null

   activate: ->
      atom.commands.add 'atom-workspace', 'px-to-em:toggle': => @convert()

   convert: ->
      editor = atom.workspace.getActivePaneItem()
      #select current line
      selection = editor.selectLinesContainingCursors()
      #get line value
      original = editor.getLastSelection()
      #save line value
      text = original.getText()
      #get init of the base
      initBase = text.search('/')
      #save the base value
      base = text.slice(initBase).slice(1)
      #get init of the px value
      values = text.match(/([0-9]+)px/gi)
      #each the px values
      values.forEach (val, key) ->
         text = text.replace(val, parseInt(val)/base + 'em')
         if key < values.length-1
            text = text.concat('/* ' + parseInt(val) + '\u00A0*/ ')
         else
            text = text.replace('/'+base, '') + ('/* ' + parseInt(val) + '\u00A0*/')
            text = text.replace(/[\u00A0]\*\//g, '/' + base.replace(/(\r\n|\n|\r)/gi, "") + '\u00A0*/')
            text = text + '\n'

      original.insertText(text)
