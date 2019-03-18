<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%@ page import = "java.util.regex.Pattern" %>
<%
class module extends jpage
{
  private admin admin;
  private category category;

  private Integer PP_DeleteChildRecord(Integer argFid)
  {
    Integer tFid = argFid;
    Integer tstate = 0;
    String tdatabase = cls.getString(conf.jt.itake("global.config.sys->category-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.sys->category-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "fid") + "=" + tFid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      for (int ti = 0; ti < tArys.length; ti ++)
      {
        int tstateNum = 0;
        Object[][] tAry = (Object[][])tArys[ti];
        Integer tid = (Integer)tDbc.getValue(tAry, tidfield);
        tstateNum = PP_DeleteChildRecord(tid);
        if (tstateNum == -101) tstate = -101;
        else
        {
          tstateNum = conf.common.dataDelete(tdatabase, tidfield, cls.toString(tid));
          if (tstateNum == -101) tstate = -101;
        }
      }
    }
    return tstate;
  }

  private String Module_Action_Add()
  {
    String tmpstr = "";
    Integer tfid = cls.getNum(conf.getRequestUsParameter("fid"), 0);
    String tgenre = cls.getSafeString(conf.getRequestUsParameter("genre"));
    if (cls.isEmpty(tgenre)) tmpstr = conf.jt.itake("manage.add-error-1", "lng");
    else
    {
      Integer tRSCount = 0;
      String tdatabase = cls.getString(conf.jt.itake("global.config.sys->category-ndatabase", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("global.config.sys->category-nfpre", "cfg"));
      String tidfield = cls.cfnames(tfpre, "id");
      String tsqlstr = "select count(*) from " + tdatabase + " where " + cls.cfnames(tfpre, "fid") + "=" + tfid + " and " + cls.cfnames(tfpre, "genre") + "='" + tgenre + "'";
      dbc tDbc = db.newInstance(conf);
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null) tRSCount = cls.getNum(cls.toString(tDbc.getValue((Object[][])tArys[0], 0)), 0);
      tsqlstr = "insert into " + tdatabase + " (";
      tsqlstr += cls.cfnames(tfpre, "topic") + ",";
      tsqlstr += cls.cfnames(tfpre, "fid") + ",";
      tsqlstr += cls.cfnames(tfpre, "genre") + ",";
      tsqlstr += cls.cfnames(tfpre, "order") + ",";
      tsqlstr += cls.cfnames(tfpre, "lng");
      tsqlstr += ") values (";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
      tsqlstr += tfid + ",";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(tgenre), 50) + "',";
      tsqlstr += tRSCount + ",";
      tsqlstr += admin.slng;
      tsqlstr += ")";
      int tstateNum = tDbc.Executes(tsqlstr);
      if (tstateNum != -101) tmpstr = conf.jt.itake("global.lng_common.add-succeed", "lng");
      else tmpstr = conf.jt.itake("global.lng_common.add-failed", "lng");
      category.removeCacheData(tgenre, admin.slng);
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Edit()
  {
    String tmpstr = "";
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String tdatabase = cls.getString(conf.jt.itake("global.config.sys->category-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.sys->category-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      String tgenre = (String)tDbc.getValue(tAry, cls.cfnames(tfpre, "genre"));
      Integer tlng = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "lng"));
      category.removeCacheData(tgenre, tlng);
      tsqlstr = "update " + tdatabase + " set ";
      tsqlstr += cls.cfnames(tfpre, "topic") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "'";
      tsqlstr += " where " + tidfield + "=" + tid;
      int tstateNum = tDbc.Executes(tsqlstr);
      if (tstateNum != -101) tmpstr = conf.jt.itake("global.lng_common.edit-succeed", "lng");
      else tmpstr = conf.jt.itake("global.lng_common.edit-failed", "lng");
      tmpstr = conf.ajaxPreContent + tmpstr;
    }
    return tmpstr;
  }

  private String Module_Action_Order()
  {
    String tstate = "200";
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String tat = cls.getSafeString(conf.getRequestUsParameter("at"));
    String tdatabase = cls.getString(conf.jt.itake("global.config.sys->category-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.sys->category-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      Integer tfid = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "fid"));
      Integer torder = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "order"));
      String tgenre = (String)tDbc.getValue(tAry, cls.cfnames(tfpre, "genre"));
      Integer tlng = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "lng"));
      String tsqlstr2 = "select count(*) from " + tdatabase + " where " + cls.cfnames(tfpre, "fid") + "=" + tfid + " and " + cls.cfnames(tfpre, "genre") + "='" + encode.addslashes(tgenre) + "' and " + cls.cfnames(tfpre, "lng") + "=" + admin.slng;
      Object[] tArys2 = tDbc.getDataAry(tsqlstr2);
      Integer tCount = cls.getNum(cls.toString(tDbc.getValue((Object[][])tArys2[0], 0)), 0);
      if (tat.equals("down"))
      {
        Integer tnum = torder + 1;
        if (tnum <= (tCount - 1))
        {
          tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "order") + "=" + cls.cfnames(tfpre, "order") + "-1 where " + cls.cfnames(tfpre, "fid") + "=" + tfid + " and " + cls.cfnames(tfpre, "genre") + "='" + encode.addslashes(tgenre) + "' and " + cls.cfnames(tfpre, "lng") + "=" + admin.slng + " and " + cls.cfnames(tfpre, "order") + "=" + tnum);
          tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "order") + "=" + tnum + " where " + tidfield + "=" + tid);
        }
      }
      else
      {
        Integer tnum = torder - 1;
        if (tnum >= 0)
        {
          tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "order") + "=" + cls.cfnames(tfpre, "order") + "+1 where " + cls.cfnames(tfpre, "fid") + "=" + tfid + " and " + cls.cfnames(tfpre, "genre") + "='" + encode.addslashes(tgenre) + "' and " + cls.cfnames(tfpre, "lng") + "=" + admin.slng + " and " + cls.cfnames(tfpre, "order") + "=" + tnum);
          tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "order") + "=" + tnum + " where " + tidfield + "=" + tid);
        }
      }
      category.removeCacheData(tgenre, tlng);
    }
    return tstate;
  }

  private String Module_Action_Reorder()
  {
    String tstate = "200";
    Integer tfid = cls.getNum(conf.getRequestUsParameter("fid"));
    String tgenre = cls.getSafeString(conf.getRequestUsParameter("genre"));
    String tdatabase = cls.getString(conf.jt.itake("global.config.sys->category-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.sys->category-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "lng") + "=" + admin.slng + " and " + cls.cfnames(tfpre, "genre") + "='" + tgenre + "' and " + cls.cfnames(tfpre, "fid") + "=" + tfid + " order by " + tidfield + " asc";
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      for (int ti = 0; ti < tArys.length; ti ++)
      {
        Object[][] tAry = (Object[][])tArys[ti];
        Integer tmpId = (Integer)tDbc.getValue(tAry, tidfield);
        tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "order") + "=" + ti + " where " + tidfield + "=" + tmpId);
      }
    }
    category.removeCacheData(tgenre, admin.slng);
    return tstate;
  }

  private String Module_Action_Delete()
  {
    String tstate = "200";
    Integer tstateNum = 0;
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String tdatabase = cls.getString(conf.jt.itake("global.config.sys->category-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.sys->category-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      String tgenre = (String)tDbc.getValue(tAry, cls.cfnames(tfpre, "genre"));
      Integer tlng = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "lng"));
      category.removeCacheData(tgenre, tlng);
      tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "order") + "=" + cls.cfnames(tfpre, "order") + "-1 where " + cls.cfnames(tfpre, "genre") + "='" + encode.addslashes(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "genre")))) + "' and " + cls.cfnames(tfpre, "lng") + "=" + (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "lng")) + " and " + cls.cfnames(tfpre, "fid") + "=" + (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "fid")) + " and " + cls.cfnames(tfpre, "order") + ">" + (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "order")));
      tstateNum = PP_DeleteChildRecord(tid);
    }
    if (tstateNum == -101) tstate = "-101";
    else
    {
      tstateNum = conf.common.dataDelete(tdatabase, tidfield, cls.toString(tid));
      if (tstateNum == -101) tstate = "-101";
    }
    return tstate;
  }

  private String Module_Action_Switch()
  {
    String tstate = "200";
    String tids = cls.getString(conf.getRequestUsParameter("ids"));
    String tswtype = cls.getString(conf.getRequestUsParameter("swtype"));
    String tdatabase = cls.getString(conf.jt.itake("global.config.sys->category-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.sys->category-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = 0;
    if (tswtype.equals("hidden")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "hidden"), tidfield, tids);
    if (tstateNum == -101) tstate = "-101";
    return tstate;
  }

  private String Module_Action_Selslng()
  {
    String tmpstr = "";
    String tlng = cls.getString(conf.getRequestUsParameter("lng"));
    if (!cls.isEmpty(tlng))
    {
      tmpstr = "200";
      cookies.setAttribute(conf, conf.getAppKey("admin-slng"), tlng);
    }
    else
    {
      tmpstr = admin.selslng();
      tmpstr = conf.ajaxPreContent + tmpstr;
    }
    return tmpstr;
  }

  private String Module_Action_Selcolumn()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tgenre = cls.getString(conf.getRequestUsParameter("genre"));
    String tATGenre = conf.getActiveGenre("category", conf.getActualRouteB("./"));
    String[] tATGenreAry = tATGenre.split(Pattern.quote("|"));
    String[][] tCategoryAry = null;
    for (int ti = 0; ti < tATGenreAry.length; ti ++)
    {
      String tATGenreAryString = tATGenreAry[ti];
      if (!cls.isEmpty(tATGenreAryString))
      {
        String[][] tAry = conf.jt.itakes("global." + tATGenreAryString + ":category.all", "cfg");
        for (int tis = 0; tis < tAry.length; tis ++)
        {
          tAry[tis][0] = tAry[tis][0].replace("{$folder}", tATGenreAryString);
          tAry[tis][1] = conf.jt.creplace(tAry[tis][1].replace("{$folder}", tATGenreAryString));
        }
        tCategoryAry = cls.mergeAry(tCategoryAry, tAry);
      }
    }
    if (tCategoryAry != null)
    {
      tmpstr = conf.jt.itake("manage-interface.data_column", "tpl");
      tmprstr = "";
      tmpastr = cls.ctemplate(tmpstr, "{@}");
      for (int tis = 0; tis < tCategoryAry.length; tis ++)
      {
        tmptstr = tmpastr;
        String tGenreString = cls.getString(tCategoryAry[tis][0]);
        String tGenreTextString = cls.getLeft(tGenreString, 20);
        String tGenreNameString = cls.getString(tCategoryAry[tis][1]);
        if (tGenreString.equals("&hidden")) tmptstr = "";
        else
        {
          tmptstr = tmptstr.replace("{$genre}", encode.htmlencode(tGenreString));
          tmptstr = tmptstr.replace("{$genre-text}", encode.htmlencode(tGenreTextString));
          tmptstr = tmptstr.replace("{$genre-name}", encode.htmlencode(tGenreNameString));
          if (!tGenreString.equals(tgenre)) tmptstr = tmptstr.replace("{$selected}", "");
          else tmptstr = tmptstr.replace("{$selected}", " selected=\"selected\"");
        }
        tmprstr += tmptstr;
      }
      tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
      tmpstr = conf.jt.creplace(tmpstr);
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("add")) tmpstr = Module_Action_Add();
    else if (tAtype.equals("edit")) tmpstr = Module_Action_Edit();
    else if (tAtype.equals("order")) tmpstr = Module_Action_Order();
    else if (tAtype.equals("reorder")) tmpstr = Module_Action_Reorder();
    else if (tAtype.equals("delete")) tmpstr = Module_Action_Delete();
    else if (tAtype.equals("switch")) tmpstr = Module_Action_Switch();
    else if (tAtype.equals("selslng")) tmpstr = Module_Action_Selslng();
    else if (tAtype.equals("selcolumn")) tmpstr = Module_Action_Selcolumn();
    return tmpstr;
  }

  private String Module_Add()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("manage-interface.add", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Edit()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    String tdatabase = cls.getString(conf.jt.itake("global.config.sys->category-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.sys->category-nfpre", "cfg"));
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
    Integer tfid = cls.getNum(conf.getRequestUsParameter("fid"), 0);
    String tgenre = cls.getSafeString(conf.getRequestUsParameter("genre"));
    tmpstr = conf.jt.itake("manage-interface.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("global.config.sys->category-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.sys->category-nfpre", "cfg"));
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "lng") + "=" + admin.slng + " and " + cls.cfnames(tfpre, "genre") + "='" + tgenre + "' and " + cls.cfnames(tfpre, "fid") + "=" + tfid + " order by " + cls.cfnames(tfpre, "order") + " asc";
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
    tmpstr = tmpstr.replace("{$category.FaCatHtml}", category.getFaCatHtml(conf.jt.itake("manage-interface.data_fa_category", "tpl"), tgenre, admin.slng, tfid));
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
    category = new category(conf);

    if (admin.ckLogin())
    {
      String tType = cls.getString(conf.getRequestUsParameter("type"));

      if (tType.equals("action")) tmpstr = Module_Action();
      else if (tType.equals("add")) tmpstr = Module_Add();
      else if (tType.equals("edit")) tmpstr = Module_Edit();
      else if (tType.equals("list")) tmpstr = Module_List();
      else tmpstr = Module_List();
    }

    PageClose();

    return tmpstr;
  }
}
%>