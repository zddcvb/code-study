<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private admin admin;

  private String Module_Action_Add()
  {
    String tstate = "-101";
    int tuid = admin.id;
    String tdatabase = cls.getString(conf.jt.itake("global.config.admin-userlnk-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.admin-userlnk-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String ttopic = cls.getString(conf.getRequestUsParameter("topic"));
    String ticon = cls.getString(conf.getRequestUsParameter("icon"));
    String turl = cls.getString(conf.getRequestUsParameter("url"));
    if (!cls.isEmpty(ticon))
    {
      ticon = ticon.replace(conf.getNURLPre() + cls.getLRStr(conf.getNURI(), conf.getNGenre(), "left"), "");
      if (ticon.substring(0, 1).equals(".")) ticon = cls.getLRStr(ticon, "/", "rightr");
      ticon = conf.getActualRoute(ticon, "node");
      turl = turl.replace(conf.getNURLPre() + cls.getLRStr(conf.getNURI(), conf.getNGenre(), "left"), "");
      if (turl.substring(0, 1).equals(".")) turl = cls.getLRStr(turl, "/", "rightr");
      turl = conf.getActualRoute(turl, "node");
      String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "url") + "='" + encode.addslashes(turl) + "' and " + cls.cfnames(tfpre, "uid") + "=" + tuid;
      dbc tDbc = db.newInstance(conf);
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys == null)
      {
        tsqlstr = "insert into " + tdatabase + " (";
        tsqlstr += cls.cfnames(tfpre, "topic") + ",";
        tsqlstr += cls.cfnames(tfpre, "icon") + ",";
        tsqlstr += cls.cfnames(tfpre, "title") + ",";
        tsqlstr += cls.cfnames(tfpre, "url") + ",";
        tsqlstr += cls.cfnames(tfpre, "width") + ",";
        tsqlstr += cls.cfnames(tfpre, "height") + ",";
        tsqlstr += cls.cfnames(tfpre, "uid") + ",";
        tsqlstr += cls.cfnames(tfpre, "time");
        tsqlstr += ") values (";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(ttopic), 50) + "',";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(ticon.replace("1.png", "0.png")), 255) + "',";
        tsqlstr += "'" + cls.getLeft("&lt;img src=&quot;" + encode.addslashes(ticon) + "&quot; width=&quot;18&quot; height=&quot;18&quot; class=&quot;absmiddle&quot; /&gt;&nbsp;" + encode.addslashes(ttopic), 255) + "',";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(turl), 255) + "',";
        tsqlstr += "-1,";
        tsqlstr += "-1,";
        tsqlstr += "" + tuid + ",";
        tsqlstr += "'" + cls.getDate() + "'";
        tsqlstr += ")";
        int tstateNum = tDbc.Executes(tsqlstr);
        if (tstateNum != -101) tstate = "200";
      }
    }
    return tstate;
  }

  private String Module_Action_Remove()
  {
    String tstate = "-101";
    int tuid = admin.id;
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String tdatabase = cls.getString(conf.jt.itake("global.config.admin-userlnk-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.admin-userlnk-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = conf.common.dataDelete(tdatabase, tidfield, cls.toString(tid), " and " + cls.cfnames(tfpre, "uid") + "=" + tuid);
    if (tstateNum != -101) tstate = "200";
    return tstate;
  }

  private String Module_Action_Rename()
  {
    String tstate = "-101";
    int tuid = admin.id;
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String ttopic = cls.getString(conf.getRequestUsParameter("topic"));
    String tdatabase = cls.getString(conf.jt.itake("global.config.admin-userlnk-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.admin-userlnk-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "update " + tdatabase + " set " + cls.cfnames(tfpre, "topic") + "='" + cls.getLeft(encode.addslashes(ttopic), 50) + "' where " + tidfield + "=" + tid + " and " + cls.cfnames(tfpre, "uid") + "=" + tuid;
    dbc tDbc = db.newInstance(conf);
    Integer tstateNum = tDbc.Executes(tsqlstr);
    if (tstateNum != -101) tstate = "200";
    return tstate;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("add")) tmpstr = Module_Action_Add();
    else if (tAtype.equals("remove")) tmpstr = Module_Action_Remove();
    else if (tAtype.equals("rename")) tmpstr = Module_Action_Rename();
    return tmpstr;
  }

  private String Module_Load()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    int tuid = admin.id;
    String torder = cls.getString(conf.getRequestUsParameter("order"));
    if (!cls.isEmpty(torder)) cookies.setAttribute(conf, conf.getAppKey("admin-userlnk-order"), torder, 7776000);
    else torder = cls.getSafeString(cookies.getAttribute(conf, conf.getAppKey("admin-userlnk-order")));
    tmpstr = conf.jt.itake("manage-interface.load", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("global.config.admin-userlnk-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.admin-userlnk-nfpre", "cfg"));
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "uid") + "=" + tuid;
    String torderstr = " order by " + cls.cfnames(tfpre, "time") + " asc";
    if (torder.equals("topic")) torderstr = " order by " + cls.cfnames(tfpre, "topic") + " asc";
    tsqlstr = tsqlstr + torderstr;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      for (int tis = 0; tis < tArys.length; tis ++)
      {
        tmptstr = tmpastr;
        Object[][] tAry = (Object[][])tArys[tis];
        String tURL = (String)tDbc.getValue(tAry, cls.cfnames(tfpre, "url"));
        String tGenre = cls.getLRStr(cls.getLRStr(tURL, "/", "leftr"), "/", "rightr");
        if (admin.ckPopedom(admin.popedom, tGenre))
        {
          for (int ti = 0; ti < tAry.length; ti ++)
          {
            tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
            tmptstr = tmptstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.scriptencode(encode.htmlencode(cls.toString(tAry[ti][1]))));
          }
          tmprstr += tmptstr;
        }
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
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
    admin.adminPstate = "public";

    if (admin.ckLogin())
    {
      String tType = cls.getString(conf.getRequestUsParameter("type"));

      if (tType.equals("action")) tmpstr = Module_Action();
      else if (tType.equals("load")) tmpstr = Module_Load();
      else tmpstr = Module_Load();
    }

    PageClose();

    return tmpstr;
  }
}
%>