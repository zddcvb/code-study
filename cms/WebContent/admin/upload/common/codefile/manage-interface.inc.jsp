<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private admin admin;

  private String PP_GetVLReason(Integer argValid, Integer argVLReason)
  {
    String tmpstr = "";
    Integer tValid = argValid;
    Integer tVLReason = argVLReason;
    String tSpanAsh = conf.jt.itake("global.tpl_common.span-ash", "tpl");
    String tSpanHighlight = conf.jt.itake("global.tpl_common.span-highlight", "tpl");
    if (tValid == 1)
    {
      tmpstr = tSpanHighlight;
      tmpstr = tmpstr.replace("{$text}", conf.jt.itake("config.effective", "lng"));
    }
    else
    {
      tmpstr = tSpanAsh;
      tmpstr = tmpstr.replace("{$text}", conf.jt.itake("config.noneffective" + tVLReason, "lng"));
    }
    return tmpstr;
  }

  private String Module_Action_Switch()
  {
    String tstate = "200";
    String tids = cls.getString(conf.getRequestUsParameter("ids"));
    String tswtype = cls.getString(conf.getRequestUsParameter("swtype"));
    String tdatabase = cls.getString(conf.jt.itake("global.config.sys->upload-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.sys->upload-nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = 0;
    if (tswtype.equals("delete"))
    {
      Integer tdelState = 1;
      tstateNum = -101;
      if (cls.cidary(tids))
      {
        String tsqlstr = "select * from " + tdatabase + " where " + tidfield + " in(" + tids + ")";
        dbc tDbc = db.newInstance(conf);
        Object[] tArys = tDbc.getDataAry(tsqlstr);
        if (tArys != null)
        {
          for (int ti = 0; ti < tArys.length; ti ++)
          {
            Object[][] tAry = (Object[][])tArys[ti];
            String tgenre = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "genre")));
            String tfilename = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "filename")));
            String tFullPath = conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tgenre + "/" + tfilename))).toString();
            if (conf.common.fileExists(tFullPath))
            {
              if (!conf.common.fileDelete(tFullPath)) tdelState = 0;
            }
          }
        }
      }
      if (tdelState == 1) tstateNum = conf.common.dataDelete(tdatabase, tidfield, tids);
    }
    if (tstateNum == -101) tstate = "-101";
    return tstate;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("switch")) tmpstr = Module_Action_Switch();
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
    String tdatabase = cls.getString(conf.jt.itake("global.config.sys->upload-ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("global.config.sys->upload-nfpre", "cfg"));
    String tsqlstr = "select * from " + tdatabase + " where 1=1";
    if (tfield.equals("filename")) tsqlstr += " and " + cls.cfnames(tfpre, "filename") + " like '%" + tkeyword + "%'";
    if (tfield.equals("genre")) tsqlstr += " and " + cls.cfnames(tfpre, "genre") + " like '%" + tkeyword + "%'";
    if (tfield.equals("valid")) tsqlstr += " and " + cls.cfnames(tfpre, "valid") + "=" + cls.getNum(tkeyword);
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
        String tFileType = (String)cls.getAryValue(tAry, "filename");
        tFileType = cls.getLRStr(tFileType, ".", "right");
        tFileType = tFileType.toLowerCase();
        tmptstr = tmptstr.replace("{$-filetype}", tFileType);
        tmptstr = tmptstr.replace("{$-vlreason}", PP_GetVLReason((Integer)cls.getAryValue(tAry, "valid"), (Integer)cls.getAryValue(tAry, "vlreason")));
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
      else if (tType.equals("list")) tmpstr = Module_List();
      else tmpstr = Module_List();
    }

    PageClose();

    return tmpstr;
  }
}
%>