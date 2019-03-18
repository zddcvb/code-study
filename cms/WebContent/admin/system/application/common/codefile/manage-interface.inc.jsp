<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.util.regex.*" %>
<%
class module extends jpage
{
  private admin admin;

  private String Module_Action_Delete()
  {
    String tstate = "200";
    String tname = cls.getString(conf.getRequestUsParameter("name"));
    if (!cls.isEmpty(tname)) conf.application.removeAttribute(tname);
    else
    {
      String tAppStrings = "";
      Enumeration tEnumeration = conf.application.getAttributeNames();
      while (tEnumeration.hasMoreElements())
      {
        String tElementString = (String)tEnumeration.nextElement();
        tAppStrings += tElementString + ",";
      }
      if (!cls.isEmpty(tAppStrings)) tAppStrings = cls.getLRStr(tAppStrings, ",", "leftr");
      String[] tAppAry = tAppStrings.split(Pattern.quote(","));
      for (int ti = 0; ti < tAppAry.length; ti ++)
      {
        String tAppAryString = tAppAry[ti];
        if (!cls.isEmpty(tAppAryString))
        {
          if (tAppAryString.substring(0, conf.appName.length()).equals(conf.appName)) conf.application.removeAttribute(tAppAryString);
        }
      }
    }
    return tstate;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("delete")) tmpstr = Module_Action_Delete();
    return tmpstr;
  }

  private String Module_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tkeyword = cls.getSafeString(conf.getRequestUsParameter("keyword"));
    tmpstr = conf.jt.itake("manage-interface.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    Enumeration tEnumeration = conf.application.getAttributeNames();
    while (tEnumeration.hasMoreElements())
    {
      String tElementString = (String)tEnumeration.nextElement();
      if (tElementString.substring(0, conf.appName.length()).equals(conf.appName))
      {
        if (cls.isEmpty(tkeyword) || tElementString.indexOf(tkeyword) >= 0)
        {
          tmptstr = tmpastr;
          tmptstr = tmptstr.replace("{$name}", encode.htmlencode(tElementString));
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