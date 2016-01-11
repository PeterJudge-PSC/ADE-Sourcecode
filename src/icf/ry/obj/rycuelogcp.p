&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" DataLogicProcedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" DataLogicProcedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" DataLogicProcedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DataLogicProcedure 
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
  File: rytemlogic.p

  Description:  ryc_ui_event Data Logic Procedure Library Template

  Purpose:      A procedure library (PLIP) to support the maintenance of the ryc_ui_event table
                The following internal procedures may be added or modified
                to act as validation to creation, modification, or deletion of
                records in the database table

                Client-side:
                rowObjectValidate***

                Server-side upon create:
                createPreTransValidate***
                createBeginTransValidate
                createEndTransValidate
                createPostTransValidate

                Server-side upon write (create and modify):
                writePreTransValidate***
                writeBeginTransValidate
                writeEndTransValidate
                writePostTransValidate

                Server-side upon delete:
                deletePreTransValidate
                deleteBeginTransValidate
                deleteEndTransValidate
                deletePostTransValidate

                *** The rowObjectValidate, createPreTransValidate and writePreTransValidate
                internal procedures are automatically generated by the SDO generator

  Parameters:

  History:
  --------
  (v:010000)    Task:    90000033   UserRef:    POSSE
                Date:   20/04/2001  Author:     Phil Magnay

  Update Notes: Data Logic Procedure Auto-Generation

  (v:010001)    Task:    90000119   UserRef:    posse
                Date:   06/05/2001  Author:     Haavard Danielsen

  Update Notes: Point to src/adm2/logic.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycuelogcp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO


/* Data Preprocessor Definitions */
&GLOB DATA-LOGIC-TABLE ryc_ui_event
&GLOB DATA-FIELD-DEFS  "ry/obj/rycuefullo.i"

