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
  File: afsesmngrp.i

  Description:  ICF Session Manager Code

  Purpose:      The ICF Session Manager is a standard procedure to manage information
                that must span the client / server divide, i.e. information that must
                be available to business logic regardless of whether it is running
                client or server side.
                The session manager also supports properties that are only required
                client side and is an efficient mechanism to pass information between
                objects.
                On the client, session information is cached into a local temp-table and
                on the server the information is stored in a context table.
                The session manager also supports a persistent procedure manager to
                control the running of business logic procedures.
                This include file contains the common code for both the server and client
                Session Manager procedures.

  Parameters:   <none>

  History:
  --------
  (v:010036)    Task:           0   UserRef:    
                Date:   01/23/2002  Author:     Mark Davies (MIP)

  Update Notes: Fixed issue #3704 - Can't translate text treeview items.
                Assign translated TEXT widget value to SCREEN-VALUE directly,

  (v:010004)    Task:    90000021   UserRef:    
                Date:   02/15/2002  Author:     Dynamics Admin User

  Update Notes: Remove RVDB dependency

  (v:010005)    Task:    90000010   UserRef:    
                Date:   03/26/2002  Author:     Dynamics Admin User

  Update Notes: 

  (v:010006)    Task:                UserRef:    
                Date:   04/11/2002   Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED" in various places.

  (v:010007)    Task:    90000010   UserRef:    
                Date:   03/26/2002  Author:     Dynamics Admin User

  Update Notes: 

---------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsesmngrp.i
&scop object-version    000000

/* Astra object identifying preprocessor */
&global-define astraSessionManager  yes

{af/sup2/afglobals.i} /* Astra global shared variables */

DEFINE TEMP-TABLE ttProperty NO-UNDO
FIELD propertyName            AS CHARACTER    /* property name */
FIELD propertyValue           AS CHARACTER    /* prooperty value */
INDEX propertyName AS PRIMARY UNIQUE propertyName.

DEFINE VARIABLE giLoop         AS INTEGER    NO-UNDO.
DEFINE VARIABLE glPlipShutting AS LOGICAL    NO-UNDO.

/* temp table of persistent procs started in client session since we started the
   session manager - i.e. procs we must shutdown when this manager closes.
*/
DEFINE TEMP-TABLE ttPersistProc NO-UNDO
FIELD hProc     AS HANDLE
INDEX ObjHandle IS PRIMARY hProc.

DEFINE TEMP-TABLE ttUser NO-UNDO LIKE gsm_user.

{af/sup2/afcheckerr.i &define-only = YES}

{af/app/afttglobalctrl.i}
{af/app/afttsecurityctrl.i}
{af/app/afttpersist.i}
{af/app/aftttranslate.i}
{af/app/logintt.i}

/* Include the file which defines AppServerConnect procedures. */

{adecomm/appsrvtt.i "NEW GLOBAL"}
{adecomm/appserv.i}

IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO:
  /* Code for windows API calls and Help Integration */
  &GLOB DONTRUN-WINFUNC
  {af/sup/windows.i}

  PROCEDURE LockWindowUpdate EXTERNAL "user32.dll":
      DEFINE INPUT  PARAMETER piWindowHwnd AS LONG NO-UNDO.
      DEFINE RETURN PARAMETER piResult     AS LONG NO-UNDO.
  END PROCEDURE.

  &GLOBAL-DEFINE HH_DISPLAY_TOPIC 0
  &GLOBAL-DEFINE HH_KEYWORD_LOOKUP 13
  &GLOBAL-DEFINE HH_DISPLAY_TEXT_POPUP 14

  PROCEDURE HtmlHelpA EXTERNAL "hhctrl.ocx" PERSISTENT :
     DEFINE INPUT PARAMETER  hwndCaller AS LONG.
     DEFINE INPUT PARAMETER  pszFile    AS CHAR.
     DEFINE INPUT PARAMETER  uCommand   AS LONG.
     DEFINE INPUT PARAMETER  dwData     AS LONG.
     DEFINE RETURN PARAMETER hwndHelp   AS LONG.
  END PROCEDURE.
END.

{ af/sup2/aflaunch.i &Define-only = YES }
{launch.i &Define-only = YES }

DEFINE TEMP-TABLE ttActionUnderway NO-UNDO
FIELD action_underway_origin  AS CHARACTER /* Identify the origin, i.e "DYN" "RTB" */
FIELD action_table_fla        AS CHARACTER
FIELD action_type             AS CHARACTER
FIELD action_primary_key      AS CHARACTER
FIELD action_scm_object_name  AS CHARACTER
INDEX XPKrvt_action_underway  IS PRIMARY
      action_underway_origin  ASCENDING
      action_type             ASCENDING
      action_scm_object_name  ASCENDING
      action_table_fla        ASCENDING
      action_primary_key      ASCENDING
      .

/* Additional definitions needed for call batching */

{af/sup2/afttcombo.i}       /* Combo data            */
{af/app/afttglobalctrl.i}   /* Global control cache  */
{af/app/afttsecurityctrl.i} /* Security Cache        */
{af/app/afttprofiledata.i}  /* Profile Cache         */
{af/app/gsttenmn.i}         /* Entity Mnemonic Cache */

DEFINE VARIABLE hBufferCacheBuffer     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cNumericDecimalPoint   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNumericSeparator      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNumericFormat         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAppDateFormat         AS CHARACTER  NO-UNDO.

/* These definitions are used for the info cached for a dynamic container */

{ry/app/rydefrescd.i} /* default result codes */

&GLOBAL-DEFINE defineCache /* Will be undefined in the include */
{src/adm2/ttaction.i}
&GLOBAL-DEFINE defineCache /* Will be undefined in the include */
{src/adm2/tttoolbar.i}
{af/app/aftttranslation.i}

DEFINE VARIABLE cTokenSecurityString AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldSecurityString AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hObjectTable         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPageTable           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPageInstanceTable   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLinkTable           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hUIEventTable        AS HANDLE     NO-UNDO. 
DEFINE VARIABLE gcLogicalContainerName AS CHARACTER  NO-UNDO.

/* Definitions for dynamic call, only defined client side, as we're only using the dynamic call to reduce Appserver hits in this instance */

&IF DEFINED(server-side) = 0 &THEN
{
 src/adm2/calltables.i &PARAM-TABLE-TYPE = "1"
                       &PARAM-TABLE-NAME = "ttSeqType"
}

/* This temp-table is used to cache information for procedure 'showMessages'.  *
 * A record is created in it, the message displayed, and the record deleted.   */

DEFINE TEMP-TABLE ttMessageCache
    FIELD cDBList          AS CHARACTER
    FIELD cDBVersions      AS CHARACTER               
    FIELD lRemote          AS LOGICAL
    FIELD cConnid          AS CHARACTER
    FIELD cOpmode          AS CHARACTER
    FIELD lConnreg         AS LOGICAL
    FIELD lConnbnd         AS LOGICAL
    FIELD cConntxt         AS CHARACTER
    FIELD cASppath         AS CHARACTER
    FIELD cConndbs         AS CHARACTER
    FIELD cConnpps         AS CHARACTER
    FIELD cCustInfo1       AS CHARACTER
    FIELD cCustInfo2       AS CHARACTER
    FIELD cCustInfo3       AS CHARACTER
    FIELD hTableHandle1    AS HANDLE
    FIELD hTableHandle2    AS HANDLE
    FIELD hTableHandle3    AS HANDLE
    FIELD hTableHandle4    AS HANDLE
    FIELD cSite            AS CHARACTER
    FIELD cFieldSecurity   AS CHARACTER
    FIELD cTokenSecurity   AS CHARACTER.
&ENDIF

/*
ttActionUnderway - used for SCM Integration:
-----------------
This table will only contain records during a  transaction for some action,
e.g. deletion, assignment, etc. Its purpose is to make primary table information available
to involved tables during the operation, e.g. cascade deletion, object assignment, etc.

The problem is that during a deletion of the primary table, the involved tables
replication triggers can not access the primary table anymore, as it has been deleted.

To resolve this issue, we will create a record in this table at the top of the delete trigger
of a primary table, and subsequently delete the record at the end of the primary table
replication delete trigger. This means the information will be available throughout
the entire delete transaction.

Under normal cicumstances (no active transaction), this table will be empty.

action_underway_origin:
-----------------------
Where the action was initiated from, e.g. "SCM" , "DYN"
As to prevent recursive triggers firing between systems.

action_table_fla:
-----------------
The FLA of the table whose data is being actioned, e.g. deleted or assigned.

action_type:
------------
The type of action, e.g. ANY = anything, DEL = Deletion , ASS = Assignment of new data, MOV = move (CV), or ADD = Adding

action_primary_key:
-------------------
A chr(3) delimited list of primary key field values to identify the record being actioned.
The field values correspond to the primary key fields "smartobject_obj":U.
This field is only required for deletions. For other things such as assigns,
just the scm object name will be used with the table FLA to locate this record.

action_scm_object_name:
-----------------------
The object name of the data item being actioned as referenced in the SCM tool.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addAsSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addAsSuperProcedure Procedure 
FUNCTION addAsSuperProcedure RETURNS LOGICAL
    ( INPUT phSuperProcedure        AS HANDLE,
      INPUT phProcedure             AS HANDLE   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-filterEvaluateOuterJoins) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD filterEvaluateOuterJoins Procedure 
FUNCTION filterEvaluateOuterJoins RETURNS CHARACTER
  (pcQueryString  AS CHARACTER,
   pcFilterFields AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fixQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fixQueryString Procedure 
FUNCTION fixQueryString RETURNS CHARACTER
  ( INPUT pcQueryString AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInternalEntryExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInternalEntryExists Procedure 
FUNCTION getInternalEntryExists RETURNS LOGICAL
  ( INPUT phProcedure           AS HANDLE,
    INPUT pcProcedureName       AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPropertyList Procedure 
FUNCTION getPropertyList RETURNS CHARACTER
  ( INPUT pcPropertyList AS CHARACTER,
    INPUT plSessionOnly AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isObjQuoted) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isObjQuoted Procedure 
FUNCTION isObjQuoted RETURNS LOGICAL
  (INPUT pcQueryString  AS CHARACTER,
   INPUT piPosition     AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPropertyList Procedure 
FUNCTION setPropertyList RETURNS LOGICAL
  ( INPUT pcPropertyList AS CHARACTER,
    INPUT pcPropertyValues AS CHARACTER,
    INPUT plSessionOnly AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSecurityForDynObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSecurityForDynObjects Procedure 
FUNCTION setSecurityForDynObjects RETURNS CHARACTER
  ( INPUT phWidget          AS HANDLE,
    INPUT pcSecuredFields   AS CHARACTER,
    INPUT pcDisplayedFields AS CHARACTER,
    INPUT pcFieldSecurity   AS CHARACTER,
    INPUT phViewer          AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 14.81
         WIDTH              = 67.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

/* We use MAPI to send mail from Dynamics.  Unfortunately, MAPI changes the current application directory, which causes problems for us.     *
 * So we're going to get the current application directory before we send our mail, store it, and reset it when we're finished. (Issue 5744) */
&IF OPSYS = "WIN32" &THEN
  PROCEDURE GetCurrentDirectoryA EXTERNAL "KERNEL32.DLL":
      DEFINE INPUT        PARAMETER intBufferSize AS LONG.
      DEFINE INPUT-OUTPUT PARAMETER ptrToString   AS MEMPTR.
      DEFINE RETURN       PARAMETER intResult     AS SHORT.
  END PROCEDURE.

  PROCEDURE SetCurrentDirectoryA EXTERNAL "KERNEL32.DLL":
      DEFINE INPUT  PARAMETER chrCurDir AS CHARACTER.
      DEFINE RETURN PARAMETER intResult AS LONG.
  END PROCEDURE.
&ENDIF

&IF DEFINED(server-side) <> 0 &THEN
  PROCEDURE afdelctxtp:         {af/app/afdelctxtp.p}     END PROCEDURE.
  PROCEDURE afgetprplp:         {af/app/afgetprplp.p}     END PROCEDURE.
  PROCEDURE afsetprplp:         {af/app/afsetprplp.p}     END PROCEDURE.
  PROCEDURE afmessagep:         {af/app/afmessagep.p}     END PROCEDURE.
  PROCEDURE aferrorlgp:         {af/app/aferrorlgp.p}     END PROCEDURE.
  PROCEDURE afgetglocp:         {af/app/afgetglocp.p}     END PROCEDURE.
&ENDIF

RUN seedTempUniqueID.

RUN buildPersistentProc.  /* Build TT of running procedures */

IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO:

  /* When instantiated, populate temp-table with standard properties that may be cached
     on the client. These properties will always be returned from the temp-table. If a 
     property is not in the temp-table, then its value must be obtained from the server
     Session Manager which has access to the database.
  */

  /* The login values will be set-up during the user login process, which will also cause
     the context database to be updated with the same info for retrieval by the server side
     Session Manager. If these values are not set-up, then the user has not logged in
     sucessfully.
  */

  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentUserObj":U            /* logged in user object number */
    ttProperty.propertyValue = "0":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentUserLogin":U          /* logged in user login name */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentUserName":U           /* logged in user full name */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentUserEmail":U           /* logged in user email */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentLanguageObj":U         /* logged into language object number */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentLanguageName":U        /* logged into language name */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentOrganisationObj":U    /* logged in user organisation object number */
    ttProperty.propertyValue = "0":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentOrganisationCode":U   /* logged in user organisation code */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentOrganisationName":U   /* logged in user organisation full name */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentOrganisationShort":U  /* logged in user organisation short code */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentProcessDate":U        /* processing date specified at login time and used mainly in financials for forward postings */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "currentLoginValues":U        /* user defined list of extra login values in the form label,value,label,value, etc. */
    ttProperty.propertyValue = "":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "dateFormat":U                /* Property to hold Client PC session date format */
    ttProperty.propertyValue = "":U
    .

  DEFINE VARIABLE cDateFormat AS CHARACTER NO-UNDO.
  ASSIGN cDateFormat = SESSION:DATE-FORMAT.

  DO  giLoop = 1 TO 3:
      CASE SUBSTRING(cDateFormat, giLoop, 1):
          WHEN "y" THEN
              ASSIGN
                  ttProperty.propertyValue = ttProperty.propertyValue + "9999" + "/".
          OTHERWISE
              ASSIGN
                  ttProperty.propertyValue = ttProperty.propertyValue + "99" + "/".
      END CASE.
  END.

  ASSIGN ttProperty.propertyValue = SUBSTRING(ttProperty.propertyValue, 1, LENGTH(ttProperty.propertyValue) - 1).

  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "suppressDisplay":U           /* Property to supress Message Display */
    ttProperty.propertyValue = "NO":U
    .
  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "cachedTranslationsOnly":U    /* Property to load translations at login time */
    ttProperty.propertyValue = "YES":U
    .

  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "translationEnabled":U        /* Property to turn translation on/off */
    ttProperty.propertyValue = "YES":U
    .

  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "launchphysicalobject":U      /* Property to save 1st launched physical object */
    ttProperty.propertyValue = "":U
    .

  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "launchlogicalobject":U       /* Property to save 1st launched logical object */
    ttProperty.propertyValue = "":U
    .

  CREATE ttProperty.
  ASSIGN
    ttProperty.propertyName = "launchrunattribute":U        /* Property to save 1st launched object run attribute */
    ttProperty.propertyValue = "":U
    .

  IF SESSION <> gshAstraAppserver 
  THEN DO:
      /* The various programs needing the cached info are going to publish these events as they need it */
    
      SUBSCRIBE TO "loginGetMnemonicsCache":U IN SESSION:FIRST-PROCEDURE.
      SUBSCRIBE TO "loginGetClassCache":U     IN SESSION:FIRST-PROCEDURE.
      SUBSCRIBE TO "loginGetViewerCache":U    IN SESSION:FIRST-PROCEDURE.
    
      /* This manager should start just after the connection manager, cache the login stuff */
    
      RUN loginCacheUpfront.
  END.

END. /* not (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */

CREATE ttProperty.
ASSIGN
  ttProperty.propertyName = "loginWindow":U
  ttProperty.propertyValue = "af/cod2/aftemlognw.w":U
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-activateSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE activateSession Procedure 
PROCEDURE activateSession :
/*------------------------------------------------------------------------------
  Purpose:     Sets up the gst_session record for a session in a remote
               session.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcOldSessionID   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNewSessionID   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSessType       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcNumFormat      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDateFormat     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plReactivate     AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plConfirmExpired AS LOGICAL    NO-UNDO.

  ASSIGN
    gsdTempUniqueID =  gsdTempUniqueID + 100000000000000000.0  
                    - (gsdTempUniqueID + 100000000000000000.0 
                       - TRUNCATE(gsdTempUniqueID / 100000000000000000.0 + 1, 0) 
                       * 100000000000000000.0)
  .

  &IF DEFINED(server-side) <> 0 &THEN

    DEFINE VARIABLE dSessionTypeObj AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dInactive       AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE iDays           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iSeconds        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cDateFormat     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cNumFormat      AS CHARACTER  NO-UNDO.
    
    DEFINE BUFFER bgst_session      FOR gst_session.
    DEFINE BUFFER bgsm_session_type FOR gsm_session_type.

    /* If this is a reactivation and the session ID is blank,
       get the old session id from the SESSION:SERVER-CONNECTION-ID */
    IF plReactivate AND
       pcOldSessionID = "":U OR
       pcOldSessionID = ? THEN
      pcOldSessionID = SESSION:SERVER-CONNECTION-ID.

    DO TRANSACTION:
      /* See if we can find a session with the old session ID. */
      IF pcOldSessionID <> "":U AND
         pcOldSessionID <> ? THEN
      DO:
        FIND bgst_session
          WHERE bgst_session.session_id = pcOldSessionID
          NO-ERROR.
      END.

      /* If the session record does not exist, we need to look at the
         reactivate flag to decide what to do. */
      IF NOT AVAILABLE(bgst_session) THEN
      DO:
        ERROR-STATUS:ERROR = NO.

        /* If Reactivate is switched on, we should be reactivating an 
           existing session. If the record was not found, there is a 
           problem and we need to return an error. */
        IF plReactivate THEN
        DO:
          ASSIGN
            cError = {af/sup2/aferrortxt.i 'ICF' '4' '?' '?' "''"}.
          RETURN ERROR cError.
        END.

        CREATE bgst_session.
        ASSIGN
          bgst_session.session_creation_date = TODAY
          bgst_session.session_creation_time = TIME
        .
      END.
      ELSE
      DO:
        /* If we have to check the session expiry then lets see if it has
           expired. plConfirmExpired just tells us to perform this check. 
           The gsm_session_type contains a flag that indicates whether the session
           has expiry set, and how long a session should be allowed to run. */
        IF plConfirmExpired AND
           bgst_session.session_type_obj <> 0.0 THEN
        DO:
          /* Find the gsm_session type for this client session type. */
          FIND bgsm_session_type NO-LOCK
            WHERE bgsm_session_type.session_type_obj = bgst_session.session_type_obj
            NO-ERROR.
          /* We're only going to perform this check if the session type is available. */
          IF AVAILABLE(bgsm_session_type) THEN
          DO:
            /* Inactivity timeout only counts if it is > 0. If it is greater than 0, 
               the integer portion contains the number of days that a session is valid for
               and the mantissa contains the number of seconds that it is valid for -
               kind of a date/time data type. 
               
               This means that we can convert the time that has elapsed since the session
               was last active into a similar thing where the days are in the integer portion
               and the seconds are in the mantissa, and this means that we can then do a 
               straight comparison of the elapsed time against the time out */
            IF bgsm_session_type.inactivity_timeout_period > 0.0 THEN
            DO:
              /* First determine how many days have elapsed since the last access */
              iDays = TODAY - bgst_session.last_access_date.

              /* Get the number of seconds that have elapsed today. */
              iSeconds = TIME.

              /* If the number of seconds that has elapsed is less than the the last
                 access time, we are into at least the next day (possibly more days) 
                 and we therefore subtract the last access time from the number of 
                 seconds in a day (86400) and add the number of seconds that have elapsed 
                 today. We then subtract a day from the number of days that have elapsed
                 as we can measure the difference in seconds. */
              IF iSeconds < bgst_session.last_access_time THEN
                ASSIGN
                  iSeconds = 86400 - bgst_session.last_access_time + iSeconds
                  iDays    = iDays - 1
                .
              ELSE
                /* Otherwise we just subtract the elapsed seconds from the
                   last access time */
                ASSIGN
                  iSeconds = iSeconds - bgst_session.last_access_time
                .

              /* The inactivity time has to be converted to the "date/time" format */
              dInactive = iDays + (iSeconds / 100000).

              /* Now we can compare the inactive time against the inactivity timeout.
                 If the session has timed out, we return an error. */
              IF dInactive >= bgsm_session_type.inactivity_timeout_period THEN
              DO:
                ASSIGN
                  cError = {af/sup2/aferrortxt.i 'ICF' '4' '?' '?' "''"}.
                RETURN ERROR cError.
              END. /* IF dInactive >= bgsm_session_type.inactivity_timeout_period */
            END. /* IF bgsm_session_type.inactivity_timeout_period > 0.0 */
          END.  /* IF AVAILABLE(bgsm_session_type) */
        END.  /* IF plConfirmExpired AND bgst_session.session_type_obj <> 0.0 */
      END. /* IF NOT AVAILABLE(bgst_session) */

      /* If we are not reactivating the session, we need to set up the
         session ID. */
      IF NOT plReactivate THEN
      DO:
        IF pcNewSessionID <> "":U AND
           pcNewSessionID <> ?    THEN
          ASSIGN
            bgst_session.session_id  = pcNewSessionID.

        ELSE
          ASSIGN
            bgst_session.session_id  = SESSION:SERVER-CONNECTION-ID.

        ASSIGN
          bgst_session.client_date_format    = pcDateFormat
          bgst_session.client_numeric_format = pcNumFormat
        .
      END.

      /* If the session type has not previously been set, we should set it 
         here. */
      IF bgst_session.session_type_obj = 0.0 AND
         pcSessType <> ? AND
         pcSessType <> "":U THEN
      DO:
        FIND bgsm_session_type NO-LOCK
          WHERE bgsm_session_type.session_type_code = pcSessType
          NO-ERROR.
        IF NOT AVAILABLE(bgsm_session_type) THEN
          ASSIGN
            bgst_session.session_type_obj = 0.0.
        ELSE
          ASSIGN
            bgst_session.session_type_obj = bgsm_session_type.session_type_obj.
      END.

      /* Now we need to make sure that the session's last date and time
         is updated and that the session environment is synched up with 
         the client */
      ASSIGN
        bgst_session.last_access_date      = TODAY
        bgst_session.last_access_time      = TIME
        gscSessionId = bgst_session.session_id
        gsdSessionObj = bgst_session.session_obj
      .

      /* If we have a valid client date format, set the server to match */
      IF bgst_session.client_date_format <> "":U AND
         bgst_session.client_date_format <> ? AND
         CAN-DO("dmy,dym,mdy,myd,ymd,ydm":U, bgst_session.client_date_format) THEN
        SESSION:DATE-FORMAT = bgst_session.client_date_format.
      ELSE
      DO:
        cDateFormat = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                       "session_date_format":U).
        IF cDateFormat <> ? AND
           CAN-DO("dmy,dym,mdy,myd,ymd,ydm":U, cDateFormat) THEN
          SESSION:DATE-FORMAT = cDateFormat.
      END.
        

      /* If we have a valid client date format, set the server to match */
      IF bgst_session.client_numeric_format <> "":U AND
         bgst_session.client_numeric_format <> ? THEN
      DO:
        IF bgst_session.client_numeric_format = "EUROPEAN":U OR 
           bgst_session.client_numeric_format = "AMERICAN":U THEN
          SESSION:NUMERIC-FORMAT = bgst_session.client_numeric_format.
        ELSE IF LENGTH(bgst_session.client_numeric_format) = 2 THEN
          SESSION:SET-NUMERIC-FORMAT(SUBSTRING(bgst_session.client_numeric_format,1,1), SUBSTRING(bgst_session.client_numeric_format,2,1)).
      END.
      ELSE
      DO:
        cNumFormat = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                      "session_numeric_format":U).
        IF cNumFormat <> ? THEN
        DO:
          IF cNumFormat = "EUROPEAN":U OR 
             cNumFormat = "AMERICAN":U THEN
            SESSION:NUMERIC-FORMAT = cNumFormat.
          ELSE IF LENGTH(cNumFormat) = 2 THEN
            SESSION:SET-NUMERIC-FORMAT(SUBSTRING(cNumFormat,1,1), SUBSTRING(cNumFormat,2,1)).
        END.
      END.
    END.

    RETURN "":U. /* We need to make sure that we return because if we don't,
                    the return value never gets set. */

  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-askQuestion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE askQuestion Procedure 
PROCEDURE askQuestion :
/*------------------------------------------------------------------------------
  Purpose: This is the procedure for the display of all question message types.
           Any button combination is supported. 
           The default button list is "OK,CANCEL", the default label to return is
           OK if OK is passed in, otherwise the first button in the list.
           The default cancel button is CANCEL if available otherwise the first
           entry in the list, the default title will be "Question".
           If running server side the messages cannot be displayed and will only
           be able to write to the message log. Also, server side there is no user
           interface, so the default button label and answer will always be returned.
           Client side the messages will be displayed in a dialog window. 
           The procedure checks the property "suppressDisplay" in the Session Manager
           and if set to YES, will not display the message but will simply pass the
           message to the log as would be the case for a server side message.
           This is useful when running take-on procedures client side.
           The messages will be passed to a procedure on Appserver for interpretation
           called af/app/afmessagep.p. This procedure will format the messages appropriately,
           read text from the ICF message file where appropriate, interpret the carrot
           delimited lists that come back from triggers, deal with ADM2 CHR(4) delimited
           messages, etc. to end up with actual formatted messages (translated if required).
           Once the messages have been formatted, if on the client, the message will be
           displayed using the standard ICF message dialog af/cod2/afmessaged.w which is
           an enhanced dialog that contains an email button, etc. This dialog window is also
           used by showMessages.
           If server side, or the error log flag was returned as YES, or message display
           supression is enabled, the ICF error log will be updated with the error and an 
           email will be sent to the currently logged in user notifying them of the error
           (if possible).
    Notes: Returns untranslated button text of button pressed if client side,
           else default button if server side. 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER        pcMessageList     AS CHARACTER.
DEFINE INPUT PARAMETER        pcButtonList      AS CHARACTER.
DEFINE INPUT PARAMETER        pcDefaultButton   AS CHARACTER.
DEFINE INPUT PARAMETER        pcCancelButton    AS CHARACTER.
DEFINE INPUT PARAMETER        pcMessageTitle    AS CHARACTER.
DEFINE INPUT PARAMETER        pcDataType        AS CHARACTER.
DEFINE INPUT PARAMETER        pcFormat          AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER pcAnswer          AS CHARACTER.
DEFINE OUTPUT PARAMETER       pcButtonPressed   AS CHARACTER.

  DEFINE VARIABLE cSummaryMessages                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullMessages                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonList                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageTitle                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdateErrorLog                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iButtonPressed                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFailed                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuppressDisplay                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSuppressDisplay                AS CHARACTER  NO-UNDO.

  /* Set up defaults for values not passed in */
  IF pcButtonList = "":U THEN ASSIGN pcButtonList = "OK,CANCEL":U.
  IF pcDefaultButton = "":U OR LOOKUP(pcDefaultButton,pcButtonList) = 0 THEN
  DO:
    IF LOOKUP("OK":U,pcButtonList) > 0 THEN
      ASSIGN pcDefaultButton = "OK":U.
    ELSE
      ASSIGN pcDefaultButton = ENTRY(1,pcButtonList).
  END.
  IF pcCancelButton = "":U OR LOOKUP(pcCancelButton,pcButtonList) = 0 THEN
  DO:
    IF LOOKUP("CANCEL":U,pcButtonList) > 0 THEN
      ASSIGN pcCancelButton = "CANCEL":U.
    ELSE
      ASSIGN pcCancelButton = ENTRY(1,pcButtonList).
  END.
  IF pcMessageTitle = "":U THEN ASSIGN pcMessageTitle = "Question":U. 

  /* When the message is substituted later in the procedure
     and the message data contains any substitute characters 
     it bombs out - MAD (MIP) 10/08/2001 */
  IF INDEX(pcMessageList,"&":U) <> 0 THEN
    pcMessageList = REPLACE(pcMessageList,"&":U,"'&'":U).

  /* Next interpret / translate the messages */
  &IF DEFINED(server-side) <> 0 &THEN
    DO:
      RUN afmessagep (INPUT pcMessageList,
                      INPUT pcButtonList,
                      INPUT pcMessageTitle,
                      OUTPUT cSummaryMessages,
                      OUTPUT cFullMessages,
                      OUTPUT cButtonList,
                      OUTPUT cMessageTitle,
                      OUTPUT lUpdateErrorLog,
                      OUTPUT lSuppressDisplay).  
    END.
  &ELSE
    DO:
      RUN af/app/afmessagep.p ON gshAstraAppserver (INPUT pcMessageList,
                                                    INPUT pcButtonList,
                                                    INPUT pcMessageTitle,
                                                    OUTPUT cSummaryMessages,
                                                    OUTPUT cFullMessages,
                                                    OUTPUT cButtonList,
                                                    OUTPUT cMessageTitle,
                                                    OUTPUT lUpdateErrorLog,
                                                    OUTPUT lSuppressDisplay).  
    END.
  &ENDIF

  /* Display message if not remote and not suppressed */
  IF NOT lSuppressDisplay THEN
  DO:
    cSuppressDisplay = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                        INPUT "suppressDisplay":U,
                                        INPUT YES).
  END.
  ELSE cSuppressDisplay = "YES":U.

  IF cSuppressDisplay = "YES":U THEN ASSIGN lSuppressDisplay = YES.

  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND NOT lSuppressDisplay THEN
  DO:
      ASSIGN gcLogicalContainerName = "afmessaged":U.
    RUN af/cod2/afmessaged.w (INPUT "QUE",
                              INPUT cSummaryMessages,
                              INPUT cFullMessages,
                              INPUT cButtonList,
                              INPUT cMessageTitle,
                              INPUT LOOKUP(pcDefaultButton,pcButtonList),
                              INPUT LOOKUP(pcCancelButton,pcButtonList),
                              INPUT pcDataType,
                              INPUT pcFormat,
                              INPUT pcAnswer,
                              INPUT ?,
                              OUTPUT iButtonPressed,
                              OUTPUT pcAnswer).
    ASSIGN gcLogicalContainerName = "":U.

    IF iButtonPressed > 0 AND iButtonPressed <= NUM-ENTRIES(pcButtonList) THEN
      ASSIGN pcButtonPressed = ENTRY(iButtonPressed, pcButtonList).  /* Pass back untranslated button pressed */
    ELSE
      ASSIGN pcButtonPressed = pcDefaultButton.
  END.
  ELSE
    ASSIGN pcButtonPressed = pcDefaultButton.  /* If remote, assume default button */

  /* If remote, or update error log set to YES, then update error log and send an email if possible */
  IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) OR lUpdateErrorLog OR lSuppressDisplay THEN
  DO:
    RUN updateErrorLog IN gshSessionManager (INPUT cSummaryMessages,
                                             INPUT cFullMessages).
    RUN notifyUser IN gshSessionManager (INPUT 0,                           /* default user */
                                         INPUT "":U,                        /* default user */
                                         INPUT "email":U,                   /* by email */
                                         INPUT "Progress Dynamics " + cMessageTitle,    /* ICF message */
                                         INPUT cSummaryMessages,            /* Summary translated messages */
                                         OUTPUT cFailed).           
  END.


  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildPersistentProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPersistentProc Procedure 
PROCEDURE buildPersistentProc :
/*------------------------------------------------------------------------------
  Purpose:     To build a temp-table of persistent procs already running before
               this manager was started - i.e. the ones we should not kill.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProcedure AS HANDLE NO-UNDO.

  ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE( hProcedure ):
    CREATE ttPersistProc.
    ASSIGN ttPersistProc.hProc = hProcedure
           hProcedure          = hProcedure:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearActionUnderwayCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearActionUnderwayCache Procedure 
PROCEDURE clearActionUnderwayCache :
/*------------------------------------------------------------------------------
  Purpose:     To empty client cache temp-tables to ensure the database is accessed
               again to retrieve up-to-date information. This may be called when 
               SCM and Dynamicsmaintennance programs have been run. The procedure prevents
               having to log off and start a new session in order to use the new
               repository data settings.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U)
  THEN DO:
    IF TRANSACTION
    THEN
      FOR EACH ttActionUnderway:
        DELETE ttActionUnderway.
      END.
    ELSE
      EMPTY TEMP-TABLE ttActionUnderway.
  END.    /* runnign client side. */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-containerCacheUpfront) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE containerCacheUpfront Procedure 
