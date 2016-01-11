&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" dTables _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDataObjectWizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* SmartDataObject Wizard
Welcome to the SmartDataObject Wizard! During the next few steps, the wizard will lead you through creating a SmartDataObject. You will define the query that you will use to retrieve data from your database(s) and define a set of field values to make available to visualization objects. Press Next to proceed.
adm2/support/_wizqry.w,adm2/support/_wizfld.w 
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
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
  File: rysttasdoo.w

  Description:  Template SmartDataObject Template

  Purpose:      Template SmartDataObject Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

--------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gscpdfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

&glob DATA-LOGIC-PROCEDURE       ry/obj/gscpdlogcp.p

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gsc_package_dataset gsc_deploy_dataset ~
gsc_deploy_package

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  deploy_dataset_obj deploy_package_obj deploy_full_data
&Scoped-define ENABLED-FIELDS-IN-gsc_package_dataset deploy_dataset_obj ~
deploy_package_obj deploy_full_data 
&Scoped-Define DATA-FIELDS  package_dataset_obj deploy_dataset_obj deploy_package_obj package_code~
 package_description deploy_full_data dataset_code dataset_description~
 default_ado_filename
&Scoped-define DATA-FIELDS-IN-gsc_package_dataset package_dataset_obj ~
deploy_dataset_obj deploy_package_obj deploy_full_data 
&Scoped-define DATA-FIELDS-IN-gsc_deploy_dataset dataset_code ~
dataset_description default_ado_filename 
&Scoped-define DATA-FIELDS-IN-gsc_deploy_package package_code ~
package_description 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/gscpdfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsc_package_dataset NO-LOCK, ~
      FIRST gsc_deploy_dataset WHERE gsc_deploy_dataset.deploy_dataset_obj = gsc_package_dataset.deploy_dataset_obj NO-LOCK, ~
      FIRST gsc_deploy_package WHERE gsc_deploy_package.deploy_package_obj = gsc_package_dataset.deploy_package_obj NO-LOCK ~
    BY gsc_package_dataset.package_dataset_obj INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsc_package_dataset NO-LOCK, ~
      FIRST gsc_deploy_dataset WHERE gsc_deploy_dataset.deploy_dataset_obj = gsc_package_dataset.deploy_dataset_obj NO-LOCK, ~
      FIRST gsc_deploy_package WHERE gsc_deploy_package.deploy_package_obj = gsc_package_dataset.deploy_package_obj NO-LOCK ~
    BY gsc_package_dataset.package_dataset_obj INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsc_package_dataset ~
gsc_deploy_dataset gsc_deploy_package
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsc_package_dataset
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_deploy_dataset
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main gsc_deploy_package


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsc_package_dataset, 
      gsc_deploy_dataset
    FIELDS(gsc_deploy_dataset.dataset_code
      gsc_deploy_dataset.dataset_description
      gsc_deploy_dataset.default_ado_filename), 
      gsc_deploy_package
    FIELDS(gsc_deploy_package.package_code
      gsc_deploy_package.package_description) SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.62
         WIDTH              = 57.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _TblList          = "ICFDB.gsc_package_dataset,ICFDB.gsc_deploy_dataset WHERE ICFDB.gsc_package_dataset ...,ICFDB.gsc_deploy_package WHERE ICFDB.gsc_package_dataset ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION "
     _TblOptList       = ", FIRST USED, FIRST USED"
     _OrdList          = "ICFDB.gsc_package_dataset.package_dataset_obj|yes"
     _JoinCode[2]      = "ICFDB.gsc_deploy_dataset.deploy_dataset_obj = ICFDB.gsc_package_dataset.deploy_dataset_obj"
     _JoinCode[3]      = "ICFDB.gsc_deploy_package.deploy_package_obj = ICFDB.gsc_package_dataset.deploy_package_obj"
     _FldNameList[1]   > ICFDB.gsc_package_dataset.package_dataset_obj
"package_dataset_obj" "package_dataset_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 24 yes
     _FldNameList[2]   > ICFDB.gsc_package_dataset.deploy_dataset_obj
"deploy_dataset_obj" "deploy_dataset_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 24 yes
     _FldNameList[3]   > ICFDB.gsc_package_dataset.deploy_package_obj
"deploy_package_obj" "deploy_package_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 24 yes
     _FldNameList[4]   > ICFDB.gsc_deploy_package.package_code
"package_code" "package_code" ? ? "character" ? ? ? ? ? ? no ? no 20 yes
     _FldNameList[5]   > ICFDB.gsc_deploy_package.package_description
"package_description" "package_description" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[6]   > ICFDB.gsc_package_dataset.deploy_full_data
"deploy_full_data" "deploy_full_data" ? ? "logical" ? ? ? ? ? ? yes ? no 1 no
     _FldNameList[7]   > ICFDB.gsc_deploy_dataset.dataset_code
"dataset_code" "dataset_code" ? ? "character" ? ? ? ? ? ? no ? no 13 yes
     _FldNameList[8]   > ICFDB.gsc_deploy_dataset.dataset_description
"dataset_description" "dataset_description" ? ? "character" ? ? ? ? ? ? no ? no 500 yes
     _FldNameList[9]   > ICFDB.gsc_deploy_dataset.default_ado_filename
"default_ado_filename" "default_ado_filename" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _Design-Parent    is WINDOW dTables @ ( 1.14 , 2.6 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

