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

/*--------------------------------------------------------------------

File: prodict/odb/odb_sys.i

Description:
    This string contains a comma-seperated list of the names of all
    system-objects for ODBC-based schemaholders, that are non-queryable.
    For example: Stored-Procedures, Buffers, ...
    This file gets used also from the report-builder -therefore it
    needs to be in a format that complies with C *and* PROGRESS
    
Text-Parameters:  
   none
                                     
History:
    hutegger    95/08   creation
    mcmann      99/11/02 Added New tables for stored procedure implementation
    
--------------------------------------------------------------------*/
/*h-*/
"SQLTables,SQLTables_buffer,SQLColumns,SQLColumns_buffer,SQLStatistics,SQLStatistics_buffer,GetFieldIds,GetFieldIds_buffer,GetInfo,GetInfo_buffer,CloseAllProcs,SendInfo,PROC-TEXT-BUFFER,SEND-SQL-STATEMENT,SQLProcs_Buffer,SQLProcCols_Buffer,SQLProcedures,SQLProcColumns"

/*------------------------------------------------------------------*/