PROCEDURE containerCacheUpfront :
/*------------------------------------------------------------------------------
  Purpose:     This procedures makes an Appserver call to cache all information
               needed to build a dynamic container.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcLogicalObjectName      AS CHARACTER  NO-UNDO. /* Needed for security & container retrieval */
DEFINE INPUT  PARAMETER pcAttributeCode          AS CHARACTER  NO-UNDO. /* Needed for security & container retrieval */
DEFINE INPUT  PARAMETER plReturnEntireContainer  AS LOGICAL    NO-UNDO. /* Needed for container retrieval */
DEFINE INPUT  PARAMETER plDesignMode             AS LOGICAL    NO-UNDO. /* Needed for container retrieval */
DEFINE INPUT  PARAMETER pcToolbar                AS CHARACTER  NO-UNDO. /* Needed for toolbar retrieval, blank for ALL */
DEFINE INPUT  PARAMETER pcBandList               AS CHARACTER  NO-UNDO. /* Needed for toolbar retrieval, blank for ALL */
DEFINE OUTPUT PARAMETER plContainerSecured       AS LOGICAL    NO-UNDO. /* Is the container, well...secured */

DEFINE VARIABLE hTableHandle             AS HANDLE     NO-UNDO EXTENT 20.
DEFINE VARIABLE dUserObj                 AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dOrganisationObj         AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dLanguageObj             AS DECIMAL    NO-UNDO. 
DEFINE VARIABLE cProperties              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cResultCodes             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hCustomizationManager    AS HANDLE     NO-UNDO.
DEFINE VARIABLE iCnt                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE lGetObjectFromAppserver  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lGetTokensFromAppserver  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lGetFieldsFromAppserver  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lGetToolbars             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lProfileRecordExists     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cObjectName              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectSecurity          AS CHARACTER  NO-UNDO.

/* Make sure we don't have any cached information left over from a previous container */
IF NOT TRANSACTION 
THEN DO:
    EMPTY TEMP-TABLE ttStoreToolbarsCached.
    EMPTY TEMP-TABLE ttCacheToolbarBand.
    EMPTY TEMP-TABLE ttCacheObjectBand.
    EMPTY TEMP-TABLE ttCacheBand.
    EMPTY TEMP-TABLE ttCacheBandAction.
    EMPTY TEMP-TABLE ttCacheAction.
    EMPTY TEMP-TABLE ttCacheCategory.
    EMPTY TEMP-TABLE ttProfileData.
END.
ELSE DO:
    FOR EACH ttStoreToolbarsCached: DELETE ttStoreToolbarsCached. END.
    FOR EACH ttCacheToolbarBand:    DELETE ttCacheToolbarBand.    END.
    FOR EACH ttCacheObjectBand:     DELETE ttCacheObjectBand.     END.
    FOR EACH ttCacheBand:           DELETE ttCacheBand.           END.
    FOR EACH ttCacheBandAction:     DELETE ttCacheBandAction.     END.
    FOR EACH ttCacheAction:         DELETE ttCacheAction.         END.
    FOR EACH ttCacheCategory:       DELETE ttCacheCategory.       END.
    FOR EACH ttProfileData:         DELETE ttProfileData.         END.
END.

IF VALID-HANDLE(hBufferCacheBuffer) THEN
    DELETE OBJECT hBufferCacheBuffer.

IF VALID-HANDLE(hObjectTable) THEN
    DELETE OBJECT hObjectTable.

IF VALID-HANDLE(hPageTable) THEN
    DELETE OBJECT hPageTable.

IF VALID-HANDLE(hPageInstanceTable) THEN
    DELETE OBJECT hPageInstanceTable.

IF VALID-HANDLE(hLinkTable) THEN
    DELETE OBJECT hLinkTable.

IF VALID-HANDLE(hUIEventTable) THEN
    DELETE OBJECT hUIEventTable.

ASSIGN cTokenSecurityString = "":U
       cFieldSecurityString = "":U
       hBufferCacheBuffer   = ?
       hObjectTable         = ?
       hPageTable           = ?
       hPageInstanceTable   = ?
       hLinkTable           = ?
       hUIEventTable        = ?.

/* Right, nothing in cache, now get the stuff we're going to need to retrieve the object detail */
ASSIGN cProperties           = DYNAMIC-FUNCTION("getPropertyList":U, INPUT "currentUserObj,currentOrganisationObj,currentLanguageObj":U,INPUT NO)       
       dUserObj              = DECIMAL(ENTRY(1, cProperties, CHR(3)))
       dOrganisationObj      = DECIMAL(ENTRY(2, cProperties, CHR(3)))
       dLanguageObj          = DECIMAL(ENTRY(3, cProperties, CHR(3)))
       hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "CustomizationManager":U)
       cResultCodes          = IF VALID-HANDLE(hCustomizationManager)
                               THEN DYNAMIC-FUNCTION("getSessionResultCodes":U IN hCustomizationManager)
                               ELSE "{&DEFAULT-RESULT-CODE}":U.

/* Check what has already been cached, and what hasn't */
ASSIGN lGetObjectFromAppserver = NOT DYNAMIC-FUNCTION("isObjectCached":U IN gshRepositoryManager, 
                                     INPUT pcLogicalObjectName, INPUT dUserObj, 
                                     INPUT cResultCodes,        INPUT pcAttributeCode,     
                                     INPUT dLanguageObj,        INPUT plDesignMode)

       /* These flags aren't necessary.  If we need to get the object, we won't have anything else. *
        * If we don't need to get the object, we know we've fetched everything we need already.     */
       lGetTokensFromAppserver = lGetObjectFromAppserver
       lGetFieldsFromAppserver = lGetObjectFromAppserver
       lGetToolbars            = lGetObjectFromAppserver.

IF lGetObjectFromAppserver = NO THEN
    RETURN.

/* Run the procedure on the Appserver to return all the info we require to view the container */
RUN af/app/cachecontr.p ON gshAstraAppserver
                           (INPUT-OUTPUT lGetObjectFromAppserver,   /* Container */
                            INPUT-OUTPUT lGetTokensFromAppserver,   /* Security  */
                            INPUT-OUTPUT lGetFieldsFromAppserver,   /* Security  */
                            INPUT-OUTPUT lGetToolbars,              /* Toolbars  */
                            INPUT pcLogicalObjectName,              /* Security & Container */
                            INPUT pcAttributeCode,                  /* Security & Container */                            
                            INPUT dUserObj,                         /* Container */
                            INPUT cResultCodes,                     /* Container */
                            INPUT dLanguageObj,                     /* Container */
                            INPUT plReturnEntireContainer,          /* Container */
                            INPUT plDesignMode,                     /* Container */
                            INPUT pcToolbar,                        /* Toolbars */
                            INPUT pcLogicalObjectName,              /* Toolbars */
                            INPUT pcBandList,                       /* Toolbars */
                            INPUT dOrganisationObj,                 /* Toolbars */
                            OUTPUT cTokenSecurityString,            /* Security */
                            OUTPUT cFieldSecurityString,            /* Security */
                            OUTPUT TABLE-HANDLE hObjectTable,       /* Container */
                            OUTPUT TABLE-HANDLE hPageTable,         /* Container */
                            OUTPUT TABLE-HANDLE hPageInstanceTable, /* Container */
                            OUTPUT TABLE-HANDLE hLinkTable,         /* Container */
                            OUTPUT TABLE-HANDLE hUIEventTable,      /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[1],    /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[2],    /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[3],    /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[4],    /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[5],    /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[6],    /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[7],    /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[8],    /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[9],    /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[10],   /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[11],   /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[12],   /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[13],   /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[14],   /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[15],   /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[16],   /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[17],   /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[18],   /* Container */
                            OUTPUT TABLE-HANDLE hTableHandle[19],   /* Container */
                            OUTPUT TABLE ttStoreToolbarsCached,     /* Toolbars */
                            OUTPUT TABLE ttCacheToolbarBand,        /* Toolbars */
                            OUTPUT TABLE ttCacheObjectBand,         /* Toolbars */
                            OUTPUT TABLE ttCacheBand,               /* Toolbars */
                            OUTPUT TABLE ttCacheBandAction,         /* Toolbars */
                            OUTPUT TABLE ttCacheAction,             /* Toolbars */
                            OUTPUT TABLE ttCacheCategory,           /* Toolbars */
                            OUTPUT TABLE ttProfileData,
                            OUTPUT plContainerSecured
                           ).

IF lGetObjectFromAppserver = NO THEN /* This flag could have been reset on the Appserver */
    RETURN.

RUN receiveCacheObject IN gshRepositoryManager (INPUT dUserObj,
                                                INPUT cResultCodes,
                                                INPUT pcAttributeCode,
                                                INPUT dLanguageObj,

                                                INPUT TABLE-HANDLE hObjectTable,
                                                INPUT TABLE-HANDLE hPageTable,
                                                INPUT TABLE-HANDLE hPageInstanceTable,
                                                INPUT TABLE-HANDLE hLinkTable,
                                                INPUT TABLE-HANDLE hUIEventTable,

                                                INPUT TABLE-HANDLE hTableHandle[1],
                                                INPUT TABLE-HANDLE hTableHandle[2],
                                                INPUT TABLE-HANDLE hTableHandle[3],
                                                INPUT TABLE-HANDLE hTableHandle[4],
                                                INPUT TABLE-HANDLE hTableHandle[5],
                                                INPUT TABLE-HANDLE hTableHandle[6],
                                                INPUT TABLE-HANDLE hTableHandle[7],
                                                INPUT TABLE-HANDLE hTableHandle[8],
                                                INPUT TABLE-HANDLE hTableHandle[9],
                                                INPUT TABLE-HANDLE hTableHandle[10],
                                                INPUT TABLE-HANDLE hTableHandle[11],
                                                INPUT TABLE-HANDLE hTableHandle[12],
                                                INPUT TABLE-HANDLE hTableHandle[13],
                                                INPUT TABLE-HANDLE hTableHandle[14],
                                                INPUT TABLE-HANDLE hTableHandle[15],
                                                INPUT TABLE-HANDLE hTableHandle[16],
                                                INPUT TABLE-HANDLE hTableHandle[17],
                                                INPUT TABLE-HANDLE hTableHandle[18],
                                                INPUT TABLE-HANDLE hTableHandle[19]
                                               ).
/* Send the security stuff */
do-blk:
DO iCnt = 1 TO NUM-ENTRIES(cTokenSecurityString, CHR(27)):
    ASSIGN cObjectName     = ENTRY(iCnt, cTokenSecurityString, CHR(27))
           cObjectSecurity = ENTRY(2, cObjectName, CHR(4))
           cObjectName     = ENTRY(1, cObjectName, CHR(4)).

    RUN receiveCacheTokSecurity IN gshSecurityManager (INPUT cObjectName,
                                                       INPUT pcAttributeCode,
                                                       INPUT cObjectSecurity).

END.

do-blk:
DO iCnt = 1 TO NUM-ENTRIES(cFieldSecurityString, CHR(27)):
    ASSIGN cObjectName     = ENTRY(iCnt, cFieldSecurityString, CHR(27))
           cObjectSecurity = ENTRY(2, cObjectName, CHR(4))
           cObjectName     = ENTRY(1, cObjectName, CHR(4)).

    RUN receiveCacheFldSecurity IN gshSecurityManager (INPUT cObjectName,
                                                       INPUT pcAttributeCode,
                                                       INPUT cObjectSecurity).
END.

/* Pass menu information */
RUN receiveCacheMenu IN gshRepositoryManager (INPUT TABLE ttStoreToolbarsCached,
                                              INPUT TABLE ttCacheToolbarBand,
                                              INPUT TABLE ttCacheObjectBand,
                                              INPUT TABLE ttCacheBand,
                                              INPUT TABLE ttCacheBandAction,
                                              INPUT TABLE ttCacheAction,
                                              INPUT TABLE ttCacheCategory).

/* Check what we need to add to the profile cache */
FOR EACH ttProfileData:
    RUN checkProfileDataExists IN gshProfileManager (INPUT ttProfileData.cProfileTypeCode,
                                                     INPUT ttProfileData.cProfileCode,
                                                     INPUT ttProfileData.profile_data_key,
                                                     INPUT NO,  /* Check profile info on db */
                                                     INPUT YES, /* Check profile cache only */
                                                     OUTPUT lProfileRecordExists).
    IF lProfileRecordExists THEN
        DELETE ttProfileData.
END.

IF CAN-FIND(FIRST ttProfileData) THEN
    RUN receiveProfileCache IN gshProfileManager (INPUT TABLE ttProfileData).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-contextHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE contextHelp Procedure 
PROCEDURE contextHelp :
/*------------------------------------------------------------------------------
  Purpose:     Context help launcher - for ICF context help integration
  Parameters:  input handle of object containing widget (THIS-PROCEDURE)
               input handle of widget that has focus (FOCUS)
  Notes:       An event exists in visualcustom.i that runs this procedure
               on help anywhere of the frame.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  phObject                    AS HANDLE       NO-UNDO.
  DEFINE INPUT PARAMETER  phWidget                    AS HANDLE       NO-UNDO.

  DEFINE VARIABLE cContainerFilename                  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cObjectFilename                     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cItemName                           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cLogicalObject                      AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE iPosn                               AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cLinkHandles                        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hContainer                          AS HANDLE       NO-UNDO.

  DEFINE VARIABLE cHelpFile                           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cHelpFound                          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iHelpContext                        AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cHelpText                           AS CHARACTER    NO-UNDO.
  
  
  IF VALID-HANDLE(phObject) THEN
  DO:
    /* Get logical object names (for dynamic objects) */
    IF LOOKUP("getlogicalobjectname", phObject:INTERNAL-ENTRIES) <> 0 THEN
      cLogicalObject = DYNAMIC-FUNCTION('getlogicalobjectname' IN phObject).
    ELSE cLogicalObject = "":U.      

    /* use logical object name if dynamic */
    IF cLogicalObject <> "":U THEN
      ASSIGN cObjectFilename = cLogicalObject.
    ELSE
    DO:
      /* get filename of object and strip off path */
      ASSIGN iPosn = R-INDEX(phObject:FILE-NAME,"/":U) + 1.
      IF iPosn = 1 THEN
          ASSIGN iPosn = R-INDEX(phObject:FILE-NAME,"~\":U) + 1.
      ASSIGN cObjectFilename = SUBSTRING(phObject:FILE-NAME,iPosn).
    END.

    /* Check whether object is itself a window */
    IF LOOKUP("getObjectType":U, phObject:INTERNAL-ENTRIES) > 0 
          AND( DYNAMIC-FUNCTION("getObjectType":U IN phObject) = "Window":U 
           OR DYNAMIC-FUNCTION("getObjectType":U IN phObject) = "SmartWindow":U) THEN 
      ASSIGN cContainerFileName = cObjectFileName
             hContainer         = ?.
    ELSE
    /* get container handle */        
    IF LOOKUP("getContainerSource", phObject:INTERNAL-ENTRIES) <> 0 THEN
    DO:
      hContainer = DYNAMIC-FUNCTION('getContainerSource' IN phObject).
      IF NOT VALID-HANDLE(hContainer) THEN
        ASSIGN hContainer = phObject.
    END.

    /* Check whether current field is a smartDataField. If so, we need to get it's parent 
       first to find container */
    IF VALID-HANDLE(hContainer)
       AND LOOKUP("getObjectType":U, phObject:INTERNAL-ENTRIES) > 0 
       AND DYNAMIC-FUNCTION("getObjectType":U IN phObject) = "smartDataField":U 
    THEN DO:
       hContainer = DYNAMIC-FUNCTION('getContainerSource' IN hContainer).
       IF NOT VALID-HANDLE(hContainer) THEN
         ASSIGN hContainer = phObject.
    END.


    IF VALID-HANDLE(hContainer) THEN
    DO:
      /* Get logical object names (for dynamic objects) */
      IF LOOKUP("getlogicalobjectname", hContainer:INTERNAL-ENTRIES) <> 0 THEN
        cLogicalObject = DYNAMIC-FUNCTION('getlogicalobjectname' IN hContainer).
      ELSE cLogicalObject = "":U.      

      /* use logical object name if dynamic */
      IF cLogicalObject <> "":U THEN
        ASSIGN cContainerFilename = cLogicalObject.
      ELSE
      DO:
        ASSIGN iPosn = R-INDEX(hContainer:FILE-NAME,"/":U) + 1.
        IF iPosn = 1 THEN
            ASSIGN iPosn = R-INDEX(hContainer:FILE-NAME,"~\":U) + 1.
        ASSIGN cContainerFilename = SUBSTRING(hContainer:FILE-NAME,iPosn).
      END.
    END. /* End Valid hContainer */
  END. /* End valid-handle hObject */
  ELSE
    ASSIGN cContainerFilename = "<Unknown>":U
           cObjectFilename = "<Unknown>":U.        


  IF VALID-HANDLE(phWidget) AND CAN-QUERY(phWidget, "NAME":U)
  THEN DO:
      /* For smartDataFields, we don't want to use the widget name, as this is always going to be the same.           *
       * For instance, if you had 4 dynamic combos on a viewer, the fieldname for all of them is going to be fiCombo. *
       * So we try and determine if this is a SDF, and if so, get the field name from it.                             */
      
     IF LOOKUP("getObjectType":U, phObject:INTERNAL-ENTRIES) > 0 
        AND DYNAMIC-FUNCTION("getObjectType":U IN phObject) = "smartDataField":U 
      THEN DO:
          IF LOOKUP("getFieldName":U, phObject:INTERNAL-ENTRIES) > 0 THEN
              ASSIGN cItemName = DYNAMIC-FUNCTION("getFieldName":U IN phObject).
      END.

      IF cItemName = "":U THEN
          ASSIGN cItemName = phWidget:NAME.
  END.
  ELSE
      ASSIGN cItemName = "<Unknown>":U.

  /* get help context to use */

  RUN af/app/afgethctxp.p ON gshAstraAppserver (INPUT cContainerFilename,
                                                INPUT cObjectFilename,
                                                INPUT cItemName,
                                                OUTPUT cHelpFile,
                                                OUTPUT iHelpContext,
                                                OUTPUT cHelpText).
  cHelpFound = SEARCH(cHelpFile).

  IF cHelpFound = ? OR cHelpFound = "":U THEN
  DO:
     DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
     RUN showMessages IN gshSessionManager (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                            INPUT "ERR":U,
                                            INPUT "OK":U,
                                            INPUT "OK":U,
                                            INPUT "OK":U,
                                            INPUT "Progress Dynamics Help",
                                            INPUT NOT SESSION:REMOTE,
                                            INPUT hContainer,
                                            OUTPUT cButton).
     RETURN.
  END.
  IF INDEX(cHelpFound, ".hlp":U) > 0 THEN  /* Windows help */
  DO:
    IF cHelpText <> "":U THEN
      SYSTEM-HELP
        cHelpFound
        PARTIAL-KEY cHelpText.
    ELSE IF iHelpContext > 0 THEN
      SYSTEM-HELP
        cHelpFound
        CONTEXT iHelpContext.
    ELSE 
      SYSTEM-HELP
         cHelpFound CONTENTS.

  END.
  ELSE IF INDEX(cHelpFound, ".chm":U) > 0 
       OR INDEX(cHelpFound, ".htm":U) > 0  THEN  /* HTML Help */
  DO:
    IF cHelpText <> "":U  THEN
      SYSTEM-HELP 
         cHelpFound HELP-TOPIC cHelpText.
    ELSE
      SYSTEM-HELP
         cHelpFound CONTENTS.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createLinks) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createLinks Procedure 
PROCEDURE createLinks :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcPhysicalName AS CHARACTER NO-UNDO. 
 DEFINE INPUT PARAMETER phProcedureHandle AS HANDLE NO-UNDO.
 DEFINE INPUT PARAMETER phObjectProcedure AS HANDLE NO-UNDO.
 DEFINE INPUT PARAMETER plAlreadyRunning AS LOGICAL NO-UNDO.

    IF CAN-DO("ry/uib/rydyncontw.w,ry/uib/rydynframw.w":U, pcPhysicalName) AND 
       VALID-HANDLE(phProcedureHandle) AND VALID-HANDLE(phObjectProcedure) THEN
    DO:
        DEFINE VARIABLE hDataSource AS HANDLE NO-UNDO.
        DEFINE VARIABLE hNavigationSource AS HANDLE NO-UNDO.
        DEFINE VARIABLE hCommitSource     AS HANDLE NO-UNDO.
        DEFINE VARIABLE cDataTargets AS CHARACTER NO-UNDO.
        DEFINE VARIABLE hContainerSource AS HANDLE NO-UNDO.
        DEFINE VARIABLE hUpdateSource AS HANDLE NO-UNDO.
        DEFINE VARIABLE hPrimarySdoTarget AS HANDLE NO-UNDO.
        DEFINE VARIABLE hOldDataSource AS HANDLE NO-UNDO.
        DEFINE VARIABLE lQueryObject   AS LOGICAL    NO-UNDO.
        IF NOT plAlreadyRunning AND LOOKUP("doThisOnceOnly", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN
        DO:            
            RUN doThisOnceOnly IN phProcedureHandle.
        END.

        hPrimarySdoTarget = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION('linkHandles' IN phProcedureHandle,'PrimarySdo-Target'))).


        {get DataTarget cDataTargets phProcedureHandle}.
        {get QueryObject lQueryObject phObjectProcedure}.
        /* If this is a queryobject (SDO/SBO) then use it as datasource */ 
        IF lQueryObject THEN 
          hDataSource = phObjectProcedure.
        /* Else use its dataSource */
        ELSE 
          {get DataSource hDataSource phObjectProcedure}.

        IF NOT VALID-HANDLE(hDataSource) THEN hDataSource = WIDGET-HANDLE(ENTRY(1,DYNAMIC-FUNCTION('linkHandles' IN phObjectProcedure,'PrimarySdo-Target'))).
        {get ContainerSource hContainerSource phProcedureHandle}.
        {get UpdateSource hUpdateSource phProcedureHandle}.     
        {get NavigationSource hNavigationSource phProcedureHandle}.
        {get CommitSource hCommitSource phProcedureHandle}.

        PUBLISH "toggleData" FROM phProcedureHandle (TRUE).

        IF VALID-HANDLE(hContainerSource) AND VALID-HANDLE(hDataSource) THEN
        DO:                                                         
            IF VALID-HANDLE(hPrimarySdoTarget) THEN 
            DO:
                /* remove the old Data Links */
                {get DataSource hOldDataSource hPrimarySdoTarget}.
                IF VALID-HANDLE(hOldDataSource) THEN RUN removeLink IN hContainerSource (hOldDataSource, 'Data':U, hPrimarySdoTarget).

                RUN addLink IN hContainerSource ( hDataSource , 'Data':U , hPrimarySdoTarget ).
            END.
            IF cDataTargets <> ""        THEN 
            DO:
                RUN addLink IN hContainerSource ( hDataSource , 'Data':U , phProcedureHandle ).
            END.
            IF VALID-HANDLE(hUpdateSource)      THEN 
            DO:
                RUN addLink IN hContainerSource ( phProcedureHandle , 'Update':U , hDataSource ).
            END.
            IF VALID-HANDLE(hNavigationSource)  THEN 
            DO:
                RUN addLink IN hContainerSource ( phProcedureHandle , 'Navigation':U , hDataSource ).
            END.
            IF VALID-HANDLE(hCommitSource)  THEN 
            DO:
                RUN addLink IN hContainerSource ( phProcedureHandle , 'Commit':U , hDataSource ).
            END.

        END.

        IF plAlreadyRunning THEN 
        DO:
            PUBLISH 'dataAvailable' FROM hDataSource("DIFFERENT").
            PUBLISH 'toggleData' FROM phProcedureHandle (FALSE).
        END.

   END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteActiveSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteActiveSession Procedure 
PROCEDURE deleteActiveSession :
/*------------------------------------------------------------------------------
  Purpose:     Deletes the active session and all its context.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  &IF DEFINED(server-side) <> 0 &THEN
    DEFINE BUFFER bgst_session      FOR gst_session.

    /* Delete all the context data */
    RUN deleteContext IN THIS-PROCEDURE.

    DO TRANSACTION:

      /* Delete the session record. */
      FIND bgst_session
        WHERE bgst_session.session_id = gscSessionID
        NO-ERROR.
      IF AVAILABLE(bgst_session) THEN
        DELETE bgst_session.
    END.
  &ENDIF
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteContext Procedure 
PROCEDURE deleteContext :
/*------------------------------------------------------------------------------
  Purpose:     deletion of session context, run from as_disconnect when client
               disconnects from agent.
  Parameters:  <none>
  Notes:       Zap any remaining context database entries
               This must use the actual SESSION:SERVER-CONNECTION-ID and not the
               gscSessionId as the gscSessionId may have been set to null by the
               time this runs.
------------------------------------------------------------------------------*/

&IF DEFINED(server-side) <> 0 &THEN
  RUN afdelctxtp.  
&ELSE
  RUN af/app/afdelctxtp.p ON gshAstraAppserver.
&ENDIF

{af/sup2/afcheckerr.i &display-error = YES}   /* check for errors and display if can */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deletePersistentProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePersistentProc Procedure 
PROCEDURE deletePersistentProc :
/*------------------------------------------------------------------------------
  Purpose:     To delete persistent procedures started since this manager started
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hDeleteProc   AS HANDLE   NO-UNDO.
DEFINE VARIABLE hProcedure    AS HANDLE   NO-UNDO.
DEFINE VARIABLE lDesignMode   AS LOGICAL  NO-UNDO.

DEFINE VARIABLE cManagerList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hConnManager AS HANDLE     NO-UNDO.

/* If we're running this procedure because this PLIPP is shutting, we want to kill ALL procedures. *
 * If we're running from somewhere else, managers need to stay running.                            */
IF NOT glPlipShutting THEN
    ASSIGN hConnManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "ConnectionManager":U).
           cManagerList = (IF VALID-HANDLE(gshAgnManager)         THEN STRING(gshAgnManager) ELSE "") + CHR(3) 
                        + (IF VALID-HANDLE(gshFinManager)         THEN STRING(gshFinManager) ELSE "") + CHR(3)                  
                        + (IF VALID-HANDLE(gshRIManager)          THEN STRING(gshRIManager) ELSE "") + CHR(3)                 
                        + (IF VALID-HANDLE(gshWebManager)         THEN STRING(gshWebManager) ELSE "") + CHR(3)
                        + (IF VALID-HANDLE(gshSecurityManager)    THEN STRING(gshSecurityManager) ELSE "") + CHR(3) 
                        + (IF VALID-HANDLE(gshGenManager)         THEN STRING(gshGenManager) ELSE "") + CHR(3) 
                        + (IF VALID-HANDLE(gshTranslationManager) THEN STRING(gshTranslationManager) ELSE "") + CHR(3) 
                        + (IF VALID-HANDLE(gshRepositoryManager)  THEN STRING(gshRepositoryManager) ELSE "") + CHR(3) 
                        + (IF VALID-HANDLE(gshProfileManager)     THEN STRING(gshProfileManager) ELSE "") + CHR(3) 
                        + (IF VALID-HANDLE(gshSessionManager)     THEN STRING(gshSessionManager) ELSE "") + CHR(3) 
                        + (IF VALID-HANDLE(gshAstraAppserver)     THEN STRING(gshAstraAppserver) ELSE "") + CHR(3)
                        + (IF VALID-HANDLE(hConnManager)          THEN STRING(hConnManager) ELSE "") + CHR(3).

/* Check for objects open in design mode */
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN  
DO:
    ASSIGN hProcedure = SESSION:FIRST-PROCEDURE
           lDesignMode = FALSE.

    designloop:
    DO WHILE VALID-HANDLE( hProcedure ):
    
      IF CAN-DO(hProcedure:INTERNAL-ENTRIES,"get-attribute":U) /* V8-style */ THEN
      DO:
        RUN get-attribute IN hProcedure ("UIB-MODE":U).
        ASSIGN lDesignMode = RETURN-VALUE NE ?.
      END.
      ELSE IF CAN-DO(hProcedure:INTERNAL-ENTRIES,"getUIBMode":U) 
              AND INDEX(hProcedure:FILE-NAME,"smart.p":U) = 0 /* v9-style */ THEN 
      DO:
        lDesignMode = DYNAMIC-FUNCTION("getUIBMode":U IN hProcedure) = "Design":U NO-ERROR.
      END.
      IF lDesignMode THEN LEAVE designloop.
    
      ASSIGN hProcedure = hProcedure:NEXT-SIBLING.
    END.
    
    IF lDesignMode THEN
    DO:
      MESSAGE "Could not shutdown persistent procedures started in session as you" SKIP
              "have got objects open in design mode." SKIP
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      RETURN.      
    END.
END.

/* Shut down, but don't shut ADM2 supers. We may shut a procedure after it that needs it. */
ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.

do-blk:
DO WHILE VALID-HANDLE(hProcedure):
    FIND FIRST ttPersistProc WHERE ttPersistProc.hProc = hProcedure NO-ERROR.

    IF NOT AVAILABLE ttPersistProc THEN
      ASSIGN hDeleteProc = hProcedure.
    
    ASSIGN hProcedure = hProcedure:NEXT-SIBLING.

    IF LOOKUP(STRING(hDeleteProc), cManagerList, CHR(3)) <> 0 THEN
        NEXT do-blk.

    /* Be VERY careful not to shutdown OpenAppbuilder if running, or the
       editor extensions if running - as this will cause funny editor
       problems and GPFs
    */
    IF VALID-HANDLE( hDeleteProc ) AND 
        LOOKUP("ADEPersistent",hDeleteProc:INTERNAL-ENTRIES) = 0 AND
        LOOKUP("OpenAppEMGetProcedures",hDeleteProc:INTERNAL-ENTRIES) = 0 AND
        LOOKUP("CapKeyWord",hDeleteProc:INTERNAL-ENTRIES) = 0 AND 
        NOT hDeleteProc:FILE-NAME BEGINS "rtb":U AND /* &IF "{&scmTool}" = "RTB":U */
        NOT hDeleteProc:FILE-NAME BEGINS "ade":U AND
        NOT hDeleteProc:FILE-NAME BEGINS "pro":U THEN
    DO:
        /* Make sure this isn't one of the ADM2 supers */
        IF INDEX(hDeleteProc:FILE-NAME, "adm":U) > 0 THEN
            NEXT do-blk.

        IF LOOKUP("dispatch":U,hDeleteProc:INTERNAL-ENTRIES) NE 0 THEN
           RUN dispatch IN hDeleteProc ('destroy':U).
        IF VALID-HANDLE(hDeleteProc) AND INDEX(hDeleteProc:FILE-NAME,"rydyncont":U) = 0 THEN /* not container */
           APPLY "CLOSE":U TO hDeleteProc.
        IF VALID-HANDLE(hDeleteProc) THEN
           DELETE PROCEDURE hDeleteProc .    
    END.
END.

/* Now shut ADM supers as well */
ASSIGN hProcedure = SESSION:FIRST-PROCEDURE.

do-blk:
DO WHILE VALID-HANDLE(hProcedure):
    FIND FIRST ttPersistProc WHERE ttPersistProc.hProc = hProcedure NO-ERROR.

    IF NOT AVAILABLE ttPersistProc THEN
      ASSIGN hDeleteProc = hProcedure.
    
    ASSIGN hProcedure = hProcedure:NEXT-SIBLING.

    IF LOOKUP(STRING(hDeleteProc), cManagerList, CHR(3)) <> 0 THEN
        NEXT do-blk.

    /* Be VERY careful not to shutdown OpenAppbuilder if running, or the
       editor extensions if running - as this will cause funny editor
       problems and GPFs
    */
    IF VALID-HANDLE( hDeleteProc ) AND 
        LOOKUP("ADEPersistent",hDeleteProc:INTERNAL-ENTRIES) = 0 AND
        LOOKUP("OpenAppEMGetProcedures",hDeleteProc:INTERNAL-ENTRIES) = 0 AND
        LOOKUP("CapKeyWord",hDeleteProc:INTERNAL-ENTRIES) = 0 AND 
        NOT hDeleteProc:FILE-NAME BEGINS "rtb":U AND /* &IF "{&scmTool}" = "RTB":U */
        NOT hDeleteProc:FILE-NAME BEGINS "ade":U AND
        NOT hDeleteProc:FILE-NAME BEGINS "pro":U THEN
    DO:
        IF LOOKUP("dispatch":U,hDeleteProc:INTERNAL-ENTRIES) NE 0 THEN
           RUN dispatch IN hDeleteProc ('destroy':U).
        IF VALID-HANDLE(hDeleteProc) AND INDEX(hDeleteProc:FILE-NAME,"rydyncont":U) = 0 THEN /* not container */
           APPLY "CLOSE":U TO hDeleteProc.
        IF VALID-HANDLE(hDeleteProc) THEN
           DELETE PROCEDURE hDeleteProc .    
    END.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionUnderway) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getActionUnderway Procedure 
