<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%@ page import = "java.util.regex.Pattern" %>
<%
class module extends jpage
{
  private admin admin;

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
        tmprstr = tmptstr + tmprstr;
        tId = cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "fid"))), 0);
      }
    }
    while (tId != 0);
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private Integer PP_DeleteChildRecord(Integer argFid)
  {
    Integer tFid = argFid;
    Integer tstate = 0;
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
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
    Integer tRSCount = 0;
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select count(*) from " + tdatabase + " where " + cls.cfnames(tfpre, "fid") + "=" + tfid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null) tRSCount = cls.getNum(cls.toString(tDbc.getValue((Object[][])tArys[0], 0)), 0);
    tsqlstr = "insert into " + tdatabase + " (";
    tsqlstr += cls.cfnames(tfpre, "topic") + ",";
    tsqlstr += cls.cfnames(tfpre, "fid") + ",";
    tsqlstr += cls.cfnames(tfpre, "itype") + ",";
    tsqlstr += cls.cfnames(tfpre, "popedom") + ",";
    tsqlstr += cls.cfnames(tfpre, "image") + ",";
    tsqlstr += cls.cfnames(tfpre, "manager") + ",";
    tsqlstr += cls.cfnames(tfpre, "rule") + ",";
    tsqlstr += cls.cfnames(tfpre, "explain") + ",";
    tsqlstr += cls.cfnames(tfpre, "hidden") + ",";
    tsqlstr += cls.cfnames(tfpre, "order") + ",";
    tsqlstr += cls.cfnames(tfpre, "time") + ",";
    tsqlstr += cls.cfnames(tfpre, "lng");
    tsqlstr += ") values (";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
    tsqlstr += tfid + ",";
    tsqlstr += cls.getNum(conf.getRequestUsParameter("itype"), 0) + ",";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameters("popedom")), 255) + "',";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("image")), 255) + "',";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("manager")), 255) + "',";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("rule")), 10000) + "',";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("explain")), 255) + "',";
    tsqlstr += cls.getNum(conf.getRequestUsParameter("hidden"), 0) + ",";
    tsqlstr += tRSCount + ",";
    tsqlstr += "'" + cls.getDate() + "',";
    tsqlstr += admin.slng;
    tsqlstr += ")";
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
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      Integer tlng = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "lng"));
      tsqlstr = "update " + tdatabase + " set ";
      tsqlstr += cls.cfnames(tfpre, "topic") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
      tsqlstr += cls.cfnames(tfpre, "itype") + "=" + cls.getNum(conf.getRequestUsParameter("itype"), 0) + ",";
      tsqlstr += cls.cfnames(tfpre, "popedom") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameters("popedom")), 255) + "',";
      tsqlstr += cls.cfnames(tfpre, "image") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("image")), 255) + "',";
      tsqlstr += cls.cfnames(tfpre, "manager") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("manager")), 255) + "',";
      tsqlstr += cls.cfnames(tfpre, "rule") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("rule")), 10000) + "',";
      tsqlstr += cls.cfnames(tfpre, "explain") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("explain")), 255) + "',";
      tsqlstr += cls.cfnames(tfpre, "hidden") + "=" + cls.getNum(conf.getRequestUsParameter("hidden"), 0);
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
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      Integer tfid = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "fid"));
      Integer torder = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "order"));
      Integer tlng = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "lng"));
      String tsqlstr2 = "select count(*) from " + tdatabase + " where " + cls.cfnames(tfpre, "fid") + "=" + tfid + " and " + cls.cfnames(tfpre, "lng") + "=" + admin.slng;
      Object[] tArys2 = tDbc.getDataAry(tsqlstr2);
      Integer tCount = cls.getNum(cls.toString(tDbc.getValue((Object[][])tArys2[0], 0)), 0);
      if (tat.equals("down"))
      {
        Integer tnum = torder + 1;
        if (tnum <= (tCount - 1))
        {
          tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "order") + "=" + cls.cfnames(tfpre, "order") + "-1 where " + cls.cfnames(tfpre, "fid") + "=" + tfid + " and " + cls.cfnames(tfpre, "lng") + "=" + admin.slng + " and " + cls.cfnames(tfpre, "order") + "=" + tnum);
          tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "order") + "=" + tnum + " where " + tidfield + "=" + tid);
        }
      }
      else
      {
        Integer tnum = torder - 1;
        if (tnum >= 0)
        {
          tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "order") + "=" + cls.cfnames(tfpre, "order") + "+1 where " + cls.cfnames(tfpre, "fid") + "=" + tfid + " and " + cls.cfnames(tfpre, "lng") + "=" + admin.slng + " and " + cls.cfnames(tfpre, "order") + "=" + tnum);
          tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "order") + "=" + tnum + " where " + tidfield + "=" + tid);
        }
      }
    }
    return tstate;
  }

  private String Module_Action_Reorder()
  {
    String tstate = "200";
    Integer tfid = cls.getNum(conf.getRequestUsParameter("fid"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "lng") + "=" + admin.slng + " and " + cls.cfnames(tfpre, "fid") + "=" + tfid + " order by " + tidfield + " asc";
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
    return tstate;
  }

  private String Module_Action_Delete()
  {
    String tstate = "200";
    Integer tstateNum = 0;
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      Integer tlng = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "lng"));
      tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "order") + "=" + cls.cfnames(tfpre, "order") + "-1 where " + cls.cfnames(tfpre, "lng") + "=" + (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "lng")) + " and " + cls.cfnames(tfpre, "fid") + "=" + (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "fid")) + " and " + cls.cfnames(tfpre, "order") + ">" + (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "order")));
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
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
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
    return tmpstr;
  }

  private String Module_Add()
  {
    String tmpstr = "";
    Integer tfid = cls.getNum(conf.getRequestUsParameter("fid"), 0);
    if (tfid.equals(0)) tmpstr = conf.jt.itake("manage_category-interface.add-1", "tpl");
    else tmpstr = conf.jt.itake("manage_category-interface.add-2", "tpl");
    tmpstr = tmpstr.replace("{$-fid}", cls.toString(tfid));
    tmpstr = tmpstr.replace("{$-naccount}", cls.toString(conf.jt.itake("config.naccount", "cfg")));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Edit()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tId;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      Integer tfid = cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "fid"))), 0);
      if (tfid.equals(0)) tmpstr = conf.jt.itake("manage_category-interface.edit-1", "tpl");
      else tmpstr = conf.jt.itake("manage_category-interface.edit-2", "tpl");
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
      tmpstr = tmpstr.replace("{$-fid}", cls.toString(tfid));
      tmpstr = tmpstr.replace("{$-naccount}", cls.toString(conf.jt.itake("config.naccount", "cfg")));
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
    tmpstr = conf.jt.itake("manage_category-interface.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "lng") + "=" + admin.slng + " and " + cls.cfnames(tfpre, "fid") + "=" + tfid + " order by " + cls.cfnames(tfpre, "order") + " asc";
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
    tmpstr = tmpstr.replace("{$-fid}", cls.toString(tfid));
    tmpstr = tmpstr.replace("{$-naccount}", cls.toString(conf.jt.itake("config.naccount", "cfg")));
    tmpstr = tmpstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
    tmpstr = tmpstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
    tmpstr = tmpstr.replace("{$category.FaCatHtml}", PP_GetFaCatHtml(conf.jt.itake("manage_category-interface.data_fa_category", "tpl"), admin.slng, tfid));
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
      else tmpstr = Module_List();
    }

    PageClose();

    return tmpstr;
  }
}
%>