/* Error handling definitions */
{af/sup2/afcheckerr.i &define-only = YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DataLogicProcedure
&Scoped-define DB-AWARE yes


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF





/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDOLevel DataLogicProcedure 
FUNCTION getSDOLevel RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DataLogicProcedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE APPSERVER DB-AWARE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DataLogicProcedure ASSIGN
         HEIGHT             = 18.1
         WIDTH              = 59.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DataLogicProcedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/logic.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DataLogicProcedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createPreTransValidate DataLogicProcedure  _DB-REQUIRED
PROCEDURE createPreTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate records server-side before the transaction scope upon create
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

  IF CAN-FIND(FIRST ryc_ui_event 
              WHERE ryc_ui_event.object_type_obj = b_ryc_ui_event.object_type_obj
                AND ryc_ui_event.smartobject_obj = b_ryc_ui_event.smartobject_obj
                AND ryc_ui_event.object_instance_obj = b_ryc_ui_event.object_instance_obj
                AND ryc_ui_event.event_name = b_ryc_ui_event.event_name
                AND ryc_ui_event.container_smartobject_obj = b_ryc_ui_event.container_smartobject_obj) THEN
  DO:
     ASSIGN
        cValueList   = STRING(b_ryc_ui_event.object_type_obj) + ', ' + STRING(b_ryc_ui_event.smartobject_obj) + ', ' + STRING(b_ryc_ui_event.object_instance_obj) + ', ' + STRING(b_ryc_ui_event.event_name) + ', ' + STRING(b_ryc_ui_event.container_smartobject_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '8' 'ryc_ui_event' '' "'object_type_obj, smartobject_obj, object_instance_obj, event_name, container_smartobject_obj, '" cValueList }.
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip DataLogicProcedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription DataLogicProcedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

  ASSIGN cDescription = "Astra 2 ryc_ui_event Data Logic Procedure".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup DataLogicProcedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

  {ry/app/ryplipsetu.i}  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown DataLogicProcedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectValidate DataLogicProcedure 
PROCEDURE rowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObject record client-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMessageList        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hDesignManager      AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cObjectTypeCode     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lFoundUIEvent       AS LOGICAL      NO-UNDO.
  
  IF b_ryc_ui_event.object_type_obj = 0 OR b_ryc_ui_event.object_type_obj = ? THEN
      ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) 
                          + {af/sup2/aferrortxt.i 'AF' '1' 'ryc_ui_event' 'object_type_obj' "'Object Type Obj'"}.
  
  IF b_ryc_ui_event.smartobject_obj = 0 OR b_ryc_ui_event.smartobject_obj = ? THEN
      ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)
                          + {af/sup2/aferrortxt.i 'AF' '1' 'ryc_ui_event' 'smartobject_obj' "'SmartObject Obj'"}.
  
  IF LENGTH(b_ryc_ui_event.event_name) = 0 OR LENGTH(b_ryc_ui_event.event_name) = ? THEN
      ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)
                          + {af/sup2/aferrortxt.i 'AF' '1' 'ryc_ui_event' 'event_name' "'Event Name'"}.

  /* Check if UI Event is valid for this object type */
  IF b_ryc_ui_event.smartobject_obj <> 0 THEN DO:
   hDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
   cObjectTypeCode = DYNAMIC-FUNCTION("getObjectTypeCodeFromDB":U IN hDesignManager, b_ryc_ui_event.object_type_obj).
   lFoundUIEvent = DYNAMIC-FUNCTION("classHasAttribute" IN gshRepositoryManager, cObjectTypeCode,b_ryc_ui_event.event_name,TRUE).
   IF NOT lFoundUIEvent THEN DO:
     RUN clearClientCache IN gshRepositoryManager.
     lFoundUIEvent = DYNAMIC-FUNCTION("classHasAttribute" IN gshRepositoryManager, cObjectTypeCode,b_ryc_ui_event.event_name,TRUE).
   END.
   IF NOT lFoundUIEvent THEN DO:
     cObjectTypeCode = "The UI Event specified is not valid for the object's class. (" + cObjectTypeCode + ")":U.
     cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                   {af/sup2/aferrortxt.i 'AF' '5' 'ryc_ui_event' 'event_name' "'Event Name'" cObjectTypeCode}.
    END.
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writePreTransValidate DataLogicProcedure  _DB-REQUIRED
PROCEDURE writePreTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate records server-side before the transaction scope upon write
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cMessageList            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cValueList              AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cValidActionTypes       AS CHARACTER                NO-UNDO.

    DEFINE BUFFER gsc_manager_type  FOR gsc_manager_type.

    IF NOT isCreate() AND CAN-FIND(FIRST ryc_ui_event 
                WHERE ryc_ui_event.object_type_obj = b_ryc_ui_event.object_type_obj
                  AND ryc_ui_event.smartobject_obj = b_ryc_ui_event.smartobject_obj
                  AND ryc_ui_event.object_instance_obj = b_ryc_ui_event.object_instance_obj
                  AND ryc_ui_event.event_name = b_ryc_ui_event.event_name
                  AND ryc_ui_event.container_smartobject_obj = b_ryc_ui_event.container_smartobject_obj
                  AND ROWID(ryc_ui_event) <> TO-ROWID(ENTRY(1,b_ryc_ui_event.RowIDent))) THEN
    DO:
        ASSIGN cValueList   = STRING(b_ryc_ui_event.object_type_obj) + ', ' + STRING(b_ryc_ui_event.smartobject_obj) + ', ' + STRING(b_ryc_ui_event.object_instance_obj) + ', ' + STRING(b_ryc_ui_event.event_name) + ', ' + STRING(b_ryc_ui_event.container_smartobject_obj)
               cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)
                            + {af/sup2/aferrortxt.i 'AF' '8' 'ryc_ui_event' '' "'object_type_obj, smartobject_obj, object_instance_obj, event_name, container_smartobject_obj, '" cValueList }.
    END.

    /* Action Type */
    ASSIGN cValidActionTypes = "RUN,PUBLISH":U.
    IF LOOKUP(b_ryc_ui_event.action_type, cValidActionTypes) EQ 0 THEN
        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)
                            + {af/sup2/aferrortxt.i 'AF' '5' 'ryc_ui_event' 'action_type' "'action type'" "'The action type must one of: ' + cValidActionTypes"}.

    /* Action Target
     * The action target should be one of either SELF,CONTAINER,ANYWHERE or
     * a valid manager code, as per the gsc_manager_type table.            */
    FIND gsc_manager_type WHERE
         gsc_manager_type.manager_type_code = b_ryc_ui_event.action_target
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsc_manager_type                                          AND
       LOOKUP(b_ryc_ui_event.action_target, "SELF,CONTAINER,ANYWHERE":U) EQ 0  THEN
        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)
                            + {af/sup2/aferrortxt.i 'AF' '5' 'ryc_ui_event' 'action_target' "'action target'" "'The action type must either be a valid manager type or one of `SELF`,`CONTAINER` OR `ANYWHERE`.'"}.
    
    /* If the action target is ANYWHERE, the action type must be PUBLISH. */
    IF b_ryc_ui_event.action_target EQ "ANYWHERE":U AND
       b_ryc_ui_event.action_type   NE "PUBLISH":U  THEN
        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U)
                            + {af/sup2/aferrortxt.i 'AF' '22' 'ryc_ui_event' 'action_target' "'action type'" "'`PUBLISH`'" "'action target of `ANYWHERE`'"}.
    
    ERROR-STATUS:ERROR = NO.
    RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDOLevel DataLogicProcedure 
FUNCTION getSDOLevel RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  This procedure returns to a caller at which level in an object
            heirarchy this SDO exists. This is used for maintaining UI events
            in a treeview, and allows us to have only one viewer.
    Notes:  
------------------------------------------------------------------------------*/   
    RETURN "SmartObject":U.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
