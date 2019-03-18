<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private String Module_Count()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    String tGenre = cls.getSafeString(conf.getRequestUsParameter("genre"));
    String tActiveGenre = conf.getActiveGenre("config", conf.getActualRouteB("./"));
    if (cls.cinstr(tActiveGenre, tGenre, "|"))
    {
      String tdatabase = cls.getString(conf.jt.itake("global." + tGenre + ":config.ndatabase", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("global." + tGenre + ":config.nfpre", "cfg"));
      String tidfield = cls.cfnames(tfpre, "id");
      String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tId;
      dbc tDbc = db.newInstance(conf);
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        Object[][] tAry = (Object[][])tArys[0];
        Integer tcount = (Integer)tDbc.getValue(tAry, cls.cfnames(tfpre, "count"));
        tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "count") + "=" + cls.cfnames(tfpre, "count") + "+1 where " + tidfield + "=" + tId);
        tmpstr = cls.toString(tcount);
      }
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    String tmpstr = "";
    String tType = cls.getString(conf.getRequestUsParameter("type"));

    if (tType.equals("count")) tmpstr = Module_Count();
    else tmpstr = Module_Count();

    PageClose();
    return tmpstr;
  }
}
%>