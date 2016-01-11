&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
/*--------------------------------------------------------------------------
    File        : dvisprop.i
    Purpose     : Property Include file for Data Visualization Objects 

    Syntax      : src\adm2\dvisprop.i

    Description :

    Modified    : May 26, 2000 -- Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}~
DataSourceNames,UpdateTargetNames,LogicalObjectName 

  {src/adm2/custom/datavisdefscustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */


  /* Include the file which defines prototypes for all of the super
     procedure's entry points. Also, start or attach to the super procedure.
     Skip start-super-proc if we *are* the super procedure. 
     And skip including the prototypes if we are *any* super procedure. */
&IF "{&ADMSuper}":U EQ "":U &THEN
  {src/adm2/dvisprto.i}
&ENDIF

  /* These preprocessors tell at compile time which properties can be
     retrieved directly from the property temp-table. */
  &GLOBAL-DEFINE xpFieldsEnabled         
  &GLOBAL-DEFINE xpDisplayedFields       
  &GLOBAL-DEFINE xpEnabledHandles        
  &GLOBAL-DEFINE xpCreateHandles         
  &GLOBAL-DEFINE xpEnabledFields         
  &GLOBAL-DEFINE xpFieldHandles          
  &GLOBAL-DEFINE xpTableIOSource         
  &GLOBAL-DEFINE xpTableIOSourceEvents   
  &GLOBAL-DEFINE xpSaveSource            
  &GLOBAL-DEFINE xpRecordState           
  &GLOBAL-DEFINE xpUpdateTarget          
  &GLOBAL-DEFINE xpGroupAssignSource     
  &GLOBAL-DEFINE xpGroupAssignTarget     
  &GLOBAL-DEFINE xpGroupAssignSourceEvents 
  &GLOBAL-DEFINE xpGroupAssignTargetEvents 
  &GLOBAL-DEFINE xpDisplayedTables
  &GLOBAL-DEFINE xpWindowTitleField
  &GLOBAL-DEFINE xpObjectMode
  /* Include the next property file up the chain; we will add our field
     definitions to its list. As of 9.1A, if this visual object is also
     a SmartContainer, we include container properties as well. */

&IF DEFINED(ADM-CONTAINER) NE 0 &THEN
  {src/adm2/cntnprop.i}
&ELSE
  {src/adm2/visprop.i}
&ENDIF

IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('FieldsEnabled':U, 'LOGICAL':U, 0, ?, no). 
  ghADMProps:ADD-NEW-FIELD('Editable':U, 'LOGICAL':U, 0, ?, ?). 
  ghADMProps:ADD-NEW-FIELD('DataModified':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('NewRecord':U, 'CHAR':U, 0, ?, 'No':U). /* Values: Add, Copy, No */
  ghADMProps:ADD-NEW-FIELD('RowIdent':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DisplayedFields':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('EnabledHandles':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CreateHandles':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('EnabledFields':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldHandles':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('TableIOSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('TableIOSourceEvents':U, 'CHAR':U, 0, ?, 
    'addRecord,updateRecord,copyRecord,deleteRecord,resetRecord,cancelRecord,updateMode,toolbar':U).
  ghADMProps:ADD-NEW-FIELD('SaveSource':U, 'LOGICAL':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RecordState':U, 'CHAR':U, 0, ?, 'NoRecordAvailable':U).
  ghADMProps:ADD-NEW-FIELD('UpdateTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('GroupAssignSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('GroupAssignTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('GroupAssignSourceEvents':U, 'CHAR':U, 0, ?, 
    'addRecord,copyRecord,updateRecord,resetRecord,cancelRecord,enableFields,disableFields,collectChanges,validateFields':U).
  ghADMProps:ADD-NEW-FIELD('GroupAssignTargetEvents':U, 'CHAR':U, 0, ?, 'updateState,LinkState':U).
  ghADMProps:ADD-NEW-FIELD('DisplayedTables':U, 'CHAR':U, 0, ?, 
  &IF "{&DISPLAYED-TABLES}":U NE "":U &THEN
    REPLACE("{&DISPLAYED-TABLES}":U, " ":U, ",":U)).
  &ELSE
    REPLACE("{&INTERNAL-TABLES}":U, " ":U, ",":U)).
  &ENDIF
  ghADMProps:ADD-NEW-FIELD('UpdateTargetNames':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('WindowTitleField':U, 'CHARACTER':U).  
  ghADMProps:ADD-NEW-FIELD('ObjectMode':U,'CHARACTER':U, 0, ?, 'View':U).  
  ghADMProps:ADD-NEW-FIELD('EnabledObjFldsToDisable':U,'CHARACTER':U, 0, ?, ?).  
&ENDIF

  {src/adm2/custom/dvispropcustom.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

