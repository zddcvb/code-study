<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private account account;

  private String Module_Action_Logout()
  {
    String tstate = "200";
    account.Logout();
    return tstate;
  }

  private String Module_Action_Login()
  {
    String tstate = "200";
    String tNamePre = cls.getString(conf.getRequestUsParameter("namepre"));
    String tValCode = cls.getSafeString(conf.getRequestUsParameter(tNamePre + "valcode"));
    String tUsername = cls.getSafeString(conf.getRequestUsParameter(tNamePre + "username"));
    String tPassword = cls.getSafeString(conf.getRequestUsParameter(tNamePre + "password"));
    if (!conf.common.ckValcodes(tValCode)) tstate = "-101";
    else
    {
      if (!account.Login(tUsername, tPassword)) tstate = "-102";
    }
    return tstate;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("login")) tmpstr = Module_Action_Login();
    else if (tAtype.equals("logout")) tmpstr = Module_Action_Logout();
    return tmpstr;
  }

  private String Module_CkLogin()
  {
    String tmpstr = "";
    String tid = cls.getString(conf.getRequestUsParameter("id"));
    if (!account.checkUserLogin())
    {
      tmpstr = conf.jt.itake("api." + tid + "-login", "tpl");
      tmpstr = conf.common.crValcodeTpl(tmpstr);
      tmpstr = conf.jt.creplace(tmpstr);
    }
    else
    {
      tmpstr = conf.jt.itake("api." + tid + "-logined", "tpl");
      tmpstr = tmpstr.replace("{$username}", encode.htmlencode(account.nusername));
      tmpstr = conf.jt.creplace(tmpstr);
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_GetUserID()
  {
    String tusername = cls.getSafeString(conf.getRequestUsParameter("username"));
    String tmpstr = cls.toString(account.getUserID(tusername));
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    PageNoCache();
    account = new account(conf);
    account.Init();
    account.UserInit();

    String tmpstr = "";
    String tType = cls.getString(conf.getRequestUsParameter("type"));
    if (tType.equals("action")) tmpstr = Module_Action();
    else if (tType.equals("cklogin")) tmpstr = Module_CkLogin();
    else if (tType.equals("getuserid")) tmpstr = Module_GetUserID();
    PageClose();
    return tmpstr;
  }
}
%>