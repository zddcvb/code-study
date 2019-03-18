manage_topics = {
  ttempArg: null,
  tinterfaceURL: 'manage_topic-interface.jsp',
  tinterfaceContentID: 'windowsContent-rightPanel-Content',
  tInit: function(_strArg)
  {
    var tstrArg = _strArg;
    var tnParameter = manage.tgetPoundURLParameter(self.location.href);
    if (tnParameter && tnParameter != 'null') tstrArg = tnParameter;
    var tnParaField = cls.tgetParameter(tstrArg, 'field');
    var tnParaKeyword = cls.tgetParameter(tstrArg, 'keyword');
    if (tnParaField) cls.tselOptions($I('field'), tnParaField);
    if (tnParaKeyword) $I('keyword').value = unescape(tnParaKeyword);
    manage_topics.tLoad(tstrArg);
  },
  tLoad: function(_strArg)
  {
    var tstrArg = _strArg;
    manage_topics.history.tSetHistory();
    manage_topics.ttempArg = tstrArg;
    self.location.href = '#' + tstrArg;
    var tstrURL = manage_topics.tinterfaceURL;
    if (tstrArg) tstrURL += tstrArg;
    manage.windows.tShowPanelLoading();
    manage.tajaxGet(tstrURL, manage_topics.tLoads);
  },
  tLoads: function(_strers)
  {
    var tstrers = _strers;
    manage.tajaxCompleted();
    manage.windows.tHidePanelLoading();
    if (manage.tckBackString(tstrers))
    {
      if (tstrers.indexOf('<!--alert-->') != -1) manage.windows.dialog.tAlert(tstrers);
      else setInnerHTML($I(manage_topics.tinterfaceContentID), tstrers);
    };
  },
  tEdit: function(_strfname)
  {
    var tstrfname = _strfname;
    var tformObj = $I(tstrfname);
    if (tformObj)
    {
      var tformBeObj = $I(tstrfname + 'BeforeAction');
      if (tformBeObj) eval(tformBeObj.value);
      if (manage.validator.tCheck(tformObj))
      {
        var tAction = tformObj.action;
        var tstrform = cls.form.tgetValues(tformObj);
        $I('ajaxSubmit').disabled = true;
        manage.windows.tShowPanelLoading();
        manage.tajaxPost(tAction, tstrform, manage_topics.tEdits);
      };
    };
  },
  tEdits: function(_strers)
  {
    var tstrers = _strers;
    manage.tajaxCompleted();
    $I('ajaxSubmit').disabled = false;
    manage.windows.tHidePanelLoading();
    if (manage.tckBackString(tstrers))
    {
      manage.windows.dialog.tAlert(tstrers);
      if (tstrers.indexOf('<!--200-->') != -1) manage_topics.tRefresh();
    };
  },
  tDelete: function(_strid)
  {
    var tstrid = _strid;
    manage.windows.tShowPanelLoading();
    manage.tajaxGet(manage_topics.tinterfaceURL + '?type=action&atype=delete&id=' + tstrid, manage_topics.tDeletes);
  },
  tDeletes: function(_strers)
  {
    var tstrers = _strers;
    manage.tajaxCompleted();
    manage.windows.tHidePanelLoading();
    if (tstrers == '200') manage_topics.tLoad(manage_topics.ttempArg);
  },
  tSwitch: function(_strswtype, _strids)
  {
    var tswtype = _strswtype;
    var tstrids = _strids;
    manage.windows.tShowPanelLoading();
    manage.tajaxGet(manage_topics.tinterfaceURL + '?type=action&atype=switch&swtype=' + escape(tswtype) + '&ids=' + escape(tstrids), manage_topics.tSwitchs);
  },
  tSwitchs: function(_strers)
  {
    var tstrers = _strers;
    manage.tajaxCompleted();
    manage.windows.tHidePanelLoading();
    if (tstrers == '200') manage_topics.tLoad(manage_topics.ttempArg);
  },
  tRefresh: function()
  {
    manage_topics.tLoad(manage_topics.ttempArg);
  },
  tSelslng: function(_strArg)
  {
    var tstrArg = _strArg;
    var tstrURL = manage_topics.tinterfaceURL + '?type=action&atype=selslng&lng=';
    if (tstrArg)
    {
      tstrURL += tstrArg;
      var tobj = $I('selslng');
      manage.tajaxGet(tstrURL, manage_topics.tSelslngs);
    }
    else manage.tajaxLoad(tstrURL, 'selslng');
  },
  tSelslngs: function(_strers)
  {
    var tstrers = _strers;
    manage.tajaxCompleted();
    if (tstrers == "200")
    {
      manage_topics.tSelslng();
      manage_topics.tLoad(manage_topics.ttempArg);
    };
  },
  tInsert: function(_editor, _value, _text)
  {
    var tEditor = _editor;
    var tValue = _value;
    var tText = _text;
    if (tEditor && tValue)
    {
      var tFileType = tValue.substr(tValue.lastIndexOf('.') + 1);
      if (cinstr('.bmp.jpg.jpeg.gif.png', tFileType, '.')) tEditor.tinsertUBB('[img]' + tValue + '[/img]');
      else tEditor.tinsertUBB('[url=' + tValue + ']' + tText + '[/url]');
    };
  }
};

manage_topics.history = {
  tBack: function()
  {
    if (manage.history.tnIndex != -1)
    {
      if (manage.history.tnIndex == (manage.history.thAry.length - 1))
      {
        manage_topics.history.tSetHistory();
      };
      manage.history.tBack();
      var tnAry = manage.history.tGetNAry();
      if (tnAry)
      {
        var tstrArg = tnAry[0];
        manage_topics.ttempArg = tstrArg;
        self.location.href = '#' + tstrArg;
        var tstrURL = manage_topics.tinterfaceURL;
        if (tstrArg) tstrURL += tstrArg;
        manage.windows.tShowPanelLoading();
        manage.tajaxGet(tstrURL, manage_topics.tLoads);
      };
      manage.history.tSetHistoryImg();
    };
  },
  tForward: function()
  {
    if (manage.history.tnIndex != -1)
    {
      if (manage.history.tnIndex != (manage.history.thAry.length - 1))
      {
        manage.history.tForward();
        var tnAry = manage.history.tGetNAry();
        if (tnAry)
        {
          var tstrArg = tnAry[0];
          manage_topics.ttempArg = tstrArg;
          self.location.href = '#' + tstrArg;
          var tstrURL = manage_topics.tinterfaceURL;
          if (tstrArg) tstrURL += tstrArg;
          manage.windows.tShowPanelLoading();
          manage.tajaxGet(tstrURL, manage_topics.tLoads);
        };
        manage.history.tSetHistoryImg();
      };
    };
  },
  tSetHistory: function()
  {
    var tformBeObj = null;
    var tFormObj = document.getElementsByTagName('form');
    for(ti = 0; ti < tFormObj.length; ti ++)
    {
      tformBeObj = $I(tFormObj[ti].id + 'BeforeAction');
      if (tformBeObj) eval(tformBeObj.value);
    };
    manage.history.tSetHistory(manage_topics.ttempArg, $I(manage_topics.tinterfaceContentID).innerHTML);
    manage.history.tSetHistoryImg();
  }
};
