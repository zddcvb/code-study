var editor = {
  tGetXHTML: function(_name)
  {
    var tXHTML = '';
    var tname = _name;
    tXHTML = eval('CKEDITOR.instances.' + tname + '.getData();');
    return tXHTML;
  },
  tInsertHtml: function(_name, _strers)
  {
    var tname = _name;
    var tstrers = _strers;
    var tEditor = eval('CKEDITOR.instances.' + tname);
  	if (tEditor.mode == 'wysiwyg') tEditor.insertHtml(tstrers);
  },
  tInsertImage: function(_name, _strers)
  {
    var tname = _name;
    var tstrers = _strers;
    if (tstrers)
    {
      var tLocation = location.href.substr(0, location.href.lastIndexOf('/'));
      tstrers = '<img src="' + tLocation + '/' + tstrers + '" />';
      editor.tInsertHtml(tname, tstrers);
    };
  },
  tInsertAttachments: function(_name, _strers, _text)
  {
    var tname = _name;
    var tstrers = _strers;
    var ttext = _text;
    if (tstrers)
    {
      var tLocation = location.href.substr(0, location.href.lastIndexOf('/'));
      var tfiletype = tstrers.substr(tstrers.lastIndexOf('.'));
      if (tfiletype == '.jpg' || tfiletype == '.gif' || tfiletype == '.png') tstrers = '<img src="' + tLocation + '/' + tstrers + '" />';
      else tstrers = '<a href="' + tLocation + '/' + tstrers + '" target="_blank">' + ttext + '</a>';
      editor.tInsertHtml(tname, tstrers);
    };
  },
  tSetInputValue: function(_name)
  {
    var tname = _name;
    var tobj = $I(tname);
    if (tobj) tobj.value = editor.tGetXHTML(tname);
  }
};