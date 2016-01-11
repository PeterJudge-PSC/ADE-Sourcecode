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
* This program creates a .p of the current query and passes the program
* to the .p supplied in the argument list.
*
* This file is needed by the tty to GUI conversion for those v6 Results
* applications that have the need to set printer characteristics before
* sending the output
*
* Input Parameters
*
*    arg    The file to run.
*
*  Output Parameter
*
*    retStat True if Results should repaint the user interface.
*
*/

DEFINE INPUT  PARAMETER arg     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER retStat AS LOGICAL   NO-UNDO INITIAL FALSE.

{ aderes/u-pvars.i }

DEFINE VARIABLE f-name    AS CHARACTER NO-UNDO INITIAL "temp.p".
DEFINE VARIABLE apArgs    AS CHARACTER NO-UNDO.
DEFINE VARIABLE retState  AS LOGICAL   NO-UNDO.

/*
* Set the cursor to the wait state. In case the thru function
* takes alot of time
*/
RUN adecomm/_setcurs.p("WAIT":u).

/* Put the current state of the query into a .p file */
apArgs = f-name + ",":u + qbf-module.

RUN aderes/sffire.p("AdminProgWrite4GL":u, apArgs, OUTPUT retState).

/* Start the output.  */

RUN VALUE(arg)(f-name).

OS-DELETE VALUE(f-name).

RUN adecomm/_setcurs.p("").

/* u-pprog.p - end of file */
