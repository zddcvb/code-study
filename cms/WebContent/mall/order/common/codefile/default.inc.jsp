<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%@ page import = "java.util.regex.Pattern" %>
<%
class module extends jpage
{
  private account account;

  private String PP_formatOrderID(Integer argID)
  {
    Integer tID = argID;
    Integer tID2 = tID % 1000;
    String tID2String = cls.toString(tID2);
    if (tID2 < 10) tID2String = "00" + tID2;
    if (tID2 >= 10 && tID2 < 100) tID2String = "0" + tID2;
    tID2String = cls.formatDate(cls.getDate(), 30) + tID2String;
    return tID2String;
  }

  private String PP_Get_Products_Topic(String argID)
  {
    String tmpstr = "";
    Integer tid = cls.getNum(argID, 0);
    String tnfgenre = cls.getString(conf.jt.itake("config.nfgenre", "cfg"));
    String tdatabase = cls.getString(conf.jt.itake("global." + tnfgenre + ":config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global." + tnfgenre + ":config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      tmpstr = (String)tDbc.getValue(tAry, cls.cfnames(tfpre, "topic"));
      tmpstr = encode.htmlencode(tmpstr);
    }
    if (cls.isEmpty(tmpstr)) tmpstr = conf.jt.itake("manage.topic_error_1", "lng");
    return tmpstr;
  }

  private String Module_Action_Add()
  {
    String tmpstr = "";
    Integer tid = cls.getNum(conf.getRequestParameter("id"), 0);
    Integer tnum = cls.getNum(conf.getRequestParameter("num"), 0);
    if (tnum < 1) tnum = 1;
    if (tid != 0)
    {
      String tncookiesid = "";
      String tcookiesid = cls.getSafeString(cookies.getAttribute(conf, conf.getAppKey("order-id")));
      tncookiesid = tcookiesid;
      if (cls.isEmpty(tcookiesid)) tncookiesid = cls.toString(tid);
      else
      {
        if (!cls.cinstr(tcookiesid, cls.toString(tid), ",")) tncookiesid = tcookiesid + "," + tid;
      }
      cookies.setAttribute(conf, conf.getAppKey("order-id"), tncookiesid);
      cookies.setAttribute(conf, conf.getAppKey("order-" + tid), cls.toString(tnum));
      tmpstr = conf.jt.itake("default.add-succeed", "lng");
    }
    else tmpstr = conf.jt.itake("default.add-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;

    try
    {
      conf.response.sendRedirect("./?type=list");
    }
    catch(Exception e) {}

    return tmpstr;
  }

  private String Module_Action_Edit()
  {
    String tmpstr = "";
    String tncookiesid = "";
    String tcookiesid = cls.getSafeString(cookies.getAttribute(conf, conf.getAppKey("order-id")));
    String tselectedids = cls.getSafeString(conf.getRequestParameters("id"));
    if (!cls.isEmpty(tcookiesid))
    {
      String[] tcookiesidAry = tcookiesid.split(Pattern.quote(","));
      for (int ti = 0; ti < tcookiesidAry.length; ti ++)
      {
        Integer tid = cls.getNum(tcookiesidAry[ti], 0);
        if (tid != 0)
        {
          Integer tIDNum = cls.getNum(conf.getRequestParameter("num-" + tid));
          if (cls.cinstr(tselectedids, cls.toString(tid), ",") && tIDNum > 0)
          {
            tncookiesid += "," + tid;
            String tnCookiesInfo = cls.toString(tIDNum);
            cookies.setAttribute(conf, conf.getAppKey("order-" + tid), tnCookiesInfo);
          }
          else cookies.removeAttribute(conf, conf.getAppKey("order-" + tid));
        }
      }
      cookies.setAttribute(conf, conf.getAppKey("order-id"), tncookiesid);
    }
    tmpstr = conf.jt.itake("default.edit-succeed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;

    try
    {
      conf.response.sendRedirect("./?type=list");
    }
    catch(Exception e) {}

    return tmpstr;
  }

  private String Module_Action_RemoveAll()
  {
    String tmpstr = "";
    String tcookiesid = cls.getSafeString(cookies.getAttribute(conf, conf.getAppKey("order-id")));
    if (!cls.isEmpty(tcookiesid))
    {
      String[] tcookiesidAry = tcookiesid.split(Pattern.quote(","));
      for (int ti = 0; ti < tcookiesidAry.length; ti ++)
      {
        cookies.removeAttribute(conf, conf.getAppKey("order-" + tcookiesidAry[ti]));
      }
      cookies.removeAttribute(conf, conf.getAppKey("order-id"));
    }
    tmpstr = conf.jt.itake("default.removeall-succeed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;

    try
    {
      conf.response.sendRedirect("./?type=list");
    }
    catch(Exception e) {}

    return tmpstr;
  }

  private String Module_Action_Submit()
  {
    String tmpstr = "";
    Double ttotalprice = 0.0;
    String tcookiesid = cls.getSafeString(cookies.getAttribute(conf, conf.getAppKey("order-id")));
    if (!cls.isEmpty(tcookiesid))
    {
      dbc tDbc = db.newInstance(conf);
      //********************************************************************************//
      String toListString = "";
      String tnfgenre = cls.getString(conf.jt.itake("config.nfgenre", "cfg"));
      String tdatabase = cls.getString(conf.jt.itake("global." + tnfgenre + ":config.ndatabase", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("global." + tnfgenre + ":config.nfpre", "cfg"));
      String tidfield = cls.cfnames(tfpre, "id");
      String[] tcookiesidAry = tcookiesid.split(Pattern.quote(","));
      for (int ti = 0; ti < tcookiesidAry.length; ti ++)
      {
        Double tprice = 0.0;
        //###############################################################################//
        Integer tnid = cls.getNum(tcookiesidAry[ti], 0);
        String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tnid;
        Object[] tArys = tDbc.getDataAry(tsqlstr);
        if (tArys != null)
        {
          Object[][] tAry = (Object[][])tArys[0];
          Integer tid = cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id"))), 0);
          String tcookiesidInfo = cls.getSafeString(cookies.getAttribute(conf, conf.getAppKey("order-" + tid)));
          tprice = cls.getDouble(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "xprice"))), 0.00);
          ttotalprice += tprice * cls.getNum(tcookiesidInfo, 0);
        }
        //###############################################################################//
        String tnCookiesID = tcookiesidAry[ti];
        String tCookiesString = cls.getSafeString(cookies.getAttribute(conf, conf.getAppKey("order-" + tnCookiesID)));
        if (!cls.isEmpty(tCookiesString)) toListString += "|-|" + tnCookiesID + "|:|" + tCookiesString + "|:|" + cls.formatDouble(tprice, "0.00");
      }
      if (!cls.isEmpty(toListString)) toListString = cls.getLRStr(toListString, "|-|", "rightr");
      //********************************************************************************//
      if (!cls.isEmpty(toListString))
      {
        Integer tnuserid = cls.getNum(account.nuserid, 0);
        String tndatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
        String tnfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
        String tnidfield = cls.cfnames(tnfpre, "id");
        String tnsqlstr = "insert into " + tndatabase + " (";
        tnsqlstr += cls.cfnames(tnfpre, "uid") + ",";
        tnsqlstr += cls.cfnames(tnfpre, "olist") + ",";
        tnsqlstr += cls.cfnames(tnfpre, "totalprice") + ",";
        tnsqlstr += cls.cfnames(tnfpre, "name") + ",";
        tnsqlstr += cls.cfnames(tnfpre, "address") + ",";
        tnsqlstr += cls.cfnames(tnfpre, "zipcode") + ",";
        tnsqlstr += cls.cfnames(tnfpre, "phone") + ",";
        tnsqlstr += cls.cfnames(tnfpre, "email") + ",";
        tnsqlstr += cls.cfnames(tnfpre, "remark") + ",";
        tnsqlstr += cls.cfnames(tnfpre, "time");
        tnsqlstr += ") values (";
        tnsqlstr += tnuserid + ",";
        tnsqlstr += "'" + cls.getLeft(encode.addslashes(toListString), 10000) + "',";
        tnsqlstr += ttotalprice + ",";
        tnsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestParameter("name")), 50) + "',";
        tnsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestParameter("address")), 255) + "',";
        tnsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestParameter("zipcode")), 50) + "',";
        tnsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestParameter("phone")), 50) + "',";
        tnsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestParameter("email")), 50) + "',";
        tnsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestParameter("remark")), 50) + "',";
        tnsqlstr += "'" + cls.getDate() + "'";
        tnsqlstr += ")";
        int tstateNum = tDbc.Executes(tnsqlstr);
        if (tstateNum != -101)
        {
          cookies.removeAttribute(conf, conf.getAppKey("order-id"));
          int tTopID = conf.common.getTopID(tndatabase, tnidfield);
          String torderID = PP_formatOrderID(tTopID);
          tDbc.Execute("update " + tndatabase + " set " + cls.cfnames(tnfpre, "orderid") + "='" + torderID + "' where " + tnidfield + "=" + tTopID);
          tmpstr = conf.jt.itake("default.submit-succeed", "lng");
        }
        else tmpstr = conf.jt.itake("default.submit-failed", "lng");
      }
      else tmpstr = conf.jt.itake("default.submit-error1", "lng");
    }
    else tmpstr = conf.jt.itake("default.submit-error1", "lng");
    tmpstr = conf.common.webMessages(tmpstr, "./?type=mylist");
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestParameter("atype"));
    if (tAtype.equals("add")) tmpstr = Module_Action_Add();
    else if (tAtype.equals("edit")) tmpstr = Module_Action_Edit();
    else if (tAtype.equals("removeall")) tmpstr = Module_Action_RemoveAll();
    else if (tAtype.equals("submit")) tmpstr = Module_Action_Submit();
    return tmpstr;
  }

  private String Module_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    tmpstr = conf.jt.itake("default.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    Double ttotalprice = 0.0;
    String tcookiesid = cls.getSafeString(cookies.getAttribute(conf, conf.getAppKey("order-id")));
    String tnfgenre = cls.getString(conf.jt.itake("config.nfgenre", "cfg"));
    String tdatabase = cls.getString(conf.jt.itake("global." + tnfgenre + ":config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global." + tnfgenre + ":config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    if (cls.getLRStr(tcookiesid, ",", "left").equals("")) tcookiesid = cls.getLRStr(tcookiesid, ",", "rightr");
    if (cls.cidary(tcookiesid))
    {
      String[] tcookiesidAry = tcookiesid.split(Pattern.quote(","));
      for (int ti = 0; ti < tcookiesidAry.length; ti ++)
      {
        Integer tnid = cls.getNum(tcookiesidAry[ti], 0);
        String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tnid;
        dbc tDbc = db.newInstance(conf);
        Object[] tArys = tDbc.getDataAry(tsqlstr);
        if (tArys != null)
        {
          Object[][] tAry = (Object[][])tArys[0];
          Integer tid = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "id"));
          String tcookiesidInfo = cls.getSafeString(cookies.getAttribute(conf, conf.getAppKey("order-" + tid)));
          Double tprice = cls.getDouble(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "xprice"))), 0.00);
          ttotalprice += tprice * cls.getNum(tcookiesidInfo, 0);
          tmptstr = tmpastr;
          for (int tj = 0; tj < tAry.length; tj ++)
          {
            tAry[tj][0] = (Object)cls.getLRStr((String)tAry[tj][0], tfpre, "rightr");
            tmptstr = tmptstr.replace("{$" + cls.toString(tAry[tj][0]) + "}", encode.htmlencode(cls.toString(tAry[tj][1])));
          }
          tmptstr = tmptstr.replace("{$num}", cls.toString(cls.getNum(tcookiesidInfo, 0)));
          tmptstr = tmptstr.replace("{$-baseurl}", encode.htmlencode(conf.getActualRoute(tnfgenre)));
          tmptstr = conf.jt.creplace(tmptstr);
          tmprstr += tmptstr;
        }
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = tmpstr.replace("{$totalprice}", cls.formatDouble(ttotalprice, "0.00"));
    tmpstr = tmpstr.replace("{$-nfgenre}", encode.htmlencode(tnfgenre));
    Object[][] tnUserAry = account.getUserAry(account.nuserid);
    tmpstr = tmpstr.replace("{$-name}", encode.htmlencode(cls.toString(cls.getAryValue(tnUserAry, account.cfname("name")))));
    tmpstr = tmpstr.replace("{$-address}", encode.htmlencode(cls.toString(cls.getAryValue(tnUserAry, account.cfname("address")))));
    tmpstr = tmpstr.replace("{$-zipcode}", encode.htmlencode(cls.toString(cls.getAryValue(tnUserAry, account.cfname("zipcode")))));
    tmpstr = tmpstr.replace("{$-phone}", encode.htmlencode(cls.toString(cls.getAryValue(tnUserAry, account.cfname("phone")))));
    tmpstr = tmpstr.replace("{$-email}", encode.htmlencode(cls.toString(cls.getAryValue(tnUserAry, account.cfname("email")))));
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_MyList()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    Integer tpage = cls.getNum(conf.getRequestParameter("page"));
    String tnfgenre = cls.getString(conf.jt.itake("config.nfgenre", "cfg"));
    tmpstr = conf.jt.itake("default.mylist", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "uid") + "=" + account.nuserid + " order by " + cls.cfnames(tfpre, "time") + " desc";
    pagi pagi;
    pagi = new pagi(conf);
    pagi.sqlstr = tsqlstr;
    pagi.pagenum = tpage.longValue();
    pagi.rslimit = cls.getNum64(conf.jt.itake("config.nlisttopx", "cfg"));
    pagi.pagesize = cls.getNum64(conf.jt.itake("config.npagesize", "cfg"));
    pagi.Init();
    Object[] tArys = pagi.getDataAry();
    if (tArys != null)
    {
      for (int tis = 0; tis < tArys.length; tis ++)
      {
        tmptstr = tmpastr;
        Object[][] tAry = (Object[][])tArys[tis];
        for (int ti = 0; ti < tAry.length; ti ++)
        {
          tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
          tmptstr = tmptstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
        }
        tmprstr += tmptstr;
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = tmpstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
    tmpstr = tmpstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
    tmpstr = tmpstr.replace("{$-defmenu}", account.getDefMenuHtml());
    tmpstr = tmpstr.replace("{$-nfgenre}", encode.htmlencode(tnfgenre));
    tmpstr = tmpstr.replace("{$-npassport}", cls.getLRStr(conf.jt.itake("config.naccount", "cfg"), "/", "left"));
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_MyDetail()
  {
    Integer tId = cls.getNum(conf.getRequestParameter("id"), 0);
    String tnfgenre = cls.getString(conf.jt.itake("config.nfgenre", "cfg"));
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "uid") + "=" + account.nuserid + " and " + tidfield + "=" + tId;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      tmpstr = conf.jt.itake("default.mydetail", "tpl");
      Object[][] tAry = (Object[][])tArys[0];
      String tOlist = (String)tDbc.getValue(tAry, cls.cfnames(tfpre, "olist"));
      tmprstr = "";
      tmpastr = cls.ctemplate(tmpstr, "{@}");
      if (!cls.isEmpty(tOlist))
      {
        String[] tOlistAry = tOlist.split(Pattern.quote("|-|"));
        for (int tis = 0; tis < tOlistAry.length; tis ++)
        {
          String tval = tOlistAry[tis];
          if (!cls.isEmpty(tval))
          {
            String[] tvalAry = tval.split(Pattern.quote("|:|"));
            if (tvalAry.length == 3)
            {
              tmptstr = tmpastr;
              tmptstr = tmptstr.replace("{$-pid}", encode.htmlencode(tvalAry[0]));
              tmptstr = tmptstr.replace("{$-num}", encode.htmlencode(tvalAry[1]));
              tmptstr = tmptstr.replace("{$-price}", encode.htmlencode(tvalAry[2]));
              tmptstr = tmptstr.replace("{$-topic}", encode.htmlencode(PP_Get_Products_Topic(tvalAry[0])));
              tmprstr += tmptstr;
            }
          }
        }
      }
      tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
      tmpstr = tmpstr.replace("{$-defmenu}", account.getDefMenuHtml());
      tmpstr = tmpstr.replace("{$-nfgenre}", encode.htmlencode(tnfgenre));
      tmpstr = tmpstr.replace("{$-npassport}", cls.getLRStr(conf.jt.itake("config.naccount", "cfg"), "/", "left"));
      tmpstr = conf.jt.creplace(tmpstr);
    }
    return tmpstr;
  }

  private String Module_Default()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("default.default", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    if (cls.isEmpty(tmpstr)) tmpstr = Module_List();
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    PageNoCache();
    account = new account(conf);
    String tnaccount = conf.jt.itake("config.naccount", "cfg");
    account.Init(tnaccount);
    account.UserInit();
    conf.cntitle(conf.jt.itake("default.channel_title", "lng"));

    String tmpstr = "";
    if (!account.checkUserLogin()) tmpstr = conf.common.webMessages(conf.jt.itake("global." + tnaccount + ":default.manage-error-1", "lng"), conf.getActualRoute(tnaccount) + "?type=login&backurl=" + encode.base64encode(conf.getRequestURL().getBytes()));
    else
    {
      String tType = cls.getString(conf.getRequestParameter("type"));
      if (tType.equals("action")) tmpstr = Module_Action();
      else if (tType.equals("list")) tmpstr = Module_List();
      else if (tType.equals("mylist")) tmpstr = Module_MyList();
      else if (tType.equals("mydetail")) tmpstr = Module_MyDetail();
      else tmpstr = Module_Default();
    }

    PageClose();
    return tmpstr;
  }
}
%>