<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private String Module_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    Integer tpage = cls.getNum(conf.getRequestParameter("page"), 0);
    String tkeyword = cls.getSafeString(conf.getRequestParameter("keyword"));
    Integer tfid = cls.getNum(conf.getRequestParameter("fid"), 0);
    conf.cntitle(conf.jt.itake("default.nav_list", "lng"));
    tmpstr = conf.jt.itake("default.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "keyword") + "='" + tkeyword + "' and " + cls.cfnames(tfpre, "fid") + "=" + tfid + " order by " + cls.cfnames(tfpre, "time") + " desc";
    pagi pagi;
    pagi = new pagi(conf);
    pagi.sqlstr = tsqlstr;
    pagi.pagenum = tpage.longValue();
    pagi.rslimit = cls.getNum64(conf.jt.itake("config.nlisttopx", "cfg"));
    pagi.pagesize = cls.getNum64(conf.jt.itake("config.npagesize", "cfg"));
    pagi.Init();
    Object[] tArys = pagi.getDataAry();
    if (tArys != null)
    {
      for (int tis = 0; tis < tArys.length; tis ++)
      {
        tmptstr = tmpastr;
        Object[][] tAry = (Object[][])tArys[tis];
        for (int ti = 0; ti < tAry.length; ti ++)
        {
          tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
          tmptstr = tmptstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
        }
        conf.rsAry = tAry;
        tmptstr = conf.jt.creplace(tmptstr);
        tmprstr += tmptstr;
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = tmpstr.replace("{$-genre}", tNGenre);
    tmpstr = tmpstr.replace("{$-lng}", cls.toString(tNLng));
    tmpstr = tmpstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
    tmpstr = tmpstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
    tmpstr = conf.jt.creplace(tmpstr);
    return tmpstr;
  }

  private String Module_Default()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("default.default", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    if (cls.isEmpty(tmpstr)) tmpstr = Module_List();
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    conf.cntitle(conf.jt.itake("default.channel_title", "lng"));

    String tmpstr = "";
    String tType = cls.getString(conf.getRequestParameter("type"));
    if (tType.equals("list")) tmpstr = Module_List();
    else tmpstr = Module_Default();

    PageClose();
    return tmpstr;
  }
}
%>