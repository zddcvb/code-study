manages = {
  ttempArg: null,
  tinterfaceURL: 'manage-interface.jsp',
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
    manages.tLoad(tstrArg);
  },
  tLoad: function(_strArg)
  {
    var tstrArg = _strArg;
    manages.history.tSetHistory();
    manages.ttempArg = tstrArg;
    self.location.href = '#' + tstrArg;
    var tstrURL = manages.tinterfaceURL;
    if (tstrArg) tstrURL += tstrArg;
    manage.windows.tShowPanelLoading();
    manage.tajaxGet(tstrURL, manages.tLoads);
  },
  tLoads: function(_strers)
  {
    var tstrers = _strers;
    manage.tajaxCompleted();
    manage.windows.tHidePanelLoading();
    if (manage.tckBackString(tstrers))
    {
      if (tstrers.indexOf('<!--alert-->') != -1) manage.windows.dialog.tAlert(tstrers);
      else setInnerHTML($I(manages.tinterfaceContentID), tstrers);
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
        manage.tajaxPost(tAction, tstrform, manages.tEdits);
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
      if (tstrers.indexOf('<!--200-->') != -1) manages.tRefresh();
    };
  },
  tDelete: function(_strid)
  {
    var tstrid = _strid;
    manage.windows.tShowPanelLoading();
    manage.tajaxGet(manages.tinterfaceURL + '?type=action&atype=delete&id=' + tstrid, manages.tDeletes);
  },
  tDeletes: function(_strers)
  {
    var tstrers = _strers;
    manage.tajaxCompleted();
    manage.windows.tHidePanelLoading();
    if (tstrers == '200') manages.tLoad(manages.ttempArg);
  },
  tSwitch: function(_strswtype, _strids)
  {
    var tswtype = _strswtype;
    var tstrids = _strids;
    manage.windows.tShowPanelLoading();
    manage.tajaxGet(manages.tinterfaceURL + '?type=action&atype=switch&swtype=' + escape(tswtype) + '&ids=' + escape(tstrids), manages.tSwitchs);
  },
  tSwitchs: function(_strers)
  {
    var tstrers = _strers;
    manage.tajaxCompleted();
    manage.windows.tHidePanelLoading();
    if (tstrers == '200') manages.tLoad(manages.ttempArg);
  },
  tRefresh: function()
  {
    manages.tLoad(manages.ttempArg);
  }
};

manages.history = {
  tBack: function()
  {
    if (manage.history.tnIndex != -1)
    {
      if (manage.history.tnIndex == (manage.history.thAry.length - 1))
      {
        manages.history.tSetHistory();
      };
      manage.history.tBack();
      var tnAry = manage.history.tGetNAry();
      if (tnAry)
      {
        manages.ttempArg = tnAry[0];
        setInnerHTML($I(manages.tinterfaceContentID), tnAry[1]);
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
          manages.ttempArg = tnAry[0];
          setInnerHTML($I(manages.tinterfaceContentID), tnAry[1]);
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
    manage.history.tSetHistory(manages.ttempArg, $I(manages.tinterfaceContentID).innerHTML);
    manage.history.tSetHistoryImg();
  }
};

manages.olist = {
  tcount: 0,
  tAdd: function()
  {
    var tnumObj = $I('olistnum');
    var tstrURL = manages.tinterfaceURL;
    manages.olist.tcount = cls.tgetNum(tnumObj.value, 0);
    tstrURL += '?type=olist&otype=add&id=' + manages.olist.tcount;
    manages.olist.tcount += 1;
    tnumObj.value = manages.olist.tcount;
    manage.windows.tShowPanelLoading();
    manage.tajaxGet(tstrURL, manages.olist.tAdds);
  },
  tAdds: function(_strers)
  {
    var tstrers = _strers;
    manage.tajaxCompleted();
    manage.windows.tHidePanelLoading();
    if (manage.tckBackString(tstrers))
    {
      $I('olistListFactory').innerHTML = tstrers;
      var tnewolistObj = $I('olistListFactory').getElementsByTagName('table')[0];
      if (tnewolistObj) $I('olistList').appendChild(tnewolistObj);
    };
  },
  tEdit: function(_strfid)
  {
    tstrfid = _strfid;
    var tstrURL = manages.tinterfaceURL;
    tstrURL += '?type=olist&otype=edit&fid=' + tstrfid;
    manage.windows.tShowPanelLoading();
    manage.tajaxGet(tstrURL, manages.olist.tEdits);
  },
  tEdits: function(_strers)
  {
    var tstrers = _strers;
    manage.tajaxCompleted();
    manage.windows.tHidePanelLoading();
    if (manage.tckBackString(tstrers))
    {
      var tAry = tstrers.split('olist.tDelete');
      $I('olistnum').value = tAry.length;
      $I('olistList').innerHTML = tstrers;
    };
  },
  tDelete: function(_id)
  {
    var tid = _id;
    var tobj = $I('olist-' + tid);
    if (tobj) tobj.parentNode.removeChild(tobj);
  },
  tCountTotalprice: function()
  {
    var ttotalprice = 0;
    var tcount = cls.tgetNum($I('olistnum').value, 0);
    for (ti = 0; ti <= tcount; ti ++)
    {
      var tobjNum = $I('olist_num_' + ti);
      var tobjPrice = $I('olist_price_' + ti);
      if (tobjNum && tobjPrice) ttotalprice += cls.tgetNum(tobjNum.value, 0) * cls.tgetNum(tobjPrice.value, 0);
    };
    $I('totalprice').value = ttotalprice.toFixed(2);
  }
};
