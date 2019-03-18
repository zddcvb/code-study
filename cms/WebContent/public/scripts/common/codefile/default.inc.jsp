<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private String Module_Js()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestParameter("id"), 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tId;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      String tJsPath = conf.jt.itake("config.njspath", "cfg");
      String tJsFullPath = conf.application.getRealPath(conf.getMapPath(tJsPath + tId + ".js")).toString();
      String tContent = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "content")));
      Integer tTimeout = cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "timeout"))), 0);
      Long tNowNumber = cls.getUnixStamp(cls.formatDate(cls.getDate(), 100));
      Long tLastTimeNumber = cls.getUnixStamp(cls.formatDate(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "lasttime"))), 100));
      if ((tNowNumber - tLastTimeNumber) > tTimeout)
      {
        String tNewContent = "";
        tContent = conf.jt.creplace(tContent);
        tContent = encode.encodeNewline(tContent);
        String[] tContentAry = tContent.split("\r\n");
        for (int ti = 0; ti < tContentAry.length; ti ++)
        {
          tNewContent += "document.write('" + encode.scriptencode(tContentAry[ti]) + "');\r\n";
        }
        if (conf.common.filePutContents(tJsFullPath, tNewContent)) tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "lasttime") + "='" + cls.getDate() + "' where " + tidfield + "=" + tId);
      }
      tmpstr = conf.common.fileGetContents(tJsFullPath);
    }
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();

    String tmpstr = "";
    String tType = cls.getString(conf.getRequestParameter("type"));
    if (tType.equals("js")) tmpstr = Module_Js();
    else tmpstr = Module_Js();

    PageClose();
    return tmpstr;
  }
}
%>