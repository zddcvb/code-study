<%@ page import = "jtbc.*" %>
<%
class module extends jpage
{
  private admin admin;

  private String Module_Action_Folder_Add()
  {
    String tmpstr = "";
    String tpath = cls.getString(conf.getRequestUsParameter("path"));
    String tFolder = cls.getString(conf.getRequestUsParameter("folder"));
    String tFullPath = conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tpath + tFolder))).toString();
    if (conf.common.directoryCreateNew(tFullPath)) tmpstr = conf.jt.itake("global.lng_common.add-succeed", "lng");
    else tmpstr = conf.jt.itake("global.lng_common.add-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Folder_Edit()
  {
    String tmpstr = "";
    String tpath = cls.getString(conf.getRequestUsParameter("path"));
    String tFolder = cls.getString(conf.getRequestUsParameter("folder"));
    String tFullPath1 = conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tpath))).toString();
    String tFullPath2 = conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(cls.getLRStr(tpath, "/", "leftr") + "/" + tFolder))).toString();
    if (conf.common.directoryMove(tFullPath1, tFullPath2)) tmpstr = conf.jt.itake("global.lng_common.edit-succeed", "lng");
    else tmpstr = conf.jt.itake("global.lng_common.edit-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Folder_Delete()
  {
    String tstate = "200";
    String tpath = cls.getString(conf.getRequestUsParameter("path"));
    String tFullPath = conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tpath))).toString();
    if (!conf.common.directoryDelete(tFullPath)) tstate = conf.ajaxPreContent + conf.jt.itake("global.lng_common.delete-failed", "lng");
    return tstate;
  }

  private String Module_Action_Folder()
  {
    String tmpstr = "";
    String tFtype = cls.getString(conf.getRequestUsParameter("ftype"));
    if (tFtype.equals("add")) tmpstr = Module_Action_Folder_Add();
    else if (tFtype.equals("edit")) tmpstr = Module_Action_Folder_Edit();
    else if (tFtype.equals("delete")) tmpstr = Module_Action_Folder_Delete();
    return tmpstr;
  }

  private String Module_Action_File_Add()
  {
    String tmpstr = "";
    String tpath = cls.getString(conf.getRequestUsParameter("path"));
    String tFile = cls.getString(conf.getRequestUsParameter("file"));
    String tContent = cls.getString(conf.getRequestUsParameter("content"));
    String tFullPath = conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tpath + tFile))).toString();
    if (!conf.common.fileExists(tFullPath))
    {
      if (conf.common.filePutContents(tFullPath, tContent)) tmpstr = conf.jt.itake("global.lng_common.add-succeed", "lng");
      else tmpstr = conf.jt.itake("global.lng_common.add-failed", "lng");
    }
    else tmpstr = conf.jt.itake("global.lng_common.add-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_File_Edit()
  {
    String tmpstr = "";
    String tpath = cls.getString(conf.getRequestUsParameter("path"));
    String tFile = cls.getString(conf.getRequestUsParameter("file"));
    String tContent = cls.getString(conf.getRequestUsParameter("content"));
    String tFullPath = conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(cls.getLRStr(tpath, "/", "leftr") + "/" + tFile))).toString();
    if (conf.common.filePutContents(tFullPath, tContent)) tmpstr = conf.jt.itake("global.lng_common.edit-succeed", "lng");
    else tmpstr = conf.jt.itake("global.lng_common.edit-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_File_Delete()
  {
    String tstate = "200";
    String tpath = cls.getString(conf.getRequestUsParameter("path"));
    String tFullPath = conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tpath))).toString();
    if (!conf.common.fileDelete(tFullPath)) tstate = conf.ajaxPreContent + conf.jt.itake("global.lng_common.delete-failed", "lng");
    return tstate;
  }

  private String Module_Action_File()
  {
    String tmpstr = "";
    String tFtype = cls.getString(conf.getRequestUsParameter("ftype"));
    if (tFtype.equals("add")) tmpstr = Module_Action_File_Add();
    else if (tFtype.equals("edit")) tmpstr = Module_Action_File_Edit();
    else if (tFtype.equals("delete")) tmpstr = Module_Action_File_Delete();
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("folder")) tmpstr = Module_Action_Folder();
    else if (tAtype.equals("file")) tmpstr = Module_Action_File();
    return tmpstr;
  }

  private String Module_Folder_Add()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("manage-interface.folder_add", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Folder_Edit()
  {
    String tmpstr = "";
    String tpath = cls.getString(conf.getRequestUsParameter("path"));
    tmpstr = conf.jt.itake("manage-interface.folder_edit", "tpl");
    tmpstr = tmpstr.replace("{$path}", encode.htmlencode(tpath));
    tmpstr = tmpstr.replace("{$folder}", encode.htmlencode(cls.getLRStr(tpath, "/", "right")));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Folder()
  {
    String tmpstr = "";
    String tFtype = cls.getString(conf.getRequestUsParameter("ftype"));
    if (tFtype.equals("add")) tmpstr = Module_Folder_Add();
    else if (tFtype.equals("edit")) tmpstr = Module_Folder_Edit();
    return tmpstr;
  }

  private String Module_File_Add()
  {
    String tmpstr = "";
    tmpstr = conf.jt.itake("manage-interface.file_add", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_File_Edit()
  {
    String tmpstr = "";
    String tpath = cls.getString(conf.getRequestUsParameter("path"));
    tmpstr = conf.jt.itake("manage-interface.file_edit", "tpl");
    tmpstr = tmpstr.replace("{$path}", encode.htmlencode(tpath));
    tmpstr = tmpstr.replace("{$file}", encode.htmlencode(cls.getLRStr(tpath, "/", "right")));
    tmpstr = tmpstr.replace("{$content}", encode.htmlencode(conf.common.fileGetContents(conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tpath))).toString())));
    tmpstr = conf.jt.creplace(tmpstr);
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_File()
  {
    String tmpstr = "";
    String tFtype = cls.getString(conf.getRequestUsParameter("ftype"));
    if (tFtype.equals("add")) tmpstr = Module_File_Add();
    else if (tFtype.equals("edit")) tmpstr = Module_File_Edit();
    return tmpstr;
  }

  private String Module_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String tpath = cls.getString(conf.getRequestUsParameter("path"));
    String tfield = cls.getString(conf.getRequestUsParameter("field"));
    String tkeyword = cls.getString(conf.getRequestUsParameter("keyword"));
    if (cls.isEmpty(tpath)) tpath = "./";
    tmpstr = conf.jt.itake("manage-interface.list", "tpl");
    tmprstr = "";
    tmpastr = cls.ctemplate(tmpstr, "{@}");
    String[][] tAry1 = conf.common.getFolderList(conf.getActualRoute(tpath));
    if (tAry1 != null && !tfield.equals("filename"))
    {
      for (int ti = 0; ti < tAry1.length; ti ++)
      {
        if (cls.isEmpty(tkeyword) || tAry1[ti][0].indexOf(tkeyword) != -1)
        {
          tmptstr = tmpastr;
          tmptstr = tmptstr.replace("{$id}", "1" + ti);
          tmptstr = tmptstr.replace("{$filetype}", "folder");
          tmptstr = tmptstr.replace("{$name}", encode.htmlencode(tAry1[ti][0]));
          tmptstr = tmptstr.replace("{$size}", cls.formatByte(tAry1[ti][1]));
          tmptstr = tmptstr.replace("{$time}", encode.htmlencode(tAry1[ti][2]));
          tmptstr = tmptstr.replace("{$onclick1}", "manages.tLoad('?type=list&path=" + conf.urlencode(tpath + encode.htmlencode(tAry1[ti][0]) + "/") + "');");
          tmptstr = tmptstr.replace("{$onclick2}", "manages.popup.tLoad('?type=folder&ftype=edit&path=" + conf.urlencode(tpath + encode.htmlencode(tAry1[ti][0])) + "');");
          tmptstr = tmptstr.replace("{$onclick3}", "manages.tFolderDelete(\\'?type=action&atype=folder&ftype=delete&path=" + conf.urlencode(tpath + encode.htmlencode(tAry1[ti][0])) + "\\');");
          tmprstr += tmptstr;
        }
      }
    }
    String[][] tAry2 = conf.common.getFileList(conf.getActualRoute(tpath));
    if (tAry2 != null && !tfield.equals("foldername"))
    {
      for (int ti = 0; ti < tAry2.length; ti ++)
      {
        String tFileType = cls.getLRStr(tAry2[ti][0], ".", "right");
        if (cls.isEmpty(tkeyword) || tAry2[ti][0].indexOf(tkeyword) != -1)
        {
          tmptstr = tmpastr;
          tmptstr = tmptstr.replace("{$id}", "2" + ti);
          tmptstr = tmptstr.replace("{$filetype}", encode.htmlencode(tFileType));
          tmptstr = tmptstr.replace("{$name}", encode.htmlencode(tAry2[ti][0]));
          tmptstr = tmptstr.replace("{$size}", cls.formatByte(tAry2[ti][1]));
          tmptstr = tmptstr.replace("{$time}", encode.htmlencode(tAry2[ti][2]));
          if (cls.cinstr(conf.jt.itake("config.ntextfiletype", "cfg"), tFileType, "."))
          {
            tmptstr = tmptstr.replace("{$onclick1}", "manages.popup.tLoad('?type=file&ftype=edit&path=" + conf.urlencode(tpath + encode.htmlencode(tAry2[ti][0])) + "');");
            tmptstr = tmptstr.replace("{$onclick2}", "manages.popup.tLoad('?type=file&ftype=edit&path=" + conf.urlencode(tpath + encode.htmlencode(tAry2[ti][0])) + "');");
          }
          else
          {
            tmptstr = tmptstr.replace("{$onclick1}", "manage.windows.dialog.tAlert('" + conf.jt.itake("manage.edit-file-error-1", "lng") + "');");
            tmptstr = tmptstr.replace("{$onclick2}", "manage.windows.dialog.tAlert('" + conf.jt.itake("manage.edit-file-error-1", "lng") + "');");
          }
          tmptstr = tmptstr.replace("{$onclick3}", "manages.tFileDelete(\\'?type=action&atype=file&ftype=delete&path=" + conf.urlencode(tpath + encode.htmlencode(tAry2[ti][0])) + "\\');");
          tmprstr += tmptstr;
        }
      }
    }
    tmpstr = tmpstr.replace("{$path}", encode.htmlencode(conf.application.getRealPath(conf.getMapPath(conf.getActualRoute(tpath))).toString()));
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
      else if (tType.equals("folder")) tmpstr = Module_Folder();
      else if (tType.equals("file")) tmpstr = Module_File();
      else if (tType.equals("list")) tmpstr = Module_List();
      else tmpstr = Module_List();
    }

    PageClose();

    return tmpstr;
  }
}
%>