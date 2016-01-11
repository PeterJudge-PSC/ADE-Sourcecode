/*********************************************************************
* Copyright (C) 2000-2002 by Progress Software Corporation ("PSC"),  *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors: adams@progress.com                                   *
*                                                                    *
*********************************************************************/
/*E4GL-W*/ {src/web/method/e4gl.i} {&OUT} '<HTML>~n'.
{&OUT} '<HEAD>~n'.
{&OUT} '<META NAME="wsoptions" CONTENT="compile">~n'.
{&OUT} '<SCRIPT LANGUAGE="JavaScript1.2" SRC="/webspeed31D/script/common.js"><!--~n'.
{&OUT} '  document.write("Included common.js file not found.")~;~n'.
{&OUT} '//--></SCRIPT>~n'.
{&OUT} '<SCRIPT LANGUAGE="JavaScript1.2" SRC="/webspeed31D/script/editor.js"><!--~n'.
{&OUT} '  document.write("Included editor.js file not found.")~;~n'.
{&OUT} '//--></SCRIPT>~n'.
{&OUT} '</HEAD>~n'.

{&OUT} '<BODY BACKGROUND="' /*Tag=`*/ RootURL /*Tag=`*/ '/images/bgr/wsblank.gif" onLoad="getBrowser()">~n'.

{&OUT} '<!-- File menu -->~n'.
{&OUT} '<FONT SIZE=+1><B>File</B></FONT><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void fileNew()"    ~n'.
{&OUT} '  onMouseOver="window.status=''Create a new file''~; return true~;" ~n'.
{&OUT} '  onMouseOut="window.status=''''~; return true~;">New</A><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void fileOpen()"    ~n'.
{&OUT} '  onMouseOver="window.status=''Open a file''~; return true~;" ~n'.
{&OUT} '  onMouseOut="window.status=''''~; return true~;">Open</A><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void fileSave()"    ~n'.
{&OUT} '  onMouseOver="window.status=''Save to a file''~; return true~;" ~n'.
{&OUT} '  onMouseOut="window.status=''''~; return true~;">Save</A><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void fileSaveAs()"    ~n'.
{&OUT} '  onMouseOver="window.status=''Save to a file with a new name''~; return true~;" ~n'.
{&OUT} '  onMouseOut="window.status=''''~; return true~;">Save As</A><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void filePrint()"    ~n'.
{&OUT} '  onMouseOver="window.status=''Print the file''~; return true~;" ~n'.
{&OUT} '  onMouseOut="window.status=''''~; return true~;">Print</A><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void fileClose()"    ~n'.
{&OUT} '  onMouseOver="window.status=''Close the Editor''~; return true~;" ~n'.
{&OUT} '  onMouseOut="window.status=''''~; return true~;">Close</A><BR><BR>~n'.

{&OUT} '<!-- Search menu -->~n'.
{&OUT} '<FONT SIZE=+1><B>Search</B></FONT><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void goToLine()"    ~n'.

IF INDEX(get-cgi('HTTP_USER_AGENT':U), " MSIE ":U) > 0 THEN
  {&OUT} '  onMouseOver="window.status=''Jump to a line in the file''~; return true~;" ~n'.
ELSE
  {&OUT} '  onMouseOver="window.status=''View line numbers in a separate window''~; return true~;" ~n'.

{&OUT} '  onMouseOut="window.status=''''~; return true~;">'. 
{&OUT} (IF INDEX(get-cgi('HTTP_USER_AGENT':U), " MSIE ":U) > 0 THEN
          "Goto Line" ELSE "Line Numbers").
{&OUT} '</A><BR><BR>~n'.

{&OUT} '<!-- Compile menu -->~n'.
{&OUT} '<FONT SIZE=+1><B>Compile</B></FONT><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void runFile(''run'')"    ~n'.
{&OUT} '  onMouseOver="window.status=''Run the file in a browser window''~; return true~;" ~n'.
{&OUT} '  onMouseOut="window.status=''''~; return true~;">Run</A><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void runFile(''checkSyntax'')"    ~n'.
{&OUT} '  onMouseOver="window.status=''Check the file syntax''~; return true~;" ~n'.
{&OUT} '  onMouseOut="window.status=''''~; return true~;">Check Syntax</A><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void runFile(''compile:okToCompile'')"    ~n'.
{&OUT} '  onMouseOver="window.status=''Generate an rcode file''~; return true~;" ~n'.
{&OUT} '  onMouseOut="window.status=''''~; return true~;">Create Rcode</A><BR><BR>~n'.

{&OUT} '<!-- Help menu -->~n'.
{&OUT} '<FONT SIZE=+1><B>Help</B></FONT><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void showHelp()"    ~n'.
{&OUT} '  onMouseOver="window.status=''Display Help Topic window''~; return true~;" ~n'.
{&OUT} '  onMouseOut="window.status=''''~; return true~;">Help Topics</A><BR>~n'.
{&OUT} '&nbsp~;&nbsp~;<A HREF="javascript:void aboutDialog()"    ~n'.
{&OUT} '  onMouseOver="window.status=''Display About Editor dialog''~; return true~;" ~n'.
{&OUT} '  onMouseOut="window.status=''''~; return true~;">About Editor</A>~n'.

{&OUT} '</BODY>~n'.
{&OUT} '</HTML>~n'.
/************************* END OF HTML *************************/
/*
** File: D:\progress\wrk\webedit\menu.w
** Generated on: 1999-07-02 11:34:48
** By: WebSpeed Embedded SpeedScript Preprocessor
** Version: 2
** Source file: D:\progress\wrk\webedit\menu.html
** Options: compile,wsoptions-found,web-object
**
** WARNING: DO NOT EDIT THIS FILE.  Make changes to the original
** HTML file and regenerate this file from it.
**
*/
/********************* Internal Definitions ********************/

/* This procedure returns the generation options at runtime.
   It is invoked by src/web/method/e4gl.i included at the start
   of this file. */
PROCEDURE local-e4gl-options :
  DEFINE OUTPUT PARAMETER p_version AS DECIMAL NO-UNDO
    INITIAL 2.0.
  DEFINE OUTPUT PARAMETER p_options AS CHARACTER NO-UNDO
    INITIAL "compile,wsoptions-found,web-object":U.
  DEFINE OUTPUT PARAMETER p_content-type AS CHARACTER NO-UNDO
    INITIAL "text/html":U.
END PROCEDURE.

/* end */