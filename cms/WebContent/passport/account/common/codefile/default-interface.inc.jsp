<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private account account;
  private dbcache dbcache;

  private String Module_Action_Login()
  {
    String tmpstr = "";
    String tusername = cls.getString(conf.getRequestUsParameter("username"));
    String tpassword = cls.getString(conf.getRequestUsParameter("password"));
    String tvalcode = cls.getString(conf.getRequestUsParameter("valcode"));
    if (!conf.common.ckValcodes(tvalcode)) tmpstr = conf.jt.itake("global.lng_common.valcode-error-1", "lng");
    else
    {
      if (account.Login(tusername, tpassword)) tmpstr = conf.jt.itake("default.login-succeed", "lng");
      else tmpstr = conf.jt.itake("default.login-failed", "lng");
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Lostpassword()
  {
    String tmpstr = "";
    String tusername = cls.getSafeString(conf.getRequestUsParameter("username"));
    String temail = cls.getSafeString(conf.getRequestUsParameter("email"));
    String tvalcode = cls.getString(conf.getRequestUsParameter("valcode"));
    if (!conf.common.ckValcodes(tvalcode)) tmpstr = conf.jt.itake("global.lng_common.valcode-error-1", "lng");
    else
    {
      String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
      String tidfield = cls.cfnames(tfpre, "id");
      String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "username") + "='" + tusername + "' and " + cls.cfnames(tfpre, "email") + "='" + temail + "'";
      dbc tDbc = db.newInstance(conf);
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys == null) tmpstr = conf.jt.itake("default.lostpassword-error-1", "lng");
      else
      {
        Object[][] tAry = (Object[][])tArys[0];
        String tuserid = cls.toString(tDbc.getValue(tAry, tidfield));
        String tNewPassword = cls.getRandomString(6);
        String tEmailTitle = conf.jt.itake("default.lostpassword-email-title", "lng");
        String tEmailContent = conf.jt.itake("default.lostpassword-email-content", "lng");
        tEmailTitle = tEmailTitle.replace("{$-website}", conf.jt.itake("global.default.web_title", "lng"));
        tEmailContent = tEmailContent.replace("{$-username}", encode.htmlencode(tusername));
        tEmailContent = tEmailContent.replace("{$-password}", encode.htmlencode(tNewPassword));
        if (conf.common.sendMail(temail, tEmailTitle, tEmailContent))
        {
          tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "password") + "='" + encode.md5(tNewPassword.getBytes()) + "' where " + tidfield + "=" + cls.getNum(tuserid, 0));
          tmpstr = conf.jt.itake("default.lostpassword-succeed", "lng");
        }
        else tmpstr = conf.jt.itake("default.lostpassword-failed", "lng");
      }
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Register()
  {
    String tmpstr = "";
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tusername = cls.getString(conf.getRequestUsParameter("username"));
    String tpassword = cls.getString(conf.getRequestUsParameter("password"));
    String tcpassword = cls.getString(conf.getRequestUsParameter("cpassword"));
    String temail = cls.getString(conf.getRequestUsParameter("email"));
    String tvalcode = cls.getString(conf.getRequestUsParameter("valcode"));
    if (!conf.common.ckValcodes(tvalcode)) tmpstr = conf.jt.itake("global.lng_common.valcode-error-1", "lng");
    if (!validator.isUsername(tusername)) tmpstr = conf.jt.itake("default.register-error-1", "lng");
    if (!tpassword.equals(tcpassword)) tmpstr = conf.jt.itake("default.register-error-2", "lng");
    if (!validator.isEmail(temail)) tmpstr = conf.jt.itake("default.register-error-3", "lng");
    if (cls.isEmpty(tmpstr))
    {
      tusername = cls.getSafeString(tusername);
      String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "username") + "='" + tusername + "'";
      dbc tDbc = db.newInstance(conf);
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null) tmpstr = conf.jt.itake("default.register-error-4", "lng");
      else
      {
        tsqlstr = "insert into " + tdatabase + " (";
        tsqlstr += cls.cfnames(tfpre, "username") + ",";
        tsqlstr += cls.cfnames(tfpre, "password") + ",";
        tsqlstr += cls.cfnames(tfpre, "email") + ",";
        tsqlstr += cls.cfnames(tfpre, "city") + ",";
        tsqlstr += cls.cfnames(tfpre, "gender") + ",";
        tsqlstr += cls.cfnames(tfpre, "name") + ",";
        tsqlstr += cls.cfnames(tfpre, "phone") + ",";
        tsqlstr += cls.cfnames(tfpre, "address") + ",";
        tsqlstr += cls.cfnames(tfpre, "zipcode") + ",";
        tsqlstr += cls.cfnames(tfpre, "time");
        tsqlstr += ") values (";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("username")), 50) + "',";
        tsqlstr += "'" + cls.getLeft(encode.md5(conf.getRequestUsParameter("password").getBytes()), 50) + "',";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("email")), 50) + "',";
        tsqlstr += cls.getNum(conf.getRequestUsParameter("city"), 0) + ",";
        tsqlstr += cls.getNum(conf.getRequestUsParameter("gender"), 0) + ",";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("name")), 50) + "',";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("phone")), 50) + "',";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("address")), 255) + "',";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("zipcode")), 50) + "',";
        tsqlstr += "'" + cls.getDate() + "'";
        tsqlstr += ")";
        int tstateNum = tDbc.Executes(tsqlstr);
        if (tstateNum != -101)
        {
          if (account.Login(tusername, tpassword)) tmpstr = conf.jt.itake("default.register-succeed", "lng");
        }
        else tmpstr = conf.jt.itake("default.register-failed", "lng");
      }
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Manage_Setting()
  {
    String tmpstr = "";
    Integer tnuserid = cls.getNum(account.nuserid, 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "update " + tdatabase + " set ";
    tsqlstr += cls.cfnames(tfpre, "email") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("email")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "city") + "=" + cls.getNum(conf.getRequestUsParameter("city"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "gender") + "=" + cls.getNum(conf.getRequestUsParameter("gender"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "name") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("name")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "phone") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("phone")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "address") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("address")), 255) + "',";
    tsqlstr += cls.cfnames(tfpre, "zipcode") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("zipcode")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "face") + "=" + cls.getNum(conf.getRequestUsParameter("face"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "face_u") + "=" + cls.getNum(conf.getRequestUsParameter("face_u"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "face_url") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("face_url")), 255) + "',";
    tsqlstr += cls.cfnames(tfpre, "sign") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("sign")), 255) + "'";
    tsqlstr += " where " + tidfield + "=" + tnuserid;
    dbc tDbc = db.newInstance(conf);
    int tstateNum = tDbc.Executes(tsqlstr);
    if (tstateNum != -101)
    {
      dbcache.deleteCache(tdatabase, tfpre, tnuserid);
      tmpstr = conf.jt.itake("default.manage-setting-succeed", "lng");
    }
    else tmpstr = conf.jt.itake("default.manage-setting-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Manage_Password()
  {
    String tmpstr = "";
    Integer tnuserid = cls.getNum(account.nuserid, 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tpassword = cls.getString(conf.getRequestUsParameter("password"));
    String tnpassword = cls.getString(conf.getRequestUsParameter("npassword"));
    String tncpassword = cls.getString(conf.getRequestUsParameter("ncpassword"));
    if (!tnpassword.equals(tncpassword)) tmpstr = conf.jt.itake("default.manage-password-error-1", "lng");
    else
    {
      String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tnuserid;
      dbc tDbc = db.newInstance(conf);
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        Object[][] tAry = (Object[][])tArys[0];
        String trspassword = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "password")));
        if (!trspassword.equals(encode.md5(tpassword.getBytes()))) tmpstr = conf.jt.itake("default.manage-password-error-2", "lng");
        else
        {
          if (tDbc.Executes("update " + tdatabase + " set " + cls.cfnames(tfpre, "password") + "='" + encode.md5(tnpassword.getBytes()) + "' where " + tidfield + "=" + tnuserid) != -101)
          {
            account.setPasswordCookies(encode.md5(tnpassword.getBytes()));
            tmpstr = conf.jt.itake("default.manage-password-succeed", "lng");
          }
          else tmpstr = conf.jt.itake("default.manage-password-failed", "lng");
        }
      }
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Manage()
  {
    String tmpstr = "";
    String tMtype = cls.getString(conf.getRequestUsParameter("mtype"));
    if (tMtype.equals("setting")) tmpstr = Module_Action_Manage_Setting();
    else if (tMtype.equals("password")) tmpstr = Module_Action_Manage_Password();
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("login")) tmpstr = Module_Action_Login();
    else if (tAtype.equals("lostpassword")) tmpstr = Module_Action_Lostpassword();
    else if (tAtype.equals("register")) tmpstr = Module_Action_Register();
    else if (tAtype.equals("manage")) tmpstr = Module_Action_Manage();
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    PageNoCache();
    account = new account(conf);
    dbcache = new dbcache(conf);
    account.Init();
    account.UserInit();

    String tmpstr = "";
    String tType = cls.getString(conf.getRequestUsParameter("type"));
    if (tType.equals("action")) tmpstr = Module_Action();
    PageClose();
    return tmpstr;
  }
}
%>