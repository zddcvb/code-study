<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%@ page import = "java.util.regex.Pattern" %>
<%
class module extends jpage
{
  private admin admin;

  private String PP_SelPopedom(String argPopedom, String argGenre)
  {
    int tstate = 0;
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tGenre = argGenre;
    String tPopedom = argPopedom;
    String tGenres1 = conf.getActiveGenre("guide", conf.getActualRouteB("./"));
    String tGenres2 = conf.getActiveGenre("category", conf.getActualRouteB("./"));
    String[] tGenres1Ary = tGenres1.split(Pattern.quote("|"));
    tmpstr = conf.jt.itake("manage-interface.data_popedom", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    for (int ti = 0; ti < tGenres1Ary.length; ti ++)
    {
      String tGenres1AryStr = tGenres1Ary[ti];
      if (!cls.isEmpty(tGenres1AryStr))
      {
        int tis = 0;
        if (cls.isEmpty(tGenre) && tGenres1AryStr.indexOf("/") == -1) tis = 1;
        if (!cls.isEmpty(tGenre) && cls.getLeft(tGenres1AryStr, tGenre.length() + 1).equals(tGenre + "/")  && cls.getLRStr(cls.getRight(tGenres1AryStr, tGenres1AryStr.length() - tGenre.length()), "/", "rightr").indexOf("/") == -1) tis = 1;
        if (tis == 1)
        {
          tstate = 1;
          tmptstr = tmpastr;
          tmptstr = tmptstr.replace("{$text}", conf.jt.itake("global." + tGenres1AryStr + ":manage.mgtitle", "lng"));
          tmptstr = tmptstr.replace("{$value}", encode.htmlencode(tGenres1AryStr));
          tmptstr = tmptstr.replace("{$-child}", PP_SelPopedom(tPopedom, tGenres1AryStr));
          if (cls.cinstr(tGenres2, tGenres1AryStr, "|") && cls.isEmpty(conf.jt.itake("global." + tGenres1AryStr + ":category.&hidden", "cfg")))
          {
            tmptstr = tmptstr.replace("{$-category-span-class}", "hand");
            tmptstr = tmptstr.replace("{$-category-input-value}", admin.getPopedomCategory(tPopedom, tGenres1AryStr));
          }
          else
          {
            tmptstr = tmptstr.replace("{$-category-span-class}", "hidden");
            tmptstr = tmptstr.replace("{$-category-input-value}", "-1");
          }
          if (!cls.isEmpty(tPopedom))
          {
            if (!cls.cinstr(tPopedom, tGenres1AryStr, ",")) tmptstr = tmptstr.replace("{$-checked}", "");
            else tmptstr = tmptstr.replace("{$-checked}", "checked=\"checked\"");
          }
          else tmptstr = tmptstr.replace("{$-checked}", "");
          tmprstr += tmptstr;
        }
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = conf.jt.creplace(tmpstr);
    if (tstate == 0) tmpstr = "";
    return tmpstr;
  }

  private String Module_Action_Add()
  {
    String tmpstr = "";
    String tdatabase = cls.getString(conf.jt.itake("global.config.admin-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.admin-nfpre", "cfg"));
    String tpopedom = "-1";
    Integer tutype = cls.getNum(conf.getRequestUsParameter("utype"), 0);
    if (tutype != -1)
    {
      tpopedom = "";
      String tpopedomstr = cls.getSafeString(conf.getRequestUsParameters("popedom"));
      if (!cls.isEmpty(tpopedomstr))
      {
        String[] tpopedomstrAry = tpopedomstr.split(Pattern.quote(","));
        for (int ti = 0; ti < tpopedomstrAry.length; ti ++)
        {
          String tpopedomstrArystr = tpopedomstrAry[ti].trim();
          String tcategoryStr = cls.getSafeString(conf.getRequestUsParameter(tpopedomstrArystr + "-category"));
          tpopedom += tpopedomstrArystr;
          if (!tcategoryStr.equals("-1")) tpopedom += ",[" + tcategoryStr + "]";
          tpopedom += ",";
        }
      }
      tpopedom = cls.getLRStr(tpopedom, ",", "leftr");
    }
    String tsqlstr = "insert into " + tdatabase + " (";
    tsqlstr += cls.cfnames(tfpre, "username") + ",";
    tsqlstr += cls.cfnames(tfpre, "password") + ",";
    tsqlstr += cls.cfnames(tfpre, "utype") + ",";
    tsqlstr += cls.cfnames(tfpre, "popedom") + ",";
    tsqlstr += cls.cfnames(tfpre, "lock") + ",";
    tsqlstr += cls.cfnames(tfpre, "time");
    tsqlstr += ") values (";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("username")), 50) + "',";
    tsqlstr += "'" + cls.getLeft(encode.md5(conf.getRequestUsParameter("password").getBytes()), 50) + "',";
    tsqlstr += tutype + ",";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(tpopedom), 10000) + "',";
    tsqlstr += cls.getNum(conf.getRequestUsParameter("lock"), 0) + ",";
    tsqlstr += "'" + cls.getDate() + "'";
    tsqlstr += ")";
    dbc tDbc = db.newInstance(conf);
    int tstateNum = tDbc.Executes(tsqlstr);
    if (tstateNum != -101) tmpstr = conf.jt.itake("global.lng_common.add-succeed", "lng");
    else tmpstr = conf.jt.itake("global.lng_common.add-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Edit()
  {
    String tmpstr = "";
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    admin.removeMenuHtmlCacheData(tid);
    String tdatabase = cls.getString(conf.jt.itake("global.config.admin-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.admin-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tpopedom = "-1";
    Integer tutype = cls.getNum(conf.getRequestUsParameter("utype"), 0);
    if (tutype != -1)
    {
      tpopedom = "";
      String tpopedomstr = cls.getSafeString(conf.getRequestUsParameters("popedom"));
      if (!cls.isEmpty(tpopedomstr))
      {
        String[] tpopedomstrAry = tpopedomstr.split(Pattern.quote(","));
        for (int ti = 0; ti < tpopedomstrAry.length; ti ++)
        {
          String tpopedomstrArystr = tpopedomstrAry[ti].trim();
          String tcategoryStr = cls.getSafeString(conf.getRequestUsParameter(tpopedomstrArystr + "-category"));
          tpopedom += tpopedomstrArystr;
          if (!tcategoryStr.equals("-1")) tpopedom += ",[" + tcategoryStr + "]";
          tpopedom += ",";
        }
      }
      tpopedom = cls.getLRStr(tpopedom, ",", "leftr");
    } 

    String tsqlstr = "update " + tdatabase + " set ";
    tsqlstr += cls.cfnames(tfpre, "username") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("username")), 50) + "',";
    if (!cls.isEmpty(conf.getRequestUsParameter("password"))) tsqlstr += cls.cfnames(tfpre, "password") + "='" + cls.getLeft(encode.md5(conf.getRequestUsParameter("password").getBytes()), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "utype") + "=" + tutype + ",";
    tsqlstr += cls.cfnames(tfpre, "popedom") + "='" + cls.getLeft(encode.addslashes(tpopedom), 10000) + "',";
    tsqlstr += cls.cfnames(tfpre, "lock") + "=" + cls.getNum(conf.getRequestUsParameter("lock"), 0);
    tsqlstr += " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    int tstateNum = tDbc.Executes(tsqlstr);
    if (tstateNum != -101) tmpstr = conf.jt.itake("global.lng_common.edit-succeed", "lng");
    else tmpstr = conf.jt.itake("global.lng_common.edit-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Delete()
  {
    String tstate = "200";
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String tdatabase = cls.getString(conf.jt.itake("global.config.admin-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.admin-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = conf.common.dataDelete(tdatabase, tidfield, cls.toString(tid));
    if (tstateNum == -101) tstate = "-101";
    return tstate;
  }

  private String Module_Action_Switch()
  {
    String tstate = "200";
    String tids = cls.getString(conf.getRequestUsParameter("ids"));
    String tswtype = cls.getString(conf.getRequestUsParameter("swtype"));
    String tdatabase = cls.getString(conf.jt.itake("global.config.admin-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.admin-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = 0;
    if (tswtype.equals("lock")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "lock"), tidfield, tids);
    else if (tswtype.equals("delete")) tstateNum = conf.common.dataDelete(tdatabase, tidfield, tids);
    if (tstateNum == -101) tstate = "-101";
    return tstate;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("add")) tmpstr = Module_Action_Add();
    else if (tAtype.equals("edit")) tmpstr = Module_Action_Edit();
    else if (tAtype.equals("delete")) tmpstr = Module_Action_Delete();
    else if (tAtype.equals("switch")) tmpstr = Module_Action_Switch();
    return tmpstr;
  }

  private String Module_Add()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("manage-interface.add", "tpl");
    tmpstr = tmpstr.replace("{$-popedom}", PP_SelPopedom("", ""));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Edit()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    String tdatabase = cls.getString(conf.jt.itake("global.config.admin-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.admin-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tId;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      tmpstr = conf.jt.itake("manage-interface.edit", "tpl");
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
      tmpstr = tmpstr.replace("{$-popedom}", PP_SelPopedom(cls.toString(tDbc.getValue(tAry, "popedom")), ""));
      tmpstr = conf.jt.creplace(tmpstr);
    }
    else tmpstr = conf.jt.itake("global.lng_common.edit-404", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    Integer tpage = cls.getNum(conf.getRequestUsParameter("page"));
    String tfield = cls.getSafeString(conf.getRequestUsParameter("field"));
    String tkeyword = cls.getSafeString(conf.getRequestUsParameter("keyword"));
    tmpstr = conf.jt.itake("manage-interface.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("global.config.admin-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.admin-nfpre", "cfg"));
    String tsqlstr = "select * from " + tdatabase + " where 1=1";
    if (tfield.equals("username")) tsqlstr += " and " + cls.cfnames(tfpre, "username") + " like '%" + tkeyword + "%'";
    if (tfield.equals("lock")) tsqlstr += " and " + cls.cfnames(tfpre, "lock") + "=" + cls.getNum(tkeyword);
    if (tfield.equals("id")) tsqlstr += " and " + cls.cfnames(tfpre, "id") + "=" + cls.getNum(tkeyword);
    tsqlstr += " order by " + cls.cfnames(tfpre, "time") + " desc";
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
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Category()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tgenre = cls.getSafeString(conf.getRequestUsParameter("genre"));
    String tvalue = cls.getSafeString(conf.getRequestUsParameter("value"));
    tmpstr = conf.jt.itake("manage-interface.category", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String[][] tAry = conf.jt.itakes("global.sel_lng.all", "sel");
    for (int ti = 0; ti < tAry.length; ti ++)
    {
      String tValue = tAry[ti][0];
      String tText = tAry[ti][1];
      if (!cls.isEmpty(tValue) && tValue.indexOf(":") != -1)
      {
        String[] tValueAry = tValue.split(Pattern.quote(":"));
        tmptstr = tmpastr;
        tmptstr = tmptstr.replace("{$text}", encode.htmlencode(tText));
        tmptstr = tmptstr.replace("{$-category}", conf.common.isort("tpl=manage-interface.data_category;genre=" + tgenre + ";lng=" + tValueAry[1] + ";vars=-genre=" + tgenre + "|-lng=" + tValueAry[1]));
        tmprstr += tmptstr;
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = tmpstr.replace("{$genre}", encode.htmlencode(tgenre));
    tmpstr = tmpstr.replace("{$value}", encode.htmlencode(tvalue));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    PageNoCache();

    String tmpstr = "";

    admin = new admin(conf);

    if (admin.ckLogin())
    {
      String tType = cls.getString(conf.getRequestUsParameter("type"));

      if (tType.equals("action")) tmpstr = Module_Action();
      else if (tType.equals("add")) tmpstr = Module_Add();
      else if (tType.equals("edit")) tmpstr = Module_Edit();
      else if (tType.equals("list")) tmpstr = Module_List();
      else if (tType.equals("category")) tmpstr = Module_Category();
      else tmpstr = Module_List();
    }

    PageClose();

    return tmpstr;
  }
}
%>