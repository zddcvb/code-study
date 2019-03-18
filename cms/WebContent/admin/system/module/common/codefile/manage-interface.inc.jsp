<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.util.regex.*" %>
<%@ page import = "javax.xml.xpath.*" %>
<%@ page import = "javax.xml.parsers.*" %>
<%@ page import = "org.w3c.dom.*" %>
<%
class module extends jpage
{
  private admin admin;
  private upfiles upfiles;

  private void PP_Application_RemoveAll()
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

  private String PP_GetModuleList(String argGenre)
  {
    int tstate = 0;
    String tGenre = argGenre;
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tGenres1 = conf.getActiveGenre("guide", conf.getActualRouteB("./"));
    String[] tGenres1Ary = tGenres1.split(Pattern.quote("|"));
    tmpstr = conf.jt.itake("manage-interface.data_modulelist", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    for (int ti = 0; ti < tGenres1Ary.length; ti ++)
    {
      String tGenres1AryStr = tGenres1Ary[ti];
      if (!cls.isEmpty(tGenres1AryStr))
      {
        int tis = 0;
        if (cls.isEmpty(tGenre) && tGenres1AryStr.indexOf("/") == -1) tis = 1;
        if (!cls.isEmpty(tGenre) && cls.getLeft(tGenres1AryStr, tGenre.length() + 1).equals(tGenre + "/") && cls.getLRStr(cls.getRight(tGenres1AryStr, tGenres1AryStr.length() - tGenre.length()), "/", "rightr").indexOf("/") == -1) tis = 1;
        if (tis == 1)
        {
          tstate = 1;
          tmptstr = tmpastr;
          tmptstr = tmptstr.replace("{$text}", conf.jt.itake("global." + tGenres1AryStr + ":manage.mgtitle", "lng"));
          tmptstr = tmptstr.replace("{$value}", encode.htmlencode(tGenres1AryStr));
          tmptstr = tmptstr.replace("{$-child}", PP_GetModuleList(tGenres1AryStr));
          String tnuninstall = conf.jt.itake("global." + tGenres1AryStr + ":config.nuninstall", "cfg");
          if (!cls.isEmpty(tnuninstall)) tmptstr = tmptstr.replace("{$-remove-span-class}", "hand");
          else tmptstr = tmptstr.replace("{$-remove-span-class}", "hidden");
          tmprstr += tmptstr;
        }
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = conf.jt.creplace(tmpstr);
    if (tstate == 0) tmpstr = "";
    return tmpstr;
  }

  private String PP_GetChildModuleString(String argGenre)
  {
    String tmpstr = "";
    String tGenre = argGenre;
    String tGenres1 = conf.getActiveGenre("guide", conf.getActualRouteB("./"));
    String[] tGenres1Ary = tGenres1.split(Pattern.quote("|"));
    for (int ti = 0; ti < tGenres1Ary.length; ti ++)
    {
      String tGenres1AryStr = tGenres1Ary[ti];
      if (!cls.isEmpty(tGenres1AryStr))
      {
        int tis = 0;
        if (tGenres1AryStr.equals(tGenre)) tis = 1;
        if (cls.getLeft(tGenres1AryStr, tGenre.length() + 1).equals(tGenre + "/")) tis = 1;
        if (tis == 1) tmpstr += tGenres1AryStr + "|";
      }
    }
    if (!cls.isEmpty(tmpstr)) tmpstr = cls.getLRStr(tmpstr, "|", "leftr");
    return tmpstr;
  }

  private Boolean PP_RemoveModule(String argGenre)
  {
    Boolean tbool = true;
    String tGenre = argGenre;
    String tnuninstall = conf.jt.itake("global." + tGenre + ":config.nuninstall", "cfg");
    if (cls.isEmpty(tnuninstall)) tbool = false;
    else
    {
      String[] tnuninstallAry = tnuninstall.split(Pattern.quote("|"));
      if (tnuninstallAry.length != 3) tbool = false;
      else
      {
        Integer tState1 = 0;
        Integer tState2 = 0;
        Integer tState3 = 0;
        Integer tState4 = 0;
        dbc tDbc = db.newInstance(conf);
        Integer tnuninstallMode1 = cls.getNum(tnuninstallAry[0], 0);
        if (tnuninstallMode1 == 1)
        {
          String[][] tAry1 = conf.jt.itakes("global." + tGenre + ":config.all", "cfg");
          for (int ti = 0; ti < tAry1.length; ti ++)
          {
            String tValue1 = tAry1[ti][0];
            String tValue2 = tAry1[ti][1];
            if (tValue1.equals("ndatabase") || cls.getLRStr(tValue1, "-", "left").equals("ndatabase"))
            {
              String tsqlstr1 = "DROP TABLE [" + tValue2 + "]";
              if (tDbc.Executes(tsqlstr1) != -101) tState1 = 200;
              else
              {
                if (tState1 == 0) tState1 = -101;
              }
            }
          }
        }
        Integer tnuninstallMode2 = cls.getNum(tnuninstallAry[1], 0);
        if (tnuninstallMode2 == 1)
        {
          String tdatabase2 = cls.getString(conf.jt.itake("global.config.sys->category-ndatabase", "cfg"));
          String tfpre2 = cls.getString(conf.jt.itake("global.config.sys->category-nfpre", "cfg"));
          String tsqlstr2 = "DELETE FROM [" + tdatabase2 + "] WHERE " + cls.cfnames(tfpre2, "genre") + "='" + tGenre + "'";
          if (tDbc.Executes(tsqlstr2) == -101) tState2 = -101;
        }
        Integer tnuninstallMode3 = cls.getNum(tnuninstallAry[2], 0);
        if (tnuninstallMode3 == 1)
        {
          String tdatabase3 = cls.getString(conf.jt.itake("global.config.sys->upload-ndatabase", "cfg"));
          String tfpre3 = cls.getString(conf.jt.itake("global.config.sys->upload-nfpre", "cfg"));
          String tsqlstr3 = "DELETE FROM [" + tdatabase3 + "] WHERE " + cls.cfnames(tfpre3, "genre") + "='" + tGenre + "'";
          if (tDbc.Executes(tsqlstr3) == -101) tState3 = -101;
        }
        String tFullPath = conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tGenre))).toString();
        if (!conf.common.directoryDelete(tFullPath)) tState4 = -101;
        if (tState1 == -101 || tState2 == -101 || tState3 == -101 || tState4 == -101) tbool = false;
      }
    }
    return tbool;
  }