PROCEDURE getActionUnderway :
/*------------------------------------------------------------------------------
  Purpose:     Get the ttActionUnderway values for the passed in records
  Parameters:  <none>
  Notes:       ttActionUnderway
               ttActionUnderway.action_underway_origin
               ttActionUnderway.action_table_fla
               ttActionUnderway.action_type
               ttActionUnderway.action_primary_key
               ttActionUnderway.action_scm_object_name
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcActionUnderwayOrigin   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcActionType             AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcActionScmObjectName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcActionTablePrimaryFla  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcActionPrimaryKeyValues AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plActionUnderwayRemove   AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plActionUnderway         AS LOGICAL    NO-UNDO.

  IF pcActionType = "ANY":U
  THEN
  DO:
    FIND FIRST ttActionUnderway EXCLUSIVE-LOCK
      WHERE  ttActionUnderway.action_underway_origin BEGINS pcActionUnderwayOrigin
      NO-ERROR.
  END.
  ELSE
  IF pcActionScmObjectName <> "":U
  THEN
    FIND FIRST ttActionUnderway EXCLUSIVE-LOCK
      WHERE ttActionUnderway.action_underway_origin  BEGINS pcActionUnderwayOrigin
      AND   ttActionUnderway.action_scm_object_name  = pcActionScmObjectName
      AND   ttActionUnderway.action_type             = pcActionType
      NO-ERROR.
  ELSE
  IF pcActionTablePrimaryFla   <> "":U
  AND pcActionPrimaryKeyValues <> "":U
  THEN
    FIND FIRST ttActionUnderway EXCLUSIVE-LOCK
      WHERE ttActionUnderway.action_underway_origin  BEGINS pcActionUnderwayOrigin
      AND   ttActionUnderway.action_table_fla        = pcActionTablePrimaryFla
      AND   ttActionUnderway.action_primary_key      = pcActionPrimaryKeyValues
      AND   ttActionUnderway.action_type             = pcActionType
      NO-ERROR.
  ELSE
  IF  pcActionScmObjectName     = "":U
  AND pcActionTablePrimaryFla   = "":U
  AND pcActionPrimaryKeyValues  = "":U
  THEN
  DO:
    FIND FIRST ttActionUnderway EXCLUSIVE-LOCK
      WHERE  ttActionUnderway.action_underway_origin BEGINS pcActionUnderwayOrigin
      AND   ttActionUnderway.action_type             = pcActionType
      NO-ERROR.
  END.

  IF AVAILABLE ttActionUnderway
  THEN DO:
    ASSIGN
      plActionUnderway = YES.
    IF plActionUnderwayRemove AND pcActionType <> "ANY":U
    THEN DO:
      DELETE ttActionUnderway.
    END.
  END.
  ELSE
    ASSIGN
      plActionUnderway = NO.

  ERROR-STATUS:ERROR = NO.
  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getGlobalControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getGlobalControl Procedure 
PROCEDURE getGlobalControl :
/*------------------------------------------------------------------------------
  Purpose:     To return the global control details in the form of a temp-table.
  Parameters:  output table containing single latest global control record
  Notes:       If the temp-table is empty, then it first goes to the appserver
               to read the details and populate the temp-table. 
               On the server, we must always access the database to get the
               information.
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR ttGlobalControl.

IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) OR NOT CAN-FIND(FIRST ttGlobalControl) THEN
DO:
  &IF DEFINED(server-side) <> 0 &THEN
    RUN afgetglocp (OUTPUT TABLE ttGlobalControl).  
  &ELSE
    RUN af/app/afgetglocp.p ON gshAstraAppserver (OUTPUT TABLE ttGlobalControl).
  &ENDIF
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHelp Procedure 
PROCEDURE getHelp :
/*------------------------------------------------------------------------------
  Purpose:     A temp-table of widgets for an object is passed in.  Populate the
               temp-table with help context already stored on the database.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE hHelpTable.

&IF DEFINED(Server-Side) = 0 &THEN

/* We're going to make a dynamic call to the Appserver, we need to build the temp-table of parameters */

DEFINE VARIABLE hTableNotUsed    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParamTable      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTTHandlesToSend AS HANDLE     NO-UNDO EXTENT 64.        

IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttSeqType. ELSE FOR EACH ttSeqType: DELETE ttSeqType. END.

CREATE ttSeqType.
ASSIGN ttSeqType.iParamNo   = 1
       ttSeqType.cIOMode    = "INPUT-OUTPUT":U
       ttSeqType.cParamName = "T:01":U
       ttSeqType.cDataType  = "TABLE-HANDLE".

/* Now assign the TABLE-HANDLEs, note they map directly to the ttSeq records of type TABLE-HANDLE */

ASSIGN hTTHandlesToSend[1] = hHelpTable
       hParamTable         = TEMP-TABLE ttSeqType:HANDLE.

/* calltablett.p will construct and execute the call on the Appserver */

RUN adm2/calltablett.p ON gshAstraAppserver
    (
     "getHelp":U,
     "SessionManager":U,
     INPUT "S":U,
     INPUT-OUTPUT hTableNotUsed,
     INPUT-OUTPUT TABLE-HANDLE hParamTable,
     "",
     {src/adm2/callttparam.i &ARRAYFIELD = "hTTHandlesToSend"}  /* The actual array of table handles */ 
    ) NO-ERROR.

IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

&ELSE

DEFINE VARIABLE hBuffer            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery             AS HANDLE     NO-UNDO.

DEFINE VARIABLE hLanguageObj       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerFileName AS HANDLE     NO-UNDO.
DEFINE VARIABLE hObjectName        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidgetName        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hHelpFilename      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hHelpContext       AS HANDLE     NO-UNDO.

ASSIGN hBuffer            = hHelpTable:DEFAULT-BUFFER-HANDLE
       hLanguageObj       = hBuffer:BUFFER-FIELD("dLanguageObj":U)
       hContainerFileName = hBuffer:BUFFER-FIELD("cContainerFileName":U)
       hObjectName        = hBuffer:BUFFER-FIELD("cObjectName":U)
       hWidgetName        = hBuffer:BUFFER-FIELD("cWidgetName":U)
       hHelpFilename      = hBuffer:BUFFER-FIELD("cHelpFilename":U)
       hHelpContext       = hBuffer:BUFFER-FIELD("cHelpContext":U).

CREATE QUERY hQuery.
hQuery:ADD-BUFFER(hBuffer).
hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME).
hQuery:QUERY-OPEN().

hQuery:GET-FIRST().

DO WHILE NOT hQuery:QUERY-OFF-END:

    FIND gsm_help NO-LOCK
         WHERE gsm_help.language_obj            = hLanguageObj:BUFFER-VALUE
           AND gsm_help.help_container_filename = hContainerFileName:BUFFER-VALUE
           AND gsm_help.help_object_filename    = hObjectName:BUFFER-VALUE
           AND gsm_help.help_fieldname          = hWidgetName:BUFFER-VALUE
         NO-ERROR.

    IF AVAILABLE gsm_help THEN
        ASSIGN hHelpFilename:BUFFER-VALUE = gsm_help.help_filename
               hHelpContext:BUFFER-VALUE  = gsm_help.help_context.
    ELSE
        ASSIGN hHelpFilename:BUFFER-VALUE = "":U
               hHelpContext:BUFFER-VALUE  = "":U.

    hQuery:GET-NEXT().
END.

hQuery:QUERY-CLOSE().

DELETE OBJECT hQuery.
ASSIGN hQuery  = ?
       hBuffer = ?.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLoginUserInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLoginUserInfo Procedure 
PROCEDURE getLoginUserInfo :
/*------------------------------------------------------------------------------
  Purpose:     This procedure returns user information used by the login process.
               We only return the user name (encoded), default login company and
               default language.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR ttLoginUser.

IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttLoginUser. ELSE FOR EACH ttLoginUser: DELETE ttLoginUser. END.

RUN af/app/afgetuserp.p ON gshAstraAppserver
                        (INPUT 0,
                         INPUT "":U,
                         OUTPUT TABLE ttUser).
FOR EACH ttUser:
    CREATE ttLoginUser.
    ASSIGN ttLoginUser.encoded_user_name        = ENCODE(LC(ttUser.user_login_name)) /* Always encode the lowercase of the username.  Encoding is case sensitive */
           ttLoginUser.default_organisation_obj = ttUser.default_login_company_obj
           ttLoginUser.language_obj             = ttUser.language_obj.
    DELETE ttUser.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMessageCacheHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMessageCacheHandle Procedure 
PROCEDURE getMessageCacheHandle :
/*------------------------------------------------------------------------------
  Purpose:     A temp-table record is created to store message information retrieved
               from the Appserver in showMessages.  External programs can use this
               API to get at the temp-table record.  This API only applies client-side.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER hBufferHandle AS HANDLE     NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN
    ASSIGN hBufferHandle = TEMP-TABLE ttMessageCache:DEFAULT-BUFFER-HANDLE.
    hBufferHandle:FIND-FIRST() NO-ERROR.
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPersistentProcs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPersistentProcs Procedure 
PROCEDURE getPersistentProcs :
/*------------------------------------------------------------------------------
  Purpose:     Retrieve temp-table of running persistent procedures. Used to
               make this available outside the session manager for display in
               a browser.
  Parameters:  output temp table of persistent procedures
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR ttPersistentProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-helpAbout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE helpAbout Procedure 
PROCEDURE helpAbout :
/*------------------------------------------------------------------------------
  Purpose:     To Display help about window
  Parameters:  input container procedure handle
  Notes:       Simply uses a showmessage being sute to pass in the container so
               that all the object names and versions are shown in the system
               information.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phContainer  AS HANDLE       NO-UNDO.

DEFINE VARIABLE cButton             AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTextFile           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMessage            AS CHARACTER NO-UNDO.
DEFINE VARIABLE cLine               AS CHARACTER NO-UNDO.
DEFINE VARIABLE cVersion            AS CHARACTER NO-UNDO.

ASSIGN cTextFile = SEARCH("Version":U)
       cTextFile = IF cTextFile = ? THEN SEARCH("Version.txt":U)
                                    ELSE cTextFile.

IF cTextFile <> ? THEN
DO:
  ASSIGN cMessage = "":U.
  INPUT FROM VALUE(cTextFile) NO-ECHO.
  REPEAT:
      IMPORT UNFORMATTED cLine.
      ASSIGN cMessage = cMessage + cLine + CHR(10).
  END.
  INPUT CLOSE.
END.
ELSE DO:  /*  If this is a commercial version, the posse version info is not displayed  */
  /* Read the POSSE version from POSSEINFO.XML */
  RUN ry/prc/_readpossever.p (OUTPUT cVersion).

  ASSIGN 
    cMessage = cMessage + (IF cMessage = "":U THEN "" ELSE CHR(10)) 
                        + (IF cVersion = "" or cVersion = ? THEN "" ELSE SUBSTITUTE("POSSE Version &1",cVersion)).
    cMessage = cMessage + (IF cMessage = "":U THEN "" ELSE CHR(10)) + "www.possenet.org":U.
END.

RUN showMessages IN gshSessionManager (INPUT cMessage,
                                       INPUT "ABO":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "About Application",
                                       INPUT NOT SESSION:REMOTE,
                                       INPUT phContainer,
                                       OUTPUT cButton).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-helpContents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE helpContents Procedure 
PROCEDURE helpContents :
/*------------------------------------------------------------------------------
  Purpose:     To Display help contents from help file
  Parameters:  input container procedure handle
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phContainer  AS HANDLE       NO-UNDO.

DEFINE VARIABLE cHelpFile           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cHelpFound          AS CHARACTER    NO-UNDO.

ASSIGN
  cHelpFile = "gs~\hlp~\astramodule.chm":U.

IF NOT CAN-FIND(FIRST ttSecurityControl) THEN
DO:
  RUN getSecurityControl IN gshSecurityManager (OUTPUT TABLE ttSecurityControl).
  FIND FIRST ttSecurityControl NO-ERROR.
END.

IF AVAILABLE ttSecurityControl THEN
    ASSIGN cHelpFile = ttSecurityControl.default_help_filename.

ASSIGN cHelpFound = SEARCH(cHelpFile).

IF cHelpFound = ? THEN
  DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    RUN showMessages IN gshSessionManager (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Progress Dynamics Help",
                                           INPUT NOT SESSION:REMOTE,
                                           INPUT phContainer,
                                           OUTPUT cButton).
    RETURN.
  END.
IF INDEX(cHelpFound, ".hlp":U) > 0 THEN  /* Windows help */
  DO:
    SYSTEM-HELP
        cHelpFound
        CONTENTS.
  END.
ELSE                                        /* HTML Help */
  DO:
    DEFINE VARIABLE hwindow AS HANDLE.
    DEFINE VARIABLE hFrame AS HANDLE.

    ASSIGN 
      hWindow = phContainer:CURRENT-WINDOW
      hFrame = hWindow:FIRST-CHILD
      .

    RUN htmlHelpTopic IN gshSessionManager (INPUT hFrame,
                                            INPUT cHelpFound,
                                            INPUT "htm~\helpcontents1.htm":U).
  END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-helpHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE helpHelp Procedure 
PROCEDURE helpHelp :
/*------------------------------------------------------------------------------
  Purpose:     To Display help contents from help file
  Parameters:  input container procedure handle
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phContainer  AS HANDLE       NO-UNDO.

DEFINE VARIABLE cHelpFile           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cHelpFound          AS CHARACTER    NO-UNDO.

ASSIGN
  cHelpFile = "gs~\hlp~\astramodule.chm":U.

IF NOT CAN-FIND(FIRST ttSecurityControl) THEN
DO:
  RUN getSecurityControl IN gshSecurityManager (OUTPUT TABLE ttSecurityControl).
  FIND FIRST ttSecurityControl NO-ERROR.
END.

IF AVAILABLE ttSecurityControl THEN
    ASSIGN cHelpFile = ttSecurityControl.default_help_filename.

ASSIGN cHelpFound = SEARCH(cHelpFile).

IF cHelpFound = ? THEN
  DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    RUN showMessages IN gshSessionManager (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Progress Dynamics Help",
                                           INPUT NOT SESSION:REMOTE,
                                           INPUT phContainer,
                                           OUTPUT cButton).
    RETURN.
  END.
IF INDEX(cHelpFound, ".hlp":U) > 0 THEN  /* Windows help */
  DO:
    SYSTEM-HELP
        cHelpFound
        HELP.
  END.
ELSE                                        /* HTML Help */
  DO:
    DEFINE VARIABLE hwindow AS HANDLE.
    DEFINE VARIABLE hFrame AS HANDLE.

    ASSIGN 
      hWindow = phContainer:CURRENT-WINDOW
      hFrame = hWindow:FIRST-CHILD
      .

    RUN htmlHelpTopic IN gshSessionManager (INPUT hFrame,
                                            INPUT cHelpFound,
                                            INPUT "htm~\astrahelp.htm":U).
  END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-helpTopics) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE helpTopics Procedure 
PROCEDURE helpTopics :
/*------------------------------------------------------------------------------
  Purpose:     To Display help contents from help file
  Parameters:  input container procedure handle
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phContainer  AS HANDLE       NO-UNDO.

DEFINE VARIABLE cHelpFile           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cHelpFound          AS CHARACTER    NO-UNDO.
  
IF NOT CAN-FIND(FIRST ttSecurityControl) THEN
DO:
  RUN getSecurityControl IN gshSecurityManager (OUTPUT TABLE ttSecurityControl).
  FIND FIRST ttSecurityControl NO-ERROR.
END.

IF AVAILABLE ttSecurityControl THEN
    ASSIGN cHelpFile = ttSecurityControl.default_help_filename.

ASSIGN cHelpFound = SEARCH(cHelpFile).
IF cHelpFound = ? THEN
DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    RUN showMessages IN gshSessionManager (INPUT {af/sup2/aferrortxt.i 'AF' '19' '?' '?' 'help' cHelpFile},
                                           INPUT "ERR":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "OK":U,
                                           INPUT "Progress Dynamics Help",
                                           INPUT NOT SESSION:REMOTE,
                                           INPUT phContainer,
                                           OUTPUT cButton).
    RETURN.
END.

/* .chm (Compiled HTML) and ,hlp  */
IF INDEX(cHelpFound, ".chm":U) > 0 
       OR INDEX(cHelpFound, ".htm":U) > 0  THEN  /* HTML Help */
  SYSTEM-HELP cHelpFound CONTENTS.
ELSE
  SYSTEM-HELP cHelpFound FINDER.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlHelpKeywords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE htmlHelpKeywords Procedure 
PROCEDURE htmlHelpKeywords :
/*------------------------------------------------------------------------------
  Purpose:     To show a help topics using keyword lookup from a html help file
  Parameters:  input parent handle (frame) or ?
               input help file
               input help keywords
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phParent         AS HANDLE       NO-UNDO.
  DEFINE INPUT PARAMETER pcHelpFile       AS CHARACTER    NO-UNDO.  
  DEFINE INPUT PARAMETER pcHelpKeywords   AS CHARACTER    NO-UNDO.  

  DEFINE VARIABLE        hWndHelp           AS INTEGER      NO-UNDO.
  DEFINE VARIABLE        lpKeywords         AS MEMPTR       NO-UNDO.
  DEFINE VARIABLE        lpHH_AKLINK        AS MEMPTR       NO-UNDO.

  IF NOT VALID-HANDLE(phParent) THEN 
    ASSIGN phParent = CURRENT-WINDOW:HANDLE.

  IF pcHelpKeywords = "":U THEN RETURN.

  IF pcHelpFile = "":U THEN ASSIGN pcHelpFile = "gs/hlp/astramodule.chm":U.

  /* first use HH_DISPLAY_TOPIC to initialize the help window */
  RUN HtmlHelpTopic (phParent, pcHelpFile, "":U).

  /* if succeeded then use HH_KEYWORD_LOOKUP */
  SET-SIZE (lpKeywords)     = length(pcHelpKeywords) + 2.
  PUT-STRING(lpKeywords, 1) = pcHelpKeywords.
  SET-SIZE (lpHH_AKLINK)    = 32.
  PUT-LONG (lpHH_AKLINK, 1) = GET-SIZE(lpHH_AKLINK).
  PUT-LONG (lpHH_AKLINK, 5) = INT(FALSE). /* reserved, always FALSE */
  PUT-LONG (lpHH_AKLINK, 9) = GET-POINTER-VALUE(lpKeywords).
  PUT-LONG (lpHH_AKLINK,13) = 0.          /* pszUrl      */
  PUT-LONG (lpHH_AKLINK,17) = 0.          /* pszMsgText  */
  PUT-LONG (lpHH_AKLINK,21) = 0.          /* pszMsgTitle */
  PUT-LONG (lpHH_AKLINK,25) = 0.          /* pszWindow   */
  PUT-LONG (lpHH_AKLINK,29) = INT(TRUE).  /* fIndexOnFail */

  RUN HtmlHelpA( phParent:Hwnd ,
                 pcHelpFile, 
                 {&HH_KEYWORD_LOOKUP},
                 GET-POINTER-VALUE(lpHH_AKLINK), 
                 OUTPUT hWndHelp).
  SET-SIZE (lpHH_AKLINK) = 0.
  SET-SIZE (lpKeywords) = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-htmlHelpTopic) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE htmlHelpTopic Procedure 
PROCEDURE htmlHelpTopic :
/*------------------------------------------------------------------------------
  Purpose:     To show a specific help topic in a html help file
  Parameters:  input parent handle (frame) or ?
               input help file
               input help topic
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phParent         AS HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER pcHelpfile       AS CHARACTER    NO-UNDO.  
DEFINE INPUT PARAMETER pcHelpTopic      AS CHARACTER    NO-UNDO.  

DEFINE VARIABLE        hWndHelp         AS INTEGER      NO-UNDO.

IF NOT VALID-HANDLE(phParent) THEN 
  ASSIGN phParent = CURRENT-WINDOW:HANDLE.

IF pcHelpfile = "":U THEN ASSIGN pcHelpfile = "gs/hlp/astramodule.chm":U.

IF pcHelpTopic <> "":U THEN
  ASSIGN pcHelpTopic = "::/":U + pcHelpTopic + (IF INDEX(pcHelpTopic,".":U) > 0 THEN "":U ELSE ".htm":U).

RUN HtmlHelpA( phParent:HWND,
               pcHelpfile + pcHelpTopic, 
               {&HH_DISPLAY_TOPIC},
               0, 
               OUTPUT hWndHelp).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-increaseFrameforPopup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE increaseFrameforPopup Procedure 
PROCEDURE increaseFrameforPopup :
/*------------------------------------------------------------------------------
  Purpose:     Increase the width of a frame for a popup.  Remember
               we may have to increase the window width as well, this procedure will
               take care of the details. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phObject           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phFrame            AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phLookup           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phWidget           AS HANDLE     NO-UNDO.

DEFINE VARIABLE dWindowMargin  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dWindowWidth   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dNewFrameWidth AS DECIMAL    NO-UNDO.
DEFINE VARIABLE hWindow        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainer     AS HANDLE     NO-UNDO.

ASSIGN hWindow        = phFrame:WINDOW
       dWindowMargin  = 1 /* Hardcoded, this is what we know it must be */
       dWindowWidth   = hWindow:WIDTH - dWindowMargin
       dNewFrameWidth = phWidget:COLUMN + phWidget:WIDTH + phLookup:WIDTH.

/* 1st resize the window */

IF phFrame:COLUMN + dNewFrameWidth + dWindowMargin > hWindow:WIDTH-CHARS 
THEN DO:
    ASSIGN hWindow:VIRTUAL-WIDTH  = 320
           hWindow:WIDTH          = phFrame:COLUMN + dNewFrameWidth + dWindowMargin
           hWindow:MIN-WIDTH      = hWindow:WIDTH.
END.

/* ...then resize the frame */

IF dNewFrameWidth > phFrame:WIDTH 
THEN DO:
    ASSIGN phFrame:SCROLLABLE     = TRUE
           phFrame:VIRTUAL-WIDTH  = 320
           phFrame:WIDTH          = dNewFrameWidth 
           phLookup:X             = phWidget:X + phWidget:WIDTH-PIXELS - 3
           NO-ERROR.
    {set minWidth phFrame:WIDTH phObject}.
END.

/* We're assuming we've been called from a viewer, so find it's container. */

ASSIGN hContainer = DYNAMIC-FUNCTION("getcontainersource":U IN phObject) NO-ERROR.

IF  VALID-HANDLE(hContainer)
THEN DO:
    IF LOOKUP("resizeWindow":U, hContainer:INTERNAL-ENTRIES) = 0 THEN
        ASSIGN hContainer = DYNAMIC-FUNCTION("getContainerSource":U IN hContainer) NO-ERROR.
    
    IF VALID-HANDLE(hContainer) AND LOOKUP("resizeWindow":U, hContainer:INTERNAL-ENTRIES) <> 0 
    THEN DO:
        APPLY "window-resized":u TO hWindow.
        RUN resizeWindow IN hContainer.
    END.
END.

/* Set virtual size back */

ASSIGN hWindow:VIRTUAL-WIDTH  = hWindow:WIDTH
       phFrame:VIRTUAL-WIDTH  = phFrame:WIDTH
       phFrame:SCROLLABLE     = FALSE
       ERROR-STATUS:ERROR     = NO.

RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlips) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlips Procedure 
PROCEDURE killPlips :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to shutdown plips cleanly, forcing correct update of
               the running procedures temp-table.
  Parameters:  input CHR(3) delimited list of plip names to kill
               input CHR(3) delimited list of plip handles to kill
  Notes:       Only one of the parameters is required, depending on whether
               the plip name or the plip handle is known. A combination can
               be passed in if required.
               Note if plip names are used, the full plip name including relative
               path and .p extension must be specified, as was specified when the
               plip was launched.
               Copes with killing Astra 1 and ICF plips, plus non standard plips.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcPlipNames               AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcPlipHandles             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iLoop                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE hPlip                             AS HANDLE     NO-UNDO.
DEFINE VARIABLE cPlipName                         AS CHARACTER  NO-UNDO.

/* first add plip handle filenames to plip names */
IF pcPlipHandles <> "":U THEN
handle-loop:
DO iLoop = 1 TO NUM-ENTRIES(pcPlipHandles, CHR(3)):
  ASSIGN hPlip = WIDGET-HANDLE(ENTRY(iLoop, pcPlipHandles, CHR(3))) NO-ERROR.
  ASSIGN cPlipName = "":U.
  IF VALID-HANDLE(hPlip) THEN ASSIGN cPlipName = hPlip:FILE-NAME NO-ERROR.
  IF cPlipName <> "":U THEN
    ASSIGN
      pcPlipNames = pcPlipNames + (IF pcPlipNames <> "":U THEN CHR(3) ELSE "":U) +
                                  cPlipName.
END.

/* then loop around and kill them */
IF pcPlipNames <> "":U THEN
name-loop:
DO iLoop = 1 TO NUM-ENTRIES(pcPlipNames, CHR(3)):
  FOR EACH ttPersistentProc
     WHERE ttPersistentProc.physicalName = ENTRY(iLoop, pcPlipNames, CHR(3))
       AND ttPersistentProc.procedureType <> "MAN":U: 

      /* ICF Procedure */
      IF DYNAMIC-FUNCTION("getInternalEntryExists":U, ttPersistentProc.ProcedureHandle, "killPlip":U) THEN
          RUN killPlip IN ttPersistentProc.ProcedureHandle.
      ELSE
      IF VALID-HANDLE(ttPersistentProc.ProcedureHandle) THEN
      DO:
        DELETE PROCEDURE ttPersistentProc.ProcedureHandle.
        DELETE ttPersistentProc.
      END.
  END.
END.  /* name-loop */

/* Finally, just to be sure, zap any handles STILL valid if handles passed in */
IF pcPlipHandles <> "":U THEN
handle-loop2:
DO iLoop = 1 TO NUM-ENTRIES(pcPlipHandles, CHR(3)):
  ASSIGN hPlip = WIDGET-HANDLE(ENTRY(iLoop, pcPlipHandles, CHR(3))) NO-ERROR.
  IF hPlip = gshSessionManager OR
     hplip = gshProfileManager OR
     hplip = gshTranslationManager OR
     hplip = gshSecurityManager OR
     hplip = gshRepositoryManager THEN NEXT handle-loop2.
  IF DYNAMIC-FUNCTION("getInternalEntryExists":U, hPlip, "killPlip":U ) THEN
    RUN killPlip IN hPlip.
  ELSE
  IF VALID-HANDLE(hPlip) THEN
    DELETE PROCEDURE hPlip.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killProcedure Procedure 
