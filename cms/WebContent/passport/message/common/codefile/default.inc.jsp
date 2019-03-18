<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private account account;

  private String Module_Manage_Add()
  {
    String tmpstr = "";
    conf.cntitle(conf.jt.itake("default.nav_manage_add", "lng"));
    tmpstr = conf.jt.itake("default.manage-add", "tpl");
    tmpstr = conf.common.crValcodeTpl(tmpstr);
    tmpstr = tmpstr.replace("{$-defmenu}", account.getDefMenuHtml());
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_Manage_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    Integer tpage = cls.getNum(conf.getRequestParameter("page"), 0);
    conf.cntitle(conf.jt.itake("default.nav_manage_list", "lng"));
    Integer tnuserid = cls.getNum(account.nuserid, 0);
    tmpstr = conf.jt.itake("default.manage-list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "ruid") + "=" + tnuserid + " order by " + cls.cfnames(tfpre, "time") + " desc";
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
        conf.rsAry = tAry;
        tmptstr = conf.jt.creplace(tmptstr);
        tmprstr += tmptstr;
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = tmpstr.replace("{$-genre}", tNGenre);
    tmpstr = tmpstr.replace("{$-lng}", cls.toString(tNLng));
    tmpstr = tmpstr.replace("{$-defmenu}", account.getDefMenuHtml());
    tmpstr = tmpstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
    tmpstr = tmpstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_Manage_Detail()
  {
    String tmpstr = "";
    Integer tnuserid = cls.getNum(account.nuserid, 0);
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "ruid") + "=" + tnuserid + " and " + tidfield + "=" + tId;
    dbc tDbc = db.newInstance(conf); 
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      conf.cntitle((String)tDbc.getValue(tAry, cls.cfnames(tfpre, "topic")));
      tmpstr = conf.jt.itake("default.manage-detail", "tpl");
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
      if ((Integer)tDbc.getValue(tAry, "read") != 1) tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "read") + "=1 where " + tidfield + "=" + tId);
      tmpstr = tmpstr.replace("{$-genre}", conf.getNGenre());
      tmpstr = tmpstr.replace("{$-lng}", cls.toString(conf.getNLng()));
      tmpstr = tmpstr.replace("{$-defmenu}", account.getDefMenuHtml());
      tmpstr = conf.jt.creplace(tmpstr);
    }
    return tmpstr;
  }

  private String Module_Manage()
  {
    String tmpstr = "";
    String tMtype = cls.getString(conf.getRequestUsParameter("mtype"));
    if (!account.checkUserLogin()) tmpstr = conf.common.webMessages(conf.jt.itake("default.manage-error-1", "lng"), conf.getActualRoute(conf.jt.itake("config.naccount", "cfg")) + "/?type=login&backurl=" + encode.base64encode(conf.getRequestURL().getBytes()));
    else
    {
      if (tMtype.equals("add")) tmpstr = Module_Manage_Add();
      else if (tMtype.equals("list")) tmpstr = Module_Manage_List();
      else if (tMtype.equals("detail")) tmpstr = Module_Manage_Detail();
      else tmpstr = Module_Manage_List();
    }
    return tmpstr;
  }

  private String Module_Default()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("default.default", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    if (cls.isEmpty(tmpstr)) tmpstr = Module_Manage();
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
    String tType = cls.getString(conf.getRequestParameter("type"));
    if (tType.equals("manage")) tmpstr = Module_Manage();
    else tmpstr = Module_Default();

    PageClose();
    return tmpstr;
  }
}
%>