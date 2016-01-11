&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
/*---------------------------------------------------------------------------------
  File: afgetprplp.p

  Description:  Proxy for getPropertyList in SessionMgr

  Purpose:      Proxy for getPropertyList in Session Manager.

  Parameters:   input property name list comma delimited
                output property values, chr(3) delimited

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   05/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        6063   UserRef:    
                Date:   23/06/2000  Author:     Anthony Swindells

  Update Notes: trim property and check available correctly

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgetprplp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER  pcPropertyList          AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcValueList             AS CHARACTER  NO-UNDO.

{af/sup2/afglobals.i}     /* Astra global shared variables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.

DO iLoop = 1 TO NUM-ENTRIES(pcPropertyList):

  ASSIGN cProperty = TRIM(ENTRY(iLoop,pcPropertyList)).
  FIND FIRST gsm_server_context NO-LOCK
       WHERE gsm_server_context.session_obj = gsdSessionObj
         AND gsm_server_context.CONTEXT_name = cProperty
       NO-ERROR.
  ASSIGN pcValueList = pcValueList + (IF iLoop = 1 THEN "":U ELSE CHR(3)) +
                       (IF AVAILABLE gsm_server_context THEN gsm_server_context.CONTEXT_value ELSE "":U).      

END.  /* iLoop = 1 TO NUM-ENTRIES(pcPropertyList) */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