PROCEDURE killProcedure :
/*------------------------------------------------------------------------------
  Purpose:     To remove a procedure from the temp-table of running procedures
  Parameters:  input physical object filename (with path and extension)
               input logical object name if applicable and known
               input child data key if applicable
               input run attribute if required to post into container run
               input on appserver flag YES/NO
  Notes:       This is used to remove all types of procedures from the 
               temp-table as launched by the launchContainer and the
               launchProcedure procedures.
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcPhysicalName    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcLogicalName     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcChildDataKey    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcRunAttribute    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plOnAppserver     AS LOGICAL   NO-UNDO.

DEFINE VARIABLE         lOnAppserver      AS LOGICAL   NO-UNDO.

FOR EACH ttPersistentProc
   WHERE ttPersistentProc.physicalName = pcPhysicalName
     AND ttPersistentProc.logicalName = pcLogicalName
     AND ttPersistentProc.runAttribute = pcRunAttribute
     AND ttPersistentProc.childDataKey = pcChildDataKey
     AND ttPersistentProc.onAppserver = plOnAppserver:
  DELETE ttPersistentProc.
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchContainer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchContainer Procedure 
PROCEDURE launchContainer :
/*------------------------------------------------------------------------------
  Purpose:     To launch an Dynamics container object, dealing with whether it
               is already running and whether the existing instance should be
               replaced or a new instance run. The temp-table of running
               persistent procedures is updated with the appropriate details.
  Parameters:  input object filename if the physical or physical and logical names are not known
               input physical object name (with path and extension) if known
               input logical object name if applicable and known
               input once only flag YES/NO
               input instance attributes to pass to container
               input child data key if applicable
               input run attribute if required to post into container run
               input container mode, e.g. modify, view, add or copy
               input parent (caller) window handle if known (container window handle)
               input parent (caller) procedure handle if known (container procedure handle)
               input parent (caller) object handle if known (handle at end of toolbar link, e.g. browser)
               output procedure handle of object run/running
               output procedure type (e.g ADM1, Astra1, ADM2, ICF, "")
  Notes:       See document or help file for detailed explanation of what this procedure does.
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcObjectFileName      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcPhysicalName        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcLogicalName         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plOnceOnly            AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcInstanceAttributes  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcChildDataKey        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcRunAttribute        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcContainerMode       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER phParentWindow        AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phParentProcedure     AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phObjectProcedure     AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phProcedureHandle     AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER pcProcedureType       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lAlreadyRunning               AS LOGICAL    NO-UNDO.                            
  DEFINE VARIABLE lRunSuccessful                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cProcedureDesc                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonPressed                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lMultiInstanceSupported       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cLaunchContainer              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainerSuperProcedure      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hWindow                       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectToCache                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lContainerSecured             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dSmartObjectObj               AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE rProfileDataRowid             AS ROWID      NO-UNDO.
  DEFINE VARIABLE cProfileDataValue             AS CHARACTER  NO-UNDO.
  
  /* Work out what the object's name is going to be in the repository.  For caching and security. */
  ASSIGN cObjectToCache = IF pcLogicalName <> "":U 
                          THEN pcLogicalName 
                          ELSE pcObjectFileName.

  /* If we don't have a logical object name and we were passed a physical filename, deduce what we think the logical name is. *
   * The caching and security procedures will massage it even more, to see if they can find the object.                       */

  IF  cObjectToCache  = "":U 
  AND pcPhysicalName <> "":U THEN
      ASSIGN cObjectToCache = REPLACE(pcPhysicalName, "~\":U, "/":U)
             cObjectToCache = ENTRY(NUM-ENTRIES(cObjectToCache, "/":U), cObjectToCache, "/":U). /* The caching and security functions will remove the file extension if necessary */

  /* If we're running Appserver, cache all the info we're going to need to launch this container in one Appserver hit. *
   * The call manager will then prepopulate the manager caches, to ensure the info is there when requested.            */

  IF SESSION <> gshAstraAppserver THEN /* Only cache when running Appserver. */
      RUN containerCacheUpfront (INPUT cObjectToCache,
                                 INPUT pcRunAttribute,
                                 INPUT YES,       /* Return entire container */    
                                 INPUT NO,        /* Design mode */                
                                 INPUT "":U,      /* Toolbar list, blank for all */
                                 INPUT "":U,      /* Band list, blank for all */   
                                 OUTPUT lContainerSecured).
  ELSE
      RUN objectSecurityCheck IN gshSecurityManager (INPUT-OUTPUT cObjectToCache,
                                                     INPUT-OUTPUT dSmartObjectObj, /* Always going to be 0 here */
                                                     OUTPUT lContainerSecured).
  IF lContainerSecured = YES
  THEN DO:
      RUN showMessages IN THIS-PROCEDURE 
           (INPUT {af/sup2/aferrortxt.i 'AF' '17' '?' '?' '"You do not have the necessary security permission to launch this container"'},
            INPUT "ERR":U,
            INPUT "OK",
            INPUT "OK",
            INPUT "OK",
            INPUT "Security",
            INPUT NO,
            INPUT ?,
            OUTPUT cButtonPressed).
      RETURN.
  END.

  /* Save the RunAttribute value so that it can be retrieved by a "launched" *
   * container during container initialization */
  DYNAMIC-FUNCTION("setSessionParam":U, "RunAttribute":U, pcRunAttribute).

  /* If object filename passed in, get logical and physical object names */
  IF pcObjectFileName <> "":U THEN
      RUN getObjectNames IN gshRepositoryManager (INPUT  pcObjectFileName,
                                                  INPUT  pcRunAttribute,
                                                  OUTPUT pcPhysicalName,
                                                  OUTPUT pcLogicalName).

  /** Even though dynamic frames are containers themselves, they are not
   *  launchable by themselves. They should be first placed on a window,
   *  and run from there. The underlying rendering engine is changed so
   *  that the Dynamics default container is used. We can do this with
   *  an expectation of success because both the frame and window rendering
   *  engines use the same super procedures, and so much of the code is shared.
   *  ----------------------------------------------------------------------- **/
  IF pcPhysicalName MATCHES "*ry/uib/rydynframw.*":U THEN
    ASSIGN pcPhysicalName = "ry/uib/rydyncontw.w".

  /* smart objects does a Callback to getCurrentLogicalname which returns this
     in order to read attribute data from repository BEFORE any set is done
     (This may change when dynamic objects no longer include the .i)  */       
  gcLogicalContainerName = pcLogicalName.
  
  /* If objects do not exit, give an error */

  IF pcPhysicalName = "":U
  THEN DO:
    IF pcLogicalName <> "":U THEN
        ASSIGN cLaunchContainer = pcLogicalName.
    ELSE
        ASSIGN cLaunchContainer = pcObjectFileName.

    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.

    RUN showMessages IN gshSessionManager
                    (INPUT {af/sup2/aferrortxt.i 'RY' '6' '?' '?' cLaunchContainer}
                    ,INPUT "ERR":U
                    ,INPUT "OK":U
                    ,INPUT "OK":U
                    ,INPUT "OK":U
                    ,INPUT "Launch Container"
                    ,INPUT NOT SESSION:REMOTE
                    ,INPUT ?
                    ,OUTPUT cButton
                    ).

    ASSIGN phProcedureHandle = ?
           pcProcedureType   = "":U.
    gcLogicalContainerName = ?.
    RETURN.
  END.

  ASSIGN
    cProcedureDesc    = "":U
    lAlreadyRunning   = NO
    lRunSuccessful    = NO
    phProcedureHandle = ?
    pcProcedureType   = "CON":U.

  /* regardless of once only flag, see if already running as it may be an object
   * that does not support multiple instances. */
  FIND FIRST ttPersistentProc
    WHERE ttPersistentProc.physicalName  = pcPhysicalName
    AND   ttPersistentProc.logicalName   = pcLogicalName
    AND   ttPersistentProc.runAttribute  = pcRunAttribute
    AND   ttPersistentProc.childDataKey  = pcChildDataKey
    NO-ERROR.
  IF NOT AVAILABLE ttPersistentProc
  THEN
    FIND FIRST ttPersistentProc
      WHERE ttPersistentProc.physicalName  = pcPhysicalName
      AND   ttPersistentProc.logicalName   = pcLogicalName
      AND   ttPersistentProc.runAttribute  = pcRunAttribute
      AND   ttPersistentProc.childDataKey  = "":U
      NO-ERROR.

  /* check handle still valid */

  IF AVAILABLE ttPersistentProc
  AND (NOT VALID-HANDLE(ttPersistentProc.procedureHandle)
  OR  ttPersistentProc.ProcedureHandle:UNIQUE-ID <> ttPersistentProc.UniqueId)
  THEN DO:
    DELETE ttPersistentProc.
  END.

  IF AVAILABLE ttPersistentProc
  THEN DO:
    ASSIGN
      lAlreadyRunning   = YES
      phProcedureHandle = ttPersistentProc.ProcedureHandle
      pcChildDataKey    = ttPersistentProc.childDataKey.       
  END.

  /* check in running instance if multiple instances supported */
  ASSIGN
    lMultiInstanceSupported = YES.

  IF VALID-HANDLE(phProcedureHandle)
  AND LOOKUP("getMultiInstanceSupported", phProcedureHandle:INTERNAL-ENTRIES) <> 0
  THEN
    ASSIGN
      lMultiInstanceSupported = DYNAMIC-FUNCTION('getMultiInstanceSupported' IN phProcedureHandle) = "YES":U
      NO-ERROR.

  /*
  IF multiple instances support is unknown
  THEN default to the user preferences and if a attribute has been set for the container then use the conteiner default
  ELSE force a single instance
  */
  IF plOnceOnly = ?
  THEN DO:

    ASSIGN
      plOnceOnly = NO.

    /* Find the User Preferences */
    RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                             INPUT "OneWindow":U,
                                             INPUT "OneWindow":U,
                                             INPUT NO,
                                             INPUT-OUTPUT rProfileDataRowid,
                                             OUTPUT cProfileDataValue).

    /* Find the Object Attribute if possible */
    /*
      TO BE DONE LATER
    */

    ASSIGN
      plOnceOnly = (IF cProfileDataValue = "YES":U THEN YES ELSE NO).

  END.

  /* if not a valid handle or not once only, then run it */
  IF NOT VALID-HANDLE(phProcedureHandle)
  OR NOT plOnceOnly
  THEN DO:

    ASSIGN
      lAlreadyRunning = NO.

    /* run the procedure */      
    SESSION:SET-WAIT-STATE('general':U).

    RUN-BLOCK:
    DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:

      RUN VALUE(pcPhysicalName) PERSISTENT SET phProcedureHandle.

    END.

    IF NOT VALID-HANDLE(phProcedureHandle)
    THEN DO:

      SESSION:SET-WAIT-STATE('':U).
      ASSIGN
        phProcedureHandle = ?.

    END.
    /* Add the container's super procedure, if any. */  
    ELSE DO:

      ASSIGN
        cContainerSuperProcedure = "":U.

      RUN getObjectSuperProcedure IN gshRepositoryManager
                                 (INPUT (IF pcLogicalName <> "":U THEN pcLogicalName ELSE pcPhysicalName)
                                 ,INPUT pcRunAttribute
                                 ,OUTPUT cContainerSuperProcedure
                                 ).

      /* Make sure that the custom super procedure exists. */
      IF SEARCH(cContainerSuperProcedure)                          <> ?
      OR SEARCH(REPLACE(cContainerSuperProcedure, ".p":U, ".r":U)) <> ?
      THEN DO:
        {launch.i
            &PLIP  = cContainerSuperProcedure
            &OnApp = 'NO'
            &Iproc = ''
            &NewInstance = YES 
        }
        IF VALID-HANDLE(hPlip) THEN
            DYNAMIC-FUNCTION("addAsSuperProcedure":U, INPUT hPlip, INPUT phProcedureHandle).
      END.    /* add super procedure */

      /* work out the procedure type of the object run / running */
      IF LOOKUP( "dispatch":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0
      THEN
        ASSIGN
          pcProcedureType = "ADM1":U.

      IF LOOKUP( "getobjectversion":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0
      THEN
        ASSIGN
          pcProcedureType = "ADM2":U.

      IF LOOKUP( "getLogicalObjectName":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0
      THEN
        ASSIGN
          pcProcedureType = "ICF":U.

      /* set initial attributes in object */
      IF pcProcedureType = "ICF":U
      OR pcProcedureType = "ADM2":U
      THEN DO:   

        RUN setAttributesInObject IN gshSessionManager
                                 (INPUT phProcedureHandle
                                 ,INPUT pcInstanceAttributes
                                 ).

      END.

    END.    /* IF VALID-HANDLE(phProcedureHandle) */

  END.

  /* turn egg timer off */
  IF VALID-HANDLE(phProcedureHandle)
  THEN DO:
    SESSION:SET-WAIT-STATE('':U).
  END.

  /* see if handle now valid and if so, update temp-table with details */        
  IF VALID-HANDLE(phProcedureHandle)
  THEN DO:

    FIND FIRST ttPersistentProc
      WHERE ttPersistentProc.physicalName  = pcPhysicalName
      AND   ttPersistentProc.logicalName   = pcLogicalName
      AND   ttPersistentProc.runAttribute  = pcRunAttribute
      AND   ttPersistentProc.childDataKey  = pcChildDataKey
      NO-ERROR.

    /* Create a new entry in the temp-table if the procedure is not yet running,
     * or if this is an additional instance of a container. This will only happen if
     * the call specifies that the container should be a multiple instance.         */
    IF NOT AVAILABLE ttPersistentProc
    OR ( AVAILABLE ttPersistentProc AND NOT plOnceOnly )
    THEN DO:

      CREATE ttPersistentProc.
      ASSIGN
        ttPersistentProc.physicalName           = pcPhysicalName
        ttPersistentProc.logicalName            = pcLogicalName
        ttPersistentProc.runAttribute           = pcRunAttribute
        ttPersistentProc.childDataKey           = pcChildDataKey
        ttPersistentProc.procedureType          = pcProcedureType
        ttPersistentProc.onAppserver            = NO
        ttPersistentProc.multiInstanceSupported = lMultiInstanceSupported
        ttPersistentProc.currentOperation       = pcContainerMode
        ttPersistentProc.startDate              = TODAY
        ttPersistentProc.startTime              = TIME
        ttPersistentProc.procedureVersion       = "":U
        ttPersistentProc.procedureNarration     = "":U.

    END.

    /* try and get object version number */
    IF LOOKUP("getLogicalVersion", phProcedureHandle:INTERNAL-ENTRIES) <> 0
    THEN
      ASSIGN
        ttPersistentProc.procedureVersion = DYNAMIC-FUNCTION('getLogicalVersion' IN phProcedureHandle)
        NO-ERROR.
    ELSE
    IF LOOKUP( "mip-get-object-version":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0
    THEN
      RUN mip-get-object-version IN phProcedureHandle
                                (OUTPUT ttPersistentProc.procedureNarration
                                ,OUTPUT ttPersistentProc.procedureVersion
                                ).
    /* try and get object description from standard internal procedure */
    IF LOOKUP( "objectDescription":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0
    THEN
      RUN objectDescription IN phProcedureHandle
                           (OUTPUT ttPersistentProc.procedureNarration).
    ELSE
    IF LOOKUP( "mip-object-description":U, phProcedureHandle:INTERNAL-ENTRIES ) <> 0
    THEN
      RUN mip-object-description IN phProcedureHandle
                                (OUTPUT ttPersistentProc.procedureNarration).

    /* reset procedure handle, unique id, etc. */
    ASSIGN
      ttPersistentProc.ProcedureHandle  = phProcedureHandle
      ttPersistentProc.uniqueId         = phProcedureHandle:UNIQUE-ID
      ttPersistentProc.RunPermanent     = NO
      lRunSuccessful                    = YES.       

    IF pcProcedureType = "ICF":U
    THEN DO:

      IF VALID-HANDLE(phParentProcedure)
      OR phParentProcedure <> ?
      THEN DO:

        IF lAlreadyRunning
        THEN DO:

          DEFINE VARIABLE hOldContainerSource AS HANDLE NO-UNDO.

          {get ContainerSource hOldContainerSource phProcedureHandle}.

          IF VALID-HANDLE(hOldContainerSource)
          THEN
            RUN removeLink IN phParentProcedure
                          (INPUT hOldContainerSource
                          ,INPUT "container"
                          ,INPUT phProcedureHandle
                          ).

        END.

        RUN addLink IN phParentProcedure
                   (INPUT phParentProcedure
                   ,INPUT "Container"
                   ,INPUT phProcedureHandle
                   ).

      END.

      IF VALID-HANDLE(phParentWindow)
      OR phParentWindow <> ?
      THEN DO:

        /* set the parent window */
        {set ObjectParent phParentWindow phProcedureHandle}.

      END.

      /* give it the run attribute */
      IF pcRunAttribute <> "":U
      AND LOOKUP("setRunAttribute", phProcedureHandle:INTERNAL-ENTRIES) <> 0
      THEN DO:
        DYNAMIC-FUNCTION('setRunAttribute' IN phProcedureHandle, pcRunAttribute).
      END.

      /* Object launched ok, set logical object name attribute to correct value if required */
      IF pcLogicalName <> "":U
      AND LOOKUP("setLogicalObjectName", phProcedureHandle:INTERNAL-ENTRIES) <> 0
      THEN DO:
          DYNAMIC-FUNCTION('setLogicalObjectName' IN phProcedureHandle, INPUT pcLogicalName).
      END.
      ELSE
          IF cObjectToCache <> "":U THEN
              DYNAMIC-FUNCTION('setLogicalObjectName' IN phProcedureHandle, INPUT cObjectToCache).

      IF VALID-HANDLE(phObjectProcedure)
      OR phObjectProcedure <> ?
      THEN DO:

        /* perform the required pre-initialization work */
        RUN createLinks (INPUT pcPhysicalName
                        ,INPUT phProcedureHandle
                        ,INPUT phObjectProcedure
                        ,INPUT lAlreadyRunning
                        ).

      END.

      /* set correct container mode before initialize object */
      IF pcContainerMode <> "":U
      AND LOOKUP("setContainerMode", phProcedureHandle:INTERNAL-ENTRIES) <> 0
      THEN DO:
        DYNAMIC-FUNCTION('setContainerMode' IN phProcedureHandle, INPUT pcContainerMode).
      END.

      /* set caller attributes in container just launched */
      IF phObjectProcedure <> ?
      AND LOOKUP("setCallerObject", phProcedureHandle:INTERNAL-ENTRIES) <> 0
      THEN DO:
        DYNAMIC-FUNCTION('setCallerObject' IN phProcedureHandle, INPUT phObjectProcedure).
      END.

      IF phParentProcedure <> ?
      AND LOOKUP("setCallerProcedure", phProcedureHandle:INTERNAL-ENTRIES) <> 0
      THEN DO:
        DYNAMIC-FUNCTION('setCallerProcedure' IN phProcedureHandle, INPUT phParentProcedure).
      END.

      IF phParentWindow <> ?
      AND LOOKUP("setCallerWindow", phProcedureHandle:INTERNAL-ENTRIES) <> 0
      THEN DO:
        DYNAMIC-FUNCTION('setCallerWindow' IN phProcedureHandle, INPUT phParentWindow).
      END.

      /* Initialize the run object */
      IF LOOKUP("initializeObject", phProcedureHandle:INTERNAL-ENTRIES) <> 0 THEN 
      DO:
          RUN initializeObject IN phProcedureHandle.

          /* There may be code in the container that forces a shutdown while the
           * container is instantiating. We need to cater for this.             */
          IF NOT VALID-HANDLE(phProcedureHandle) THEN
          DO:
              ASSIGN phProcedureHandle = ?
                     pcProcedureType   = "":U
                     .
              IF AVAILABLE ttPersistentProc THEN
                  DELETE ttPersistentProc NO-ERROR.

              SESSION:SET-WAIT-STATE("":U).
              RETURN.
          END.  /* not valid procedure handle */
      END.

    END.  /* END ICF code */
    /* Bring container to front or restore if minimized and apply focus */
    ASSIGN
      hWindow = phProcedureHandle:CURRENT-WINDOW NO-ERROR.

    IF VALID-HANDLE(hWindow)
    THEN DO:  

      IF hWindow:WINDOW-STATE = WINDOW-MINIMIZED
      THEN
         hWindow:WINDOW-STATE = WINDOW-NORMAL.

      hWindow:MOVE-TO-TOP().

      APPLY "ENTRY":U TO hWindow.

    END.
  END. /* END IF VALID-HANDLE(phProcedureHandle) */
  ELSE DO:

    ASSIGN
      lAlreadyRunning   = NO
      lRunSuccessful    = NO
      phProcedureHandle = ?
      pcProcedureType   = "":U
      .       

  END.

  gcLogicalContainerName = ?.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-LaunchExternalProcess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LaunchExternalProcess Procedure 
PROCEDURE LaunchExternalProcess :
/*------------------------------------------------------------------------------
  Purpose:     To launch an external process
  Parameters:  input command line, e.g. "notepad.exe"
               input default directory for the process
               input show window flag, 0 (Hidden) / 1 (Normal) / 2 (Minimised) / 3 (Maximised)
               output result, 0 (Failure) / Non-zero (Handle of new process)

  Notes:       Uses the CreateProcess API function from af/sup/windows.i
------------------------------------------------------------------------------*/
IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN RETURN.

DEFINE INPUT  PARAMETER pcCommandLine         AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcCurrentDirectory    AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER piShowWindow          AS INTEGER      NO-UNDO.
DEFINE OUTPUT PARAMETER piResult              AS INTEGER      NO-UNDO.

DEFINE VARIABLE pmStartupInfoPointer          AS MEMPTR       NO-UNDO.
DEFINE VARIABLE pmProcessInfoPointer          AS MEMPTR       NO-UNDO.
DEFINE VARIABLE pmCurrentDirPointer           AS MEMPTR       NO-UNDO.
DEFINE VARIABLE iResult                       AS INTEGER      NO-UNDO.

SET-SIZE(  pmStartupInfoPointer     ) = 68.
PUT-LONG(  pmStartupInfoPointer,  1 ) = 68.
PUT-LONG(  pmStartupInfoPointer, 45 ) = 1.   /* = STARTF_USESHOWWINDOW */
PUT-SHORT( pmStartupInfoPointer, 49 ) = piShowWindow.

SET-SIZE( pmProcessInfoPointer ) = 16.

IF pcCurrentDirectory <> "":U THEN
  DO:
    SET-SIZE(   pmCurrentDirPointer    ) = 256.
    PUT-STRING( pmCurrentDirPointer, 1 ) = pcCurrentDirectory.
  END.


RUN CreateProcess{&A} IN hpApi
 ( 0,
   pcCommandLine,
   0,
   0,
   0,
   0,
   0,
   IF pcCurrentDirectory = "":U
      THEN 0
      ELSE GET-POINTER-VALUE( pmCurrentDirPointer ),
   GET-POINTER-VALUE( pmStartupInfoPointer ),
   GET-POINTER-VALUE( pmProcessInfoPointer ),
   OUTPUT iResult
 ).

DEFINE VARIABLE iProcessHandle   AS INTEGER  NO-UNDO.
ASSIGN
  iProcessHandle = GET-LONG( pmProcessInfoPointer, 1 ).

SET-SIZE( pmStartupInfoPointer ) = 0.
SET-SIZE( pmProcessInfoPointer ) = 0.
SET-SIZE( pmCurrentDirPointer  ) = 0.

ASSIGN
    piResult = iProcessHandle.

RELEASE EXTERNAL PROCEDURE "kernel32".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-launchProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE launchProcedure Procedure 
PROCEDURE launchProcedure :
/*------------------------------------------------------------------------------
  Purpose:     To launch a business logic procedure / manager procedure.
               Deals with whether the procedure is already running and whether
               the existing instance should be replaced or a new instance run.
               Also deals with connecting to appserver partition if required.
               The temp-table of running persistent procedures is updated with
               the appropriate details.
  Parameters:  input physical object filename (with path and extension)
               input once only flag YES/NO (default = YES)
               input run on appserver flag YES/NO/APPSERVER
               input appserver partition name to run on
               input run permanent flag YES/NO, default is NO
               output procedure handle of object run/running
  Notes:       If the once only flag is passed in as YES, then the procedure will
               check for an already running instance and use this if possible. 
               If the run permanent flag is passed in as YES, then this procedure
               will not be automatically killed when an Appserver agent is
               deactivated. Ordinarily this flag should be NO and all procedures
               left running should be deleted at the end of an appserver request by
               the deactivation routine. When procedures are closed down corerectly,
               they are removed from the temp-table and deleted - this behaviour is just
               to tidy up any procedures started outside of this control procedure, or
               shutdown incorrectly for some reason.
               If the appserver flag is passed in as APPSERVER, then this procedure
               may ONLY be run on appserver. If the flag is YES and no Appserver
               partition is passed in, then "Astra" will be defaulted and the session
               handle gshAstraAppserver handle used for the Appserver.
               If the partition is passed in as anthing other than Astra and the Appserver
               flag is not NO, then the partition is connected if required. Any
               partitions connected in this way will be disconnected by the shutdown
               procedure af/sup2/afshutdwnp.p.
               Do not ordinarily need to run this procedure for managers as their
               handles are available via system wide global shared variables. We do
               however initially use this for the managers when they are first run to
               add them to the temp-table of running persistent procedures.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcPhysicalName        AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plOnceOnly            AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcOnAppserver         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAppserverPartition  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plRunPermanent        AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER phProcedureHandle     AS HANDLE     NO-UNDO.

DEFINE VARIABLE lAlreadyRunning               AS LOGICAL    NO-UNDO.                            
DEFINE VARIABLE lRunSuccessful                AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cProcedureType                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProcedureDesc                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cButtonPressed                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hAppserver                    AS HANDLE     NO-UNDO.

/* Variables for Appserver connection */
DEFINE VARIABLE lASUsePrompt                  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cASInfo                       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAsDivision                   AS CHARACTER  NO-UNDO.    

DEFINE VARIABLE hAttributeBuffer            AS HANDLE               NO-UNDO.
DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
DEFINE VARIABLE cClassType                  AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cCustomSuperProcedure       AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cAllCustomSuperProcedures   AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cPhysicalObjectName         AS CHARACTER            NO-UNDO.
DEFINE VARIABLE dRecordIdentifier           AS DECIMAL              NO-UNDO.   
DEFINE VARIABLE cAttributeList              AS CHARACTER            NO-UNDO.
DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.

ASSIGN cAsDivision = "CLIENT"    /* Client appserver connection */
       lAsUsePrompt = NO
       cAsInfo = "".

/* Ensure we get the correct names form the Repository */
RUN getObjectNames IN gshRepositoryManager ( INPUT  pcPhysicalName,
                                             INPUT  "":U,                       /* run attribute only value for containers */
                                             OUTPUT cPhysicalObjectName,
                                             OUTPUT gcLogicalContainerName ) NO-ERROR.

/* Get Repository data for this procedure */
IF DYNAMIC-FUNCTION("cacheObjectOnClient":U IN gshRepositoryManager,
                    INPUT gcLogicalContainerName, INPUT "{&DEFAULT-RESULT-CODE}":U,
                    INPUT "":U, INPUT NO                                )  THEN
DO:
    /* The hObjectBuffer record should be available immediately after the cacheObjectOnClient() call.
     * See that APIs comments for information.                                                       */
    ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager, INPUT ?).

    /* getAllObjectSuperProcedures */
    IF hObjectBuffer:AVAILABLE THEN
    DO:
        ASSIGN pcPhysicalName          = cPhysicalObjectName
               dRecordIdentifier       = hObjectBuffer:BUFFER-FIELD("tRecordIdentifier":U):BUFFER-VALUE
               hAttributeBuffer        = hObjectBuffer:BUFFER-FIELD("tClassBufferHandle":U):BUFFER-VALUE
               cAttributeList          = DYNAMIC-FUNCTION("buildAttributeList":U IN gshRepositoryManager, 
                                                          INPUT hAttributeBuffer, INPUT dRecordIdentifier)
               .
        ASSIGN cAllCustomSuperProcedures = DYNAMIC-FUNCTION("getAllObjectSuperProcedures":U IN gshRepositoryManager,
                                                            INPUT gcLogicalContainerName,
                                                            INPUT "":U  /* Run Attribute */ ).
    END.    /* Object is in the Repository */       
END.    /* can find object in cache. */
ELSE
    ASSIGN gcLogicalContainerName = "":U.

/* check for pre-started managers running */
CASE pcPhysicalName:
  WHEN "af/sup2/afproclnt.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Client Profile Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshProfileManager
      .
  END.
  WHEN "af/app/afprosrvrp.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Server Profile Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshProfileManager
      .
  END.
  WHEN "af/sup2/afsecclnt.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Client Security Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshSecurityManager
      .
  END.
  WHEN "af/app/afsecsrvrp.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Server Security Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshSecurityManager
      .
  END.
  WHEN "af/sup2/afsesclnt.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Client Session Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshSessionManager
      .
  END.
  WHEN "af/app/afsessrvrp.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Server Session Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshSessionManager
      .
  END.
  WHEN "af/sup2/aftrnclnt.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Client Translation Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshTranslationManager
      .
  END.
  WHEN "af/app/aftrnsrvrp.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Server Translation Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshTranslationManager
      .
  END.
  WHEN "ry/prc/ryrepclnt.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Client Repository Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshRepositoryManager
      .
  END.
  WHEN "ry/app/ryprosrvrp.p" THEN
  DO:
    ASSIGN
      cProcedureType = "MAN":U
      cProcedureDesc = "Server Repository Manager":U
      lAlreadyRunning = YES
      lRunSuccessful = YES
      phProcedureHandle = gshRepositoryManager
      .
  END.
  OTHERWISE DO:
    /* The user could have passed a manager description, see if he passed a manager in */

    ASSIGN phProcedureHandle = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, pcPhysicalName) NO-ERROR.

    IF NOT VALID-HANDLE(phProcedureHandle) THEN
        ASSIGN cProcedureType = "PRO":U
               cProcedureDesc = "":U
               lAlreadyRunning = NO
               lRunSuccessful = NO
               phProcedureHandle = ?.
  END.
END CASE.

/* default to astra appserver partition */
IF pcAppserverPartition = "":U AND pcOnAppserver <> "NO":U THEN 
  ASSIGN pcAppserverPartition = "Astra":U.

/* check if Appserver connected and get handle to it */
IF pcOnAppserver <> "NO":U AND NOT VALID-HANDLE(phProcedureHandle) THEN
DO:
  IF pcAppserverPartition = "Astra":U THEN
    ASSIGN hAppserver = gshAstraAppserver.
  ELSE
  DO:
    RUN appServerConnect(INPUT  pcAppserverPartition, 
                         INPUT  IF NOT lASUsePrompt THEN ? ELSE lASUsePrompt,
                         INPUT  IF cASInfo NE "":U THEN cASInfo ELSE ?, 
                         OUTPUT hAppserver).                                       
  END.
END.

/* if can only run on appserver and appserver not connected, return a null handle */
IF NOT VALID-HANDLE(phProcedureHandle) AND NOT VALID-HANDLE(hAppserver) AND pcOnAppserver = "APPSERVER":U THEN
DO:
  ASSIGN phProcedureHandle = ?.
  RETURN ERROR "Could not connect to Appserver Partition: " + pcAppserverPartition. 
END.

IF NOT VALID-HANDLE(hAppserver) THEN
  ASSIGN hAppserver = SESSION:HANDLE.

/* if handle not already valid (not a manager) - then run it if not already running 
   or want multiple instances
*/
IF NOT VALID-HANDLE(phProcedureHandle) THEN
DO:
  IF plOnceOnly THEN
  DO:
    IF pcOnAppserver <> "NO":U AND VALID-HANDLE(hAppserver) AND hAppserver <> SESSION:HANDLE THEN
      FIND FIRST ttPersistentProc
           WHERE ttPersistentProc.physicalName = pcPhysicalName
             AND ttPersistentProc.logicalName  = "":U
             AND ttPersistentProc.runAttribute = "":U
             AND ttPersistentProc.childDataKey = "":U
             AND ttPersistentProc.onAppserver  = YES
           NO-ERROR.
    ELSE
      FIND FIRST ttPersistentProc
           WHERE ttPersistentProc.physicalName = pcPhysicalName
             AND ttPersistentProc.logicalName  = "":U
             AND ttPersistentProc.runAttribute = "":U
             AND ttPersistentProc.childDataKey = "":U
             AND ttPersistentProc.onAppserver  = NO
           NO-ERROR.

    /* check handle still valid */

    IF AVAILABLE ttPersistentProc AND
       (NOT VALID-HANDLE(ttPersistentProc.procedureHandle) OR
        ttPersistentProc.ProcedureHandle:UNIQUE-ID <> ttPersistentProc.UniqueId) THEN
    DO:
      DELETE ttPersistentProc.
    END.

    IF AVAILABLE ttPersistentProc THEN
    DO:
      ASSIGN
        lAlreadyRunning = YES
        lRunSuccessful = YES
        phProcedureHandle = ttPersistentProc.ProcedureHandle
        .       
    END.
  END. /* IF plOnceOnly */

  /* if still not a valid handle, then run it */
  IF NOT VALID-HANDLE(phProcedureHandle) THEN
  DO:
    /* run the procedure */
    RUN-BLOCK:
    DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
      RUN VALUE(pcPhysicalName) PERSISTENT SET phProcedureHandle ON hAppserver.
    END.
  END.
END. 

/* see if handle now valid and if so, update temp-table with details */        

IF VALID-HANDLE(phProcedureHandle) THEN
DO:
  IF pcOnAppserver <> "NO":U AND VALID-HANDLE(hAppserver) AND hAppserver <> SESSION:HANDLE THEN
    FIND FIRST ttPersistentProc
         WHERE ttPersistentProc.physicalName = pcPhysicalName
           AND ttPersistentProc.logicalName  = "":U
           AND ttPersistentProc.runAttribute = "":U
           AND ttPersistentProc.childDataKey = "":U
           AND ttPersistentProc.onAppserver  = YES
         NO-ERROR.
  ELSE
    FIND FIRST ttPersistentProc
         WHERE ttPersistentProc.physicalName = pcPhysicalName
           AND ttPersistentProc.logicalName  = "":U
           AND ttPersistentProc.runAttribute = "":U
           AND ttPersistentProc.childDataKey = "":U
           AND ttPersistentProc.onAppserver  = NO
         NO-ERROR.

  /* Create a new entry in the temp-table if the procedure is not yet running, or *
   * if this is an additional instance of a procedure. This will only happen if   *
   * the call specifies that the procedure should be a multiple instance.         */

  IF NOT AVAILABLE ttPersistentProc OR
     ( AVAILABLE ttPersistentProc AND NOT plOnceOnly ) 
  THEN DO:
    CREATE ttPersistentProc.
    ASSIGN
      ttPersistentProc.physicalName = pcPhysicalName
      ttPersistentProc.logicalName = "":U
      ttPersistentProc.runAttribute = "":U
      ttPersistentProc.childDataKey = "":U
      ttPersistentProc.procedureType = cProcedureType
      ttPersistentProc.onAppserver = (IF pcOnAppserver <> "NO":U AND VALID-HANDLE(hAppserver) AND hAppserver <> SESSION:HANDLE THEN YES ELSE NO)
      ttPersistentProc.multiInstanceSupported = YES
      ttPersistentProc.currentOperation = "":U
      ttPersistentProc.startDate = TODAY
      ttPersistentProc.startTime = TIME
      ttPersistentProc.procedureVersion = "":U
      ttPersistentProc.procedureNarration = "":U
      .    

    /* First, we'll try and get all the PLIP detail in one Appserver hit.  Client-server should benefit as well. *
     * Don't check if the procedure exists first, this will result in an extra Appserver hit, just run NO-ERROR  */

    RUN getPlipInfo IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration,
                                          OUTPUT ttPersistentProc.procedureVersion,
                                          OUTPUT ttPersistentProc.internalEntries) 
                                          NO-ERROR.

    IF ERROR-STATUS:ERROR /* getPlipInfo doesn't exist */
    THEN DO:
        ASSIGN ERROR-STATUS:ERROR = NO.

        /* Get the procedure internal entries */

        ASSIGN ttPersistentProc.internalEntries = DYNAMIC-FUNCTION("getInternalEntries":U IN phProcedureHandle) NO-ERROR.

        /* try and get object version number */

        IF DYNAMIC-FUNCTION("getInternalEntryExists":U, phProcedureHandle, "getObjectVersion":U) THEN
            RUN getObjectVersion IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration,
                                                       OUTPUT ttPersistentProc.procedureVersion).
        ELSE
            IF DYNAMIC-FUNCTION("getInternalEntryExists":U, phProcedureHandle, "mip-get-object-version":U) THEN
                RUN mip-get-object-version IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration,
                                                                 OUTPUT ttPersistentProc.procedureVersion).
    
        /* try and get object description from standard internal procedure */

        IF DYNAMIC-FUNCTION("getInternalEntryExists":U, phProcedureHandle, "objectDescription":U) THEN
            RUN objectDescription IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration).
        ELSE
            IF DYNAMIC-FUNCTION("getInternalEntryExists":U, phProcedureHandle, "mip-object-description":U) THEN
                RUN mip-object-description IN phProcedureHandle (OUTPUT ttPersistentProc.procedureNarration).
    END.

    /* Use manager hard coded description */
    IF ttPersistentProc.procedureNarration = "":U AND cProcedureDesc <> "":U THEN
        ASSIGN ttPersistentProc.procedureNarration = cProcedureDesc.  
  END.

  /* always reset procedure handle, unique id and run permanent flag */

  ASSIGN ttPersistentProc.ProcedureHandle = phProcedureHandle
         ttPersistentProc.uniqueId        = phProcedureHandle:UNIQUE-ID
         ttPersistentProc.RunPermanent    = plRunPermanent
         lRunSuccessful = YES
         .       
