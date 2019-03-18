<%@ page import = "jtbc.*" %>
<%
class module extends jpage
{
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
    tmpstr = Module_Default();
    PageClose();
    return tmpstr;
  }
}
%>