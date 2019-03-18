<%@ page import = "jtbc.*" %>
<%
class module extends jpage
{
  public String getOutput()
  {
    PageInit();
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    tmpstr = conf.jt.itake("manage.default", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String[][] tgroupary = conf.jt.itakes("sel_group.jtbc", "lng");
    if (tgroupary != null)
    {
      for (int ti = 0; ti < tgroupary.length; ti ++)
      {
        tmptstr = tmpastr;
        tmptstr = tmptstr.replace("{$-group-id}", encode.htmlencode(tgroupary[ti][0]));
        tmptstr = tmptstr.replace("{$-group-topic}", encode.htmlencode(tgroupary[ti][1]));
        tmprstr += tmptstr;
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = conf.jt.creplace(tmpstr);
    PageClose();
    return tmpstr;
  }
}
%>