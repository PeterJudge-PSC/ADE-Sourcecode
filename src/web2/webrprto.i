/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
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
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*
 * Prototype include file: C:\1a\src\web2\webrprto.i
 * Created from procedure: C:\1a\web2\webrep.p at 17:27 on 02/08/99
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE ProcessWebRequest IN SUPER:
END PROCEDURE.

PROCEDURE fetchPrev IN SUPER:
END PROCEDURE.

PROCEDURE fetchNext IN SUPER:
END PROCEDURE.

PROCEDURE fetchLast IN SUPER:
END PROCEDURE.

PROCEDURE fetchFirst IN SUPER:
END PROCEDURE.

PROCEDURE fetchCurrent IN SUPER:
END PROCEDURE.

PROCEDURE start-super-proc IN SUPER:
  DEFINE INPUT PARAMETER pcProcName AS CHARACTER.
END PROCEDURE.

FUNCTION addContextFields RETURNS LOGICAL
  (INPUT pNewContextFields AS CHARACTER) IN SUPER.

FUNCTION addSearchCriteria RETURNS LOGICAL
  (INPUT pColumn AS CHARACTER,
   INPUT pValue AS CHARACTER) IN SUPER.

FUNCTION anyMessage RETURNS LOGICAL IN SUPER.

FUNCTION assignColumnFormat RETURNS LOGICAL
  (INPUT pColumn AS CHARACTER,
   INPUT pFormat AS CHARACTER) IN SUPER.

FUNCTION assignColumnHelp RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER,
   INPUT pcHelp AS CHARACTER) IN SUPER.

FUNCTION assignColumnLabel RETURNS LOGICAL
  (INPUT pcColumn AS CHARACTER,
   INPUT pcLabel AS CHARACTER) IN SUPER.

FUNCTION assignColumnWidth RETURNS LOGICAL
  (INPUT pColumn AS CHARACTER,
   INPUT pWidth AS DECIMAL) IN SUPER.

FUNCTION bufferHandle RETURNS HANDLE
  (INPUT pcTableName AS CHARACTER) IN SUPER.

FUNCTION columnDataType RETURNS CHARACTER
  (INPUT pColumn AS CHARACTER) IN SUPER.

FUNCTION columnFormat RETURNS CHARACTER
  (INPUT pColumn AS CHARACTER) IN SUPER.

FUNCTION ColumnHandle RETURNS HANDLE
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnHelp RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnHTMLName RETURNS CHARACTER
  (INPUT pColumn AS CHARACTER) IN SUPER.

FUNCTION columnLabel RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION columnReadOnly RETURNS LOGICAL
  (INPUT pColumn AS CHARACTER) IN SUPER.

FUNCTION columnStringValue RETURNS CHARACTER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION destroyDataObject RETURNS LOGICAL IN SUPER.

FUNCTION extentValue RETURNS INTEGER
  (INPUT pcColumn AS CHARACTER) IN SUPER.

FUNCTION fieldExpression RETURNS CHARACTER
  (INPUT pColumn AS CHARACTER,
   INPUT pOperator AS CHARACTER,
   INPUT pValue AS CHARACTER) IN SUPER.

FUNCTION getAppService RETURNS CHARACTER IN SUPER.

FUNCTION getContextFields RETURNS CHARACTER IN SUPER.

FUNCTION getCurrentRowids RETURNS CHARACTER IN SUPER.

FUNCTION getForeignFieldList RETURNS CHARACTER IN SUPER.

FUNCTION getNavigationMode RETURNS CHARACTER IN SUPER.

FUNCTION getQueryEmpty RETURNS LOGICAL IN SUPER.

FUNCTION getQueryWhere RETURNS CHARACTER IN SUPER.

FUNCTION getRowids RETURNS CHARACTER IN SUPER.

FUNCTION getSearchColumns RETURNS CHARACTER IN SUPER.

FUNCTION getServerConnection RETURNS CHARACTER IN SUPER.

