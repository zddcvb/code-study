<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%@ page import = "java.util.regex.*" %>
<%
class module extends jpage
{
  private admin admin;

  private String Module_Action_Settings()
  {
    String tmpstr = "";
    Boolean tbool = true;
    String tnlng = conf.common.getLngText(cls.toString(admin.slng));
    String tsettings = cls.getString(conf.getRequestUsParameter("settings"));
    String[] tsettingsAry = tsettings.split(Pattern.quote(","));
    for (int ti = 0; ti < tsettingsAry.length; ti ++)
    {
      String tsettingsString = tsettingsAry[ti];
      if (!cls.isEmpty(tsettingsString))
      {
        String tsettingsString1 = cls.getLRStr(tsettingsString, ":", "leftr");
        String tsettingsString2 = cls.getLRStr(tsettingsString, ":", "right");
        String tsettingsString3 = tsettingsString.replace(".", "_").replace(":", "_");
        String tsettingsValue = cls.getString(conf.getRequestUsParameter(tsettingsString3));
        Boolean tsettingsBool = conf.jt.iset(tsettingsString1, tsettingsString2, tnlng, tsettingsValue);
        if (tsettingsBool == false) tbool = false;
      }
    }
    if (tbool == true) tmpstr = conf.jt.itake("manage.settings-succeed", "lng");
    else tmpstr = conf.jt.itake("manage.settings-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
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
    if (tAtype.equals("settings")) tmpstr = Module_Action_Settings();
    else if (tAtype.equals("selslng")) tmpstr = Module_Action_Selslng();
    return tmpstr;
  }

  private String Module_Settings1()
  {
    String tmpstr = "";
    String tnlng = conf.common.getLngText(cls.toString(admin.slng));
    tmpstr = conf.jt.itake("manage-interface.settings1", "tpl");
    tmpstr = tmpstr.replace("{$-nlng}", tnlng);
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Settings2()
  {
    String tmpstr = "";
    String tnlng = conf.common.getLngText(cls.toString(admin.slng));
    String tnvalidate = conf.jt.itake("global.config.nvalidate", "cfg", "", tnlng);
    tmpstr = conf.jt.itake("manage-interface.settings2", "tpl");
    tmpstr = tmpstr.replace("{$-nlng}", tnlng);
    tmpstr = tmpstr.replace("{$-nvalidate}", tnvalidate);
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
      else if (tType.equals("settings1")) tmpstr = Module_Settings1();
      else if (tType.equals("settings2")) tmpstr = Module_Settings2();
      else tmpstr = Module_Settings1();
    }

    PageClose();

    return tmpstr;
  }
}
%>