END. /* IF VALID-HANDLE(phProcedureHandle) */
ELSE
  ASSIGN
    lAlreadyRunning = NO
    lRunSuccessful = NO
    phProcedureHandle = ?
    .

/* If this is the first time that this procedure has started, then start the super procedures. */
IF NOT lAlreadyRunning AND lRunSuccessful THEN
DO:
    /* If this is a Repository Object, thens et any attributes necessary. */
    IF gcLogicalContainerName NE "":U THEN
    DO:
        ASSIGN gcLogicalContainerName = "":U.
        RUN setPropertyList IN phProcedureHandle ( INPUT cAttributeList ) NO-ERROR.
    END.    /* wsa a logical object. */


    /* Add any super proecdures required. Static objects wills tart their own super procedures. */
    IF NUM-ENTRIES(cAllCustomSuperProcedures) GT 0 THEN
    DO iLoop = NUM-ENTRIES(cAllCustomSuperProcedures) TO 1 BY -1:
        ASSIGN cCustomSuperProcedure = ENTRY(iLoop, cAllCustomSuperProcedures).

        {launch.i
            &PLIP  = cCustomSuperProcedure
            &OnApp = 'NO'
            &Iproc = ''
        }
        IF VALID-HANDLE(hPlip) THEN
            phProcedureHandle:ADD-SUPER-PROCEDURE(hPlip, SEARCH-TARGET).
    END.    /* super procedure exists */
END.    /* succesfull run; not already running */

ASSIGN gcLogicalContainerName = "":U
       ERROR-STATUS:ERROR     = NO.
RETURN.
END PROCEDURE.  /* launchProcedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loginCacheAfter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loginCacheAfter Procedure 
PROCEDURE loginCacheAfter :
/*------------------------------------------------------------------------------
  Purpose:     We can only cache certain information after we have a current user &
               organisation etc.  This procedure will fire when the user presses OK
               in the login screen, and get all the stuff to cache, and cache it 
               client side, in one Appserver call.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcLoginName                AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcPassword                 AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pdCompanyObj               AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pdLanguageObj              AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER ptProcessDate              AS DATE       NO-UNDO.
DEFINE INPUT  PARAMETER pcDateFormat               AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcLoginValues              AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcLoginProc                AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcCustTypesPrioritised     AS CHARACTER  NO-UNDO.

DEFINE OUTPUT PARAMETER pdCurrentUserObj           AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentUserName          AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentUserEmail         AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationCode  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationName  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentOrganisationShort AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcCurrentLanguageName      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcFailedReason             AS CHARACTER NO-UNDO.

DEFINE VARIABLE cTypeAPI              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSessionCustRefs      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSessionResultCodes   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hCustomizationManager AS HANDLE     NO-UNDO.

/* Clear the cached temp-tables */

IF NOT TRANSACTION 
THEN DO:
    EMPTY TEMP-TABLE ttTranslation.
    EMPTY TEMP-TABLE ttProfileData.
    EMPTY TEMP-TABLE ttSecurityControl.
END.
ELSE DO:
    FOR EACH ttProfileData:     DELETE ttProfileData.     END.
    FOR EACH ttSecurityControl: DELETE ttSecurityControl. END.
    FOR EACH ttTranslation:     DELETE ttTranslation.     END.
END.

/* Initialize any variables */

IF pcCustTypesPrioritised = ? THEN
    ASSIGN pcCustTypesPrioritised = "":U.

IF pcDateFormat = "":U THEN
    ASSIGN pcDateFormat = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,INPUT "dateFormat":U,INPUT NO).

/* Run the Appserver procedure to extract the stuff */

RUN af/app/cacheafter.p ON gshAstraAppserver (INPUT pcLoginName,
                                              INPUT pcPassword,
                                              INPUT pdCompanyObj,
                                              INPUT pdLanguageObj,
                                              INPUT ptProcessDate,
                                              INPUT pcDateFormat,
                                              INPUT pcLoginValues,
                                              INPUT pcLoginProc,
                                              INPUT pcCustTypesPrioritised,

                                              OUTPUT TABLE ttSecurityControl,
                                              OUTPUT TABLE ttProfileData,
                                              OUTPUT TABLE ttTranslation,
                                              OUTPUT pdCurrentUserObj,
                                              OUTPUT pcCurrentUserName,
                                              OUTPUT pcCurrentUserEmail,
                                              OUTPUT pcCurrentOrganisationCode,
                                              OUTPUT pcCurrentOrganisationName,
                                              OUTPUT pcCurrentOrganisationShort,
                                              OUTPUT pcCurrentLanguageName,
                                              OUTPUT pcFailedReason,
                                              OUTPUT cTypeAPI,
                                              OUTPUT cSessionCustRefs,
                                              OUTPUT cSessionResultCodes).

IF pcFailedReason <> "":U THEN /* This will cause the login to fail */
    RETURN.

/* Now send the profile cache to the profile manager */

IF CAN-FIND(FIRST ttProfileData) THEN
    RUN receiveProfileCache IN gshProfileManager (INPUT TABLE ttProfileData).

/* Send the security cache to the security manager */

IF CAN-FIND(FIRST ttSecurityControl) THEN
    RUN receiveCacheSessionSecurity IN gshSecurityManager (INPUT TABLE ttSecurityControl).

/* Send the translation cache to the translation manager */

RUN receiveCacheClient IN gshTranslationManager (INPUT TABLE ttTranslation,
                                                 INPUT pdLanguageObj).

/* Send the type API to the customization manager */

ASSIGN hCustomizationManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, "CustomizationManager":U).

IF VALID-HANDLE(hCustomizationManager) 
THEN DO:
    RUN receiveCacheTypeAPI IN hCustomizationManager (INPUT pcCustTypesPrioritised,
                                                      INPUT cTypeAPI).

    RUN receiveCacheResultCodes IN hCustomizationManager (INPUT cSessionCustRefs,
                                                          INPUT cSessionResultCodes).
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loginCacheUpfront) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loginCacheUpfront Procedure 
PROCEDURE loginCacheUpfront :
/*------------------------------------------------------------------------------
  Purpose:     This procedures makes an Appserver call to cache all information
               needed for the login process.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hClassAttributeTable AS HANDLE     NO-UNDO EXTENT 32.
DEFINE VARIABLE iCnt                 AS INTEGER    NO-UNDO.

/* Make sure we don't have any cached information left over from a previous login. */

IF NOT TRANSACTION 
THEN DO:
    EMPTY TEMP-TABLE ttProfileData.
    EMPTY TEMP-TABLE ttGlobalControl.
    EMPTY TEMP-TABLE ttSecurityControl.
    EMPTY TEMP-TABLE ttComboData.
END.
ELSE DO:
    FOR EACH ttProfileData:     DELETE ttProfileData.     END.
    FOR EACH ttGlobalControl:   DELETE ttGlobalControl.   END.
    FOR EACH ttSecurityControl: DELETE ttSecurityControl. END.
    FOR EACH ttComboData:       DELETE ttComboData.       END.
END.

ASSIGN hBufferCacheBuffer   = ?
       cNumericDecimalPoint = "":U
       cNumericSeparator    = "":U
       cNumericSeparator    = "":U
       cNumericFormat       = "":U
       cAppDateFormat       = "":U.

/* Get all the required information from the Appserver */

RUN af/app/cachelogin.p ON gshAstraAppserver
                           (OUTPUT TABLE ttTranslate,
                            OUTPUT cNumericDecimalPoint,
                            OUTPUT cNumericSeparator,
                            OUTPUT cNumericFormat,
                            OUTPUT cDateFormat,
                            OUTPUT TABLE ttEntityMnemonic, /* Redundant, cachelogin.p isn't going to extract these either */
                            OUTPUT TABLE ttLoginUser,
                            OUTPUT TABLE ttGlobalControl,
                            OUTPUT TABLE ttSecurityControl,
                            OUTPUT TABLE ttComboData).

RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loginGetClassCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loginGetClassCache Procedure 
PROCEDURE loginGetClassCache :
/*------------------------------------------------------------------------------
  Purpose:     Returns cached class information (gsc_object_type) to whoever 
               requests it.
  Parameters:  <none>
  Notes:       This procedure is only going to contain cache up to the login 
               screen appearing.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hCallingProcedure AS HANDLE NO-UNDO.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loginGetMnemonicsCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loginGetMnemonicsCache Procedure 
PROCEDURE loginGetMnemonicsCache :
/*------------------------------------------------------------------------------
  Purpose:     Sends the entity_mnemonic table to whoever requests it.
  Parameters:  <none>
  Notes:       This procedure is only going to contain cache up to the login 
               screen appearing.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hCallingProcedure AS HANDLE NO-UNDO.

IF VALID-HANDLE(hCallingProcedure) 
AND LOOKUP("sendLoginCache", hCallingProcedure:INTERNAL-ENTRIES) <> 0 
THEN DO:
    /* Send the info */

    RUN sendLoginCache IN hCallingProcedure (INPUT TABLE ttEntityMnemonic).

    /* Unsubscribe from the event, it's not going to be published again */

    UNSUBSCRIBE TO "loginGetMnemonicsCache":U IN SESSION:FIRST-PROCEDURE.

    /* Clear the cached info, we don't want it hanging around in memory, we're not going to need it again */

    EMPTY TEMP-TABLE ttEntityMnemonic.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loginGetViewerCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loginGetViewerCache Procedure 
PROCEDURE loginGetViewerCache :
/*------------------------------------------------------------------------------
  Purpose:     Sends all the information required by the login screen.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hCallingProcedure AS HANDLE NO-UNDO.

IF VALID-HANDLE(hCallingProcedure) 
AND LOOKUP("sendLoginCache", hCallingProcedure:INTERNAL-ENTRIES) <> 0 
THEN DO:
    /* Send the info */

    RUN sendLoginCache IN hCallingProcedure (INPUT cNumericDecimalPoint,
                                             INPUT cNumericSeparator,
                                             INPUT cNumericFormat,
                                             INPUT cDateFormat,
                                             INPUT TABLE ttGlobalControl,
                                             INPUT TABLE ttSecurityControl,
                                             INPUT TABLE ttComboData,
                                             INPUT TABLE ttLoginUser,
                                             INPUT TABLE ttTranslate).

    /* We don't clear any cache, or unsubscribe from the event, because we may relogon, we'll want this information again then */
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notifyUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notifyUser Procedure 
PROCEDURE notifyUser :
/*------------------------------------------------------------------------------
  Purpose:     Notify a user of some message by some means, e.g. email
  Parameters:  input Object number of user record to notify
               input User name of user record to notify (used only when obj is 0)
               input Action, e.g. "email"
               input Subject of message
               input Message text
               output failed reason
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  pdUserObj                     AS DECIMAL      NO-UNDO.
DEFINE INPUT PARAMETER  pcUserName                    AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  pcAction                      AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  pcSubject                     AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  pcMessage                     AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcFailedReason                AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         cEmailAddress                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cEmailProfile                 AS CHARACTER    NO-UNDO.

IF pcAction = "email":U
THEN DO:
    IF pdUserObj = 0 AND pcUserName = "":U THEN
        /* get user email from property for current user */
        cEmailAddress = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                         INPUT "currentUserEmail":U,
                                         INPUT NO).
    ELSE DO:
        /* find user email by reading user record */
        RUN af/app/afgetuserp.p ON gshAstraAppserver (INPUT pdUserObj, INPUT pcUserName, OUTPUT TABLE ttUser).
        FIND FIRST ttUser NO-ERROR.
        IF AVAILABLE ttUser THEN ASSIGN cEmailAddress = ttUser.USER_email_address.
    END.

    IF cEmailAddress <> "":U THEN /* Send email message to user */
        RUN sendEmail IN gshSessionManager
                          ( INPUT cEmailProfile,        /* Email profile to use  */
                            INPUT cEmailAddress,        /* Comma list of Email addresses for to: box */
                            INPUT "":U,                 /* Comma list of Email addresses to cc */
                            INPUT pcSubject,            /* Subject of message */
                            INPUT pcMessage,            /* Message text */
                            INPUT "":U,                 /* Comma list of attachment filenames */
                            INPUT "":U,                 /* Comma list of attachment filenames with full path */
                            INPUT NOT SESSION:REMOTE,   /* YES = display dialog for modification before send */
                            INPUT 0,                    /* Importance 0 = low, 1 = medium, 2 = high */
                            INPUT NO,                   /* YES = return a read receipt */
                            INPUT NO,                   /* YES = return a delivery receipt */
                            INPUT "":U,                 /* Not used yet but could be used for additional settings */
                            OUTPUT pcFailedReason       /* If failed - the reason why, blank = it worked */
                          ).
    ELSE
        ASSIGN pcFailedReason = "Your e-mail address has not been set up against your user account.  Please contact your System Administrator.".
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseAppServerInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parseAppServerInfo Procedure 
PROCEDURE parseAppServerInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcAppSrvrInfo   AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcSessType      AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcNumFormat     AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcDateFormat    AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcOldSessionID  AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE cCurrAppSrv AS CHARACTER  NO-UNDO.
    ASSIGN
      pcSessType     = "":U
      pcNumFormat    = "":U
      pcDateFormat   = "":U
      pcOldSessionID = "":U.

    /* Parse out the information from AppSrvrInfo string. */
    IF LENGTH(pcAppSrvrInfo) > 2 THEN
    DO:
      /* First two characters MUST be numeric format */
      ASSIGN
        pcNumFormat  = SUBSTRING(pcAppSrvrInfo, 1, 2)
        cCurrAppSrv = SUBSTRING(pcAppSrvrInfo, 3).
  
      /* Next three characters must be date format */
      IF LENGTH(cCurrAppSrv) > 3 THEN
      DO:
        ASSIGN
          pcDateFormat = SUBSTRING(cCurrAppSrv, 1, 3)
          cCurrAppSrv = SUBSTRING(cCurrAppSrv, 4).

        /* The next entry (to the comma) is the client session type,
           and everything after the comma is the old connection id. */
        IF NUM-ENTRIES(cCurrAppSrv) >= 1 THEN
        DO:
          ASSIGN
            pcSessType    = ENTRY(1,cCurrAppSrv)
            pcOldSessionID = SUBSTRING(cCurrAppSrv, LENGTH(pcSessType) + 2).
        END.
      END.
    END.

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     Run on close of procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN glPlipShutting = YES.
  RUN deletePersistentProc.  /* delete persistent procs started since we started */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-relogon) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE relogon Procedure 
PROCEDURE relogon :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to relogon user, clear caches, etc.
  Parameters:  <none>
  Notes:       If user cancels from login window, then nothing is done.
               If the user presses ok, then details are reset and caches cleared,
               even if the user informationwas the same - this is so that we have
               a facility to clear caches on the fly without exiting the session.
               The user details are reset.
               Status bar information is updated.
               The translations are cleared and re-cached for the new language.
               The cached user profile data for the previous user is flushed to the
               database, and the cache rebuilt for the new user.
               The security cache is cleared
               The repository cache is cleared
------------------------------------------------------------------------------*/

DEFINE VARIABLE cLoginWindow              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dCurrentUserObj           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cCurrentUserLogin         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentUserName          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentUserEmail         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dCurrentOrganisationObj   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cCurrentOrganisationCode  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentOrganisationName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentOrganisationShort AS CHARACTER  NO-UNDO.
DEFINE VARIABLE tCurrentProcessDate       AS DATE       NO-UNDO.
DEFINE VARIABLE dCurrentLanguageObj       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cCurrentLanguageName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentLoginValues       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPropertyList             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValueList                AS CHARACTER  NO-UNDO.

/* 1st get login window in user */
cLoginWindow = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                   INPUT "loginWindow":U,
                                                   INPUT NO).
IF cLoginWindow = "":U THEN RETURN.

RUN VALUE(cLoginWindow)  (INPUT  "Two":U,                       /* Re-login */
                          OUTPUT dCurrentUserObj,
                          OUTPUT cCurrentUserLogin,
                          OUTPUT cCurrentUserName,
                          OUTPUT cCurrentUserEmail,
                          OUTPUT dCurrentOrganisationObj,
                          OUTPUT cCurrentOrganisationCode,
                          OUTPUT cCurrentOrganisationName,
                          OUTPUT cCurrentOrganisationShort,
                          OUTPUT tCurrentProcessDate,
                          OUTPUT dCurrentLanguageObj,
                          OUTPUT cCurrentLanguageName,
                          OUTPUT cCurrentLoginValues).

IF dCurrentUserObj = 0 THEN RETURN.

SESSION:SET-WAIT-STATE('general').

/* 1st flush old user profile cache to db */
RUN updateCacheToDb IN gshProfileManager (INPUT "":U).

/* Re-logged in, so reset details */
IF tCurrentProcessDate = ? THEN ASSIGN tCurrentProcessDate = TODAY.
DEFINE VARIABLE cDateFormat AS CHARACTER NO-UNDO.
cDateFormat = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                   INPUT "dateFormat":U,
                                                   INPUT NO).
ASSIGN
  cPropertyList = "CurrentUserObj,CurrentUserLogin,CurrentUserName,CurrentUserEmail,CurrentOrganisationObj,CurrentOrganisationCode,CurrentOrganisationName,CurrentOrganisationShort,CurrentLanguageObj,CurrentLanguageName,CurrentProcessDate,CurrentLoginValues,DateFormat,LoginWindow":U
  cValueList = STRING(dCurrentUserObj) + CHR(3) +
               cCurrentUserLogin + CHR(3) +
               cCurrentUserName + CHR(3) +
               cCurrentUserEmail + CHR(3) +
               STRING(dCurrentOrganisationObj) + CHR(3) +
               cCurrentOrganisationCode + CHR(3) +
               cCurrentOrganisationName + CHR(3) +
               cCurrentOrganisationShort + CHR(3) +
               STRING(dCurrentLanguageObj) + CHR(3) +
               cCurrentLanguageName + CHR(3) +
               STRING(tCurrentProcessDate,cDateFormat) + CHR(3) +
               cCurrentLoginValues + CHR(3) +
               cDateFormat + CHR(3) +
               cLoginWindow
  .

DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                     INPUT cPropertyList,
                                     INPUT cValueList,
                                     INPUT NO).

/* reset status bars */
PUBLISH 'ClientCachedDataChanged' FROM gshSessionManager.

/* clear caches */
DEFINE VARIABLE cCacheTranslations            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lCacheTranslations            AS LOGICAL    INITIAL YES NO-UNDO.
cCacheTranslations = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                 INPUT "cachedTranslationsOnly":U,
                                 INPUT NO).
lCacheTranslations = cCacheTranslations <> "NO":U NO-ERROR.

/* if caching translations - do so for logged into language */
RUN clearClientCache IN gshTranslationManager.
IF lCacheTranslations THEN
DO:
  RUN buildClientCache IN gshTranslationManager (INPUT dCurrentLanguageObj).
END.

/* Rebuild user profile data */
RUN clearClientCache IN gshProfileManager.
RUN buildClientCache IN gshProfileManager (INPUT "":U). /* load temp-table on client */

/* Clear security manager cache */
RUN clearClientCache IN gshSecurityManager.

/* Clear repository cache */
RUN clearClientCache IN gshRepositoryManager.

SESSION:SET-WAIT-STATE('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeLookupFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeLookupFrame Procedure 
PROCEDURE resizeLookupFrame :
/*------------------------------------------------------------------------------
  Purpose:     To resize lookup SDF frame to fit new labels 
  Parameters:  input object handle
               input SDF frame handle
               input number to add to all columns
  Notes:       called from translatewidgets from widgetwalk procedure
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phFrame            AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pdAddCol           AS DECIMAL    NO-UNDO.

DEFINE VARIABLE cAllFieldHandles          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hParent                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainer                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hViewer                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSideLabel                AS HANDLE     NO-UNDO.

hViewer = DYNAMIC-FUNCTION("getcontainersource":U IN phObject) NO-ERROR.
IF VALID-HANDLE(hViewer) AND 
   LOOKUP("resizeWindow":U, hViewer:INTERNAL-ENTRIES) = 0 THEN
  hContainer = DYNAMIC-FUNCTION("getcontainersource":U IN hViewer) NO-ERROR.

hWindow = phFrame:WINDOW.
hParent = DYNAMIC-FUNCTION("getcontainerhandle":U IN hViewer) NO-ERROR.
IF hParent:TYPE = "window":U THEN
  hParent = hParent:FIRST-CHILD.

/* 1st make frame virtually big to avoid size issues */
hParent:SCROLLABLE = TRUE.
phFrame:SCROLLABLE = TRUE.
hWindow:VIRTUAL-WIDTH-CHARS  = 204.80.
hWindow:VIRTUAL-HEIGHT-CHARS = 35.67.
phFrame:VIRTUAL-WIDTH-CHARS  = 204.80.
phFrame:VIRTUAL-HEIGHT-CHARS = 35.67.
hParent:VIRTUAL-WIDTH-CHARS  = 204.80.
hParent:VIRTUAL-HEIGHT-CHARS = 35.67.

/* move frame back if we can */
IF phFrame:COLUMN - pdAddCol > 1 THEN
  ASSIGN phFrame:COLUMN = phFrame:COLUMN - pdAddCol.
ELSE
  ASSIGN phFrame:COLUMN = 1.

/* resize window if too small to fit frame (plus a bit for margin) */
IF (phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol) > (hWindow:WIDTH-CHARS - 10) THEN
DO:
  hWindow:WIDTH-CHARS = phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol + 10.
  hWindow:MIN-WIDTH-CHARS = phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol + 10.

  IF VALID-HANDLE(hContainer) AND LOOKUP("resizeWindow":U, hContainer:INTERNAL-ENTRIES) <> 0 THEN
  DO:
    APPLY "window-resized":u TO hWindow.
    RUN resizeWindow IN hContainer.
  END.
END.

/* resize parent frame if too small to fit new SDF frame */
IF (phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol) > (hParent:WIDTH-CHARS) THEN
DO:
  hParent:WIDTH-CHARS = phFrame:COLUMN + phFrame:WIDTH-CHARS + pdAddCol + 1.
END.

/* resize frame to fit new labels */
phFrame:WIDTH-CHARS = phFrame:WIDTH-CHARS + pdAddCol.

/* always ensure min window size set correctly - even if not resized */
IF (hWindow:MIN-WIDTH-CHARS - 10) < (phFrame:WIDTH-CHARS + phFrame:COLUMN) THEN
  ASSIGN hWindow:MIN-WIDTH-CHARS = phFrame:WIDTH-CHARS + phFrame:COLUMN + 10.

cAllFieldHandles = DYNAMIC-FUNCTION("getAllFieldHandles":U IN phObject) NO-ERROR.

IF cAllFieldHandles = "":U OR cAllFieldHandles = ? THEN RETURN.

field-loop:
DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):

  ASSIGN 
    hWidget = WIDGET-HANDLE(ENTRY(iLoop, cAllFieldHandles)).
  IF NOT VALID-HANDLE(hWidget) OR
     LOOKUP(hWidget:TYPE, "text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) = 0
     OR NOT CAN-QUERY(hWidget, "column":U) THEN NEXT field-loop.

  /* got a valid widget to move */
  ASSIGN hSideLabel = DYNAMIC-FUNCTION("getfieldlabel":U IN phObject).   

  hWidget:COLUMN = hWidget:COLUMN + pdAddCol.

  IF VALID-HANDLE(hSideLabel) THEN
    hSideLabel:COLUMN = hSideLabel:COLUMN + pdAddCol.
END.

hWindow:VIRTUAL-WIDTH-CHARS  = hWindow:WIDTH-CHARS.
hWindow:VIRTUAL-HEIGHT-CHARS = hWindow:HEIGHT-CHARS.
phFrame:VIRTUAL-WIDTH-CHARS  = phFrame:WIDTH-CHARS.
phFrame:VIRTUAL-HEIGHT-CHARS = phFrame:HEIGHT-CHARS.
phFrame:SCROLLABLE = FALSE.
hParent:VIRTUAL-WIDTH-CHARS  = hParent:WIDTH-CHARS.
hParent:VIRTUAL-HEIGHT-CHARS = hParent:HEIGHT-CHARS.
hParent:SCROLLABLE = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeNormalFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeNormalFrame Procedure 
PROCEDURE resizeNormalFrame :
/*------------------------------------------------------------------------------
  Purpose:     To resize standard frame to fit new labels (not an SDF frame)
  Parameters:  input object handle
               input frame handle
               input number to add to all columns
  Notes:       called from translatewidgets from widgetwalk procedure.  This procedure
               will move all the widgets on the frame as well.  So if you want to 
               resize the frame, but keep the widgets where they are, don't use it.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phFrame            AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pdAddCol           AS DECIMAL    NO-UNDO.

DEFINE VARIABLE cAllFieldHandles          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hWindow                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainer                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidget                   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSideLabel                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPopupHandle              AS HANDLE     NO-UNDO.

hContainer = DYNAMIC-FUNCTION("getcontainersource":U IN phObject) NO-ERROR.
IF VALID-HANDLE(hContainer) AND 
   LOOKUP("resizeWindow":U, hContainer:INTERNAL-ENTRIES) = 0 THEN
  hContainer = DYNAMIC-FUNCTION("getcontainersource":U IN hContainer) NO-ERROR.

hWindow = phFrame:WINDOW.

/* 1st make frame virtually big to avoid size issues */
phFrame:SCROLLABLE = TRUE.
hWindow:VIRTUAL-WIDTH-CHARS  = 204.80.
hWindow:VIRTUAL-HEIGHT-CHARS = 35.67.
phFrame:VIRTUAL-WIDTH-CHARS  = 204.80.
phFrame:VIRTUAL-HEIGHT-CHARS = 35.67.

/* resize window if too small to fit new frame (plus a bit for margin) */
IF (phFrame:WIDTH-CHARS + pdAddCol) > (hWindow:WIDTH-CHARS - 10) THEN
DO:
  hWindow:WIDTH-CHARS = phFrame:WIDTH-CHARS + pdAddCol + 10.
  hWindow:MIN-WIDTH-CHARS = phFrame:WIDTH-CHARS + pdAddCol + 10.

  IF VALID-HANDLE(hContainer) AND LOOKUP("resizeWindow":U, hContainer:INTERNAL-ENTRIES) <> 0 THEN
  DO:
    APPLY "window-resized":u TO hWindow.
    RUN resizeWindow IN hContainer.
  END.
END.

/* resize frame to fit new labels */
phFrame:WIDTH-CHARS = phFrame:WIDTH-CHARS + pdAddCol.

/* always ensure min window size set correctly - even if not resized */
IF (hWindow:MIN-WIDTH-CHARS - 10) < phFrame:WIDTH-CHARS THEN
  ASSIGN hWindow:MIN-WIDTH-CHARS = phFrame:WIDTH-CHARS + 10.

cAllFieldHandles = DYNAMIC-FUNCTION("getAllFieldHandles":U IN phObject) NO-ERROR.

IF cAllFieldHandles = "":U OR cAllFieldHandles = ? THEN RETURN.

field-loop:
DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):

  ASSIGN hWidget = WIDGET-HANDLE(ENTRY(iLoop, cAllFieldHandles)) NO-ERROR.

  IF NOT VALID-HANDLE(hWidget) THEN
      NEXT field-loop.

  /* SDFs need to be resized individually */

  IF hWidget:TYPE = "PROCEDURE":U 
  THEN DO:
      /* I'm not aware of an easy way to get the SDF frame handle.  So get the field handle, and then derive the frame handle from that */

      DEFINE VARIABLE hSDFFrame AS HANDLE     NO-UNDO.
      
      IF LOOKUP("getComboHandle":U, hWidget:INTERNAL-ENTRIES) <> 0 THEN
          {get ComboHandle hSDFFrame hWidget}.
      ELSE
          IF LOOKUP("getLookupHandle":U, hWidget:INTERNAL-ENTRIES) <> 0 THEN
              {get LookupHandle hSDFFrame hWidget}.

      IF VALID-HANDLE(hSDFFrame) 
      THEN DO:
          ASSIGN hSDFFrame = hSDFFrame:PARENT  /* Get the field FIELD-GROUP            */
                 hSDFFrame = hSDFFrame:PARENT. /* The FIELD-GROUPs parent is the frame */

          RUN resizeSDFFrame (INPUT hWidget,   /* The SDF procedure handle */
                              INPUT hSDFFrame, /* The SDF frame */
                              INPUT pdAddCol). /* The amount it needs to move */
          NEXT field-loop.
      END.
  END.

  IF LOOKUP(hWidget:TYPE, "text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) = 0
  OR NOT CAN-QUERY(hWidget, "column":U) THEN 
      NEXT field-loop.

  /* got a valid widget to move */
  ASSIGN hSideLabel = ?.
  ASSIGN hSideLabel = hWidget:SIDE-LABEL-HANDLE NO-ERROR.

  hWidget:COLUMN = hWidget:COLUMN + pdAddCol.

  /* If the label has been created as a separate widget (like the dynamic
   * viewer does), then ignore the moving of the label. This will be done
   * as if it were a normal text widget.                                  
   *
   * We still need to cater for static fill-ins. These also have a side
   * label handle, but they differ from dynamic fill-ins in that these labels
    have a widget type of LITERAL, as opposed to TEXT.                       */
  IF VALID-HANDLE(hSideLabel) AND
     ( LOOKUP(STRING(hSideLabel), cAllFieldHandles) EQ 0 OR
       hSideLabel:TYPE                              EQ "LITERAL":U ) THEN
    hSideLabel:COLUMN = hSideLabel:COLUMN + pdAddCol.

  /* And finally, check if the widget has a popup button (calendar or calculator). *
   * If it does, move the popup as well.                                           */
  IF LOOKUP("PopupHandle":U, hWidget:PRIVATE-DATA) <> 0 
  THEN DO:
      ASSIGN hPopupHandle = WIDGET-HANDLE(ENTRY(LOOKUP("PopupHandle":U, hWidget:PRIVATE-DATA) + 1, hWidget:PRIVATE-DATA)) NO-ERROR.
      IF VALID-HANDLE(hPopupHandle) THEN
          ASSIGN hPopupHandle:COLUMN = hPopupHandle:COLUMN + pdAddCol.
  END.
END.

hWindow:VIRTUAL-WIDTH-CHARS  = hWindow:WIDTH-CHARS.
hWindow:VIRTUAL-HEIGHT-CHARS = hWindow:HEIGHT-CHARS.
phFrame:VIRTUAL-WIDTH-CHARS  = phFrame:WIDTH-CHARS.
phFrame:VIRTUAL-HEIGHT-CHARS = phFrame:HEIGHT-CHARS.
phFrame:SCROLLABLE = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeSDFFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeSDFFrame Procedure 
PROCEDURE resizeSDFFrame :
/*------------------------------------------------------------------------------
  Purpose:     To resize SDF frame to fit new labels 
  Parameters:  input object handle
               input SDF frame handle
               input number to add to all columns
  Notes:       called from translatewidgets from widgetwalk procedure
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phFrame            AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER pdAddCol           AS DECIMAL    NO-UNDO.

DEFINE VARIABLE hParentFrame AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWindow      AS HANDLE     NO-UNDO.

/* We're going to move the frame in line with the other widgets */

ASSIGN hParentFrame = phFrame:PARENT      /* Field group */
       hParentFrame = hParentFrame:PARENT /* Frame */
       NO-ERROR.

IF VALID-HANDLE(hParentFrame)
AND hParentFrame:TYPE = "FRAME":U THEN
    IF (phFrame:COLUMN + phFrame:WIDTH + pdAddCol) <= hParentFrame:WIDTH THEN
        ASSIGN phFrame:COLUMN = phFrame:COLUMN + pdAddCol.
    ELSE
        RUN resizeLookupFrame (INPUT phObject, /* This proc will work for combos and lookups */
                               INPUT phFrame,
                               INPUT pdAddCol).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-runLookup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runLookup Procedure 
PROCEDURE runLookup :
/*------------------------------------------------------------------------------
  Purpose:     Launch a lookup window for a widget
  Parameters:  handle of focused widget
  Notes:       If the data type is a date then a pop-up calendar is displayed.
               If the data type is a integer or decimal then a pop-up calculator
               is displayed.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER phFocus      AS HANDLE                       NO-UNDO.

    DEFINE VARIABLE cOldValue       AS CHARACTER                        NO-UNDO.

    IF CAN-QUERY(phFocus,"data-type":U) AND
       CAN-QUERY(phFocus,"sensitive":U) AND phFocus:SENSITIVE = TRUE THEN
    DO:
        APPLY "ENTRY":U TO phFocus.
        ASSIGN cOldValue = phFocus:SCREEN-VALUE.

        CASE phFocus:DATA-TYPE:
            WHEN "date":U THEN
            DO:
                ASSIGN gcLogicalContainerName = "afcalnpopd":U.
                RUN af/cod2/afcalnpopd.w (INPUT phFocus).
            END.    /* date*/
            WHEN "decimal":U OR WHEN "integer":U THEN
            DO:
                ASSIGN gcLogicalContainerName = "afcalcpopd":U.
                RUN af/cod2/afcalcpopd.w (INPUT phFocus).
            END.    /* decimal/integer */
        END CASE.   /* datatype */

        ASSIGN gcLogicalContainerName = "":U.

        IF cOldValue <> phFocus:SCREEN-VALUE THEN
            APPLY "value-changed":U TO phFocus.
    END.    /* is sensitive and has a data-type */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* runLookup */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-seedTempUniqueID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE seedTempUniqueID Procedure 
PROCEDURE seedTempUniqueID :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED(server-side) <> 0 &THEN
   DEFINE VARIABLE iSessNo AS INTEGER    NO-UNDO.
   DEFINE VARIABLE iSiteRev AS INTEGER    NO-UNDO.
   DEFINE VARIABLE iSiteDiv AS INTEGER    NO-UNDO.
   ASSIGN
     iSiteRev = CURRENT-VALUE(seq_site_reverse,ICFDB)
     iSiteRev = (IF iSiteRev = ? THEN 0 ELSE iSiteRev)
     iSiteDiv = CURRENT-VALUE(seq_site_division,ICFDB)
     iSiteDiv = (IF iSiteDiv < 1 THEN 1 ELSE iSiteDiv)
     gsdTempUniqueID = (NEXT-VALUE(seq_session_id,ICFDB) * 10000000000000000000000000000.0)
                     + (iSiteRev / iSiteDiv)

   .
&ELSE
   gsdTempUniqueID = 90000000000000000000000000000000000000000.0.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendEmail) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendEmail Procedure 
