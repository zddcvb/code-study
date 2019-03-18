<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private admin admin;
  private dbcache dbcache;

  private String Module_Action_Add()
  {
    String tmpstr = "";
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tusername = cls.getString(conf.getRequestUsParameter("username"));
    if (!validator.isUsername(tusername)) tmpstr = conf.jt.itake("manage.add-error-1", "lng");
    else
    {
      tusername = cls.getSafeString(tusername);
      String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "username") + "='" + tusername + "'";
      dbc tDbc = db.newInstance(conf);
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null) tmpstr = conf.jt.itake("manage.add-error-2", "lng");
      else
      {
        tsqlstr = "insert into " + tdatabase + " (";
        tsqlstr += cls.cfnames(tfpre, "username") + ",";
        tsqlstr += cls.cfnames(tfpre, "password") + ",";
        tsqlstr += cls.cfnames(tfpre, "email") + ",";
        tsqlstr += cls.cfnames(tfpre, "city") + ",";
        tsqlstr += cls.cfnames(tfpre, "gender") + ",";
        tsqlstr += cls.cfnames(tfpre, "name") + ",";
        tsqlstr += cls.cfnames(tfpre, "phone") + ",";
        tsqlstr += cls.cfnames(tfpre, "address") + ",";
        tsqlstr += cls.cfnames(tfpre, "zipcode") + ",";
        tsqlstr += cls.cfnames(tfpre, "group") + ",";
        tsqlstr += cls.cfnames(tfpre, "time");
        tsqlstr += ") values (";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("username")), 50) + "',";
        tsqlstr += "'" + cls.getLeft(encode.md5(conf.getRequestUsParameter("password").getBytes()), 50) + "',";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("email")), 50) + "',";
        tsqlstr += cls.getNum(conf.getRequestUsParameter("city"), 0) + ",";
        tsqlstr += cls.getNum(conf.getRequestUsParameter("gender"), 0) + ",";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("name")), 50) + "',";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("phone")), 50) + "',";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("address")), 255) + "',";
        tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("zipcode")), 50) + "',";
        tsqlstr += cls.getNum(conf.getRequestUsParameter("group"), 0) + ",";
        tsqlstr += "'" + cls.getDate() + "'";
        tsqlstr += ")";
        int tstateNum = tDbc.Executes(tsqlstr);
        if (tstateNum != -101) tmpstr = conf.jt.itake("global.lng_common.add-succeed", "lng");
        else tmpstr = conf.jt.itake("global.lng_common.add-failed", "lng");
      }
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Edit()
  {
    String tmpstr = "";
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tpassword = cls.getString(conf.getRequestUsParameter("password"));
    String tsqlstr = "update " + tdatabase + " set ";
    if (!cls.isEmpty(tpassword)) tsqlstr += cls.cfnames(tfpre, "password") + "='" + cls.getLeft(encode.md5(conf.getRequestUsParameter("password").getBytes()), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "email") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("email")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "city") + "=" + cls.getNum(conf.getRequestUsParameter("city"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "gender") + "=" + cls.getNum(conf.getRequestUsParameter("gender"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "name") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("name")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "phone") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("phone")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "address") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("address")), 255) + "',";
    tsqlstr += cls.cfnames(tfpre, "zipcode") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("zipcode")), 50) + "',";
    tsqlstr += cls.cfnames(tfpre, "group") + "=" + cls.getNum(conf.getRequestUsParameter("group"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "emoney") + "=" + cls.getNum(conf.getRequestUsParameter("emoney"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "integral") + "=" + cls.getNum(conf.getRequestUsParameter("integral"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "face") + "=" + cls.getNum(conf.getRequestUsParameter("face"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "face_u") + "=" + cls.getNum(conf.getRequestUsParameter("face_u"), 0) + ",";
    tsqlstr += cls.cfnames(tfpre, "face_url") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("face_url")), 255) + "',";
    tsqlstr += cls.cfnames(tfpre, "sign") + "='" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("sign")), 255) + "',";
    tsqlstr += cls.cfnames(tfpre, "lock") + "=" + cls.getNum(conf.getRequestUsParameter("lock"), 0);
    tsqlstr += " where " + tidfield + "=" + tid;
    dbc tDbc = db.newInstance(conf);
    int tstateNum = tDbc.Executes(tsqlstr);
    if (tstateNum != -101)
    {
      dbcache.deleteCache(tdatabase, tfpre, tid);
      tmpstr = conf.jt.itake("global.lng_common.edit-succeed", "lng");
    }
    else tmpstr = conf.jt.itake("global.lng_common.edit-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Delete()
  {
    String tstate = "200";
    Integer tid = cls.getNum(conf.getRequestUsParameter("id"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = conf.common.dataDelete(tdatabase, tidfield, cls.toString(tid));
    if (tstateNum == -101) tstate = "-101";
    return tstate;
  }

  private String Module_Action_Switch()
  {
    String tstate = "200";
    String tids = cls.getString(conf.getRequestUsParameter("ids"));
    String tswtype = cls.getString(conf.getRequestUsParameter("swtype"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    Integer tstateNum = 0;
    if (tswtype.equals("lock")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "lock"), tidfield, tids);
    else if (tswtype.equals("delete")) tstateNum = conf.common.dataDelete(tdatabase, tidfield, tids);
    if (tstateNum == -101) tstate = "-101";
    return tstate;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("add")) tmpstr = Module_Action_Add();
    else if (tAtype.equals("edit")) tmpstr = Module_Action_Edit();
    else if (tAtype.equals("delete")) tmpstr = Module_Action_Delete();
    else if (tAtype.equals("switch")) tmpstr = Module_Action_Switch();
    return tmpstr;
  }

  private String Module_Add()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("manage-interface.add", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Edit()
  {
    String tmpstr = "";
    Integer tId = cls.getNum(conf.getRequestUsParameter("id"), 0);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tId;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      tmpstr = conf.jt.itake("manage-interface.edit", "tpl");
      for (int ti = 0; ti < tAry.length; ti ++)
      {
        tAry[ti][0] = (Object)cls.getLRStr((String)tAry[ti][0], tfpre, "rightr");
        tmpstr = tmpstr.replace("{$" + cls.toString(tAry[ti][0]) + "}", encode.htmlencode(cls.toString(tAry[ti][1])));
      }
      conf.rsAry = tAry;
      tmpstr = conf.jt.creplace(tmpstr);
    }
    else tmpstr = conf.jt.itake("global.lng_common.edit-404", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    Integer tpage = cls.getNum(conf.getRequestUsParameter("page"));
    Integer tgroup = cls.getNum(conf.getRequestUsParameter("group"), -1);
    String tfield = cls.getSafeString(conf.getRequestUsParameter("field"));
    String tkeyword = cls.getSafeString(conf.getRequestUsParameter("keyword"));
    tmpstr = conf.jt.itake("manage-interface.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tsqlstr = "select * from " + tdatabase + " where 1=1";
    if (tgroup != -1) tsqlstr += " and " + cls.cfnames(tfpre, "group") + "=" + tgroup;
    if (tfield.equals("username")) tsqlstr += " and " + cls.cfnames(tfpre, "username") + " like '%" + tkeyword + "%'";
    if (tfield.equals("lock")) tsqlstr += " and " + cls.cfnames(tfpre, "lock") + "=" + cls.getNum(tkeyword);
    if (tfield.equals("id")) tsqlstr += " and " + cls.cfnames(tfpre, "id") + "=" + cls.getNum(tkeyword);
    tsqlstr += " order by " + cls.cfnames(tfpre, "time") + " desc";
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
        tmprstr += tmptstr;
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = tmpstr.replace("{$pagi.pagenum}", cls.toString(pagi.pagenum));
    tmpstr = tmpstr.replace("{$pagi.pagenums}", cls.toString(pagi.pagenums));
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
    dbcache = new dbcache(conf);

    if (admin.ckLogin())
    {
      String tType = cls.getString(conf.getRequestUsParameter("type"));

      if (tType.equals("action")) tmpstr = Module_Action();
      else if (tType.equals("add")) tmpstr = Module_Add();
      else if (tType.equals("edit")) tmpstr = Module_Edit();
      else if (tType.equals("list")) tmpstr = Module_List();
      else tmpstr = Module_List();
    }

    PageClose();

    return tmpstr;
  }
}
%>