<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private account account;

  private String PP_CheckManager(String argManagers)
  {
    String tManager = "0";
    String tManagers = argManagers;
    String tUserGroup = cls.toString(account.getUserInfo("group"));
    if (tUserGroup.equals("999")) tManager = "999";
    else
    {
      if (cls.cinstr(tManagers, account.nusername, ",")) tManager = "1";
    }
    return tManager;
  }

  private String PP_FormatTopic(String argTopic, String argColor, String argStrong)
  {
    String tmpstr = "";
    String tTopic = argTopic;
    String tColor = argColor;
    String tStrong = argStrong;
    tmpstr = tTopic;
    if (!cls.isEmpty(tColor)) tmpstr = "<font color=\"" + tColor + "\">" + tmpstr + "</font>";
    if (tStrong.equals("1")) tmpstr = "<strong>" + tmpstr + "</strong>";
    return tmpstr;
  }

  private String PP_GetTopHtml(String argClass)
  {
    String tmpstr = "";
    String tClass = argClass;
    String tNLng = conf.getNLng();
    tmpstr = conf.jt.itake("manager.data_top", "tpl");
    tmpstr = tmpstr.replace("{$-inavigation}", PP_GetFaCatHtml(conf.jt.itake("default.data_fa_category", "tpl"), cls.getNum(tNLng, 0), cls.getNum(tClass, 0)));
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String PP_GetFaCatHtml(String argTpl, Integer argLng, Integer argFid)
  {
    String tTpl = argTpl;
    Integer tLng = argLng;
    Integer tId = argFid;
    Integer tmpId = 0;
    String tmpstr = tTpl;
    String tmpastr, tmprstr, tmptstr;
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    dbc tDbc = db.newInstance(conf);
    do
    {
      tmpId = tId;
      String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tmpId;
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        Object[][] tAry = (Object[][])tArys[0];
        tmptstr = tmpastr;
        tmptstr = tmptstr.replace("{$id}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id")))));
        tmptstr = tmptstr.replace("{$topic}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "topic")))));
        tmptstr = tmptstr.replace("{$fid}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "fid")))));
        tId = cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "fid"))), 0);
        if (tId != 0) tmprstr = tmptstr + tmprstr;
      }
    }
    while (tId != 0);
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  public String Module_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    String tAtt = cls.getString(conf.getRequestParameter("att"));
    Integer tpage = cls.getNum(conf.getRequestParameter("page"), 0);
    Integer tClass = cls.getNum(conf.getRequestParameter("class"), -1);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    dbc tDbc = db.newInstance(conf);
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "fid") + "<>0 and " + cls.cfnames(tfpre, "lng") + "=" + tNLng + " and " + tidfield + "=" + tClass;
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      conf.cntitle(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "topic"))));
      String tForumManager = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "manager")));
      String tCheckManager = PP_CheckManager(tForumManager);
      if (tCheckManager.equals("0")) tmpstr = conf.common.webMessage(conf.jt.itake("manager.popedom-error-1", "lng"));
      else
      {
        tmpstr = conf.jt.itake("manager.list", "tpl");
        for (int ti = 0; ti < tAry.length; ti ++)
        {
          tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
          tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
        }
        conf.rsAry = tAry;
        tmprstr = "";
        tmpastr = cls.ctemplate(tmpstr, "{@}");
        String tControlString = "select";
        if (tCheckManager.equals("999")) tControlString += ",htop";
        tControlString += ",top,elite,lock,hidden";
        tdatabase = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
        tfpre = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
        tidfield = cls.cfnames(tfpre, "id");
        tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "class") + "=" + tClass + " and " + cls.cfnames(tfpre, "fid") + "=0";
        if (tAtt.equals("elite")) tsqlstr += " and " + cls.cfnames(tfpre, "elite") + "=1";
        if (tAtt.equals("lock")) tsqlstr += " and " + cls.cfnames(tfpre, "lock") + "=1";
        if (tAtt.equals("top")) tsqlstr += " and " + cls.cfnames(tfpre, "top") + "=1";
        if (tAtt.equals("htop")) tsqlstr += " and " + cls.cfnames(tfpre, "htop") + "=1";
        if (tAtt.equals("hidden")) tsqlstr += " and " + cls.cfnames(tfpre, "hidden") + "=1";
        tsqlstr += " order by " + cls.cfnames(tfpre, "htop") + " desc," + cls.cfnames(tfpre, "top") + " desc," + cls.cfnames(tfpre, "last_time") + " desc";
        pagi pagi;
        pagi = new pagi(conf);
        pagi.sqlstr = tsqlstr;
        pagi.pagenum = tpage.longValue();
        pagi.rslimit = cls.getNum64(conf.jt.itake("config.nlisttopx", "cfg"));
        pagi.pagesize = cls.getNum64(conf.jt.itake("config.npagesize", "cfg"));
        pagi.Init();
        Object[] tArysT = pagi.getDataAry();
        if (tArysT != null)
        {
          for (int tis = 0; tis < tArysT.length; tis ++)
          {
            tmptstr = tmpastr;
            Object[][] tAryT = (Object[][])tArysT[tis];
            String tTopicHTop = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpre, "htop")));
            String tTopicTop = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpre, "top")));
            String tTopicElite = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpre, "elite")));
            String tTopicLock = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpre, "lock")));
            String tTopicHidden = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpre, "hidden")));
            for (int ti = 0; ti < tAryT.length; ti ++)
            {
              tAryT[ti][0] = (Object)cls.getLRStr((String)tAryT[ti][0], tfpre, "rightr");
              tmptstr = tmptstr.replace("{$-" + cls.toString(tAryT[ti][0]) + "}", encode.htmlencode(cls.toString(tAryT[ti][1])));
            }
            String tTopicStateString = "";
            if (tTopicHTop.equals("1")) tTopicStateString += conf.jt.itake("manager.txt-state-htop", "lng") + " ";
            if (tTopicTop.equals("1")) tTopicStateString += conf.jt.itake("manager.txt-state-top", "lng") + " ";
            if (tTopicElite.equals("1")) tTopicStateString += conf.jt.itake("manager.txt-state-elite", "lng") + " ";
            if (tTopicLock.equals("1")) tTopicStateString += conf.jt.itake("manager.txt-state-lock", "lng") + " ";
            if (tTopicHidden.equals("1")) tTopicStateString += conf.jt.itake("manager.txt-state-hidden", "lng") + " ";
            tmptstr = tmptstr.replace("{$-p-state-strings}", encode.htmlencode(tTopicStateString));
            tmptstr = tmptstr.replace("{$-p-topic}", PP_FormatTopic(encode.htmlencode(cls.toString(tDbc.getValue(tAryT, "topic"))), encode.htmlencode(cls.toString(tDbc.getValue(tAryT, "color"))), encode.htmlencode(cls.toString(tDbc.getValue(tAryT, "strong")))));
            conf.rsbAry = tAryT;
            tmptstr = conf.jt.creplace(tmptstr);
            tmprstr += tmptstr;
          }
        }
        tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
        tmpstr = tmpstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
        tmpstr = tmpstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
        tmpstr = tmpstr.replace("{$-genre}", tNGenre);
        tmpstr = tmpstr.replace("{$-lng}", cls.toString(tNLng));
        tmpstr = tmpstr.replace("{$-class}", cls.toString(tClass));
        tmpstr = tmpstr.replace("{$-att}", encode.htmlencode(tAtt));
        tmpstr = tmpstr.replace("{$-controlstring}", cls.toString(tControlString));
        tmpstr = tmpstr.replace("{$-topHtml}", PP_GetTopHtml(cls.toString(tClass)));
        tmpstr = conf.jt.creplace(tmpstr);
      }
    }
    else tmpstr = conf.common.webMessage(conf.jt.itake("manager.notexist-error-1", "lng"));
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  public String Module_Detail()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    Integer tId = cls.getNum(conf.getRequestParameter("id"), 0);
    Integer tCtPage = cls.getNum(conf.getRequestParameter("ctpage"), 0);
    Integer tClass = cls.getNum(conf.getRequestParameter("class"), -1);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tdatabaseT = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
    String tfpreT = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
    String tidfieldT = cls.cfnames(tfpreT, "id");
    dbc tDbc = db.newInstance(conf);
    String tsqlstr = "select * from " + tdatabase + "," + tdatabaseT + " where " + tdatabaseT + "." + cls.cfnames(tfpreT, "fid") + "=0 and " + tdatabaseT + "." + tidfieldT + "=" + tId + " and " + tdatabaseT + "." + cls.cfnames(tfpreT, "class") + "=" + tdatabase + "." + tidfield;
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      conf.cntitle(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "topic"))));
      conf.cntitle(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "topic"))));
      String tForumManager = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "manager")));
      String tCheckManager = PP_CheckManager(tForumManager);
      if (tCheckManager.equals("0")) tmpstr = conf.common.webMessage(conf.jt.itake("manager.popedom-error-1", "lng"));
      else
      {
        tmpstr = conf.jt.itake("manager.detail", "tpl");
        tmprstr = "";
        tmpastr = cls.ctemplate(tmpstr, "{@}");
        String tsqlstrT = "select * from " + tdatabaseT + " where (" + cls.cfnames(tfpreT, "fid") + "=" + tId + " or " + tidfieldT + "=" + tId + ")  order by " + cls.cfnames(tfpreT, "fid") + " asc," + cls.cfnames(tfpreT, "time") + " asc";
        pagi pagi;
        pagi = new pagi(conf);
        pagi.sqlstr = tsqlstrT;
        pagi.pagenum = tCtPage.longValue();
        pagi.rslimit = cls.getNum64(conf.jt.itake("config.nlisttopx", "cfg"));
        pagi.pagesize = cls.getNum64(conf.jt.itake("config.npagesize-2", "cfg"));
        pagi.Init();
        Object[] tArysT = pagi.getDataAry();
        if (tArysT != null)
        {
          for (int tis = 0; tis < tArysT.length; tis ++)
          {
            tmptstr = tmpastr;
            Object[][] tAryT = (Object[][])tArysT[tis];
            String tAuid = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpreT, "auid")));
            String tAuthor = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpreT, "author")));
            String tEditUserName = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpreT, "edit_username")));
            String tEditTime = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpreT, "edit_time")));
            String tTopicHidden = cls.toString(tDbc.getValue(tAryT, cls.cfnames(tfpreT, "hidden")));
            for (int ti = 0; ti < tAryT.length; ti ++)
            {
              tAryT[ti][0] = (Object)cls.getLRStr((String)tAryT[ti][0], tfpreT, "rightr");
              tmptstr = tmptstr.replace("{$-" + cls.toString(tAryT[ti][0]) + "}", encode.htmlencode(cls.toString(tAryT[ti][1])));
            }
            conf.rsbAry = tAryT;
            String tEditInfo = "";
            if (!cls.isEmpty(tEditUserName))
            {
              tEditInfo = conf.jt.itake("default.txt-edit-info", "lng");
              tEditInfo = tEditInfo.replace("[username]", tEditUserName);
              tEditInfo = tEditInfo.replace("[time]", cls.formatDate(tEditTime));
            }
            String tAuthorFaceURLString = "";
            String tAuthorFace = cls.toString(account.getUserInfo("face", tAuid));
            String tAuthorFaceU = cls.toString(account.getUserInfo("face_u", tAuid));
            String tAuthorFaceURL = cls.toString(account.getUserInfo("face_url", tAuid));
            if (tAuthorFaceU.equals("1")) tAuthorFaceURLString = tAuthorFaceURL;
            else tAuthorFaceURLString = conf.getActualRoute(conf.jt.itake("config.naccount", "cfg")) + "/" + conf.imagesRoute + "/face/" + tAuthorFace + ".gif";
            tmptstr = tmptstr.replace("{$-p-floor}", cls.toString(((pagi.pagenum - 1) * pagi.pagesize) + tis + 1));
            tmptstr = tmptstr.replace("{$-p-edit-info}", encode.htmlencode(tEditInfo));
            tmptstr = tmptstr.replace("{$-author-face}", encode.htmlencode(tAuthorFaceURLString));
            tmptstr = tmptstr.replace("{$-author-group}", encode.htmlencode(cls.toString(account.getUserInfo("group", tAuid))));
            tmptstr = tmptstr.replace("{$-author-integral}", encode.htmlencode(cls.toString(account.getUserInfo("integral", tAuid))));
            tmptstr = tmptstr.replace("{$-author-time}", encode.htmlencode(cls.toString(account.getUserInfo("time", tAuid))));
            tmptstr = tmptstr.replace("{$-author-sign}", encode.htmlencode(cls.toString(account.getUserInfo("sign", tAuid))));
            //****************************************************************************//
            String tTopicStateString = "";
            if (tTopicHidden.equals("1")) tTopicStateString += conf.jt.itake("manager.txt-state-hidden", "lng") + " ";
            tmptstr = tmptstr.replace("{$-p-state-strings}", encode.htmlencode(tTopicStateString));
            //****************************************************************************//
            tmptstr = conf.jt.creplace(tmptstr);
            tmprstr += tmptstr;
          }
        }
        tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
        tmpstr = tmpstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
        tmpstr = tmpstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
        tmpstr = tmpstr.replace("{$-topHtml}", PP_GetTopHtml(cls.toString(tClass)));
        tmpstr = tmpstr.replace("{$-nusername}", encode.htmlencode(account.nusername));
        //****************************************************************************//
        tmpstr = tmpstr.replace("{$id}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "id")))));
        tmpstr = tmpstr.replace("{$topic}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "topic")))));
        tmpstr = tmpstr.replace("{$class}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "class")))));
        tmpstr = tmpstr.replace("{$time}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpreT, "time")))));
        tmpstr = conf.jt.creplace(tmpstr);
      }
    }
    return tmpstr;
  }

  public String Module_Blacklist()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    Integer tpage = cls.getNum(conf.getRequestParameter("page"), 0);
    Integer tClass = cls.getNum(conf.getRequestParameter("class"), -1);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    dbc tDbc = db.newInstance(conf);
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "fid") + "<>0 and " + cls.cfnames(tfpre, "lng") + "=" + tNLng + " and " + tidfield + "=" + tClass;
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      conf.cntitle(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "topic"))));
      String tForumManager = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "manager")));
      String tCheckManager = PP_CheckManager(tForumManager);
      if (tCheckManager.equals("0")) tmpstr = conf.common.webMessage(conf.jt.itake("manager.popedom-error-1", "lng"));
      else
      {
        tmpstr = conf.jt.itake("manager.blacklist", "tpl");
        for (int ti = 0; ti < tAry.length; ti ++)
        {
          tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
          tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
        }
        conf.rsAry = tAry;
        tmprstr = "";
        tmpastr = cls.ctemplate(tmpstr, "{@}");
        tdatabase = cls.getString(conf.jt.itake("config.ndatabase-blacklist", "cfg"));
        tfpre = cls.getString(conf.jt.itake("config.nfpre-blacklist", "cfg"));
        tidfield = cls.cfnames(tfpre, "id");
        tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "fid") + "=" + tClass + " order by " + tidfield + " desc";
        pagi pagi;
        pagi = new pagi(conf);
        pagi.sqlstr = tsqlstr;
        pagi.pagenum = tpage.longValue();
        pagi.rslimit = cls.getNum64(conf.jt.itake("config.nlisttopx", "cfg"));
        pagi.pagesize = cls.getNum64(conf.jt.itake("config.npagesize", "cfg"));
        pagi.Init();
        Object[] tArysB = pagi.getDataAry();
        if (tArysB != null)
        {
          for (int tis = 0; tis < tArysB.length; tis ++)
          {
            tmptstr = tmpastr;
            Object[][] tAryB = (Object[][])tArysB[tis];
            for (int ti = 0; ti < tAryB.length; ti ++)
            {
              tAryB[ti][0] = (Object)cls.getLRStr((String)tAryB[ti][0], tfpre, "rightr");
              tmptstr = tmptstr.replace("{$-" + cls.toString(tAryB[ti][0]) + "}", encode.htmlencode(cls.toString(tAryB[ti][1])));
            }
            conf.rsbAry = tAryB;
            tmptstr = conf.jt.creplace(tmptstr);
            tmprstr += tmptstr;
          }
        }
        tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
        tmpstr = tmpstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
        tmpstr = tmpstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
        tmpstr = tmpstr.replace("{$-genre}", tNGenre);
        tmpstr = tmpstr.replace("{$-lng}", cls.toString(tNLng));
        tmpstr = tmpstr.replace("{$-class}", cls.toString(tClass));
        tmpstr = tmpstr.replace("{$-topHtml}", PP_GetTopHtml(cls.toString(tClass)));
        tmpstr = conf.jt.creplace(tmpstr);
      }
    }
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    account = new account(conf);
    account.Init(conf.jt.itake("config.naccount", "cfg"));
    account.UserInit();
    conf.cntitle(conf.jt.itake("default.channel_title", "lng"));

    String tmpstr = "";
    if (!account.checkUserLogin()) tmpstr = conf.common.webMessages(conf.jt.itake("default.login-error-1", "lng"), conf.getActualRoute(conf.jt.itake("config.naccount", "cfg")) + "/?type=login&backurl=" + encode.base64encode(conf.getRequestURL().getBytes()));
    else
    {
      String tType = cls.getString(conf.getRequestParameter("type"));
      if (tType.equals("list")) tmpstr = Module_List();
      else if (tType.equals("detail")) tmpstr = Module_Detail();
      else if (tType.equals("blacklist")) tmpstr = Module_Blacklist();
      else tmpstr = Module_List();
    }

    PageClose();
    return tmpstr;
  }
}
%>