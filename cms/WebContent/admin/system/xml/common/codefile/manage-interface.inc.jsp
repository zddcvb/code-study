<%@ page import = "jtbc.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.util.regex.*" %>
<%@ page import = "javax.xml.xpath.*" %>
<%@ page import = "javax.xml.parsers.*" %>
<%@ page import = "javax.xml.transform.*" %>
<%@ page import = "javax.xml.transform.dom.*" %>
<%@ page import = "javax.xml.transform.stream.*" %>
<%@ page import = "org.w3c.dom.*" %>
<%
class module extends jpage
{
  private admin admin;

  private String PP_GetXmlRoot(String argXml)
  {
    String tXml = argXml;
    String tmpRoot = "";
    String[] tXmlAry = tXml.split(Pattern.quote("."));
    if (tXmlAry.length == 3)
    {
      tmpRoot = conf.getActualRoute(tXmlAry[0]);
      if (cls.getRight(tmpRoot, 1) != "/") tmpRoot += "/";
      String ttXmlAry1String = tXmlAry[1];
      if (ttXmlAry1String.equals("tpl")) tmpRoot += "common/template/";
      else if (ttXmlAry1String.equals("lng")) tmpRoot += "common/language/";
      else if (ttXmlAry1String.equals("cfg")) tmpRoot += "common/";
      else tmpRoot += "common/";
      tmpRoot += tXmlAry[2] + conf.xmlsfx;
    }
    return tmpRoot;
  }