  private String Module_Action_Add()
  {
    String tmpstr = "";
    String turl = cls.getString(conf.getRequestUsParameter("url"));
    if (conf.common.fileExists(conf.application.getRealPath(conf.getMapPath(turl)).toString()))
    {
      try
      {
        File tXMLFile = new File(conf.application.getRealPath(conf.getMapPath(turl)).toString());
        DocumentBuilderFactory tDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder tDocumentBuilder = tDocumentBuilderFactory.newDocumentBuilder();
        Document tDocument = tDocumentBuilder.parse(tXMLFile);
        XPath tXPath = XPathFactory.newInstance().newXPath();
        Node tNode1 = (Node)tXPath.evaluate("/xml/configure/genre", tDocument, XPathConstants.NODE);
        String tNewGenre = tNode1.getFirstChild().getNodeValue();
        String tNewGenrePath = conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tNewGenre))).toString();
        if (!conf.common.directoryExists(tNewGenrePath))
        {
          int tState1 = 0;
          NodeList tNodeList1 = (NodeList)tXPath.evaluate("/xml/item_list/item", tDocument, XPathConstants.NODESET);
          Integer tXMLNodesCount = tNodeList1.getLength();
          for (int ti = 0; ti < tXMLNodesCount; ti ++)
          {
            NodeList tNodeList1s = tNodeList1.item(ti).getChildNodes();
            String tfilepath = tNodeList1s.item(1).getFirstChild().getNodeValue();
            String tfilevalue = tNodeList1s.item(3).getFirstChild().getNodeValue();
            byte[] tfilevalueByte = encode.base64decode(tfilevalue);
            if (!(conf.common.directoryCreate(conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(cls.getLRStr(tfilepath, "/", "leftr")))).toString()) && conf.common.fileCreate(conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tfilepath))).toString(), tfilevalueByte))) tState1 = 1;
          }
          if (tState1 == 0)
          {
            int tState2 = 0;
            String tsqlText = "";
            String tdbtype = conf.dbtype;
            if (tdbtype.equals("1")) tsqlText = conf.common.fileGetContents(conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tNewGenre) + "/_install/mysql.sql")).toString());
            if (tdbtype.equals("2")) tsqlText = conf.common.fileGetContents(conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tNewGenre) + "/_install/sqlite.sql")).toString());
            if (tdbtype.equals("11")) tsqlText = conf.common.fileGetContents(conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tNewGenre) + "/_install/access.sql")).toString());
            if (tdbtype.equals("12")) tsqlText = conf.common.fileGetContents(conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tNewGenre) + "/_install/mssql.sql")).toString());
            if (tdbtype.equals("21")) tsqlText = conf.common.fileGetContents(conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tNewGenre) + "/_install/postgresql.sql")).toString());
            if (!cls.isEmpty(tsqlText))
            {
              dbc tDbc = db.newInstance(conf);
              String[] tsqlTextAry = tsqlText.split(Pattern.quote(";"));
              for (int ti = 0; ti < tsqlTextAry.length; ti ++)
              {
                int tstateNum2 = tDbc.Executes(tsqlTextAry[ti]);
                if (tstateNum2 == -101) tState2 = 1;
              }
            }
            if (conf.common.directoryDelete(conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tNewGenre) + "/_install")).toString()))
            {
              PP_Application_RemoveAll();
              tmpstr = conf.jt.itake("manage.add-succeed", "lng");
            }
            else tmpstr = conf.jt.itake("manage.add-error-4", "lng");
          }
          else tmpstr = conf.jt.itake("manage.add-error-3", "lng");
        }
        else tmpstr = conf.jt.itake("manage.add-error-2", "lng");
      }
      catch(Exception e)
      {
        tmpstr = conf.jt.itake("manage.add-error-1", "lng");
      }
    }
    else tmpstr = conf.jt.itake("manage.add-error-0", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Remove()
  {
    String tmpstr = "";
    Boolean tbool = true;
    String tgenre = cls.getString(conf.getRequestUsParameter("genre"));
    if (!cls.isEmpty(tgenre))
    {
      String tChildGenre = PP_GetChildModuleString(tgenre);
      String[] tChildGenreAry = tChildGenre.split(Pattern.quote("|"));
      for (int ti = (tChildGenreAry.length - 1); ti >= 0; ti --)
      {
        String tChildGenreAryStr = tChildGenreAry[ti];
        if (!cls.isEmpty(tChildGenreAryStr))
        {
          if (PP_RemoveModule(tChildGenreAryStr) == false) tbool = false;
        }
      }
    }
    if (tbool == true)
    {
      PP_Application_RemoveAll();
      tmpstr = conf.jt.itake("manage.remove-succeed", "lng");
    }
    else tmpstr = conf.jt.itake("manage.remove-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("add")) tmpstr = Module_Action_Add();
    else if (tAtype.equals("remove")) tmpstr = Module_Action_Remove();
    else if (tAtype.equals("upload")) tmpstr = upfiles.uploadFiles("file1", 0, admin.username);
    return tmpstr;
  }

  private String Module_List()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("manage-interface.list", "tpl");
    tmpstr = tmpstr.replace("{$-modulelist}", PP_GetModuleList(""));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Remove()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    tmpstr = conf.jt.itake("manage-interface.remove", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String tgenre = cls.getString(conf.getRequestUsParameter("genre"));
    if (!cls.isEmpty(tgenre))
    {
      String tChildGenre = PP_GetChildModuleString(tgenre);
      String[] tChildGenreAry = tChildGenre.split(Pattern.quote("|"));
      for (int ti = 0; ti < tChildGenreAry.length; ti ++)
      {
        String tChildGenreAryStr = tChildGenreAry[ti];
        if (!cls.isEmpty(tChildGenreAryStr))
        {
          String tnuninstall = conf.jt.itake("global." + tChildGenreAryStr + ":config.nuninstall", "cfg");
          if (!cls.isEmpty(tnuninstall))
          {
            tmptstr = tmpastr;
            tmptstr = tmptstr.replace("{$text}", conf.jt.itake("global." + tChildGenreAryStr + ":manage.mgtitle", "lng"));
            tmptstr = tmptstr.replace("{$value}", encode.htmlencode(tChildGenreAryStr));
            tmprstr += tmptstr;
          }
        }
      }
    }
    tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
    tmpstr = tmpstr.replace("{$-genre}", encode.htmlencode(tgenre));
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
    upfiles = new upfiles(conf);

    if (admin.ckLogin())
    {
      String tType = cls.getString(conf.getRequestUsParameter("type"));

      if (tType.equals("action")) tmpstr = Module_Action();
      else if (tType.equals("list")) tmpstr = Module_List();
      else if (tType.equals("remove")) tmpstr = Module_Remove();
      else if (tType.equals("upload")) tmpstr = upfiles.uploadHTML("upload-html-1");
      else tmpstr = Module_List();
    }

    PageClose();

    return tmpstr;
  }
}
%>