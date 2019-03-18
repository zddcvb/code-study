<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private account account;

  private String Module_Login()
  {
    String tmpstr = "";
    conf.cntitle(conf.jt.itake("default.nav_login", "lng"));
    tmpstr = conf.jt.itake("default.login", "tpl");
    tmpstr = conf.common.crValcodeTpl(tmpstr);
    tmpstr = tmpstr.replace("{$-defmenu}", account.getDefMenuHtml());
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_logout()
  {
    String tmpstr = "";
    account.Logout();
    tmpstr = conf.common.webMessages(conf.jt.itake("default.logout-done", "lng"), conf.getActualRoute("./"));
    return tmpstr;
  }

  private String Module_Lostpassword()
  {
    String tmpstr = "";
    conf.cntitle(conf.jt.itake("default.nav_lostpassword", "lng"));
    tmpstr = conf.jt.itake("default.lostpassword", "tpl");
    tmpstr = conf.common.crValcodeTpl(tmpstr);
    tmpstr = tmpstr.replace("{$-defmenu}", account.getDefMenuHtml());
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_Register()
  {
    String tmpstr = "";
    conf.cntitle(conf.jt.itake("default.nav_register", "lng"));
    tmpstr = conf.jt.itake("default.register", "tpl");
    tmpstr = conf.common.crValcodeTpl(tmpstr);
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_Manage_Member()
  {
    String tmpstr = "";
    conf.cntitle(conf.jt.itake("default.nav_manage_member", "lng"));
    Integer tnuserid = cls.getNum(account.nuserid, 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tnuserid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      tmpstr = conf.jt.itake("default.manage-member", "tpl");
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
      tmpstr = tmpstr.replace("{$-genre}", conf.getNGenre());
      tmpstr = tmpstr.replace("{$-lng}", cls.toString(conf.getNLng()));
      tmpstr = tmpstr.replace("{$-defmenu}", account.getDefMenuHtml());
      tmpstr = conf.jt.creplace(tmpstr);
    }
    return tmpstr;
  }

  private String Module_Manage_Settiing()
  {
    String tmpstr = "";
    conf.cntitle(conf.jt.itake("default.nav_manage_setting", "lng"));
    Integer tnuserid = cls.getNum(account.nuserid, 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tnuserid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      tmpstr = conf.jt.itake("default.manage-setting", "tpl");
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
      tmpstr = tmpstr.replace("{$-genre}", conf.getNGenre());
      tmpstr = tmpstr.replace("{$-lng}", cls.toString(conf.getNLng()));
      tmpstr = tmpstr.replace("{$-defmenu}", account.getDefMenuHtml());
      tmpstr = conf.jt.creplace(tmpstr);
    }
    return tmpstr;
  }

  private String Module_Manage_Password()
  {
    String tmpstr = "";
    conf.cntitle(conf.jt.itake("default.nav_manage_password", "lng"));
    Integer tnuserid = cls.getNum(account.nuserid, 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tnuserid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      tmpstr = conf.jt.itake("default.manage-password", "tpl");
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
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
    if (!account.checkUserLogin()) tmpstr = conf.common.webMessages(conf.jt.itake("default.manage-error-1", "lng"), "./?type=login&backurl=" + encode.base64encode(conf.getRequestURL().getBytes()));
    else
    {
      if (tMtype.equals("member")) tmpstr = Module_Manage_Member();
      else if (tMtype.equals("setting")) tmpstr = Module_Manage_Settiing();
      else if (tMtype.equals("password")) tmpstr = Module_Manage_Password();
      else tmpstr = Module_Manage_Member();
    }
    return tmpstr;
  }

  private String Module_Default()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("default.default", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    if (cls.isEmpty(tmpstr)) tmpstr = Module_Register();
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    account = new account(conf);
    account.Init();
    account.UserInit();
    conf.cntitle(conf.jt.itake("default.channel_title", "lng"));

    String tmpstr = "";
    String tType = cls.getString(conf.getRequestParameter("type"));
    if (tType.equals("login")) tmpstr = Module_Login();
    else if (tType.equals("logout")) tmpstr = Module_logout();
    else if (tType.equals("lostpassword")) tmpstr = Module_Lostpassword();
    else if (tType.equals("register")) tmpstr = Module_Register();
    else if (tType.equals("manage")) tmpstr = Module_Manage();
    else tmpstr = Module_Default();

    PageClose();
    return tmpstr;
  }
}
%>