FUNCTION getTableRowids RETURNS CHARACTER IN SUPER.

FUNCTION getTables RETURNS CHARACTER IN SUPER.

FUNCTION getUpdateMode RETURNS CHARACTER IN SUPER.

FUNCTION HTMLAlert RETURNS LOGICAL
  (INPUT pMessage AS CHARACTER) IN SUPER.

FUNCTION HTMLSetFocus RETURNS LOGICAL
  (INPUT pForm AS CHARACTER,
   INPUT pfield AS CHARACTER) IN SUPER.

FUNCTION joinExternalTables RETURNS LOGICAL
  (INPUT pTables AS CHARACTER,
   INPUT pRowids AS CHARACTER) IN SUPER.

FUNCTION joinForeignFields RETURNS LOGICAL
  (INPUT pTables AS CHARACTER) IN SUPER.

FUNCTION OpenQuery RETURNS LOGICAL IN SUPER.

FUNCTION reopenQuery RETURNS LOGICAL IN SUPER.

FUNCTION setAppService RETURNS LOGICAL
  (INPUT pAppService AS CHARACTER) IN SUPER.

FUNCTION setBuffers RETURNS LOGICAL
  (INPUT pcTables AS CHARACTER) IN SUPER.

FUNCTION setColumns RETURNS LOGICAL
  (INPUT pColumns AS CHARACTER) IN SUPER.

FUNCTION setContextFields RETURNS LOGICAL
  (INPUT pContextFields AS CHARACTER) IN SUPER.

FUNCTION setCurrentRowids RETURNS LOGICAL
  (INPUT pcRowids AS CHARACTER) IN SUPER.

FUNCTION setExternalJoinList RETURNS LOGICAL
  (INPUT pExternalJoinList AS CHARACTER) IN SUPER.

FUNCTION setExternalTableList RETURNS LOGICAL
  (INPUT pExternalTableList AS CHARACTER) IN SUPER.

FUNCTION setExternalTables RETURNS LOGICAL
  (INPUT pExternalTables AS CHARACTER) IN SUPER.

FUNCTION setExternalWhereList RETURNS LOGICAL
  (INPUT pExternalWhereList AS CHARACTER) IN SUPER.

FUNCTION setForeignFieldList RETURNS LOGICAL
  (INPUT pcForeignFieldList AS CHARACTER) IN SUPER.

FUNCTION setLinkColumns RETURNS LOGICAL
  (INPUT pLinkColumns AS CHARACTER) IN SUPER.

FUNCTION setNavigationMode RETURNS LOGICAL
  (INPUT pmode AS CHARACTER) IN SUPER.

FUNCTION setQueryWhere RETURNS LOGICAL
  (INPUT pWhere AS CHARACTER) IN SUPER.

FUNCTION setSearchColumns RETURNS LOGICAL
  (INPUT pSearchColumns AS CHARACTER) IN SUPER.

FUNCTION setServerConnection RETURNS LOGICAL
  (INPUT pConnection AS CHARACTER) IN SUPER.

FUNCTION setUpdateMode RETURNS LOGICAL
  (INPUT pMode AS CHARACTER) IN SUPER.

FUNCTION showDataMessages RETURNS CHARACTER IN SUPER.

FUNCTION startDataObject RETURNS LOGICAL
  (INPUT pcDataSource AS CHARACTER) IN SUPER.

FUNCTION urlJoinParams RETURNS CHARACTER
  (INPUT pJoin AS CHARACTER) IN SUPER.

FUNCTION urlLink RETURNS CHARACTER
  (INPUT pcWebObject AS CHARACTER,
   INPUT pcJoin      AS CHARACTER) IN SUPER.

FUNCTION validateColumnValue RETURNS LOGICAL
  (INPUT pColumn AS CHARACTER,
   INPUT pValue AS CHARACTER) IN SUPER.

FUNCTION convert-datetime RETURNS CHARACTER
  (INPUT p_conversion AS CHARACTER,
   INPUT p_idate AS DATE,
   INPUT p_itime AS INTEGER,
   OUTPUT p_odate AS DATE,
   OUTPUT p_otime AS INTEGER) IN SUPER.

