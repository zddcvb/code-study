<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private admin admin;

  private String Module_Action_Run()
  {
    String tmpstr = "";
    String tsqlstr = "";
    String tsqlstrs = cls.getString(conf.getRequestUsParameter("sqlstrs"));
    if (!cls.isEmpty(tsqlstrs))
    {
      Integer tstate2 = 0;
      String ttpl = "";
      String tstate1 = "0";
      String ttplstr = conf.jt.itake("manage-interface.run", "tpl");
      String[] tSqlAry = tsqlstrs.split("\\r\\n");
      for (int ti = 0; ti < tSqlAry.length; ti ++)
      {
        tstate1 = "0";
        tstate2 = 0;
        tsqlstr = tSqlAry[ti];
        if (!cls.isEmpty(tsqlstr))
        {
          dbc tDbc = db.newInstance(conf);
          tstate2 = tDbc.Executes(tsqlstr);
          if (tstate2 != -101) tstate1 = "1";
          ttpl = ttplstr;
          ttpl = ttpl.replace("{$sqlstr}", encode.htmlencode(tsqlstr));
          ttpl = ttpl.replace("{$state1}", tstate1);
          if (tstate2 == -1 || tstate2 == -101) ttpl = ttpl.replace("{$state2}", "");
          else ttpl = ttpl.replace("{$state2}", "(" + tstate2 + ")");
          tmpstr += ttpl;
        }
      }
    }
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("run")) tmpstr = Module_Action_Run();
    return tmpstr;
  }

  private String Module_List()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("manage-interface.list", "tpl");
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