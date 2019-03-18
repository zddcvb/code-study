<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private admin admin;

  private String Module_Action_Add()
  {
    String tmpstr = "";
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "insert into " + tdatabase + " (";
    tsqlstr += cls.cfnames(tfpre, "topic") + ",";
    tsqlstr += cls.cfnames(tfpre, "vtype") + ",";
    tsqlstr += cls.cfnames(tfpre, "starttime") + ",";
    tsqlstr += cls.cfnames(tfpre, "endtime") + ",";
    tsqlstr += cls.cfnames(tfpre, "commendatory") + ",";
    tsqlstr += cls.cfnames(tfpre, "hidden") + ",";
    tsqlstr += cls.cfnames(tfpre, "time") + ",";
    tsqlstr += cls.cfnames(tfpre, "lng");
    tsqlstr += ") values (";
    tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
    tsqlstr += cls.getNum(conf.getRequestUsParameter("vtype"), 0) + ",";
    tsqlstr += "'" + cls.getDate(conf.getRequestUsParameter("starttime")) + "',";
    tsqlstr += "'" + cls.getDate(conf.getRequestUsParameter("endtime")) + "',";
    tsqlstr += cls.getNum(conf.getRequestUsParameter("commendatory"), 0) + ",";
    tsqlstr += cls.getNum(conf.getRequestUsParameter("hidden"), 0) + ",";
    tsqlstr += "'" + cls.getDate() + "',";
    tsqlstr += admin.slng;
    tsqlstr += ")";
    dbc tDbc = db.newInstance(conf);
    int tstateNum = tDbc.Executes(tsqlstr);
    if (tstateNum != -101)
    {
      int tTopID = conf.common.getTopID(tdatabase, tidfield);
      //********************************************************************************//
      String toptions = "";
      Integer toptionsnum = cls.getNum(conf.getRequestUsParameter("optionsnum"), 0);
      String tdatabaseOptions = cls.getString(conf.jt.itake("config.ndatabase-options", "cfg"));
      String tfpreOptions = cls.getString(conf.jt.itake("config.nfpre-options", "cfg"));
      for(int ti = 0; ti < toptionsnum; ti ++)
      {
        Integer toptionsCount = cls.getNum(conf.getRequestUsParameter("options_count_" + ti), 0);
        String toptionsTopic = cls.getString(conf.getRequestUsParameter("options_topic_" + ti));
        if (!cls.isEmpty(toptionsTopic))
        {
          String toptionsSqlstr = "insert into " + tdatabaseOptions + " (";
          toptionsSqlstr += cls.cfnames(tfpreOptions, "vote_id") + ",";
          toptionsSqlstr += cls.cfnames(tfpreOptions, "topic") + ",";
          toptionsSqlstr += cls.cfnames(tfpreOptions, "vote_count") + ",";
          toptionsSqlstr += cls.cfnames(tfpreOptions, "time") + ",";
          toptionsSqlstr += cls.cfnames(tfpreOptions, "lng");
          toptionsSqlstr += ") values (";
          toptionsSqlstr += tTopID + ",";
          toptionsSqlstr += "'" + cls.getLeft(encode.addslashes(toptionsTopic), 50) + "',";
          toptionsSqlstr += toptionsCount + ",";
          toptionsSqlstr += "'" + cls.getDate() + "',";
          toptionsSqlstr += admin.slng;
          toptionsSqlstr += ")";
          tDbc.Executes(toptionsSqlstr);
        }
      }
      //********************************************************************************//
      tmpstr = conf.jt.itake("global.lng_common.add-succeed", "lng");
    }
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
    tsqlstr += cls.cfnames(tfpre, "vtype") + "=" + cls.getNum(conf.getRequestUsParameter("vtype"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "starttime") + "='" + cls.getDate(conf.getRequestUsParameter("starttime")) + "',";
    tsqlstr += cls.cfnames(tfpre, "endtime") + "='" + cls.getDate(conf.getRequestUsParameter("endtime")) + "',";
    tsqlstr += cls.cfnames(tfpre, "commendatory") + "=" + cls.getNum(conf.getRequestUsParameter("commendatory"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "hidden") + "=" + cls.getNum(conf.getRequestUsParameter("hidden"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "time") + "='" + cls.getDate(conf.getRequestUsParameter("time")) + "',";
    tsqlstr += cls.cfnames(tfpre, "lng") + "=" + admin.slng;
    tsqlstr += " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    int tstateNum = tDbc.Executes(tsqlstr);
    if (tstateNum != -101)
    {
      //********************************************************************************//
      String toptions = "";
      Integer toptionsnum = cls.getNum(conf.getRequestUsParameter("optionsnum"), 0);
      String tdatabaseOptions = cls.getString(conf.jt.itake("config.ndatabase-options", "cfg"));
      String tfpreOptions = cls.getString(conf.jt.itake("config.nfpre-options", "cfg"));
      tDbc.Executes("update " + tdatabaseOptions + " set " + cls.cfnames(tfpreOptions, "update") + "=0 where " + cls.cfnames(tfpreOptions, "vote_id") + "=" + tid);
      for(int ti = 0; ti < toptionsnum; ti ++)
      {
        Integer toptionsId = cls.getNum(conf.getRequestUsParameter("options_id_" + ti), 0);
        Integer toptionsCount = cls.getNum(conf.getRequestUsParameter("options_count_" + ti), 0);
        String toptionsTopic = cls.getString(conf.getRequestUsParameter("options_topic_" + ti));
        if (!cls.isEmpty(toptionsTopic))
        {
          if (toptionsId != 0)
          {
            String toptionsSqlstr = "update " + tdatabaseOptions + " set ";
            toptionsSqlstr += cls.cfnames(tfpreOptions, "topic") + "='" + cls.getLeft(encode.addslashes(toptionsTopic), 50) + "',";
            toptionsSqlstr += cls.cfnames(tfpreOptions, "vote_count") + "=" + toptionsCount + ",";
            toptionsSqlstr += cls.cfnames(tfpreOptions, "update") + "=1,";
            toptionsSqlstr += cls.cfnames(tfpreOptions, "lng") + "=" + admin.slng;
            toptionsSqlstr += " where " + cls.cfnames(tfpreOptions, "id") + "=" + toptionsId;
            tDbc.Executes(toptionsSqlstr);
          }
          else
          {
            String toptionsSqlstr = "insert into " + tdatabaseOptions + " (";
            toptionsSqlstr += cls.cfnames(tfpreOptions, "vote_id") + ",";
            toptionsSqlstr += cls.cfnames(tfpreOptions, "topic") + ",";
            toptionsSqlstr += cls.cfnames(tfpreOptions, "vote_count") + ",";
            toptionsSqlstr += cls.cfnames(tfpreOptions, "time") + ",";
            toptionsSqlstr += cls.cfnames(tfpreOptions, "update") + ",";
            toptionsSqlstr += cls.cfnames(tfpreOptions, "lng");
            toptionsSqlstr += ") values (";
            toptionsSqlstr += tid + ",";
            toptionsSqlstr += "'" + cls.getLeft(encode.addslashes(toptionsTopic), 50) + "',";
            toptionsSqlstr += toptionsCount + ",";
            toptionsSqlstr += "'" + cls.getDate() + "',";
            toptionsSqlstr += "1,";
            toptionsSqlstr += admin.slng;
            toptionsSqlstr += ")";
            tDbc.Executes(toptionsSqlstr);
          }
        }
      }
      tDbc.Executes("delete from " + tdatabaseOptions + " where " + cls.cfnames(tfpreOptions, "update") + "=0 and " + cls.cfnames(tfpreOptions, "vote_id") + "=" + tid);
      //********************************************************************************//
      tmpstr = conf.jt.itake("global.lng_common.edit-succeed", "lng");
    }
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
    if (tswtype.equals("commendatory")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "commendatory"), tidfield, tids);
    else if (tswtype.equals("hidden")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "hidden"), tidfield, tids);
    else if (tswtype.equals("delete")) tstateNum = conf.common.dataDelete(tdatabase, tidfield, tids);
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
    else if (tAtype.equals("delete")) tmpstr = Module_Action_Delete();
    else if (tAtype.equals("switch")) tmpstr = Module_Action_Switch();
    else if (tAtype.equals("selslng")) tmpstr = Module_Action_Selslng();
    return tmpstr;
  }

  private String Module_Options_Add()
  {
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    String tmpstr = "";
    tmpstr = conf.jt.itake("manage-interface.options_add", "tpl");
    tmpstr = tmpstr.replace("{$id}", cls.toString(tId));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Options_Edit()
  {
    String tmpstr = "";
    String tmpoutstr = "";
    Integer tFid = cls.getNum(conf.getRequestUsParameter("fid"), 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-options", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre-options", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "vote_id") + "=" + tFid + " order by " + tidfield + " asc";
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      for (int tis = 0; tis < tArys.length; tis ++)
      {
        Object[][] tAry = (Object[][])tArys[tis];
        tmpstr = conf.jt.itake("manage-interface.options_edit", "tpl");
        String tmptstr = tmpstr;
        tmptstr = tmptstr.replace("{$id}", cls.toString(tis));
        tmptstr = tmptstr.replace("{$dbid}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "id")))));
        tmptstr = tmptstr.replace("{$topic}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "topic")))));
        tmptstr = tmptstr.replace("{$vote_count}", encode.htmlencode(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "vote_count")))));
        tmpoutstr += tmptstr;
      }
    }
    tmpoutstr = conf.jt.creplace(tmpoutstr);
    tmpoutstr = conf.ajaxPreContent + tmpoutstr;
    return tmpoutstr;
  }

  private String Module_Options()
  {
    String tmpstr = "";
    String tUtype = cls.getString(conf.getRequestUsParameter("utype"));
    if (tUtype.equals("add")) tmpstr = Module_Options_Add();
    else if (tUtype.equals("edit")) tmpstr = Module_Options_Edit();
    return tmpstr;
  }

  private String Module_Add()
  {
    String tmpstr = "";
    String tNGenre = conf.getNGenre();
    tmpstr = conf.jt.itake("manage-interface.add", "tpl");
    tmpstr = tmpstr.replace("{$-genre}", tNGenre);
    tmpstr = tmpstr.replace("{$-lng}", cls.toString(admin.slng));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
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
      tmpstr = conf.jt.itake("manage-interface.edit", "tpl");
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
      tmpstr = tmpstr.replace("{$-genre}", tNGenre);
      tmpstr = tmpstr.replace("{$-lng}", cls.toString(admin.slng));
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
    tmpstr = conf.jt.itake("manage-interface.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "lng") + "=" + admin.slng;
    if (tfield.equals("topic")) tsqlstr += " and " + cls.cfnames(tfpre, "topic") + " like '%" + tkeyword + "%'";
    if (tfield.equals("commendatory")) tsqlstr += " and " + cls.cfnames(tfpre, "commendatory") + "=" + cls.getNum(tkeyword);
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

    if (admin.ckLogin())
    {
      String tType = cls.getString(conf.getRequestUsParameter("type"));

      if (tType.equals("action")) tmpstr = Module_Action();
      else if (tType.equals("options")) tmpstr = Module_Options();
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