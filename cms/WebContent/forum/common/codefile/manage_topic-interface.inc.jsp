<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private admin admin;
  private account account;
  private upfiles upfiles;

  public String PP_selClass(String argStrings)
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tStrings = argStrings;
    String tLng = cls.getParameter(tStrings, "lng");
    String tFid = cls.getParameter(tStrings, "fid");
    Integer tClass = cls.getNum(cls.getParameter(tStrings, "class"), 0);
    Integer tInum = cls.getNum(cls.getParameter(tStrings, "inum"), 0);
    tmpstr = conf.jt.itake("global.tpl_common.sel-class", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "lng") + "=" + cls.getNum(tLng, 0) + " and " + cls.cfnames(tfpre, "fid") + "=" + cls.getNum(tFid, 0);
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      tInum += 1;
      for (int tis = 0; tis < tArys.length; tis ++)
      {
        Object[][] tAry = (Object[][])tArys[tis];
        tmptstr = tmpastr;
        tmptstr = tmptstr.replace("{$topic}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "topic")))));
        tmptstr = tmptstr.replace("{$id}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id")))));
        if (tClass != cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id"))), 0)) tmptstr = tmptstr.replace("{$-selected}", "");
        else tmptstr = tmptstr.replace("{$-selected}", "selected=\"selected\"");
        tmptstr = tmptstr.replace("{$-prestr}", cls.getRepeatedString(conf.jt.itake("global.lng_common.sys-spsort", "lng"), tInum));
        tmptstr = tmptstr.replace("{$-child}", PP_selClass("lng=" + tLng + ";class=" + tClass + ";inum=" + tInum + ";fid=" + cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id"))), 0)));
        tmprstr += tmptstr;
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_Action_Edit()
  {
    String tmpstr = "";
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tAuid = account.getUserID(conf.getRequestUsParameter("author"));
    if (!tAuid.equals(0))
    {
      String tsqlstr = "update " + tdatabase + " set ";
      tsqlstr += cls.cfnames(tfpre, "topic") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
      tsqlstr += cls.cfnames(tfpre, "class") + "=" + cls.getNum(conf.getRequestUsParameter("class"), 0) + ",";
      tsqlstr += cls.cfnames(tfpre, "auid") + "=" + account.getUserID(conf.getRequestUsParameter("author")) + ",";
      tsqlstr += cls.cfnames(tfpre, "author") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("author")), 50) + "',";
      tsqlstr += cls.cfnames(tfpre, "icon") + "=" + cls.getNum(conf.getRequestUsParameter("icon"), 0) + ",";
      tsqlstr += cls.cfnames(tfpre, "content") + "='" + cls.getLeft(encode.addslashes(conf.common.repathencode(conf.getRequestUsParameter("content"))), 100000) + "',";
      tsqlstr += cls.cfnames(tfpre, "content_files") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("content_files")), 10000) + "',";
      tsqlstr += cls.cfnames(tfpre, "htop") + "=" + cls.getNum(conf.getRequestUsParameter("htop"), 0) + ",";
      tsqlstr += cls.cfnames(tfpre, "top") + "=" + cls.getNum(conf.getRequestUsParameter("top"), 0) + ",";
      tsqlstr += cls.cfnames(tfpre, "elite") + "=" + cls.getNum(conf.getRequestUsParameter("elite"), 0) + ",";
      tsqlstr += cls.cfnames(tfpre, "lock") + "=" + cls.getNum(conf.getRequestUsParameter("lock"), 0) + ",";
      tsqlstr += cls.cfnames(tfpre, "hidden") + "=" + cls.getNum(conf.getRequestUsParameter("hidden"), 0) + ",";
      tsqlstr += cls.cfnames(tfpre, "time") + "='" + cls.getDate(conf.getRequestUsParameter("time")) + "',";
      tsqlstr += cls.cfnames(tfpre, "timestamp") + "='" + cls.getUnixStamp(conf.getRequestUsParameter("time")) + "',";
      tsqlstr += cls.cfnames(tfpre, "count") + "=" + cls.getNum(conf.getRequestUsParameter("count"), 0) + ",";
      tsqlstr += cls.cfnames(tfpre, "lng") + "=" + admin.slng;
      tsqlstr += " where " + tidfield + "=" + tid;
      dbc tDbc = db.newInstance(conf);
      int tstateNum = tDbc.Executes(tsqlstr);
      if (tstateNum != -101)
      {
        upfiles.UpdateDatabaseNote(conf.getNGenre(), conf.getRequestUsParameter("content_files"), "content_files", tid);
        tDbc.Executes("update " + tdatabase + " set " + cls.cfnames(tfpre, "class") + "=" + cls.getNum(conf.getRequestUsParameter("class"), 0) + " where " + cls.cfnames(tfpre, "fid") + "=" + tid);
        tmpstr = conf.jt.itake("global.lng_common.edit-succeed", "lng");
      }
      else tmpstr = conf.jt.itake("global.lng_common.edit-failed", "lng");
    }
    else tmpstr = conf.jt.itake("manage_topic.edit-error-1", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Delete()
  {
    String tstate = "200";
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = conf.common.dataDelete(tdatabase, tidfield, cls.toString(tid));
    if (tstateNum == -101) tstate = "-101";
    else
    {
      upfiles.DeleteDatabaseNote(conf.getNGenre(), cls.toString(tid));
      String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "fid") + "=" + tid;
      dbc tDbc = db.newInstance(conf);
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        for (int tis = 0; tis < tArys.length; tis ++)
        {
          Object[][] tAry = (Object[][])tArys[tis];
          String tFidId = cls.toString(tDbc.getValue(tAry, tidfield));
          int tstateNum2 = conf.common.dataDelete(tdatabase, tidfield, tFidId);
          if (tstateNum2 != -101) upfiles.DeleteDatabaseNote(conf.getNGenre(), tFidId);
        }
      }
    }
    return tstate;
  }

  private String Module_Action_Switch()
  {
    String tstate = "200";
    String tids = cls.getString(conf.getRequestUsParameter("ids"));
    String tswtype = cls.getString(conf.getRequestUsParameter("swtype"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = 0;
    if (tswtype.equals("htop")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "htop"), tidfield, tids);
    else if (tswtype.equals("top")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "top"), tidfield, tids);
    else if (tswtype.equals("hidden")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "hidden"), tidfield, tids);
    else if (tswtype.equals("delete")) tstateNum = conf.common.dataDelete(tdatabase, tidfield, tids);
    if (tstateNum == -101) tstate = "-101";
    else
    {
      if (tswtype.equals("delete"))
      {
        upfiles.DeleteDatabaseNote(conf.getNGenre(), tids);
        if (cls.cidary(tids))
        {
          String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "fid") + " in (" + tids + ")";
          dbc tDbc = db.newInstance(conf);
          Object[] tArys = tDbc.getDataAry(tsqlstr);
          if (tArys != null)
          {
            for (int tis = 0; tis < tArys.length; tis ++)
            {
              Object[][] tAry = (Object[][])tArys[tis];
              String tFidId = cls.toString(tDbc.getValue(tAry, tidfield));
              int tstateNum2 = conf.common.dataDelete(tdatabase, tidfield, tFidId);
              if (tstateNum2 != -101) upfiles.DeleteDatabaseNote(conf.getNGenre(), tFidId);
            }
          }
        }
      }
    }
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
    if (tAtype.equals("edit")) tmpstr = Module_Action_Edit();
    else if (tAtype.equals("delete")) tmpstr = Module_Action_Delete();
    else if (tAtype.equals("switch")) tmpstr = Module_Action_Switch();
    else if (tAtype.equals("selslng")) tmpstr = Module_Action_Selslng();
    else if (tAtype.equals("upload")) tmpstr = upfiles.uploadFiles("file1", 0, admin.username);
    return tmpstr;
  }

  private String Module_Edit()
  {
    String tmpstr = "";
    String tNGenre = conf.getNGenre();
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
      String tTopicClass = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "class")));
      tmpstr = conf.jt.itake("manage_topic-interface.edit", "tpl");
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
      tmpstr = tmpstr.replace("{$-genre}", tNGenre);
      tmpstr = tmpstr.replace("{$-lng}", cls.toString(admin.slng));
      tmpstr = tmpstr.replace("{$-class-option}", PP_selClass("lng=" + admin.slng + ";fid=0;class=" + tTopicClass));
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
    String tNGenre = conf.getNGenre();
    Integer tpage = cls.getNum(conf.getRequestUsParameter("page"));
    Integer tnclstype = cls.getNum(conf.jt.itake("config.nclstype", "cfg"), 0);
    String tfield = cls.getSafeString(conf.getRequestUsParameter("field"));
    String tkeyword = cls.getSafeString(conf.getRequestUsParameter("keyword"));
    tmpstr = conf.jt.itake("manage_topic-interface.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "fid") + "=0 and " + cls.cfnames(tfpre, "lng") + "=" + admin.slng;
    if (tfield.equals("topic")) tsqlstr += " and " + cls.cfnames(tfpre, "topic") + " like '%" + tkeyword + "%'";
    if (tfield.equals("htop")) tsqlstr += " and " + cls.cfnames(tfpre, "htop") + "=" + cls.getNum(tkeyword);
    if (tfield.equals("top")) tsqlstr += " and " + cls.cfnames(tfpre, "top") + "=" + cls.getNum(tkeyword);
    if (tfield.equals("auid")) tsqlstr += " and " + cls.cfnames(tfpre, "auid") + "=" + cls.getNum(tkeyword);
    if (tfield.equals("hidden")) tsqlstr += " and " + cls.cfnames(tfpre, "hidden") + "=" + cls.getNum(tkeyword);
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
    tmpstr = tmpstr.replace("{$-genre}", tNGenre);
    tmpstr = tmpstr.replace("{$-lng}", cls.toString(admin.slng));
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
    account = new account(conf);
    account.Init(conf.jt.itake("config.naccount", "cfg"));
    upfiles = new upfiles(conf);

    if (admin.ckLogin())
    {
      String tType = cls.getString(conf.getRequestUsParameter("type"));

      if (tType.equals("action")) tmpstr = Module_Action();
      else if (tType.equals("edit")) tmpstr = Module_Edit();
      else if (tType.equals("list")) tmpstr = Module_List();
      else if (tType.equals("upload")) tmpstr = upfiles.uploadHTML("upload-html-1");
      else tmpstr = Module_List();
    }

    PageClose();

    return tmpstr;
  }
}
%>