  private String Module_Action_Edit()
  {
    String tmpstr = "";
    String tnode = cls.getSafeString(conf.getRequestUsParameter("xmlconfig_node"));
    String tfield = cls.getSafeString(conf.getRequestUsParameter("xmlconfig_field"));
    String tbase = cls.getSafeString(conf.getRequestUsParameter("xmlconfig_base"));
    Integer tcount = cls.getNum(conf.getRequestUsParameter("xmlconfig_count"), 0);
    String trootstr = "";
    try
    {
      trootstr = new String(encode.base64decode(conf.getRequestUsParameter("xmlconfig_rootstr")), conf.charset);
      trootstr = cls.getSafeString(trootstr);
    }
    catch(Exception e) {}
    if (conf.common.fileExists(conf.application.getRealPath(conf.getMapPath(trootstr)).toString()) && !cls.isEmpty(tnode) && !cls.isEmpty(tfield) && !cls.isEmpty(tbase))
    {
      String tmpXML = "";
      String tmode = conf.jt.getXRootAtt(trootstr, "mode");
      String[] tfieldAry = tfield.split(Pattern.quote(","));
      tmpXML += "<?xml version=\"1.0\" encoding=\"" + conf.charset + "\"?>" + "\r\n";
      tmpXML += "<xml mode=\"" + tmode + "\" author=\"jetiben\">" + "\r\n";
      tmpXML += "  <configure>" + "\r\n";
      tmpXML += "    <node>" + tnode + "</node>" + "\r\n";
      tmpXML += "    <field>" + tfield + "</field>" + "\r\n";
      tmpXML += "    <base>" + tbase + "</base>" + "\r\n";
      tmpXML += "  </configure>" + "\r\n";
      tmpXML += "  <" + tbase + ">" + "\r\n";
      for (int ti = 0; ti < tcount; ti ++)
      {
        tmpXML += "    <" + tnode + ">" + "\r\n";
        for (int tis = 0; tis < tfieldAry.length; tis ++)
        {
          tmpXML += "      <" + tfieldAry[tis] + "><![CDATA[" + cls.getString(conf.getRequestUsParameter(tfieldAry[tis] + ti)) + "]]></" + tfieldAry[tis] + ">" + "\r\n";
        }
        tmpXML += "    </" + tnode + ">" + "\r\n";
      }
      int tNewNodeState = 0;
      for (int tis = 0; tis < tfieldAry.length; tis ++)
      {
        if (!cls.isEmpty(conf.getRequestUsParameter(tfieldAry[tis] + "-new"))) tNewNodeState = 1;
      }
      if (tNewNodeState == 1)
      {
        tmpXML += "    <" + tnode + ">" + "\r\n";
        for (int tis = 0; tis < tfieldAry.length; tis ++)
        {
          tmpXML += "      <" + tfieldAry[tis] + "><![CDATA[" + cls.getString(conf.getRequestUsParameter(tfieldAry[tis] + "-new")) + "]]></" + tfieldAry[tis] + ">" + "\r\n";
        }
        tmpXML += "    </" + tnode + ">" + "\r\n";
      }
      tmpXML += "  </" + tbase + ">" + "\r\n";
      tmpXML += "</xml>" + "\r\n";
      if (conf.common.filePutContents(conf.application.getRealPath(conf.getMapPath(trootstr)).toString(), tmpXML)) tmpstr = conf.jt.itake("global.lng_common.edit-succeed", "lng");
      else tmpstr = conf.jt.itake("global.lng_common.edit-failed", "lng");
    }
    else tmpstr = conf.jt.itake("global.lng_common.edit-failed", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Delete()
  {
    String tmpstr = "";
    String trootstr = "";
    String tvaluestr = "";
    try
    {
      trootstr = new String(encode.base64decode(conf.getRequestUsParameter("root")), conf.charset);
      trootstr = cls.getSafeString(trootstr);
      tvaluestr = new String(encode.base64decode(conf.getRequestUsParameter("value")), conf.charset);
      tvaluestr = cls.getSafeString(tvaluestr);
    }
    catch(Exception e) {}
    tmpstr = conf.jt.itake("global.lng_common.delete-failed", "lng");
    if (conf.common.fileExists(conf.application.getRealPath(conf.getMapPath(trootstr)).toString()))
    {
      try
      {
        String tnode, tfield, tbase;
        File tXMLFile = new File(conf.application.getRealPath(conf.getMapPath(trootstr)).toString());
        DocumentBuilderFactory tDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder tDocumentBuilder = tDocumentBuilderFactory.newDocumentBuilder();
        Document tDocument = tDocumentBuilder.parse(tXMLFile);
        XPath tXPath = XPathFactory.newInstance().newXPath();
        Node tNode1 = (Node)tXPath.evaluate("/xml/configure/node", tDocument, XPathConstants.NODE);
        Node tNode2 = (Node)tXPath.evaluate("/xml/configure/field", tDocument, XPathConstants.NODE);
        Node tNode3 = (Node)tXPath.evaluate("/xml/configure/base", tDocument, XPathConstants.NODE);
        tnode = tNode1.getFirstChild().getNodeValue();
        tfield = tNode2.getFirstChild().getNodeValue();
        tbase = tNode3.getFirstChild().getNodeValue();
        Node tXmlNodeDel = (Node)tXPath.evaluate("/xml/" + tbase + "/" + tnode + "[" + cls.getLRStr(tfield, ",", "left") + "='" + tvaluestr + "']", tDocument, XPathConstants.NODE);
        if (tXmlNodeDel != null)
        {
          tXmlNodeDel.getParentNode().removeChild(tXmlNodeDel);
          TransformerFactory tTransformerFactory = TransformerFactory.newInstance();
          Transformer tTransformer = tTransformerFactory.newTransformer();
          DOMSource tDOMSource = new DOMSource(tDocument);
          StreamResult tStreamResult = new StreamResult(new File(conf.application.getRealPath(conf.getMapPath(trootstr)).toString()));
          tTransformer.transform(tDOMSource, tStreamResult);
          tmpstr = conf.jt.itake("global.lng_common.delete-succeed", "lng");
        }
      }
      catch(Exception e) {}
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("edit")) tmpstr = Module_Action_Edit();
    else if (tAtype.equals("delete")) tmpstr = Module_Action_Delete();
    return tmpstr;
  }

  private String Module_List()
  {
    String tmpstr = "";
    String tmpastr, tmprstr, tmptstr;
    String txml = cls.getSafeString(conf.getRequestUsParameter("xml"));
    String trootstr = PP_GetXmlRoot(txml);
    if (conf.common.fileExists(conf.application.getRealPath(conf.getMapPath(trootstr)).toString()))
    {
      Integer tXMLNodesCount = 0;
      String tnode, tfield, tbase;
      tmpstr = conf.jt.itake("manage-interface.list", "tpl");
      tmprstr = "";
      tmpastr = cls.ctemplate(tmpstr, "{@}");
      try
      {
        File tXMLFile = new File(conf.application.getRealPath(conf.getMapPath(trootstr)).toString());
        DocumentBuilderFactory tDocumentBuilderFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder tDocumentBuilder = tDocumentBuilderFactory.newDocumentBuilder();
        Document tDocument = tDocumentBuilder.parse(tXMLFile);
        XPath tXPath = XPathFactory.newInstance().newXPath();
        Node tNode1 = (Node)tXPath.evaluate("/xml/configure/node", tDocument, XPathConstants.NODE);
        Node tNode2 = (Node)tXPath.evaluate("/xml/configure/field", tDocument, XPathConstants.NODE);
        Node tNode3 = (Node)tXPath.evaluate("/xml/configure/base", tDocument, XPathConstants.NODE);
        tnode = tNode1.getFirstChild().getNodeValue();
        tfield = tNode2.getFirstChild().getNodeValue();
        tbase = tNode3.getFirstChild().getNodeValue();
        if (tfield.indexOf(",") >= 0)
        {
          String[] tfieldAry = tfield.split(Pattern.quote(","));
          Integer tLength = tfieldAry.length;
          NodeList tNodeList1 = (NodeList)tXPath.evaluate("/xml/" + tbase + "/" + tnode, tDocument, XPathConstants.NODESET);
          tXMLNodesCount = tNodeList1.getLength();
          for (int ti = 0; ti < tXMLNodesCount; ti ++)
          {
            NodeList tNodeList1s = tNodeList1.item(ti).getChildNodes();
            for (int tis = 0; tis < tLength; tis ++)
            {
              tmptstr = tmpastr;
              int tnodeNum = tis * 2 + 1;
              String tValueTpl = conf.jt.itake("manage-interface.data-value-textarea", "tpl");
              if (tis == 0) tValueTpl = conf.jt.itake("manage-interface.data-value-input", "tpl");
              String tName = tfieldAry[tis];
              String tValue = tNodeList1s.item(tnodeNum).getFirstChild().getNodeValue();
              tValueTpl = tValueTpl.replace("{$i}", cls.toString(ti));
              tValueTpl = tValueTpl.replace("{$name}", encode.htmlencode(tName));
              tValueTpl = tValueTpl.replace("{$value}", encode.htmlencode(tValue));
              tValueTpl = tValueTpl.replace("{$value64}", encode.base64encode(tValue.getBytes()));
              tValueTpl = tValueTpl.replace("{$rootstr}", encode.base64encode(trootstr.getBytes()));
              tmptstr = tmptstr.replace("{$name}", encode.htmlencode(tName));
              tmptstr = tmptstr.replace("{$tpl}", tValueTpl);
              tmprstr += tmptstr;
            }
          }
        }
      }
      catch(Exception e)
      {
        tnode = "";
        tfield = "";
        tbase = "";
      }
      tmpstr = cls.ctemplates(tmpstr, "{@}", tmprstr);
      tmprstr = "";
      tmpastr = cls.ctemplate(tmpstr, "{@@}");
      if (!cls.isEmpty(tfield))
      {
        String[] tfieldArys = tfield.split(Pattern.quote(","));
        for (int tis = 0; tis < tfieldArys.length; tis ++)
        {
          tmptstr = tmpastr;
          String tValueTpl = conf.jt.itake("manage-interface.data-value-textarea", "tpl");
          if (tis == 0) tValueTpl = conf.jt.itake("manage-interface.data-value-input-2", "tpl");
          String tName = tfieldArys[tis];
          String tValue = "";
          tValueTpl = tValueTpl.replace("{$i}", "-new");
          tValueTpl = tValueTpl.replace("{$name}", encode.htmlencode(tName));
          tValueTpl = tValueTpl.replace("{$value}", encode.htmlencode(tValue));
          tmptstr = tmptstr.replace("{$name}", encode.htmlencode(tName));
          tmptstr = tmptstr.replace("{$tpl}", tValueTpl);
          tmprstr += tmptstr;
        }
      }
      tmpstr = cls.ctemplates(tmpstr, "{@@}", tmprstr);
      tmpstr = tmpstr.replace("{$node}", encode.htmlencode(tnode));
      tmpstr = tmpstr.replace("{$field}", encode.htmlencode(tfield));
      tmpstr = tmpstr.replace("{$base}", encode.htmlencode(tbase));
      tmpstr = tmpstr.replace("{$count}", cls.toString(tXMLNodesCount));
      tmpstr = tmpstr.replace("{$rootstr}", encode.base64encode(trootstr.getBytes()));
      tmpstr = conf.jt.creplace(tmpstr);
    }
    else
    {
      tmpstr = conf.jt.itake("manage-interface.list-error", "tpl");
      tmpstr = conf.jt.creplace(tmpstr);
    }
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