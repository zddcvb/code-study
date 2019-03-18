<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private String Module_Detail()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestParameter("id"), 0);
    Integer tCtPage = cls.getNum(conf.getRequestParameter("ctpage"), 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tId;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      conf.cntitle((String)tDbc.getValue(tAry, cls.cfnames(tfpre, "topic")));
      tmpstr = conf.jt.itake("default.detail", "tpl");
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
      tmpstr = tmpstr.replace("{$-genre}", conf.getNGenre());
      tmpstr = tmpstr.replace("{$-lng}", cls.toString(conf.getNLng()));
      tmpstr = tmpstr.replace("{$-ctpage}", cls.toString(tCtPage));
      tmpstr = tmpstr.replace("{$-ctpages}", conf.common.getCuteContentCount(cls.toString(tDbc.getValue(tAry, "content"))));
      tmpstr = conf.jt.creplace(tmpstr);
    }
    return tmpstr;
  }

  private String Module_Default()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("default.default", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    conf.cntitle(conf.jt.itake("default.channel_title", "lng"));

    String tmpstr = "";
    String tType = cls.getString(conf.getRequestParameter("type"));
    if (tType.equals("detail")) tmpstr = Module_Detail();
    else tmpstr = Module_Default();

    PageClose();
    return tmpstr;
  }
}
%>