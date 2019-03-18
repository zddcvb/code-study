defaults = {
  tinterfaceURL: 'default-interface.jsp',
  tManageAdd: function(_strfname)
  {
    var tstrfname = _strfname;
    var tformObj = $I(tstrfname);
    if (tformObj)
    {
      var tformBeObj = $I(tstrfname + 'BeforeAction');
      if (tformBeObj) eval(tformBeObj.value);
      if (wfront.validator.tCheck(tformObj))
      {
        var tAction = tformObj.action;
        var tstrform = cls.form.tgetValues(tformObj);
        $I('ajaxSubmit').disabled = true;
        cls.tiposts(tAction, tstrform, defaults.tManageAdds);
      };
    };
    return false;
  },
  tManageAdds: function(_strers)
  {
    var tstrers = _strers;
    $I('ajaxSubmit').disabled = false;
    if (wfront.tckBackString(tstrers))
    {
      tstrers = wfront.tckrBackString(tstrers);
      if (tstrers.indexOf('<!--200-->') == -1)
      {
        alert(tstrers);
      }
      else
      {
        alert(tstrers.substr(10));
        location.href = './?type=manage&mtype=list';
      };
    };
  },
  tManageDelete: function(_strids)
  {
    var tstrids = _strids;
    $I('ajaxDelete').disabled = true;
    cls.tigets(defaults.tinterfaceURL + '?type=action&atype=manage&mtype=delete&ids=' + escape(tstrids), defaults.tManageDeletes);
  },
  tManageDeletes: function(_strers)
  {
    var tstrers = _strers;
    $I('ajaxDelete').disabled = false;
    if (wfront.tckBackString(tstrers)) location.href = './?type=manage&mtype=list';
  }
};