FUNCTION format-datetime RETURNS CHARACTER
  (INPUT p_format AS CHARACTER,
   INPUT p_date AS DATE,
   INPUT p_time AS INTEGER,
   INPUT p_options AS CHARACTER) IN SUPER.

FUNCTION get-cgi RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION get-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION get-value RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION get-user-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION hidden-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER,
   INPUT p_value AS CHARACTER) IN SUPER.

FUNCTION hidden-field-list RETURNS CHARACTER
  (INPUT p_name-list AS CHARACTER) IN SUPER.

FUNCTION html-encode RETURNS CHARACTER
  (INPUT p_in AS CHARACTER) IN SUPER.

FUNCTION output-content-type RETURNS LOGICAL
  (INPUT p_type AS CHARACTER) IN SUPER.

FUNCTION output-http-header RETURNS CHARACTER
  (INPUT p_header AS CHARACTER,
   INPUT p_value AS CHARACTER) IN SUPER.

FUNCTION set-user-field RETURNS LOGICAL
  (INPUT p_name AS CHARACTER,
   INPUT p_value AS CHARACTER) IN SUPER.

FUNCTION set-wseu-cookie RETURNS CHARACTER
  (INPUT p_cookie AS CHARACTER) IN SUPER.

FUNCTION url-decode RETURNS CHARACTER
  (INPUT p_in AS CHARACTER) IN SUPER.

FUNCTION url-encode RETURNS CHARACTER
  (INPUT p_value AS CHARACTER,
   INPUT p_enctype AS CHARACTER) IN SUPER.

FUNCTION url-field RETURNS CHARACTER
  (INPUT p_name AS CHARACTER,
   INPUT p_value AS CHARACTER,
   INPUT p_delim AS CHARACTER) IN SUPER.

FUNCTION url-field-list RETURNS CHARACTER
  (INPUT p_name-list AS CHARACTER,
   INPUT p_delim AS CHARACTER) IN SUPER.

FUNCTION url-format RETURNS CHARACTER
  (INPUT p_url AS CHARACTER,
   INPUT p_name-list AS CHARACTER,
   INPUT p_delim AS CHARACTER) IN SUPER.

FUNCTION delete-cookie RETURNS CHARACTER
  (INPUT p_name AS CHARACTER,
   INPUT p_path AS CHARACTER,
   INPUT p_domain AS CHARACTER) IN SUPER.

FUNCTION get-cookie RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.

FUNCTION set-cookie RETURNS CHARACTER
  (INPUT p_name AS CHARACTER,
   INPUT p_value AS CHARACTER,
   INPUT p_date AS DATE,
   INPUT p_time AS INTEGER,
   INPUT p_path AS CHARACTER,
   INPUT p_domain AS CHARACTER,
   INPUT p_options AS CHARACTER) IN SUPER.

FUNCTION available-messages RETURNS LOGICAL
  (INPUT p_grp AS CHARACTER) IN SUPER.

FUNCTION get-messages RETURNS CHARACTER
  (INPUT p_grp AS CHARACTER,
   INPUT p_delete AS LOGICAL) IN SUPER.

FUNCTION get-message-groups RETURNS CHARACTER IN SUPER.

FUNCTION output-messages RETURNS INTEGER
  (INPUT p_option AS CHARACTER,
   INPUT p_grp AS CHARACTER,
   INPUT p_message AS CHARACTER) IN SUPER.

FUNCTION queue-message RETURNS INTEGER
  (INPUT p_grp AS CHARACTER,
   INPUT p_message AS CHARACTER) IN SUPER.

FUNCTION check-agent-mode RETURNS LOGICAL
  (INPUT p_mode AS CHARACTER) IN SUPER.

FUNCTION get-config RETURNS CHARACTER
  (INPUT p_name AS CHARACTER) IN SUPER.