PROCEDURE sendEmail :
/*------------------------------------------------------------------------------
  Purpose:     Send an email message. This is similar to notifyUser but is
               far more flexible and has many additional options specific to 
               sending an email message.
  Parameters:  input Mail profile to use e.g. Microsoft Outlook
               input Comma list of Email addresses for to: box
               input Comma list of Email addresses to cc
               input Subject of message
               input Message text
               input Comma list of attachment filenames 
               input Comma list of attachment filenames with full path
               input YES = display dialog for modification before send
               input 0 = low, 1 = medium, 2 = high
               input YES = return a read receipt
               input YES = return a delivery receipt
               input Not used yet but could be used for additional settings
               output If failed - the reason why, blank = it worked
  Notes:       Most of the above fields are optional and will simply be left blank
               as appropriate.
               Multiple file attachments can be sent using comma delimited lists.
               If the display dialog is set to NO then no user intervention will 
               be required and the message will be sent immediately.
               Because this routine uses MAPI for client email, it will work with whatever
               email is installed on the client PC sending the email.
               On the server it uses sendmail and not all options are supported.
               The extra options parameter could contain a comma list of other 
               settings as required, e.g. setting, value, setting, value, etc.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  cEmailProfile                   AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cToEmail                        AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cCcEmail                        AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cSubject                        AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cMessage                        AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cAttachmentName                 AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  cAttachmentFPath                AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  lDisplayDialog                  AS LOGICAL      NO-UNDO.
DEFINE INPUT PARAMETER  iImportance                     AS INTEGER      NO-UNDO.
DEFINE INPUT PARAMETER  lReadReceipt                    AS LOGICAL      NO-UNDO.
DEFINE INPUT PARAMETER  lDeliveryReceipt                AS LOGICAL      NO-UNDO.
DEFINE INPUT PARAMETER  cOptions                        AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER cFailedReason                   AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         cFromEmail                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cUserLogin                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cUnixToDosFile                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cAttachmentLabel                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cMessageFile                    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         chSession                       AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE         chMessage                       AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE         chRecipient1                    AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE         chRecipient2                    AS COM-HANDLE   NO-UNDO.
DEFINE VARIABLE         chAttachment                    AS COM-HANDLE   NO-UNDO.

DEFINE VARIABLE         lOk                             AS LOGICAL      NO-UNDO.
DEFINE VARIABLE         iLoop                           AS INTEGER      NO-UNDO.

IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO: /* on server so use sendmail */

  /* get current user email from property for current user */
  cFromEmail = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                INPUT "currentUserEmail":U,
                                INPUT NO).
  cUserLogin = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                INPUT "currentUserLogin":U,
                                INPUT NO).

  ASSIGN cAttachmentLabel = REPLACE(cAttachmentName," ","_").

  ASSIGN
    cMessageFile = "/tmp/":U + REPLACE(cUserLogin," ":U,"_":U) +
                   STRING(ETIME) + ".txt":U.


  IF cFromEmail = "":U THEN ASSIGN cFromEmail = "mip@mip-holdings.com".

  OUTPUT TO VALUE(cMessageFile).
  PUT UNFORMATTED cMessage SKIP.
  OUTPUT CLOSE.

  UNIX SILENT VALUE('af/app/afsendmail.dat ' + '"' + cToEmail              + '" ' +
                                               '"' + cFromEmail            + '" ' +
                                               '"' + cCcEmail              + '" ' +
                                               '"' + cSubject              + '" ' +
                                               '"' + cMessageFile          + '" ' +
                                               '"' + cAttachmentFPath      + '" ' +
                                               '"' + cAttachmentLabel      + '"').
END.
ELSE
DO: /* On client so use MAPI */

  /* Before we start, get the current application directory and store it. We need to do this because *
   * MAPI changes it.  NASTY...                                                                      */
  &IF OPSYS = "WIN32" &THEN /* Probably the whole ELSE DO needs this check, will leave as is for now */
      DEFINE VARIABLE cCurrentAppDir AS CHARACTER  NO-UNDO.
      DEFINE VARIABLE iBufferSize    AS INTEGER    NO-UNDO INITIAL 256.
      DEFINE VARIABLE iResult        AS INTEGER    NO-UNDO.
      DEFINE VARIABLE mString        AS MEMPTR     NO-UNDO.
    
      SET-SIZE(mString) = 256.    
      RUN GetCurrentDirectoryA (INPUT iBufferSize,
                                INPUT-OUTPUT mString,
                                OUTPUT iResult).
      ASSIGN cCurrentAppDir = GET-STRING(mString,1).
      SET-SIZE(mString) = 0.
  &ENDIF

  /* Create MAPI Session */
  CREATE "MAPI.session" chSession NO-ERROR.
  IF NOT VALID-HANDLE (chSession) THEN
    DO:
      ASSIGN cFailedReason = "Could not create MAPI Session".
      RETURN.
    END.

  /* Logon to MAPI Session */
  chSession:logon (cEmailProfile, No, Yes, 0). 

  /* Create a new message in the outbox */ 
  chMessage = chSession:outbox:messages:ADD NO-ERROR.
  IF NOT VALID-HANDLE (chMessage) THEN
    DO:
      ASSIGN cFailedReason = "Could not create mail message in outbox".
      chSession:Logoff().      
      RELEASE OBJECT chSession.
      chSession = ?.
      RETURN.
    END.

  /* Set up email defaults */
  chMessage:Subject = cSubject.
  chMessage:Type = "IPM.Note".
  chMessage:Text = cMessage.
  chMessage:Importance = iImportance.
  chMessage:DeliveryReceipt = lDeliveryReceipt.
  chMessage:ReadReceipt = lReadReceipt.

  /* Set-up recipients */
  IF cToEmail <> "":U THEN
    DO:
      chRecipient1 = chMessage:Recipients:Add.
      chRecipient1:Name = cToEmail.
      chRecipient1:Type = 1.
      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
          chRecipient1:Resolve (YES) NO-ERROR.    /* Show dialog */
      ELSE
          chRecipient1:Resolve (NO) NO-ERROR.     /* Supress Dialog */
    END.
  IF cCcEmail <> "":U THEN
    DO:
      chRecipient2 = chMessage:Recipients:Add.
      chRecipient2:Name = cCcEmail.
      chRecipient2:Type = 2.
      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
          chRecipient2:Resolve (YES) NO-ERROR.    /* Show dialog */
      ELSE
          chRecipient2:Resolve (NO) NO-ERROR.     /* Supress Dialog */
    END.

  /* Add attachments if any */
  DO iLoop = 1 TO NUM-ENTRIES(cAttachmentName):
      chAttachment = chMessage:Attachments:Add.
      chAttachment:Name = ENTRY(iLoop, cAttachmentName).
      chAttachment:Type = 1.
      chAttachment:Source = ENTRY(iLoop, cAttachmentFPath).
      chAttachment:ReadFromFile (ENTRY(iLoop, cAttachmentFPath)).
      RELEASE OBJECT chAttachment NO-ERROR.
  END.

  /* Save the message */
  chMessage:Update.

  /* Check resolution of recipients */
  lOk = chMessage:Recipients:Resolved.

  IF lOk OR (cToEmail = "":U AND cCcEmail = "":U) THEN
     chMessage:Send (yes, lDisplayDialog, 0) NO-ERROR.
  ELSE
     ASSIGN cFailedReason = "Mail not sent - address not resolved for " + cToEmail + " or " + cCcEmail.

  chSession:Logoff().      

  RELEASE OBJECT chAttachment NO-ERROR.
  RELEASE OBJECT chRecipient1 NO-ERROR.
  RELEASE OBJECT chRecipient2 NO-ERROR.
/*RELEASE OBJECT chMessage NO-ERROR. - causes GPF */
  RELEASE OBJECT chSession.

  ASSIGN chAttachment = ?
         chRecipient1 = ?
         chRecipient2 = ?
         chMessage    = ?
         chSession    = ?.

  /* Make sure the application directory is set correctly */
  &IF OPSYS = "WIN32" &THEN
      RUN SetCurrentDirectoryA (INPUT cCurrentAppDir, OUTPUT iResult).
  &ENDIF
