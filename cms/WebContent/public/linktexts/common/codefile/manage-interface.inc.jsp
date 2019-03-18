<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private admin admin;

  private String Module_Action_Createjs()
  {
    String tstate = "-101";
    String tfield = cls.getSafeString(conf.getRequestUsParameter("field"));
    String tkeyword = cls.getSafeString(conf.getRequestUsParameter("keyword"));
    String tjs_name = cls.getSafeString(conf.getRequestUsParameter("js_name"));
    String tjs_tpl = cls.getSafeString(conf.getRequestUsParameter("js_tpl"));
    if (validator.isNatural(tjs_name))
    {
      String tmpstr = "";
      String tmpastr, tmprstr, tmptstr;
      tmpstr = conf.jt.itake("manage-interface-jstpl." + tjs_tpl, "tpl");
      tmprstr = "";
      tmpastr = cls.ctemplate(tmpstr, "{@}");
      String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
      String tsqlstr = "select * from " + tdatabase + " where 1=1";
      if (tfield.equals("topic")) tsqlstr += " and " + cls.cfnames(tfpre, "topic") + " like '%" + tkeyword + "%'";
      if (tfield.equals("keyword")) tsqlstr += " and " + cls.cfnames(tfpre, "keyword") + " like '%" + tkeyword + "%'";
      if (tfield.equals("id")) tsqlstr += " and " + cls.cfnames(tfpre, "id") + "=" + cls.getNum(tkeyword);
      tsqlstr += " order by " + cls.cfnames(tfpre, "time") + " desc";
      dbc tDbc = db.newInstance(conf);
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        for (int tis = 0; tis < tArys.length; tis ++)
        {
          tmptstr = tmpastr;
          Object[][] tAry = (Object[][])tArys[tis];
          for (int ti = 0; ti < tAry.length; ti ++)
          {
            tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
            tmptstr = tmptstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.scriptencode(encode.htmlencode(cls.toString(tAry[ti][1]))));
          }
          tmprstr += tmptstr;
        }
      }
      tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
      tmpstr = conf.jt.creplace(tmpstr);
      if (conf.common.filePutContents(conf.application.getRealPath(conf.getMapPath("common/js/" + tjs_name + ".js")).toString(), tmpstr)) tstate = "200";
    }
    return tstate;
  }

  private String Module_Action_Add()
  {
    String tmpstr = "";
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "insert into " + tdatabase + " (";
    tsqlstr += cls.cfnames(tfpre, "topic") + ",";
    tsqlstr += cls.cfnames(tfpre, "keyword") + ",";
    tsqlstr += cls.cfnames(tfpre, "url") + ",";
    tsqlstr += cls.cfnames(tfpre, "intro") + ",";
    tsqlstr += cls.cfnames(tfpre, "time");
    tsqlstr += ") values (";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("keyword")), 255) + "',";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("url")), 255) + "',";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("intro")), 255) + "',";
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
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "update " + tdatabase + " set ";
    tsqlstr += cls.cfnames(tfpre, "topic") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "keyword") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("keyword")), 255) + "',";
    tsqlstr += cls.cfnames(tfpre, "url") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("url")), 255) + "',";
    tsqlstr += cls.cfnames(tfpre, "intro") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("intro")), 255) + "',";
    tsqlstr += cls.cfnames(tfpre, "time") + "='" + cls.getDate(conf.getRequestUsParameter("time")) + "'";
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
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
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
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = 0;
    if (tswtype.equals("delete")) tstateNum = conf.common.dataDelete(tdatabase, tidfield, tids);
    if (tstateNum == -101) tstate = "-101";
    return tstate;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("createjs")) tmpstr = Module_Action_Createjs();
    else if (tAtype.equals("add")) tmpstr = Module_Action_Add();
    else if (tAtype.equals("edit")) tmpstr = Module_Action_Edit();
    else if (tAtype.equals("delete")) tmpstr = Module_Action_Delete();
    else if (tAtype.equals("switch")) tmpstr = Module_Action_Switch();
    return tmpstr;
  }

  private String Module_Createjs()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    tmpstr = conf.jt.itake("manage-interface.createjs", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String[][] tAry = conf.jt.itakes("manage-interface-jstpl.all", "tpl");
    for (int ti = 0; ti < tAry.length; ti ++)
    {
      String tValue = tAry[ti][0];
      tmptstr = tmpastr;
      tmptstr = tmptstr.replace("{$value}", encode.htmlencode(tValue));
      tmprstr += tmptstr;
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
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
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
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
    String tfield = cls.getSafeString(conf.getRequestUsParameter("field"));
    String tkeyword = cls.getSafeString(conf.getRequestUsParameter("keyword"));
    tmpstr = conf.jt.itake("manage-interface.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tsqlstr = "select * from " + tdatabase + " where 1=1";
    if (tfield.equals("topic")) tsqlstr += " and " + cls.cfnames(tfpre, "topic") + " like '%" + tkeyword + "%'";
    if (tfield.equals("keyword")) tsqlstr += " and " + cls.cfnames(tfpre, "keyword") + " like '%" + tkeyword + "%'";
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
      else if (tType.equals("createjs")) tmpstr = Module_Createjs();
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