END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setActionUnderway) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setActionUnderway Procedure 
PROCEDURE setActionUnderway :
/*------------------------------------------------------------------------------
  Purpose:     Set the ttActionUnderway values for the passed in records
  Parameters:  see below
  Notes:       ttActionUnderway
               ttActionUnderway.action_underway_origin - SCM or DYN
               ttActionUnderway.action_table_fla
               ttActionUnderway.action_type - ASS, DEL, MOV, ADD
               ttActionUnderway.action_primary_key
               ttActionUnderway.action_scm_object_name
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcActionUnderwayOrigin   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionType             AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionScmObjectName    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionTablePrimaryFla  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcActionPrimaryKeyValues AS CHARACTER  NO-UNDO.

  IF CAN-FIND(FIRST ttActionUnderway 
              WHERE ttActionUnderway.action_underway_origin <> pcActionUnderwayOrigin)
  THEN RETURN.

  FIND FIRST ttActionUnderway NO-LOCK
    WHERE ttActionUnderway.action_underway_origin  = pcActionUnderwayOrigin
    AND   ttActionUnderway.action_type             = pcActionType
    AND   ttActionUnderway.action_scm_object_name  = pcActionScmObjectName
    AND   ttActionUnderway.action_table_fla        = pcActionTablePrimaryFla
    NO-ERROR.
  IF NOT AVAILABLE ttActionUnderway
  THEN DO:
    CREATE ttActionUnderway.
    ASSIGN
      ttActionUnderway.action_underway_origin  = pcActionUnderwayOrigin
      ttActionUnderway.action_type             = pcActionType
      ttActionUnderway.action_scm_object_name  = pcActionScmObjectName
      ttActionUnderway.action_table_fla        = pcActionTablePrimaryFla
      ttActionUnderway.action_primary_key      = pcActionPrimaryKeyValues
      .
  END.
  RELEASE ttActionUnderway.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAttributesInObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAttributesInObject Procedure 
PROCEDURE setAttributesInObject :
/*------------------------------------------------------------------------------
  Purpose:     Set Instance attributes in an object
  Parameters:  input handle of object
               input instance attribute list
  Notes:       Run from launch container to pass on instance attributes into
               an object.
               The list is in the same format as returned to the function 
               instancePropertyList, with CHR(3) between entries and CHR(4) 
               between the property name and its value in each entry. 
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER phObject     AS HANDLE.
DEFINE INPUT PARAMETER pcPropList   AS CHARACTER.

DEFINE VARIABLE iEntry AS INTEGER NO-UNDO.
DEFINE VARIABLE cEntry AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProperty AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSignature AS CHARACTER NO-UNDO.

/* Set any Instance Properties specified. The list is in the same format
     as returned to the function instancePropertyList, with CHR(3) between
     entries and CHR(4) between the property name and its value in each entry. 
     NOTE: we must get the datatype for each property in order to set it. */

  DO iEntry = 1 TO NUM-ENTRIES(pcPropList, CHR(3)):
    cEntry = ENTRY(iEntry, pcPropList, CHR(3)).
    cProperty = ENTRY(1, cEntry, CHR(4)).
    cValue = ENTRY(2, cEntry, CHR(4)).
    /* Get the datatype from the return type of the get function. */
    cSignature = dynamic-function
      ("Signature":U IN phObject, "get":U + cProperty).

  /** The message code removed to avoid issues with attributes being set in an
   *  object which are not available as properties in the object. This becomes
   *  as issue as more objects become dynamic (eg viewers, lookups, etc); attributes
   *  such as HEIGHT-CHARS are necessary for the instantiation of the object, but 
   *  are not strictly properties of the object.                                  */
    IF cSignature NE "":U THEN
    CASE ENTRY(2,cSignature):
      WHEN "INTEGER":U THEN
        dynamic-function("set":U + cProperty IN phObject, INT(cValue)) NO-ERROR.
      WHEN "DECIMAL":U THEN
        dynamic-function("set":U + cProperty IN phObject, DEC(cValue)) NO-ERROR.
      WHEN "CHARACTER":U THEN
        dynamic-function("set":U + cProperty IN phObject, cValue) NO-ERROR.
      WHEN "LOGICAL":U THEN
        dynamic-function("set":U + cProperty IN phObject,
          IF cValue = "yes":U THEN yes ELSE no) NO-ERROR.
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setReturnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setReturnValue Procedure 
PROCEDURE setReturnValue :
/*------------------------------------------------------------------------------
  Purpose:     Return whatever was sent in to set the required RETURN-VALUE
  Parameters:  INPUT PARAMETER pcReturnValue - Required return value
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcReturnValue    AS CHARACTER  NO-UNDO.

  RETURN pcReturnValue.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showMessages Procedure 
PROCEDURE showMessages :
/*------------------------------------------------------------------------------
  Purpose: This procedure is the central procedure for the display of all message
           types including Message (MES), Information (INF), Warnings (WAR), 
           Errors (ERR), Serious Halt Errors (HAL), About Window (ABO).
           Any button combination is supported.
           The default message type is "ERR", the default button list is "OK",
           the default label to return is OK if OK exists, otherwise the default
           is the first button in the list, the default cancel button is also OK
           or the 1st entry in the button list, and the default title depends on
           the message type.
           If running server side the messages cannot be displayed and will only be
           able to write to the message log. Also, server side there is no user
           interface, so the default button label will always be returned. 
           Client side the messages will be displayed in a dialog window.
           The procedure checks the property "suppressDisplay" in the Session Manager
           and if set to YES, will not display the message but will simply pass the
           message to the log as would be the case for a server side message. 
           This is useful when running take-on procedures client side.
           The messages will be passed to a procedure on Appserver for interpretation
           called af/app/afmessagep.p. This procedure will format the messages
           appropriately, read text from the ICF message file where appropriate,
           interpret the carrot delimited lists that come back from triggers, deal
           with ADM2 CHR(4) delimited messages, etc. to end up with actual formatted
           messages (translated if required).
           Once the messages have been formatted, if on the client, the message will
           be displayed using the standard ICF message dialog af/cod2/afmessaged.w
           which is an enhanced dialog that contains an email button, etc.
           This dialog window is also used by askQuestion.
           If server side, or the error log flag was returned as YES, or message display
           supression is enabled, the ICF error log will be updated with the error and
           an email will be sent to the currently logged in user notifying them of the
           error (if possible).

    Notes: Returns untranslated button text of button pressed if client side,
           else default button if server side. 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcMessageList   AS CHARACTER.
  DEFINE INPUT  PARAMETER pcMessageType   AS CHARACTER.
  DEFINE INPUT  PARAMETER pcButtonList    AS CHARACTER.
  DEFINE INPUT  PARAMETER pcDefaultButton AS CHARACTER.
  DEFINE INPUT  PARAMETER pcCancelButton  AS CHARACTER.
  DEFINE INPUT  PARAMETER pcMessageTitle  AS CHARACTER.
  DEFINE INPUT  PARAMETER plDisplayEmpty  AS LOGICAL.
  DEFINE INPUT  PARAMETER phContainer     AS HANDLE.
  DEFINE OUTPUT PARAMETER pcButtonPressed AS CHARACTER.    

  DEFINE VARIABLE cSummaryMessages                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullMessages                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonList                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageTitle                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdateErrorLog                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iButtonPressed                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cAnswer                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFailed                         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuppressDisplay                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSuppressDisplay                AS CHARACTER  NO-UNDO.

  /* Set up defaults for values not passed in */
  IF NOT CAN-DO("MES,INF,WAR,ERR,HAL,ABO":U,pcMessageType) THEN
    ASSIGN pcMessageType = "ERR":U.
  IF pcButtonList = "":U THEN ASSIGN pcButtonList = "OK":U.
  IF pcDefaultButton = "":U OR LOOKUP(pcDefaultButton,pcButtonList) = 0 THEN
  DO:
    IF LOOKUP("OK":U,pcButtonList) > 0 THEN
      ASSIGN pcDefaultButton = "OK":U.
    ELSE
      ASSIGN pcDefaultButton = ENTRY(1,pcButtonList).
  END.
  IF pcCancelButton = "":U OR LOOKUP(pcCancelButton,pcButtonList) = 0 THEN
  DO:
    IF LOOKUP("OK":U,pcButtonList) > 0 THEN
      ASSIGN pcCancelButton = "OK":U.
    ELSE
      ASSIGN pcCancelButton = ENTRY(1,pcButtonList).
  END.
  IF pcMessageTitle = "":U THEN
  CASE pcMessageType:
    WHEN "MES":U THEN
      ASSIGN pcMessageTitle = "Message":U. 
    WHEN "INF":U THEN
      ASSIGN pcMessageTitle = "Information":U.
    WHEN "WAR":U THEN
      ASSIGN pcMessageTitle = "Warning":U. 
    WHEN "ERR":U THEN
      ASSIGN pcMessageTitle = "Error":U.
    WHEN "HAL":U THEN
      ASSIGN pcMessageTitle = "Halt Condition":U.
    WHEN "ABO":U THEN
      ASSIGN pcMessageTitle = "About Application":U.
  END CASE.
  IF plDisplayEmpty = ? THEN ASSIGN plDisplayEmpty = YES.

  /* Next interpret / translate the messages */
  &IF DEFINED(server-side) <> 0 &THEN
  DO:
      RUN afmessagep (INPUT pcMessageList,
                      INPUT pcButtonList,
                      INPUT pcMessageTitle,
                      OUTPUT cSummaryMessages,
                      OUTPUT cFullMessages,
                      OUTPUT cButtonList,
                      OUTPUT cMessageTitle,
                      OUTPUT lUpdateErrorLog,
                      OUTPUT lSuppressDisplay).  
  END.
  &ELSE
  DO:
      /* Build the list of connected databases.  We're going to need this info in our Appserver call */

      DEFINE VARIABLE cDBList AS CHARACTER  NO-UNDO.
      DEFINE VARIABLE iLoop   AS INTEGER    NO-UNDO.

      ASSIGN cDBList = "":U.
      DO iLoop = 1 TO NUM-DBS:
          ASSIGN cDBList = cDBList + (IF cDBList <> "":U THEN ",":U ELSE "":U) + LDBNAME(iLoop).
      END.

      /* We're going to store the information returned on the ttMessageCache temp-table.  We can then get the handle to the *
       * temp-table using API getMessageCacheHandle and retrieve whatever we need from there.                             */

      IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttMessageCache. ELSE FOR EACH ttMessageCache: DELETE ttMessageCache. END.

      CREATE ttMessageCache.
      RUN af/app/cachemssgp.p ON gshAstraAppserver 
               (INPUT pcMessageList,
                INPUT pcButtonList,
                INPUT pcMessageTitle,                
                INPUT cDBList,                
                OUTPUT cSummaryMessages,
                OUTPUT cFullMessages,
                OUTPUT cButtonList,
                OUTPUT cMessageTitle,
                OUTPUT lUpdateErrorLog,
                OUTPUT lSuppressDisplay,
                OUTPUT ttMessageCache.cDBVersions,
                OUTPUT ttMessageCache.lRemote,
                OUTPUT ttMessageCache.cConnid,
                OUTPUT ttMessageCache.cOpmode,
                OUTPUT ttMessageCache.lConnreg,
                OUTPUT ttMessageCache.lConnbnd,
                OUTPUT ttMessageCache.cConntxt,
                OUTPUT ttMessageCache.cASppath,
                OUTPUT ttMessageCache.cConndbs,
                OUTPUT ttMessageCache.cConnpps,
                OUTPUT ttMessageCache.cCustInfo1,
                OUTPUT ttMessageCache.cCustInfo2,
                OUTPUT ttMessageCache.cCustInfo3,
                OUTPUT TABLE-HANDLE ttMessageCache.hTableHandle1,
                OUTPUT TABLE-HANDLE ttMessageCache.hTableHandle2,
                OUTPUT TABLE-HANDLE ttMessageCache.hTableHandle3,
                OUTPUT TABLE-HANDLE ttMessageCache.hTableHandle4,
                OUTPUT ttMessageCache.cSite,
                OUTPUT ttMessageCache.cFieldSecurity,
                OUTPUT ttMessageCache.cTokenSecurity
               ).

      /* Send token and security cache to the security manager */

      RUN receiveCacheTokSecurity IN gshSecurityManager (INPUT "afmessaged.w":U,
                                                         INPUT "":U,
                                                         INPUT ttMessageCache.cTokenSecurity).

      RUN receiveCacheFldSecurity IN gshSecurityManager (INPUT "afmessaged.w":U,
                                                         INPUT "":U,
                                                         INPUT ttMessageCache.cFieldSecurity).
  END.
  &ENDIF

  /* Display message if not remote and not suppressed */
  IF NOT lSuppressDisplay THEN
  DO:
    cSuppressDisplay = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                        INPUT "suppressDisplay":U,
                                        INPUT YES).
  END.
  ELSE cSuppressDisplay = "YES":U.

  IF cSuppressDisplay = "YES":U THEN ASSIGN lSuppressDisplay = YES.

  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND NOT lSuppressDisplay THEN
  DO:
      ASSIGN gcLogicalContainerName = "afmessaged":U.

    RUN af/cod2/afmessaged.w (INPUT pcMessageType,
                              INPUT cSummaryMessages,
                              INPUT cFullMessages,
                              INPUT cButtonList,
                              INPUT cMessageTitle,
                              INPUT LOOKUP(pcDefaultButton,pcButtonList),
                              INPUT LOOKUP(pcCancelButton,pcButtonList),
                              INPUT "":U,
                              INPUT "":U,
                              INPUT "":U,
                              INPUT phContainer,
                              OUTPUT iButtonPressed,
                              OUTPUT cAnswer).
    ASSIGN gcLogicalContainerName = "":U.

    IF iButtonPressed > 0 AND iButtonPressed <= NUM-ENTRIES(pcButtonList) THEN
      ASSIGN pcButtonPressed = ENTRY(iButtonPressed, pcButtonList).  /* Pass back untranslated button pressed */
    ELSE
      ASSIGN pcButtonPressed = pcDefaultButton.
  END.
  ELSE
    ASSIGN pcButtonPressed = pcDefaultButton.  /* If remote, assume default button */

  /* If remote, or update error log set to YES, then update error log and send an email if possible */
  IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) OR lUpdateErrorLog OR lSuppressDisplay THEN
      RUN updateErrorLog IN gshSessionManager (INPUT cSummaryMessages,
                                               INPUT cFullMessages).

  &IF DEFINED(server-side) = 0 &THEN
  /* We're finished with our message, so clear our message cache temp-table */
  FIND FIRST ttMessageCache NO-ERROR.
  IF AVAILABLE ttMessageCache 
  THEN DO:
      DELETE OBJECT ttMessageCache.hTableHandle1 NO-ERROR.
      DELETE OBJECT ttMessageCache.hTableHandle2 NO-ERROR.
      DELETE OBJECT ttMessageCache.hTableHandle3 NO-ERROR.
      DELETE OBJECT ttMessageCache.hTableHandle4 NO-ERROR.
      DELETE ttMessageCache.
  END.
  &ENDIF
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showWarningMessages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showWarningMessages Procedure 
PROCEDURE showWarningMessages :
/*------------------------------------------------------------------------------
  Purpose:  To issue a warning to a user without generating an input blocking statement
            in the process

  Parameters:  INPUT pcMessageList  - Standard {aferrortxt.i} formatted message (Can contain many messages)
               INPUT pcMessageType  - ERR (Error), INF (Information), ERR (Error)
               INPUT pcMessageTitle - The title of the message dialog
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcMessageList  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcMessageType  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcMessageTitle AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cButtonList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSummaryList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewButtonList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewTitle         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdateErrorLog   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuppressDisplay  AS LOGICAL    NO-UNDO.

  IF pcMessageTitle = "":U OR
     pcMessageTitle = ?    THEN
  DO:
    CASE pcMessageType:
      WHEN "ERR":U THEN pcMessageTitle = "Error":U.
      WHEN "INF":U THEN pcMessageTitle = "Information":U.
      WHEN "MES":U THEN pcMessageTitle = "Message":U.

      OTHERWISE pcMessageTitle = "Warning":U.
    END CASE.
  END.

  &IF DEFINED(server-side) <> 0 &THEN
    DO:
      RUN afmessagep (INPUT  pcMessageList,
                      INPUT  cButtonList,
                      INPUT  pcMessageTitle,
                      OUTPUT cSummaryList,
                      OUTPUT cFullList,
                      OUTPUT cNewButtonList,
                      OUTPUT cNewTitle,
                      OUTPUT lUpdateErrorLog,
                      OUTPUT lSuppressDisplay).
    END.
  &ELSE
    DO:
      RUN af/app/afmessagep.p ON gshAstraAppserver (INPUT  pcMessageList,
                                                    INPUT  cButtonList,
                                                    INPUT  pcMessageTitle,
                                                    OUTPUT cSummaryList,
                                                    OUTPUT cFullList,
                                                    OUTPUT cNewButtonList,
                                                    OUTPUT cNewTitle,
                                                    OUTPUT lUpdateErrorLog,
                                                    OUTPUT lSuppressDisplay).
    END.
  &ENDIF  

  CASE pcMessageType:
    WHEN "ERR":U THEN MESSAGE cFullList VIEW-AS ALERT-BOX ERROR       TITLE cNewTitle.
    WHEN "INF":U THEN MESSAGE cFullList VIEW-AS ALERT-BOX INFORMATION TITLE cNewTitle.
    WHEN "MES":U THEN MESSAGE cFullList VIEW-AS ALERT-BOX MESSAGE     TITLE cNewTitle.

    OTHERWISE MESSAGE cFullList VIEW-AS ALERT-BOX WARNING TITLE cNewTitle.
  END CASE.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-translateWidgets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE translateWidgets Procedure 
PROCEDURE translateWidgets :
/*------------------------------------------------------------------------------
  Purpose:     Translate widget labels, etc.
  Parameters:  input object handle
               input frame handle
               input table tttranslate
  Notes:       called from widgetwalk procedure
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phObject           AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER phFrame            AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttTranslate.

DEFINE VARIABLE hDataSource               AS HANDLE     NO-UNDO.
DEFINE VARIABLE hSideLabel                AS HANDLE     NO-UNDO.
DEFINE VARIABLE cRadioButtons             AS CHARACTER  NO-UNDO.

DEFINE VARIABLE dNewLabelLength           AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dLabelWidth               AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFirstCol                 AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dAddCol                   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE lResize                   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE dMinCol                   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iEntry                    AS INTEGER    NO-UNDO.
DEFINE VARIABLE cListItemPairs            AS CHARACTER  NO-UNDO.

ASSIGN hDataSource = DYNAMIC-FUNCTION("getDataSource":U IN phObject).
RUN multiTranslation IN gshTranslationManager (INPUT NO,
                                               INPUT-OUTPUT TABLE ttTranslate).

ASSIGN
  dAddCol = 0
  dMinCol = 0
  dFirstCol = 0
  lResize = NO
  .

size-check1:
FOR EACH ttTranslate:
  IF NOT VALID-HANDLE(ttTranslate.hWidgetHandle) THEN NEXT size-check1.

  IF ttTranslate.cTranslatedLabel = "":U AND
     ttTranslate.cTranslatedTooltip = "":U THEN NEXT size-check1.

  IF ttTranslate.cWidgetType = "browse":U OR 
     ttTranslate.cWidgetType = "radio-set":U THEN NEXT size-check1.

  dNewLabelLength = FONT-TABLE:GET-TEXT-WIDTH-CHARS(ttTranslate.cTranslatedLabel, ttTranslate.hWidgetHandle:FONT).
  dMinCol = MAXIMUM(dminCol, dNewLabelLength + 1.2).

  IF VALID-HANDLE(ttTranslate.hWidgetHandle) AND 
     CAN-QUERY(ttTranslate.hWidgetHandle, "column":U) AND
     (ttTranslate.hWidgetHandle:COLUMN < dFirstCol OR dFirstCol = 0) THEN
    ASSIGN dFirstCol = ttTranslate.hWidgetHandle:COLUMN.

END.

IF dMinCol > 0 THEN
size-check2:
FOR EACH ttTranslate:
  IF ttTranslate.cTranslatedLabel = "":U AND
     ttTranslate.cTranslatedTooltip = "":U THEN NEXT size-check2.

  IF ttTranslate.cWidgetType = "browse":U OR 
     ttTranslate.cWidgetType = "radio-set":U THEN NEXT size-check2.

  IF VALID-HANDLE(ttTranslate.hWidgetHandle) AND 
     CAN-QUERY(ttTranslate.hWidgetHandle, "column":U) AND
     ttTranslate.hWidgetHandle:COLUMN < dMinCol THEN
  DO:
    ASSIGN lResize = YES.
    LEAVE size-check2.
  END.
END.

IF lResize = YES AND dMinCol > 0 AND dFirstCol > 0 THEN dAddCol = (dMinCol - dFirstcol) + 1.
ELSE dAddCol = 0.

/* need to resize frame to fit new labels */
IF lResize = YES AND dAddCol > 0 THEN
DO:
  IF LOOKUP("setfieldlabel":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
    RUN resizeLookupFrame (INPUT phObject, INPUT phFrame, INPUT dAddCol). 
  ELSE IF LOOKUP("getdisplayfield":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
    RUN resizeSDFFrame (INPUT phObject, INPUT phFrame, INPUT dAddCol). 
  ELSE  
    RUN resizeNormalFrame (INPUT phObject, INPUT phFrame, INPUT dAddCol).
END.

translate-loop:
FOR EACH ttTranslate:
  IF ttTranslate.cTranslatedLabel = "":U AND
     ttTranslate.cTranslatedTooltip = "":U THEN NEXT translate-loop.

  CASE ttTranslate.cWidgetType:
    WHEN "browse":U THEN
    DO:
      IF ttTranslate.cTranslatedLabel <> "":U THEN
      DO:
        ttTranslate.hWidgetHandle:LABEL = ttTranslate.cTranslatedLabel.
        IF VALID-HANDLE(hDataSource) THEN
        DO:
          DYNAMIC-FUNCTION("assignColumnLabel":U IN hDataSource,
                           INPUT (IF ttTranslate.hWidgetHandle:NAME = ? THEN "":U ELSE ttTranslate.hWidgetHandle:NAME),
                           INPUT ttTranslate.hWidgetHandle:LABEL).
          DYNAMIC-FUNCTION("assignColumnColumnLabel":U IN hDataSource,
                           INPUT (IF ttTranslate.hWidgetHandle:NAME = ? THEN "":U ELSE ttTranslate.hWidgetHandle:NAME),
                           INPUT ttTranslate.hWidgetHandle:LABEL).
        END.
      END.
      IF ttTranslate.cTranslatedTooltip <> "":U THEN
      DO:
        ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.
      END.
    END.
      WHEN "COMBO-BOX":U OR WHEN "SELECTION-LIST":U THEN
      DO:
          IF ttTranslate.cTranslatedLabel NE "":U AND ttTranslate.cTranslatedLabel NE ? THEN
          DO:
              IF ttTranslate.iWidgetEntry EQ 0 THEN
                  ASSIGN ttTranslate.hWidgetHandle:LABEL = ttTranslate.cTranslatedLabel.
              ELSE
              DO:
                  ASSIGN iEntry         = (ttTranslate.iWidgetEntry * 2) - 1
                         cListItemPairs = ttTranslate.hWidgetHandle:LIST-ITEM-PAIRS.

                  ENTRY(iEntry, cListItemPairs , ttTranslate.hWidgetHandle:DELIMITER) = ttTranslate.cTranslatedLabel.

                  ASSIGN ttTranslate.hWidgetHandle:LIST-ITEM-PAIRS = cListItemPairs.
              END.
          END.    /* translated label has a value */

          /* Only take the tooltip from the obejct itself, not any of the items. */
          IF ttTranslate.cTranslatedTooltip NE "":U AND ttTranslate.cTranslatedTooltip NE ? AND
             ttTranslate.iWidgetEntry                                                  EQ 0 THEN
              ASSIGN ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.          
      END.  /* combo or selection list */
    WHEN "radio-set":U THEN
    DO:
      /* the program that creates ttTranslate table refers to the entries as 
       * 1,2,3 as opposed to 1,3,5 (there is a label,value pair)
       * so we have to calculate the right position. Plus we need to
       * re-assign radio-buttons to new value when done (fixes bug iz 1440)
       */  
      ASSIGN cRadioButtons = ttTranslate.hWidgetHandle:RADIO-BUTTONS
             iEntry = (ttTranslate.iWidgetEntry * 2) - 1.
      IF ttTranslate.cTranslatedLabel <> "":U THEN
        ENTRY(iEntry, cRadioButtons) = ttTranslate.cTranslatedLabel.
      IF ttTranslate.cTranslatedTooltip <> "":U THEN
        ttTranslate.hWidgetHandle:TOOLTIP = ttTranslate.cTranslatedTooltip.
      ASSIGN ttTranslate.hWidgetHandle:RADIO-BUTTONS = cradiobuttons.
    END.
    WHEN "text":U THEN
    DO:
      ASSIGN ttTranslate.hWidgetHandle:PRIVATE-DATA = ttTranslate.cTranslatedLabel
             ttTranslate.hWidgetHandle:SCREEN-VALUE = ttTranslate.cTranslatedLabel.
    END.
    OTHERWISE
    DO:
      IF ttTranslate.cTranslatedLabel <> "":U AND 
         ttTranslate.hWidgetHandle = ? AND
         INDEX(ttTranslate.cObjectName, ":":U) <> 0 AND
         LOOKUP("setfieldlabel":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
      DO:
        DYNAMIC-FUNCTION("setfieldLabel":U IN phObject, INPUT ttTranslate.cTranslatedLabel).                                  
      END.
      ELSE IF ttTranslate.cTranslatedLabel <> "":U AND
           INDEX(ttTranslate.cObjectName, ":":U) <> 0 AND
           ttTranslate.cOriginalLabel = "nolabel":U THEN
      DO:          
        ttTranslate.hWidgetHandle:SCREEN-VALUE = REPLACE(ttTranslate.cTranslatedLabel,":":U,"":U) + ":":U.
        ttTranslate.hWidgetHandle:MODIFIED = NO.
      END.
      ELSE IF ttTranslate.cTranslatedLabel <> "":U THEN
      DO:
          /* Cater for widgets like TOGGLE-BOXes which do not have a side label 
           * Buttons would also fall into this category.                        */
          IF CAN-QUERY(ttTranslate.hWidgetHandle, "SIDE-LABEL-HANDLE":U) THEN
              ASSIGN hSideLabel = ttTranslate.hWidgetHandle:SIDE-LABEL-HANDLE.
          ELSE
              ASSIGN hSideLabel = ?.

         /* We need to manually resize, move and change to format of labels for
          * objects on the dynamic viewer. These labels are DYNAMIC and have a TYPE
          * of text.                                                                */
         IF VALID-HANDLE(hSideLabel) AND hSideLabel:TYPE EQ "TEXT":U AND hSideLabel:DYNAMIC THEN
         DO:
             ASSIGN ttTranslate.cTranslatedLabel = ttTranslate.cTranslatedLabel + ":":U
                    dNewLabelLength              = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(ttTranslate.cTranslatedLabel,
                                                                                    ttTranslate.hWidgetHandle:FONT)
                    .
             /** Position the label. We use pixels here since X and WIDTH-PIXELS
              *  are denominated in the same units, unlike COLUMN and WIDTH-CHARS.
              *  ----------------------------------------------------------------------- **/
             IF ( dNewLabelLength + 1 ) GT ttTranslate.hWidgetHandle:X THEN
                 ASSIGN dLabelWidth = ttTranslate.hWidgetHandle:X + 1.
             ELSE
                 ASSIGN dLabelWidth = dNewLabelLength + 1.

             IF dLabelWidth LE 0 THEN
                 ASSIGN dLabelWidth = 1.

             IF CAN-SET(hSideLabel, "FORMAT":U) THEN
                 ASSIGN hSideLabel:FORMAT = "x(" + STRING(LENGTH(ttTranslate.cTranslatedLabel, "CHARACTER":U) + 1) + ")":U.

             ASSIGN hSideLabel:WIDTH-PIXELS = dLabelWidth
                    hSideLabel:X            = ttTranslate.hWidgetHandle:X - dLabelWidth
                    hSideLabel:SCREEN-VALUE = ttTranslate.cTranslatedLabel
                    .
         END.   /* valid side-label */
         ELSE
             ASSIGN ttTranslate.hWidgetHandle:LABEL = ttTranslate.cTranslatedLabel.
      END.  /* there is a translation */
    END.    /* other widget types */
  END CASE. /* widget type */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateErrorLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateErrorLog Procedure 
PROCEDURE updateErrorLog :
/*------------------------------------------------------------------------------
  Purpose:     Updates the messages into the error log database table
  Parameters:  input CHR(3) delimited list of summary messages.
               input CHR(3) delimited list of full messages.
  Notes:       Called from askQuestion and showMessages.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcSummaryList              AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcFullList                 AS CHARACTER  NO-UNDO.

&IF DEFINED(server-side) <> 0 &THEN
  DO:
    RUN aferrorlgp (INPUT pcSummaryList, INPUT pcFullList).  
  END.
&ELSE
  DO:
    RUN af/app/aferrorlgp.p ON gshAstraAppserver (INPUT pcSummaryList, INPUT pcFullList).
  END.
&ENDIF

/* cannot check for messages as called from showmessages and may go recursive */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateHelp Procedure 
PROCEDURE updateHelp :
/*------------------------------------------------------------------------------
  Purpose:     Update the help table with the supplied temp-table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE-HANDLE hHelpTable.

&IF DEFINED(Server-Side) = 0 &THEN

/* We're going to make a dynamic call to the Appserver, we need to build the temp-table of parameters */

DEFINE VARIABLE hTableNotUsed    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hParamTable      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTTHandlesToSend AS HANDLE     NO-UNDO EXTENT 64.        

IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttSeqType. ELSE FOR EACH ttSeqType: DELETE ttSeqType. END.

CREATE ttSeqType.
ASSIGN ttSeqType.iParamNo   = 1
       ttSeqType.cIOMode    = "INPUT":U
       ttSeqType.cParamName = "T:01":U
       ttSeqType.cDataType  = "TABLE-HANDLE".

/* Now assign the TABLE-HANDLEs, note they map directly to the ttSeq records of type TABLE-HANDLE */

ASSIGN hTTHandlesToSend[1] = hHelpTable
       hParamTable         = TEMP-TABLE ttSeqType:HANDLE.

/* calltablett.p will construct and execute the call on the Appserver */

RUN adm2/calltablett.p ON gshAstraAppserver
    (
     "updateHelp":U,
     "SessionManager":U,
     INPUT "S":U,
     INPUT-OUTPUT hTableNotUsed,
     INPUT-OUTPUT TABLE-HANDLE hParamTable,
     "",
     {src/adm2/callttparam.i &ARRAYFIELD = "hTTHandlesToSend"}  /* The actual array of table handles */ 
    ) NO-ERROR.

DELETE OBJECT hParamTable.
ASSIGN hParamTable = ?.

IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

&ELSE
DEFINE BUFFER gsm_help FOR gsm_help.

DEFINE VARIABLE hBuffer            AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery             AS HANDLE     NO-UNDO.

DEFINE VARIABLE hLanguageObj       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hContainerFileName AS HANDLE     NO-UNDO.
DEFINE VARIABLE hObjectName        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hWidgetName        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hHelpFilename      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hHelpContext       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDelete            AS HANDLE     NO-UNDO.
DEFINE VARIABLE lDelete            AS LOGICAL    NO-UNDO.

ASSIGN hBuffer            = hHelpTable:DEFAULT-BUFFER-HANDLE
       hLanguageObj       = hBuffer:BUFFER-FIELD("dLanguageObj":U)
       hContainerFileName = hBuffer:BUFFER-FIELD("cContainerFileName":U)
       hObjectName        = hBuffer:BUFFER-FIELD("cObjectName":U)
       hWidgetName        = hBuffer:BUFFER-FIELD("cWidgetName":U)
       hHelpFilename      = hBuffer:BUFFER-FIELD("cHelpFilename":U)
       hHelpContext       = hBuffer:BUFFER-FIELD("cHelpContext":U)
       hDelete            = hBuffer:BUFFER-FIELD("lDelete":U).

CREATE QUERY hQuery.
hQuery:ADD-BUFFER(hBuffer).
hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME).
hQuery:QUERY-OPEN().

hQuery:GET-FIRST().

/* Update the whole record set in one transaction */

trn-blk:
DO FOR gsm_help TRANSACTION ON ERROR UNDO trn-blk, LEAVE trn-blk:

    do-blk:
    DO WHILE NOT hQuery:QUERY-OFF-END:
    
        FIND gsm_help EXCLUSIVE-LOCK
             WHERE gsm_help.language_obj            = hLanguageObj:BUFFER-VALUE
               AND gsm_help.help_container_filename = hContainerFileName:BUFFER-VALUE
               AND gsm_help.help_object_filename    = hObjectName:BUFFER-VALUE
               AND gsm_help.help_fieldname          = hWidgetName:BUFFER-VALUE
             NO-ERROR.
    
        IF NOT AVAILABLE gsm_help
        THEN DO:
            ASSIGN ERROR-STATUS:ERROR = NO. /* We don't want afcheckerr.i to return a false error */

            /* If no filename or context, or flagged for deletion, don't create */

            IF (hHelpFilename:BUFFER-VALUE = "":U
            AND hHelpContext:BUFFER-VALUE  = "":U)
             OR hDelete:BUFFER-VALUE = YES
            THEN DO:
                hQuery:GET-NEXT().
                NEXT do-blk.
            END.

            CREATE gsm_help NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trn-blk, LEAVE trn-blk.

            ASSIGN gsm_help.language_obj            = hLanguageObj:BUFFER-VALUE
                   gsm_help.help_container_filename = hContainerFileName:BUFFER-VALUE
                   gsm_help.help_object_filename    = hObjectName:BUFFER-VALUE
                   gsm_help.help_fieldname          = hWidgetName:BUFFER-VALUE
                   NO-ERROR.
            IF ERROR-STATUS:ERROR THEN UNDO trn-blk, LEAVE trn-blk.
        END.
        ELSE DO:
            ASSIGN lDelete = (hDelete:BUFFER-VALUE = YES OR (hHelpFilename:BUFFER-VALUE = "":U AND hHelpContext:BUFFER-VALUE = "":U)).

            IF lDelete = YES 
            THEN DO:
                DELETE gsm_help NO-ERROR.
                IF ERROR-STATUS:ERROR THEN UNDO trn-blk, LEAVE trn-blk.

                hQuery:GET-NEXT().
                NEXT do-blk.
            END.
        END.

        ASSIGN gsm_help.help_filename  = hHelpFilename:BUFFER-VALUE
               gsm_help.help_context   = hHelpContext:BUFFER-VALUE
               NO-ERROR.
        IF ERROR-STATUS:ERROR THEN UNDO trn-blk, LEAVE trn-blk.

        hQuery:GET-NEXT().
    END.
END.

hQuery:QUERY-CLOSE().

DELETE OBJECT hQuery.
DELETE OBJECT hHelpTable.

ASSIGN hQuery     = ?
       hHelpTable = ?.

{af/sup2/afcheckerr.i}

&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetWalk) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE widgetWalk Procedure 
PROCEDURE widgetWalk :
/*------------------------------------------------------------------------------
  Purpose:     Walk widget tree for the frame input
  Parameters:  input container handle
               input object handle
               input frame or window handle.
               input action code (e.g. setup)
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phContainer      AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER phObject         AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER phFrame          AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER pcAction         AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER plPopupsInFields AS LOGICAL   NO-UNDO.

DEFINE VARIABLE hRealContainer   AS HANDLE    NO-UNDO.
DEFINE VARIABLE cContainerName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRunAttribute    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE hWidgetGroup     AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDataSource      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hWidget          AS HANDLE    NO-UNDO.
DEFINE VARIABLE hLookup          AS HANDLE    NO-UNDO.
DEFINE VARIABLE iLoop            AS INTEGER   NO-UNDO.
DEFINE VARIABLE iEntry           AS INTEGER   NO-UNDO.
DEFINE VARIABLE lOk              AS LOGICAL   NO-UNDO.
DEFINE VARIABLE hLabel           AS HANDLE    NO-UNDO.
DEFINE VARIABLE hColumn          AS HANDLE    NO-UNDO.
DEFINE VARIABLE cFieldName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRadioButtons    AS CHARACTER NO-UNDO.
DEFINE VARIABLE iRadioLoop       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iBrowseLoop      AS INTEGER   NO-UNDO.
DEFINE VARIABLE cSecuredTokens   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSecuredFields   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cShowPopup       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHiddenFields    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cParentField     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDisplayedFields AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFieldSecurity   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iFieldPos        AS INTEGER   NO-UNDO.
DEFINE VARIABLE cBufferTableName AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnTableName AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectType      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lObjectSecured       AS LOGICAL  NO-UNDO.
DEFINE VARIABLE lObjectTranslated    AS LOGICAL NO-UNDO.
DEFINE VARIABLE cFieldPopupMapping   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectSecuredFields AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDelimiter           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cListItems           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCnt                 AS INTEGER    NO-UNDO.
DEFINE VARIABLE iWhereInList         AS INTEGER    NO-UNDO.

IF NOT VALID-HANDLE(phContainer) OR NOT VALID-HANDLE(phObject) OR NOT VALID-HANDLE(phFrame) THEN RETURN.
 
cObjectType = DYNAMIC-FUNCTION("getObjectType":U IN phObject).
ASSIGN lObjectTranslated = DYNAMIC-FUNCTION("getObjectTranslated":U IN phObject ) NO-ERROR.
IF lObjectTranslated EQ ? THEN
    ASSIGN lObjectTranslated = NO.

ASSIGN lObjectSecured = DYNAMIC-FUNCTION("getObjectSecured":U IN phObject ) NO-ERROR.
IF lObjectSecured EQ ? THEN
    ASSIGN lObjectSecured = NO.

/* If both object security and translation have been performed, then there is nothing
 * to do here. Both of these values are usually set at the same time, but there may be
 * cases where only one of these values is set. We need to cater for this.  */
IF lObjectTranslated EQ YES AND lObjectSecured EQ YES THEN
    RETURN.

/* Where should field calendar and calculator popups go?  Default is RIGHT */
IF plPopupsInFields = ? THEN
    ASSIGN plPopupsInFields = NO.

ASSIGN hDataSource = DYNAMIC-FUNCTION("getDataSource":U IN phObject).

cDisplayedFields = DYNAMIC-FUNCTION("getAllFieldHandles" IN phObject) NO-ERROR.
/* FieldSecurity will be set for SmartDataBrowsers for browse columns only, not for objects on the 
   SmartDataBrowser's frame */
IF cDisplayedFields <> "":U AND cObjectType NE "SmartDataBrowser":U THEN
  cFieldSecurity = FILL(",":U,NUM-ENTRIES(cDisplayedFields) - 1).
IF phFrame:TYPE = "window":U THEN
  phFrame = phFrame:FIRST-CHILD.

IF VALID-HANDLE(phFrame) AND phFrame:NAME <> "FolderFrame":U THEN DO:
  IF pcAction = "setup":U THEN DO:
    /* get real container name and run attribute (if sdf container is viewer !) */    
    ASSIGN hRealContainer = ?.
    IF LOOKUP("getFieldName":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
      hRealContainer = DYNAMIC-FUNCTION("getcontainersource":U IN phContainer) NO-ERROR.
    IF NOT VALID-HANDLE(hRealContainer) THEN ASSIGN hRealContainer = phContainer.

    ASSIGN cContainerName = hRealContainer:FILE-NAME.
    IF LOOKUP("getLogicalObjectName":U, hRealContainer:INTERNAL-ENTRIES) <> 0 THEN
      ASSIGN cContainerName = DYNAMIC-FUNCTION('getLogicalObjectName' IN hRealContainer).
    IF cContainerName = "":U OR cContainerName = ? THEN
      ASSIGN cContainerName = hRealContainer:FILE-NAME.
    ASSIGN
      cContainerName = LC(TRIM(REPLACE(cContainerName,"~\":U,"/":U)))
      cContainerName = SUBSTRING(cContainerName,R-INDEX(cContainerName,"/":U) + 1)
      cRunAttribute = "":U.
    cRunAttribute = DYNAMIC-FUNCTION('getRunAttribute' IN hRealContainer) NO-ERROR.  

    /* get object name to use */    
    IF LOOKUP("getFieldName":U, phObject:INTERNAL-ENTRIES) <> 0 OR
       phFrame:NAME = "Panel-Frame":U THEN
    DO: /* for toolbars and SDF's - use container name for translations */
      ASSIGN cObjectName = phContainer:FILE-NAME.
      IF LOOKUP("getLogicalObjectName":U, phContainer:INTERNAL-ENTRIES) <> 0 THEN
        ASSIGN cObjectName = DYNAMIC-FUNCTION('getLogicalObjectName' IN phContainer).
      IF cObjectName = "":U OR cObjectName = ? THEN
        ASSIGN cObjectName = phContainer:FILE-NAME.
      ASSIGN
        cObjectName = LC(TRIM(REPLACE(cObjectName,"~\":U,"/":U)))
        cObjectName = SUBSTRING(cObjectName,R-INDEX(cObjectName,"/":U) + 1).
      IF LOOKUP("getFieldName":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
        cObjectName = cObjectName + ":":U + DYNAMIC-FUNCTION("getFieldName":U IN phObject).
    END.
    ELSE
    DO: /* otherwise use object name for translations */
      ASSIGN cObjectName = phObject:FILE-NAME.
      IF LOOKUP("getLogicalObjectName":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
        ASSIGN cObjectName = DYNAMIC-FUNCTION('getLogicalObjectName' IN phObject).
      IF cObjectName = "":U OR cObjectName = ? THEN
        ASSIGN cObjectName = phObject:FILE-NAME.
      ASSIGN cObjectName = LC(TRIM(REPLACE(cObjectName,"~\":U,"/":U)))
             cObjectName = SUBSTRING(cObjectName,R-INDEX(cObjectName,"/":U) + 1).
    END.
    EMPTY TEMP-TABLE ttTranslate.
  END.

  ASSIGN
      hwidgetGroup = phFrame:HANDLE
      hwidgetGroup = hwidgetGroup:FIRST-CHILD
      hWidget = hwidgetGroup:FIRST-CHILD.
  /* deal with lookups and smartselects not initialized yet */
  IF pcAction = "setup":U AND hWidget = ? AND INDEX(cObjectName, ":":U) <> 0 AND lObjectTranslated NE YES AND
     LOOKUP("setfieldlabel":U, phObject:INTERNAL-ENTRIES) <> 0 THEN
  DO:
    CREATE ttTranslate.
    ASSIGN
      ttTranslate.dLanguageObj = 0
      ttTranslate.cObjectName = cObjectName
      ttTranslate.lGlobal = NO
      ttTranslate.lDelete = NO
      ttTranslate.cWidgetType = "fill-in":U
      ttTranslate.cWidgetName = "fiLookup":U
      ttTranslate.hWidgetHandle = ?
      ttTranslate.iWidgetEntry = 0
      ttTranslate.cOriginalLabel = "nolabel":U
      ttTranslate.cTranslatedLabel = "":U
      ttTranslate.cOriginalTooltip = "nolabel":U
      ttTranslate.cTranslatedTooltip = "":U
      .
    /* For Dynamic Combos we should set the Widget Type and Name correctly */
    IF LOOKUP("dynamicCombo":U,phObject:INTERNAL-ENTRIES) > 0 THEN
      ASSIGN ttTranslate.cWidgetType = "COMBO-BOX":U
             ttTranslate.cWidgetName = "fiCombo":U.
  END.

  /* check field security and token security */
  ASSIGN cHiddenFields = "":U.
  IF pcAction = "setup":U AND lObjectSecured NE YES THEN 
  DO:
      {get logicalObjectName cObjectName phObject}.
      RUN fieldSecurityGet IN gshSecurityManager (INPUT phObject,
                                                  INPUT cObjectName,
                                                  INPUT cRunAttribute,
                                                  OUTPUT cObjectSecuredFields).

      RUN fieldSecurityGet IN gshSecurityManager (INPUT hRealContainer,
                                                  INPUT cContainerName,
                                                  INPUT cRunAttribute,
                                                  OUTPUT cSecuredFields).
      IF cSecuredFields <> "":U THEN
          ASSIGN cSecuredFields = cSecuredFields + ",":U.

      /* Now merge the 2 lists of secured fields */
      IF NUM-ENTRIES(cObjectSecuredFields) <> 0 THEN
          DO iCnt = 1 TO NUM-ENTRIES(cObjectSecuredFields) BY 2:
              ASSIGN iWhereInList = LOOKUP(ENTRY(iCnt, cObjectSecuredFields), cSecuredFields). /* Check where the field is in the securedFields list */
              IF iWhereInList = 0 THEN /* If not in the list, add it and it's security */
                  ASSIGN cSecuredFields = cSecuredFields + ENTRY(iCnt, cObjectSecuredFields)     + ",":U
                                                         + ENTRY(iCnt + 1, cObjectSecuredFields) + ",":U.
              ELSE DO:
                  IF ENTRY(iWhereInList + 1, cSecuredFields) <> "READ ONLY":U THEN
                      ASSIGN ENTRY(iWhereInList + 1, cSecuredFields) = ENTRY(iCnt + 1, cObjectSecuredFields).
              END.
          END.

      ASSIGN cSecuredFields = RIGHT-TRIM(cSecuredFields, ",":U).
  END.
  IF pcAction = "setup":U AND lObjectSecured NE YES THEN
    RUN tokenSecurityGet IN gshSecurityManager (INPUT hRealContainer,
                                                INPUT cContainerName,
                                                INPUT cRunAttribute,
                                                OUTPUT cSecuredTokens).
  widget-walk:
  DO WHILE VALID-HANDLE (hWidget):
    /* check if european format and if so and this is a decimal widget and the delimiter is a
       comma, then set the delimiter to chr(3) because comma is a decimal separator in european
       format */
    IF pcAction = "setup":U AND
       LOOKUP(hWidget:TYPE,"selection-list,radio-set,combo-box":U) <> 0 AND
       CAN-QUERY(hWidget,"data-type":U) AND
       hWidget:DATA-TYPE = "decimal":U AND
       CAN-QUERY(hWidget,"delimiter":U) AND
       hWidget:DELIMITER = ",":U AND
       SESSION:NUMERIC-DECIMAL-POINT = ",":U THEN
    DO:
      hWidget:DELIMITER = CHR(3).    
    END.
    /* Set secured fields for Dynamic Combos and Lookups */
    IF pcAction = "setup":U AND lObjectSecured NE YES 
    AND hWidget:TYPE = "FRAME":U THEN
      cFieldSecurity = setSecurityForDynObjects (hWidget,cSecuredFields,cDisplayedFields,cFieldSecurity,phObject).
      
    /* use database help for tooltip if no tooltip set-up */
    IF pcAction = "setup":U AND CAN-QUERY(hWidget,"tooltip":U) THEN
      ASSIGN hWidget:TOOLTIP = (IF hWidget:TOOLTIP <> ? AND hWidget:TOOLTIP <> "":U THEN
                               hWidget:TOOLTIP ELSE hWidget:HELP).
    /* translation and security */
    IF pcAction = "Setup":U AND LOOKUP(hWidget:TYPE, "text,button,fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U) > 0 THEN
    DO:
      ASSIGN
        cFieldName = (IF CAN-QUERY(hWidget, "TABLE":U) AND LENGTH(hWidget:TABLE) > 0 AND hWidget:TABLE <> "RowObject":U THEN (hWidget:TABLE + ".":U) ELSE "":U) + hWidget:NAME.
      IF cFieldName = ? OR cFieldName = "":U THEN DO:
        ASSIGN hWidget = hWidget:NEXT-SIBLING.
        NEXT widget-walk.
      END.

      /* check security */
      IF lObjectSecured NE YES AND hWidget:TYPE = "button":U AND cSecuredTokens <> "":U AND LOOKUP(cFieldName,cSecuredTokens) <> 0 THEN DO:
        ASSIGN
          hWidget:SENSITIVE = FALSE
          iFieldPos = LOOKUP(STRING(hWidget),cDisplayedFields)
          ENTRY(iFieldPos,cFieldSecurity) = "ReadOnly":U.
      END.
      iFieldPos = LOOKUP(STRING(hWidget),cDisplayedFields).
      IF lObjectSecured NE YES AND hWidget:TYPE <> "button":U AND cSecuredFields <> "":U AND LOOKUP(cFieldName,cSecuredFields) <> 0 THEN DO:
        ASSIGN iEntry = LOOKUP(cFieldName,cSecuredFields). /* Look for field in list */
        IF iEntry > 0 AND NUM-ENTRIES(cSecuredFields) > iEntry THEN
        DO:
          CASE ENTRY(iEntry + 1, cSecuredFields):
            WHEN "hidden":U THEN
            DO:
              ASSIGN 
                hWidget:VISIBLE = FALSE
                cHiddenFields = (IF cHiddenFields <> "":U THEN cHiddenFields + ",":U + cFieldName ELSE cFieldName).
              IF iFieldPos <> 0 THEN
                ENTRY(iFieldPos,cFieldSecurity) = "Hidden":U NO-ERROR.
            END.
            WHEN "Read Only":U THEN
            DO:
              hWidget:SENSITIVE = FALSE.
              IF CAN-SET(hWidget,"READ-ONLY":U) THEN
                hWidget:READ-ONLY = TRUE.
              IF iFieldPos <> 0 THEN
                ENTRY(iFieldPos,cFieldSecurity) = "ReadOnly":U NO-ERROR.
            END.
          END CASE.

          /* disable field in SDO if can */
          IF VALID-HANDLE(hDataSource) THEN
          DO:
          END.
          ASSIGN hWidget:MODIFIED = FALSE.
        END.
      END.

      /* Avoid duplicates */
      IF lObjectTranslated NE YES 
      AND CAN-FIND(FIRST ttTranslate
                  WHERE ttTranslate.dLanguageObj = 0
                    AND ttTranslate.cObjectName = cObjectName
                    AND ttTranslate.cWidgetType = hWidget:TYPE
                    AND ttTranslate.cWidgetName = cFieldName) THEN
      DO:
        ASSIGN hWidget = hWidget:NEXT-SIBLING.
        NEXT widget-walk.
      END.

      IF lObjectTranslated NE YES THEN
      DO:
          IF CAN-DO("COMBO-BOX,SELECTION-LIST":U, hWidget:TYPE) AND
             CAN-QUERY(hWidget, "LIST-ITEM-PAIRS":U)            THEN
          DO:
              ASSIGN cListItems = hWidget:LIST-ITEM-PAIRS
                     cDelimiter = hWidget:DELIMITER.

              IF cListItems NE ? AND NUM-ENTRIES(cListItems, cDelimiter) GE 2 THEN
              DO iRadioLoop = 1 TO NUM-ENTRIES(cListItems, cDelimiter) BY 2:
                CREATE ttTranslate.
                ASSIGN
                  ttTranslate.dLanguageObj        = 0
                  ttTranslate.cObjectName         = cObjectName
                  ttTranslate.lGlobal             = NO
                  ttTranslate.lDelete             = NO
                  ttTranslate.cWidgetType         = hWidget:TYPE
                  ttTranslate.cWidgetName         = cFieldName
                  ttTranslate.hWidgetHandle       = hWidget
                  ttTranslate.iWidgetEntry        = (iRadioLoop + 1) / 2
                  ttTranslate.cOriginalLabel      = ENTRY(iRadioLoop, cListItems, cDelimiter)
                  ttTranslate.cTranslatedLabel    = "":U
                  ttTranslate.cOriginalTooltip    = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
                  ttTranslate.cTranslatedTooltip  = "":U.                
              END.    /* loop through list items  */
          END.    /* combos and selection list AND updatable list item pairs. */

          IF hWidget:TYPE <> "RADIO-SET":U THEN
          DO:
            CREATE ttTranslate.
            ASSIGN
              ttTranslate.dLanguageObj = 0
              ttTranslate.cObjectName = cObjectName
              ttTranslate.lGlobal = NO
              ttTranslate.lDelete = NO
              ttTranslate.cWidgetType = hWidget:TYPE
              ttTranslate.cWidgetName = cFieldName
              ttTranslate.hWidgetHandle = hWidget
              ttTranslate.iWidgetEntry = 0
              ttTranslate.cOriginalLabel = (IF CAN-QUERY(hWidget,"LABEL":U) AND hWidget:LABEL <> ? THEN hWidget:LABEL ELSE "":U)
              ttTranslate.cTranslatedLabel = "":U
              ttTranslate.cOriginalTooltip = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
              ttTranslate.cTranslatedTooltip = "":U
              .
    
            /* deal with SDF's where label is separate */
            IF INDEX(cObjectName, ":":U) <> 0 AND ttTranslate.cOriginalLabel = "":U THEN
            DO:
              ASSIGN hLabel = ?.
              ASSIGN hLabel = DYNAMIC-FUNCTION("getLabelHandle":U IN phObject) NO-ERROR.
              IF VALID-HANDLE(hLabel) AND hLabel:SCREEN-VALUE <> ? AND hLabel:SCREEN-VALUE <> "":U THEN
              DO:
                ttTranslate.cOriginalLabel = "nolabel":U /* REPLACE(hLabel:SCREEN-VALUE,":":U,"":U) */ .
                ttTranslate.hWidgetHandle = hLabel.
              END.
            END.
    
          END. /* not a radio-set */
          ELSE  /* It is a radio-set */
          DO:
            ASSIGN cRadioButtons = hWidget:RADIO-BUTTONS.
            radio-loop:
            DO iRadioLoop = 1 TO NUM-ENTRIES(cRadioButtons) BY 2:
    
              CREATE ttTranslate.
              ASSIGN
                ttTranslate.dLanguageObj = 0
                ttTranslate.cObjectName = cObjectName
                ttTranslate.lGlobal = NO
                ttTranslate.lDelete = NO
                ttTranslate.cWidgetType = hWidget:TYPE
                ttTranslate.cWidgetName = cFieldName
                ttTranslate.hWidgetHandle = hWidget
                ttTranslate.iWidgetEntry = (iRadioLoop + 1) / 2
                ttTranslate.cOriginalLabel = ENTRY(iRadioLoop, cRadioButtons)
                ttTranslate.cTranslatedLabel = "":U
                ttTranslate.cOriginalTooltip = (IF CAN-QUERY(hWidget,"TOOLTIP":U) AND hWidget:TOOLTIP <> ? THEN hWidget:TOOLTIP ELSE "":U)
                ttTranslate.cTranslatedTooltip = "":U.
            END. /* radio-loop */
          END. /* radio-set */
        END.  /* valid widget type */
        ELSE IF pcAction = "Setup":U AND INDEX(hWidget:TYPE,"browse":U) <> 0 THEN DO:
          ASSIGN hColumn        = hWidget:FIRST-COLUMN.
          
          IF cObjectType = "SmartDataBrowser":U THEN 
            cFieldSecurity = FILL(",":U,hWidget:NUM-COLUMNS - 1).
    
          col-loop:
          DO iBrowseLoop = 1 TO hWidget:NUM-COLUMNS:
            IF NOT VALID-HANDLE(hColumn) THEN LEAVE col-loop.
            
            /*
            Determine the buffer table name and the table name 
            If two buffers for the same table is used, the table prefix will be the same 
            This cause errors when creating the translation fields as a record will the same name already exist
            */
            ASSIGN
              cBufferTableName = hColumn:BUFFER-FIELD:BUFFER-HANDLE:NAME
              cColumnTableName = hColumn:TABLE
              NO-ERROR.
    
            ASSIGN
              cFieldName = (IF cBufferTableName <> ?
                            AND cBufferTableName <> "RowObject":U
                            AND LENGTH(cBufferTableName) > 0
                            THEN (cBufferTableName + ".":U)
                            ELSE
                            (IF cColumnTableName <> ?
                             AND cColumnTableName <> "RowObject":U
                             AND LENGTH(cColumnTableName) > 0
                             THEN (cColumnTableName + ".":U)
                             ELSE
                               "":U
                            )
                           )
                         + (IF (hColumn:NAME = ? OR hColumn:NAME = "":U)
                            AND hColumn:LABEL <> ?
                            THEN hColumn:LABEL
                            ELSE hColumn:NAME
                           ).
            /*
            ASSIGN cFieldName = (IF CAN-QUERY(hColumn, "TABLE":U) AND LENGTH(hColumn:TABLE) > 0 AND hColumn:TABLE <> "RowObject":U THEN (hColumn:TABLE + ".":U) ELSE "":U) + hColumn:NAME.
            */
            IF cFieldName = ? OR cFieldName = "":U THEN DO:
              ASSIGN hColumn = hcolumn:NEXT-COLUMN NO-ERROR.
              NEXT col-loop.
            END.
    
            /* Avoid duplicates */
            IF CAN-FIND(FIRST ttTranslate
                        WHERE ttTranslate.dLanguageObj = 0
                          AND ttTranslate.cObjectName = cObjectName
                          AND ttTranslate.cWidgetType = hWidget:TYPE
                          AND ttTranslate.cWidgetName = cFieldName) THEN
            DO:
              ASSIGN hColumn = hcolumn:NEXT-COLUMN NO-ERROR.
              NEXT col-loop.
            END.
    
            CREATE ttTranslate.
            ASSIGN
              ttTranslate.dLanguageObj = 0
              ttTranslate.cObjectName = cObjectName
              ttTranslate.lGlobal = NO
              ttTranslate.lDelete = NO
              ttTranslate.cWidgetType = hWidget:TYPE
              ttTranslate.cWidgetName = cFieldName
              ttTranslate.hWidgetHandle = hColumn
              ttTranslate.iWidgetEntry = 0
              ttTranslate.cOriginalLabel = (IF CAN-QUERY(hColumn,"LABEL":U) AND hColumn:LABEL <> ? THEN hColumn:LABEL ELSE "":U)
              ttTranslate.cTranslatedLabel = "":U
              ttTranslate.cOriginalTooltip = (IF CAN-QUERY(hColumn,"TOOLTIP":U) AND hColumn:TOOLTIP <> ? THEN hColumn:TOOLTIP ELSE "":U)
              ttTranslate.cTranslatedTooltip = "":U
              .
    
            IF cObjectType = "SmartDataBrowser":U THEN
            DO:
              ASSIGN iEntry = LOOKUP(cFieldName,cSecuredFields). /* Look for field in list */
              IF iEntry > 0 AND NUM-ENTRIES(cSecuredFields) > iEntry THEN
                ENTRY(iBrowseLoop,cFieldSecurity) = ENTRY(iEntry + 1, cSecuredFields).
            END.  /* if SmartDataBrowser */
    
            ASSIGN hColumn = hcolumn:NEXT-COLUMN NO-ERROR.
          END.
        END.    /* object not translated */

      IF lObjectSecured NE YES AND cObjectType = "SmartDataBrowser":U AND cFieldSecurity <> "":U THEN
        DYNAMIC-FUNCTION("setFieldSecurity" IN phObject, cFieldSecurity) NO-ERROR.
    END. /* browse setup */

    /*-----------------------------------*
     * Put popup on fields if applicable *
     *-----------------------------------*/

    /* Only Date, Decimal or Integer Fill-ins will ever have popups. */
    IF  pcAction = "setup":U
    AND LOOKUP(hWidget:TYPE, "FILL-IN":U) NE 0 
    AND CAN-QUERY(hWidget, "DATA-TYPE":U) 
    AND LOOKUP(hWidget:DATA-TYPE, "DATE,DECIMAL,INTEGER":U) NE 0 THEN 
    DO:
        /* Check whether the ShowPopup property has been explicitly set.
         * If so, use this value. If not, act according to the defaults. */

        ASSIGN cShowPopup = "":U.
        IF  CAN-QUERY(hWidget, "PRIVATE-DATA":U)             
        AND LOOKUP("ShowPopup":U, hWidget:PRIVATE-DATA) GT 0 THEN
            ASSIGN cShowPopup = ENTRY(LOOKUP("ShowPopup":U, hWidget:PRIVATE-DATA) + 1, hWidget:PRIVATE-DATA).

        /* Get the name of the field for which popup is to be created only if there are hidden fields here */
        IF cHiddenFields <> "":U THEN 
        DO:
            cParentField = (IF CAN-QUERY(hWidget, "TABLE":U) AND LENGTH(hWidget:TABLE) > 0 AND hWidget:TABLE <> "RowObject":U 
                            THEN (hWidget:TABLE + ".":U) 
                            ELSE "":U) 
                         + hWidget:NAME.

            IF cParentField <> "":U AND cParentField <> ? THEN
                IF LOOKUP(cParentField,cHiddenFields) <> 0 THEN /* Don't create popup for hidden fields */
                    ASSIGN cShowPopup = "NO".
        END.

        /* Only check for ShowPopups = NO. If it is YES, create the popup. */
        IF cShowPopup EQ "NO":U THEN 
        DO:
            ASSIGN hWidget = hWidget:NEXT-SIBLING.
            NEXT widget-walk.
        END.    /* ShowPopup is NO */
        ELSE
            IF cShowPopup NE "YES":U THEN 
            DO:
                /* By default there is no popup for integer widgets. */
                IF CAN-QUERY(hWidget, "DATA-TYPE":U) AND
                   hWidget:DATA-TYPE  EQ "INTEGER":U 
                THEN DO:
                    ASSIGN hWidget = hWidget:NEXT-SIBLING.
                    NEXT widget-walk.
                END.    /* integer default. */

                /* Kept for backwards compatability. */
                IF (phFrame:PRIVATE-DATA NE ? AND INDEX(phFrame:PRIVATE-DATA, "NoLookups":U) NE 0) OR
                   (hWidget:PRIVATE-DATA NE ? AND INDEX(hWidget:PRIVATE-DATA, "NoLookups":U) NE 0) THEN
                DO:
                    ASSIGN hWidget = hWidget:NEXT-SIBLING.
                    NEXT widget-walk.
                END.    /* NOLOOKUPS set in private data */
            END.    /* default */

        /* create a lookup button for pop-up calendar or calculator */
        CREATE BUTTON hLookup
            ASSIGN FRAME         = phFrame
                   NO-FOCUS      = TRUE
                   WIDTH-PIXELS  = 15
                   LABEL         = "...":U
                   PRIVATE-DATA  = "POPUP":U 
                   HIDDEN        = FALSE
            /* this is curretly called AFTER enableObjects, so ensure  
               the popup has the right state */      
                   SENSITIVE     = hWidget:SENSITIVE 
                                   AND CAN-SET(hWidget,'READ-ONLY':U) 
                                   AND NOT hWidget:READ-ONLY
            TRIGGERS:
                ON CHOOSE PERSISTENT RUN runLookup IN gshSessionManager (INPUT hWidget).
            END TRIGGERS.
        /* The lookup widget should be placed outside of the fill-in.  If the frame width is exceeded, widen it. */
        IF plPopupsInFields = NO THEN 
        DO:
            ASSIGN hLookup:HEIGHT-PIXELS = hWidget:HEIGHT-PIXELS - 4
                   hLookup:Y             = hWidget:Y + 2.

            IF hWidget:COLUMN + hWidget:WIDTH-CHARS + hLookup:WIDTH-CHARS > phFrame:WIDTH
            THEN DO:
                /* We're going to widen the frame to make space for the button. */
                RUN increaseFrameforPopup (INPUT phObject,
                                           INPUT phFrame,
                                           INPUT hLookup,
                                           INPUT hWidget).
            END.
            ELSE
                ASSIGN hLookup:X = hWidget:X + hWidget:WIDTH-PIXELS - 3.

            ASSIGN hWidget:WIDTH-PIXELS = hWidget:WIDTH-PIXELS + 14.
        END.
        ELSE
            ASSIGN hLookup:HEIGHT-PIXELS = hWidget:HEIGHT-PIXELS - 4
                   hLookup:Y             = hWidget:Y + 2
                   hWidget:WIDTH-PIXELS  = hWidget:WIDTH-PIXELS
                   hLookup:X             = (hWidget:X + hWidget:WIDTH-PIXELS) - 17.

        hLookup:MOVE-TO-TOP().
        IF VALID-HANDLE(hLookup) THEN
          ASSIGN 
           cFieldPopupMapping = cFieldPopupMapping
                              + (IF cFieldPopupMapping = "":U THEN "":U ELSE ",":U)
                              + STRING(hWidget)
                              + ",":U
                              + STRING(hLookup).
        /* Add F4 trigger to widget */
        ON F4 OF hWidget PERSISTENT RUN runLookup IN gshSessionManager (hWidget).
    END. /* setup of lookups */
    ASSIGN hWidget = hWidget:NEXT-SIBLING.
  END. /* widget-walk */
  /* Store the mapping of fields and popup handles */
  IF cFieldPopupMapping > '':U THEN
    DYNAMIC-FUNCTION('setFieldPopupMapping':U IN phObject,cFieldPopupMapping) NO-ERROR.   

  /* translate widgets */
  IF lObjectTranslated NE YES AND pcAction = "setup":U AND CAN-FIND(FIRST ttTranslate) THEN
    RUN translateWidgets (INPUT phobject, INPUT phFrame, INPUT TABLE ttTranslate).

END.  /* valid-handle(phframe) */

/* Now we need to set the Secured fields for objects that are not SmartDataBrowsers.  
   SmartDataBrowsers support field security for its browse columns only.  */
IF lObjectSecured NE YES AND cFieldSecurity <> "":U AND cObjectType NE "SmartDataBrowser":U THEN
  DYNAMIC-FUNCTION("setFieldSecurity" IN phObject, cFieldSecurity) NO-ERROR.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addAsSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addAsSuperProcedure Procedure 
FUNCTION addAsSuperProcedure RETURNS LOGICAL
    ( INPUT phSuperProcedure        AS HANDLE,
      INPUT phProcedure             AS HANDLE   ) :
/*------------------------------------------------------------------------------
  Purpose:  Adds a procedure (phSuperProcedure) and all of its super procedures
            to a specified procedure (phProcedure).
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hSuperProcedure         AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE iLoop                   AS INTEGER                  NO-UNDO.

    DO iLoop = NUM-ENTRIES(phSuperProcedure:SUPER-PROCEDURES) TO 1 BY -1:
        ASSIGN hSuperProcedure = WIDGET-HANDLE(ENTRY(iLoop, phSuperProcedure:SUPER-PROCEDURES)) NO-ERROR.

        IF VALID-HANDLE(hSuperProcedure) THEN
            phProcedure:ADD-SUPER-PROCEDURE(hSuperProcedure, SEARCH-TARGET).
    END.    /* loop through all the super procedures */

    /* Add this procedure as a super. */
    phProcedure:ADD-SUPER-PROCEDURE(phSuperProcedure, SEARCH-TARGET).

    RETURN FALSE.   /* Function return value. */  
END FUNCTION.   /* addAsSuperProcedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-filterEvaluateOuterJoins) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION filterEvaluateOuterJoins Procedure 
FUNCTION filterEvaluateOuterJoins RETURNS CHARACTER
  (pcQueryString  AS CHARACTER,
   pcFilterFields AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:     When we're filtering on OUTER-JOINs in a browser, Dynamics removes\
               the OUTER-JOIN keyword to ensure we do actually filter.  This procedure
               accepts a query, and a list of fields.  It will check if the fields
               apply to an OUTER-JOIN and remove it if so.
  Parameters:  pcQueryString  - The query to evaluate.
               pcFilterFields - Comma delimited list of fields.  <table>.<field>,<table.field>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cFilterFieldBuffers AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cNewQueryString     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOuterJoinEntry     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentEntry       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBuffers            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWord               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iQueryLine          AS INTEGER    NO-UNDO.
DEFINE VARIABLE iEntry              AS INTEGER    NO-UNDO.
DEFINE VARIABLE iWord               AS INTEGER    NO-UNDO.
DEFINE VARIABLE lEachFirstLast      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lFoundBuffer        AS LOGICAL    NO-UNDO.

/* Step through the Query by each buffer / table entry */
DO iEntry = 1 TO NUM-ENTRIES(pcQueryString):
    ASSIGN cCurrentEntry  = ENTRY(iEntry, pcQueryString)
           cCurrentEntry  = REPLACE(cCurrentEntry, CHR(10), " ":U) WHEN INDEX(cCurrentEntry, CHR(10)) <> 0
           cCurrentEntry  = REPLACE(cCurrentEntry, CHR(13), " ":U) WHEN INDEX(cCurrentEntry, CHR(13)) <> 0
           lEachFirstLast = FALSE
           lFoundBuffer   = FALSE.
    
    /* If the Entry contains the OUTER-JOIN keyword, continue */
    IF INDEX(cCurrentEntry, "OUTER-JOIN":U) <> 0 
    THEN DO iWord = 1 TO NUM-ENTRIES(cCurrentEntry, " ":U):
        ASSIGN cWord = ENTRY(iWord, cCurrentEntry, " ":U).
    
        /* Set the lEachFirstLast flag when the EACH, FIRST or LAST keywords are encountered */
        IF TRIM(cWord) = "EACH":U  
        OR TRIM(cWord) = "FIRST":U 
        OR TRIM(cWord) = "LAST":U THEN
            ASSIGN lEachFirstLast = TRUE.
        ELSE
            IF TRIM(cWord) <> "":U AND lEachFirstLast = TRUE THEN
              /* Found the table name */
              ASSIGN cOuterJoinEntry = cOuterJoinEntry + (IF TRIM(cOuterJoinEntry) = "":U THEN "":U ELSE ",":U) + STRING(iEntry)
                     cBuffers        = cBuffers        + (IF TRIM(cBuffers)        = "":U THEN "":U ELSE ",":U) + cWord
                     lFoundBuffer    = TRUE.
    
        IF lFoundBuffer = TRUE THEN LEAVE.
    END.
END.

/* Ensure the variable is empty for the next steps */
ASSIGN cWord = "":U.

/* Pick up to which 'buffer line' in the query do we need to replace OUTER-JOINs with '' */
IF TRIM(pcFilterFields) <> "":U 
THEN DO iEntry = 1 TO NUM-ENTRIES(cBuffers):
    ASSIGN cCurrentEntry = ENTRY(iEntry, cBuffers).
    
    DO iWord = 1 TO NUM-ENTRIES(pcFilterFields):
        IF ENTRY(1, ENTRY(iWord, pcFilterFields), ".":U) = cCurrentEntry THEN
            cWord = cCurrentEntry.
    END.
END.

IF cWord <> "":U 
THEN DO:
    ASSIGN iQueryLine = INTEGER(ENTRY(LOOKUP(cWord, cBuffers), cOuterJoinEntry)).
    
    /* Remove the OUTER-JOIN keyword from the relevant strings */
    DO iEntry = 1 TO NUM-ENTRIES(pcQueryString):
        ASSIGN cCurrentEntry = ENTRY(iEntry, pcQueryString).
    
        IF INDEX(cCurrentEntry, "OUTER-JOIN":U) <> 0 AND iEntry <= iQueryLine THEN
            cCurrentEntry = REPLACE(cCurrentEntry, "OUTER-JOIN":U, "":U).
    
        ASSIGN cNewQueryString = cNewQueryString +  (IF TRIM(cNewQueryString) = "":U THEN "":U ELSE ",":U) + cCurrentEntry.
    END.
END.
ELSE
    cNewQueryString = pcQueryString.

RETURN cNewQueryString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fixQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fixQueryString Procedure 
FUNCTION fixQueryString RETURNS CHARACTER
  ( INPUT pcQueryString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: To check for non-Decimal point decimal places in query string and replace 
           with full stops to resolve issues when running with non-American numeric
           formats selected.
    Notes: Whereever a query prepare is being used, this procedure should first
           be called to resolve any issues in the query string, such as decimal
           formatting.
           The main issues arise when the query string contains stringed decimal
           values.
------------------------------------------------------------------------------*/
    /* Don't bother if we are using American decimal format. */
    IF SESSION:NUMERIC-DECIMAL-POINT EQ ".":U THEN
        RETURN pcQueryString.

    DEFINE VARIABLE iPosn                   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cBefore                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cAfter                  AS CHARACTER  NO-UNDO.

    ASSIGN iPosn = INDEX(pcQueryString, SESSION:NUMERIC-DECIMAL-POINT).

    comma-loop:
    REPEAT WHILE iPosn <> 0 AND iPosn <> ?:
        ASSIGN cBefore = "":U
               cAfter  = "":U
               .
        IF iPosn > 1 THEN
            ASSIGN cBefore = SUBSTRING(pcQueryString, iPosn - 1,1).
        IF iPosn < LENGTH(pcQueryString) THEN
            ASSIGN cAfter = SUBSTRING(pcQueryString, iPosn + 1,1).

        IF cBefore >= "0":U AND cBefore <= "9":U AND
           cAfter  >= "0":U AND cAfter  <= "9":U THEN
        DO:
            /* See if it is not quoted and thus needs to be changed */
            IF DYNAMIC-FUNCTION("isObjQuoted":U, pcQueryString, iPosn) = FALSE THEN
                SUBSTRING(pcQueryString,iPosn,1) = ".":U.
        END.
        
        ASSIGN iPosn = INDEX(pcQueryString, SESSION:NUMERIC-DECIMAL-POINT, iPosn + 1).
    END.  /* sesion decimal point loop */

    RETURN pcQueryString.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentLogicalName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentLogicalName Procedure 
FUNCTION getCurrentLogicalName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gcLogicalContainerName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInternalEntryExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInternalEntryExists Procedure 
FUNCTION getInternalEntryExists RETURNS LOGICAL
  ( INPUT phProcedure           AS HANDLE,
    INPUT pcProcedureName       AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Checks whether a procedure or function exists for a given handle
    Notes:  * If the procedure handle is a proxy handle for a persistent
              procedure running remotely in the context of a Progress
              AppServer the :PROXY attribute will be true. If not, it
              will be false. 
            * We want to know this because we cannot read the :INTERNAL-
              ENTRIES attribute of procedures which are running remotely.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iEntryNumber                AS INTEGER              NO-UNDO.
    DEFINE VARIABLE cInternalEntries            AS CHARACTER            NO-UNDO.

    DEFINE BUFFER ttPersistentProc FOR ttPersistentProc.

    IF VALID-HANDLE(phProcedure) THEN
        IF phProcedure:PROXY 
        THEN DO:
            /* When a procedure is launched, we store the internal entries in the temp-table. *
             * See if we can find the entry in there first                                    */

            FIND FIRST ttPersistentProc
                 WHERE ttPersistentProc.physicalName = phProcedure:FILE-NAME
                   AND ttPersistentProc.onAppserver  = YES
                 NO-ERROR.

            IF AVAILABLE ttPersistentProc THEN
                ASSIGN iEntryNumber = LOOKUP(pcProcedureName, ttPersistentProc.internalEntries).

            /* Can't find the entry in the temp-table, retrieve from the Appserver */

            IF iEntryNumber = 0 OR iEntryNumber = ? 
            THEN DO:
                ASSIGN cInternalEntries = DYNAMIC-FUNCTION("getInternalEntries":U IN phProcedure) NO-ERROR.
                ASSIGN iEntryNumber = LOOKUP(pcProcedureName, cInternalEntries) WHEN cInternalEntries <> ?.
            END.
        END.    /* procedure is a proxy: running on AppServer */
        ELSE
            ASSIGN iEntryNumber = LOOKUP(pcProcedureName, phProcedure:INTERNAL-ENTRIES).

    RETURN ( iEntryNumber > 0 ).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPropertyList Procedure 
FUNCTION getPropertyList RETURNS CHARACTER
  ( INPUT pcPropertyList AS CHARACTER,
    INPUT plSessionOnly AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     To retrieve properties from local temp-table if available, otherwise
               via server side Session Manager from context database.
  Parameters:  input comma delimited list of properties whose value you wish to retrieve.
  Notes:       Returns a CHR(3) delimited list of corresponding property values.
               The local cache temp-table is only checked when running client side.
               If the session only flag is set to YES then the database is not checked
               if running client side.
               If the server side routine is running client side due to not being connected
               to the appserver, then also do not check context database as all properties
               will be set in the local temp-table.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDbPropertyList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDbValueList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturnValues   AS CHARACTER  NO-UNDO.

  /* First ensure the value list has a corresponding entry for every property */
  ASSIGN cReturnValues = FILL(CHR(3), NUM-ENTRIES(pcPropertyList) - 1).

  /* Properties to get from the database */
  IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
    ASSIGN
      cDbPropertyList = pcPropertyList
      cDbValueList = cReturnValues.
  ELSE
    ASSIGN
      cDbPropertyList = "":U
      cDbValueList = "":U.
      .

  /* Read cached values + build list of values to get from server if required */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
  cache-loop:
  DO iLoop = 1 TO NUM-ENTRIES(pcPropertyList):
    ASSIGN cProperty = TRIM(ENTRY(iLoop,pcPropertyList)).
    FIND FIRST ttProperty
         WHERE ttProperty.propertyName = cProperty
         NO-ERROR.
    IF AVAILABLE ttProperty THEN
      ENTRY(iLoop,cReturnValues,CHR(3)) = ttProperty.propertyValue. 
    ELSE
      ASSIGN cDbPropertyList = cDbPropertyList +
                               (IF cDbPropertyList = "":U THEN "":U ELSE ",":U) +
                               cProperty.
  END.  /* cache-loop */

  /* get properties from database if required */
  &IF DEFINED(server-side) <> 0 &THEN
    IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) AND cDbPropertyList <> "":U THEN
    DO:
      RUN afgetprplp (INPUT cDbPropertyList,
                      OUTPUT cDbValueList).  
    END.
  &ELSE
    IF NOT plSessionOnly AND cDbPropertyList <> "":U THEN
    DO:
      RUN af/app/afgetprplp.p ON gshAstraAppserver (INPUT cDbPropertyList,
                                                    OUTPUT cDbValueList).
    END.
  &ENDIF

  /* Update database values into returned value list */
  IF cDbPropertyList = pcPropertyList THEN
    ASSIGN cReturnValues = cDbValueList.
  ELSE
  db-loop:
  DO iLoop = 1 TO NUM-ENTRIES(cDbPropertyList):
    ASSIGN
      cProperty = TRIM(ENTRY(iLoop,cDbPropertyList))
      iEntry = LOOKUP(cProperty,pcPropertyList)
      .
    IF iEntry > 0 AND iEntry <= NUM-ENTRIES(cReturnValues, CHR(3)) THEN
      ENTRY(iEntry,cReturnValues,CHR(3)) = ENTRY(iLoop,cDbValueList, CHR(3)). 
  END.  /* db-loop */

  RETURN cReturnValues.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isObjQuoted) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isObjQuoted Procedure 
FUNCTION isObjQuoted RETURNS LOGICAL
  (INPUT pcQueryString  AS CHARACTER,
   INPUT piPosition     AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose: Looks at the object number in the query string and determines whether
           or not it is wrapped in quotes

    Notes: This is needed when running the application in European format. If an
           object number is in quotes and we are in European mode / format, the
           object number must remain with a comma in the quotes, i.e. '12345678,02'
           to convert properly to a decimal. If it is not quoted however, then
           the comma must be replaced by a '.', i.e. ...obj = 12345678,02, FIRST ...
           must be replaced with ...obj = 12345678.02, FIRST ... to ensure that
           the query resolves properly. The replace will be done by 'fixQueryString',
           which calls this function to establish whether or not to replace the object
           number's decimal seperator based on whether it is quoted or not
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAllowedCharacters  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCharacter          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQuotedInFront      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lQuotedBehind       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lObjQuoted          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFinished           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCounter            AS INTEGER    NO-UNDO.

  ASSIGN
      cAllowedCharacters = "1234567890 ":U + "'" + '"':U + CHR(10) + CHR(13)
      lQuotedInFront     = FALSE
      lQuotedBehind      = FALSE
      lObjQuoted         = FALSE.

  /* Read forward through the string */
  IF LENGTH(pcQueryString) >= piPosition THEN
  DO:
    ASSIGN
        lFinished = FALSE
        iCounter  = piPosition.

    DO WHILE lFinished = FALSE:
      ASSIGN
          iCounter   = iCounter + 1.
          cCharacter = SUBSTRING(pcQueryString, iCounter, 1).

      IF INDEX(cAllowedCharacters, cCharacter) <> 0 AND
         (cCharacter = "'":U OR cCharacter = '"':U) THEN
        ASSIGN
            lQuotedBehind = TRUE
            lFinished     = TRUE.

      IF iCounter >= LENGTH(pcQueryString) THEN lFinished = TRUE.
    END.
  END.

  /* Read backward through the string */
  IF piPosition > 1 THEN
  DO:
    ASSIGN
        lFinished = FALSE
        iCounter  = piPosition.

    DO WHILE lFinished = FALSE:
      ASSIGN
          iCounter   = iCounter - 1.
          cCharacter = SUBSTRING(pcQueryString, iCounter, 1).

      IF INDEX(cAllowedCharacters, cCharacter) <> 0 AND
         (cCharacter = "'":U OR cCharacter = '"':U) THEN
        ASSIGN
            lQuotedInFront = TRUE
            lFinished      = TRUE.

      IF iCounter <= 1 THEN lFinished = TRUE.
    END.
  END.

  IF lQuotedInFront AND lQuotedBehind THEN
    lObjQuoted = TRUE.

  RETURN lObjQuoted.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPropertyList Procedure 
FUNCTION setPropertyList RETURNS LOGICAL
  ( INPUT pcPropertyList AS CHARACTER,
    INPUT pcPropertyValues AS CHARACTER,
    INPUT plSessionOnly AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     To set properties in local temp-table if available, then
               via server side Session Manager procedure into context database.
  Parameters:  input comma delimited list of property names whose value you wish to set.
               input CHR(3) delimited list of corresponding property values.
               input this session only flag. If set to YES, only stores property
               on the client, and creates temp-table record if it does not
               exist.
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProperty       AS CHARACTER  NO-UNDO.

  /* First update cache temp-table with all properties */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
  cache-loop:
  DO iLoop = 1 TO NUM-ENTRIES(pcPropertyList):
    ASSIGN cProperty = TRIM(ENTRY(iLoop,pcPropertyList)).

    FIND FIRST ttProperty
         WHERE ttProperty.propertyName = cProperty
         NO-ERROR.

    /* if server side routine running on client due to no appserver connection, then
       only use temp-table cache for all properties
    */
    &IF DEFINED(server-side) <> 0 &THEN
      IF NOT AVAILABLE ttProperty THEN
      DO:
        CREATE ttProperty.
        ASSIGN
          ttProperty.propertyName = cProperty.
      END.
    &ENDIF

    IF plSessionOnly AND NOT AVAILABLE ttProperty THEN
    DO:
      CREATE ttProperty.
      ASSIGN
        ttProperty.propertyName = cProperty.
    END.

    IF AVAILABLE ttProperty THEN
      ASSIGN ttProperty.propertyValue = ENTRY(iLoop,pcPropertyValues,CHR(3)).

  END.  /* cache-loop */

  /* Then update database with all properties if required */
  &IF DEFINED(server-side) <> 0 &THEN
    IF (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
    DO:
      RUN afsetprplp (INPUT pcPropertyList,
                      INPUT pcPropertyValues).  
    END.
  &ELSE
    IF NOT plSessionOnly THEN
    DO:
      RUN af/app/afsetprplp.p ON gshAstraAppserver (INPUT pcPropertyList,
                                                    INPUT pcPropertyValues).
    END.
  &ENDIF

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSecurityForDynObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSecurityForDynObjects Procedure 
FUNCTION setSecurityForDynObjects RETURNS CHARACTER
  ( INPUT phWidget          AS HANDLE,
    INPUT pcSecuredFields   AS CHARACTER,
    INPUT pcDisplayedFields AS CHARACTER,
    INPUT pcFieldSecurity   AS CHARACTER,
    INPUT phViewer          AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  This function will set security properties for Dynamic Lookups and
            Dynamic Combos.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iFieldPos     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFieldName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFrameHandle  AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE iSDFLoop           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cContainerTargets  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSDFHandle         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hSDFFrameHandle    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrameProc         AS HANDLE    NO-UNDO.

  cContainerTargets = DYNAMIC-FUNCTION("linkHandles":U IN phViewer, "Container-Target":U) NO-ERROR.

  /* To move away from reading the procedure handle from the 
     frame's PRIVATE-DATA we are checking that the FRAME we
     are reading is indeed that of an SDF and that the handle
     of this FRAME is one of the SDF's found from the Container 
     Target list. This checks that we are assigning the handle 
     of the current frame's procedure handle and not any other
     SDF's that might be on the viewer. */
  hFrameProc = ?.
  SDF_LOOP:
  DO iSDFLoop = 1 TO NUM-ENTRIES(cContainerTargets):
    hSDFHandle = WIDGET-HANDLE(ENTRY(iSDFLoop,cContainerTargets)).
    IF VALID-HANDLE(hSDFHandle) THEN
      hSDFFrameHandle = DYNAMIC-FUNCTION("getSDFFrameHandle":U IN hSDFHandle) NO-ERROR.
    IF phWidget = hSDFFrameHandle THEN DO:
      hFrameProc = hSDFHandle.
      LEAVE SDF_LOOP.
    END.
  END.
  
  IF hFrameProc = ? THEN
    RETURN pcFieldSecurity. 
  

  ASSIGN phWidget = hFrameProc.
  
  IF NOT VALID-HANDLE(phWidget) OR 
     phWidget:TYPE <> "PROCEDURE":U THEN
    RETURN pcFieldSecurity. 

  /* Find the position of the Dynamic Object in the field list */
  iFieldPos = LOOKUP(STRING(hFrameProc),pcDisplayedFields).
  IF iFieldPos = ? THEN
    iFieldPos = 0.
  /* Run a function to get the field name from the Dynamic Object */
  IF LOOKUP("getFieldName":U,phWidget:INTERNAL-ENTRIES) > 0 THEN
    cFieldName = DYNAMIC-FUNCTION("getFieldName":U IN phWidget) NO-ERROR.
  /* If the function could not be found or the field name is blank - return */
  IF cFieldName = "":U THEN
    RETURN pcFieldSecurity. 

  /* Check if the field is secured - if not - Return */
  ASSIGN iEntry = LOOKUP(cFieldName,pcSecuredFields).
  IF iEntry = 0 THEN
    RETURN pcFieldSecurity. 

  CASE ENTRY(iEntry + 1, pcSecuredFields):
    WHEN "hidden":U THEN
      IF iFieldPos <> 0 THEN
        ENTRY(iFieldPos,pcFieldSecurity) = "Hidden":U NO-ERROR.
    WHEN "Read Only":U THEN
      IF iFieldPos <> 0 THEN
        ENTRY(iFieldPos,pcFieldSecurity) = "ReadOnly":U NO-ERROR.
  END CASE.
  
  RETURN pcFieldSecurity.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

