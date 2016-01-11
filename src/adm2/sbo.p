&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*--------------------------------------------------------------------------
    File        : sbo.p
    Purpose     : Super procedure for sbo class.

    Syntax      : RUN start-super-proc("adm2/sbo.p":U).

    Modified    : December 8, 2000 -- Version 9.1B+
    Modified    : 16/11/2001    Mark Davies (MIP)
                  Added new property FilterAvailable
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper sbo.p

DEFINE VARIABLE ghTargetProcedure AS HANDLE     NO-UNDO.

/* Custom exclude file */

  {src/adm2/custom/sboexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addQueryWhere Procedure 
FUNCTION addQueryWhere RETURNS LOGICAL
  ( pcWhere  AS CHARACTER, 
    pcObject AS CHARACTER, 
    pcAndOr  AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addRow Procedure 
FUNCTION addRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-appendContainedObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD appendContainedObjects Procedure 
FUNCTION appendContainedObjects RETURNS LOGICAL PRIVATE
  ( INPUT-OUTPUT pcObjects AS CHARACTER, INPUT phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyContextFromServer Procedure 
FUNCTION applyContextFromServer RETURNS LOGICAL
  ( pcContext AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignCurrentMappedObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignCurrentMappedObject Procedure 
FUNCTION assignCurrentMappedObject RETURNS LOGICAL
  ( phRequester  AS HANDLE, 
    pcObjectName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignQuerySelection Procedure 
FUNCTION assignQuerySelection RETURNS LOGICAL
  ( pcColumns AS CHARACTER, pcValues AS CHARACTER, pcOperators AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cancelRow Procedure 
FUNCTION cancelRow RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canNavigate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canNavigate Procedure 
FUNCTION canNavigate RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnColumnLabel Procedure 
FUNCTION columnColumnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDbColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDbColumn Procedure 
FUNCTION columnDbColumn RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnExtent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnExtent Procedure 
FUNCTION columnExtent RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnMandatory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnMandatory Procedure 
FUNCTION columnMandatory RETURNS LOGICAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnModified Procedure 
FUNCTION columnModified RETURNS LOGICAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnObjectHandle Procedure 
FUNCTION columnObjectHandle RETURNS HANDLE
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnPrivateData Procedure 
FUNCTION columnPrivateData RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnProperty Procedure 
FUNCTION columnProperty RETURNS CHARACTER PRIVATE
  ( pcColumn AS CHARACTER, pcProperty AS CHARACTER, phTarget AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnQuerySelection Procedure 
FUNCTION columnQuerySelection RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValExp Procedure 
FUNCTION columnValExp RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValue Procedure 
FUNCTION columnValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
    (pcColumns AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD copyRow Procedure 
FUNCTION copyRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-currentMappedObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD currentMappedObject Procedure 
FUNCTION currentMappedObject RETURNS CHARACTER
  (  phRequester AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataContainerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dataContainerHandle Procedure 
FUNCTION dataContainerHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dataObjectHandle Procedure 
FUNCTION dataObjectHandle RETURNS HANDLE
  ( pcObjectName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterAvailable Procedure 
FUNCTION getFilterAvailable RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateSiblings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateSiblings Procedure 
FUNCTION getUpdateSiblings RETURNS CHARACTER
  ( phDataObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasActiveAudit Procedure 
FUNCTION hasActiveAudit RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveComments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasActiveComments Procedure 
FUNCTION hasActiveComments RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasActiveTargets Procedure 
FUNCTION hasActiveTargets RETURNS LOGICAL
  ( phHandle     AS HANDLE,
    plCheckchild AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasForeignKeyChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasForeignKeyChanged Procedure 
FUNCTION hasForeignKeyChanged RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDataObjectOrdering Procedure 
FUNCTION initDataObjectOrdering RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-IsColumnListQualified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD IsColumnListQualified Procedure 
FUNCTION IsColumnListQualified RETURNS LOGICAL
  ( pcColumnNames AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDataObjectRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newDataObjectRow Procedure 
FUNCTION newDataObjectRow RETURNS CHARACTER
  ( pcMode        AS CHARACTER,
    pcTargetNames AS CHARACTER,
    pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD obtainContextForClient Procedure 
FUNCTION obtainContextForClient RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeQuerySelection Procedure 
FUNCTION removeQuerySelection RETURNS LOGICAL
  ( pcColumns AS CHARACTER, 
    pcOperators AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD repositionRowObject Procedure 
FUNCTION repositionRowObject RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetQuery Procedure 
FUNCTION resetQuery RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetRow Procedure 
FUNCTION resetRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD submitRow Procedure 
FUNCTION submitRow RETURNS LOGICAL
  ( pcRowIdent  AS CHARACTER, 
    pcValueList AS CHARACTER)  FORWARD.

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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 17.86
         WIDTH              = 52.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/sboprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addDataTarget Procedure 
PROCEDURE addDataTarget :
/*------------------------------------------------------------------------------
  Purpose:  Update the ObjectMapping property that are used to broker messages
            between contained objects and objects linked to the SBO and also 
            set DataSourceNames and UpdateTargetNames in the dataTarges.                
  Parameters:  <none>
  Notes:    Called from registerObject, which are subscribed as DataTargetEvent 
            and published from the DataTarget's initializeObject. 
          - DataSourceNames may be specified by the user in which case it 
            actually specifies how to generate the ObjectMapping. 
            If it's not set, we ensure that both it and UpdateTargetNames 
            is ALWAYS set here so that colValues, addRow, deleteRow and 
            updateRow etc. can identify the intended target or source without 
            looping through all the fields again and again.
          - Objects buildt against RowObject must find ALL columns in ONE
            of the ContainedDataObjects in order to become mapped. 
          - Only this procedure is allowed to add datatargets to the 
            ObjectMapping property.  
          - ObjectMapping versus DataSourceNames. Thee is some overlap here and
            we could certainly have managed add-, copy- and deleteRow with 
            ObjectMapping instead of DataSourceNames. But since both cases 
            requires that we know the requester anyways, there's not much 
            advantage of just using the ObjectMapping. We also do need a way to 
            distinguish between UpdateTargets and DataSources and having them 
            implemented the same ways makes it a bit easier to use. 
            Ideally (??) the SBO should be more transparent and have an API that
            makes it unnecessary for the SBO to have this mapping and instead 
            make the visual objects responsible of telling the SBO what to 
            update and for this reason the properties in the visual object seems
            to have a more certain future .. ()                     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phTarget AS HANDLE NO-UNDO. 
   
  /* These are the variables we are going to set the properties with */
  DEFINE VARIABLE cMapping            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateTargetNames  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSourceNames    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lSourceSpecified    AS LOGICAL    NO-UNDO.
  
  DEFINE VARIABLE hMaster             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSourceList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSource             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hUpdateTarget       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTargetList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTarget             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSource             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iTarget             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObjectList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataColumns        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledColumns     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdate             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cContainedColumns   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContainedObjects   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOColumns         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumn             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSourceFound        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSBOTarget          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataObjectNames    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignFields      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iUpdLoop            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hUpd                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOneToOne           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectType         AS CHARACTER  NO-UNDO.

    cTarget = STRING(phTarget).
    {get ObjectMapping cMapping}.
    
    /* Don't add if its already in the list */  
    IF LOOKUP(cTarget,cMapping) = 0 THEN
    DO:
      hTarget = WIDGET-HANDLE(cTarget).
      IF VALID-HANDLE(hTarget) THEN
      DO: 
        /* We also support SDOs/SBOs as data-targets */
        cObjectType = {fn getObjectType hTarget}.
        IF cObjectType = 'SmartDataObject':U OR cObjectType = 'SmartBusinessObject':U THEN
        DO:
          {get ForeignFields cForeignFields hTarget}.
          IF cForeignFields <> '':U THEN
          DO iColumn = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
              ASSIGN           /* 2nd of pair is source RowObject fld */
                cColumn     = ENTRY(iColumn + 1, cForeignFields)
                cObjectName = ENTRY(1,cColumn,".":U)
                hSource     = {fnarg dataObjectHandle cObjectName} NO-ERROR.            
             /* If this is truly one of the SBO's DataObjects 
                and not already in the DataSourceNames list then update the 
                mapping and the DataSourceNames */
              IF  VALID-HANDLE(hSource) 
              AND LOOKUP(cObjectName,cDataSourceNames) = 0  THEN
              DO:
                ASSIGN
                 cMapping         = cMapping 
                                  + (IF cMapping = "":U THEN "":U ELSE ",":U) 
                                  + STRING(hTarget) + ",":U + STRING(hSource)
                 cDataSourceNames = cDataSourceNames
                                  + (IF cDataSourceNames = "":U THEN "":U ELSE ",":U)
                                  + (IF cObjectName = ? THEN "?":U ELSE cObjectName).
              END.
          END. /* iColumn = 1 to num-entries ForeignFields by 2 */
          ELSE DO:
            /* We 'map' to master if no foreign fields */ 
            {get MasterdataObject hMaster}.
            {get ObjectName cObjectName hMaster}. 
            ASSIGN
            cMapping          = cMapping 
                              + (IF cMapping = "":U THEN "":U ELSE ",":U) 
                              + STRING(hTarget) + ",":U + STRING(hMaster)
             cDataSourceNames = cDataSourceNames
                              + (IF cDataSourceNames = "":U THEN "":U ELSE ",":U)
                              + (IF cObjectName = ? THEN "?":U ELSE cObjectName).

          END. /* else (no ForeignFields) */         
          {set DataSourceNames cDataSourceNames hTarget}.
          /* The mapping is set at the end of this proc */
        END. /* SDO  */
        ELSE DO: /* Deal with visual objects */
          {get DataSourceNames cObjectList hTarget} NO-ERROR.

             /* Set the flag that tells us that we don't need to update 
                the DataTarget Properties (probably not a big deal, but let's
                keep them as specified at design time) */       
          ASSIGN
            lSourceSpecified = (cObjectList <> ? AND cObjectList <> "":U)
            lSourceFound     = FALSE.

            /* if the Instance property dataSourceNames isn't defined see if 
             the 'Master' property DisplayedTables can be used or if it is 
             'RowObject' and all fields must be checked. (The term 'Master' 
             property refers to the fact that the property is defined at build
             time and not at instance design time)*/ 
          IF NOT lSourceSpecified THEN
            {get DisplayedTables cObjectList hTarget} NO-ERROR.
          
          /* This is probably a container with no displayedTables prop, but 
             we set it to blank and leave the decision to return after the 
             DisplayedFields check just below */
          IF cObjectList = ? THEN
            cObjectList = '':U.

          /* We want to update UpdateTargetNames according to which fields 
             that actually are enabled. */  
          {get EnabledFields cEnabledColumns hTarget} NO-ERROR.
         /* If the target was built with RowObject, we check each field in the 
            target for a complete match in one of the ContainedObjects. 
            The ObjectList = '' also for dynBrowsers built before 
            and for objects build against an SBO with all fields disabled 
            due to an AppBuilder bug */ 
          IF cObjectList = 'RowObject':U OR cObjectList = '':U THEN
          DO:
            {get DisplayedFields cDataColumns hTarget} NO-ERROR.
            
            IF cDataColumns = "":U OR cDataColumns = ? THEN
              RETURN.

            {get ContainedDataObjects cContainedObjects}.
            {get ContainedDataColumns cContainedColumns}. 
            
            /* If the first column is qualifed this is built against an SBO */
            lSBOTarget = NUM-ENTRIES(ENTRY(1,cDataColumns),".":U) > 1. 

            IF lSBOTarget THEN
            DO:
              {get DataObjectNames cDataObjectNames}.
              SBOColumnSearch:
              DO iColumn = 1 TO NUM-ENTRIES(cDataColumns):
                ASSIGN
                  cColumn       = ENTRY(iColumn, cDataColumns)
                  /* If we haven't already found a matching enabled column,
                     check if this one is */  
                  lUpdate       = LOOKUP(cColumn,cEnabledColumns) > 0                                  
                  cObjectName   = ENTRY(1,cColumn,".":U)
                  cColumn       = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U)
                  iSource       = LOOKUP(cObjectName,cDataObjectNames).
                
                /* The qualifier does not match any SDO */
                IF iSource = 0 THEN
                DO:
                  lSourceFound = FALSE.
                  LEAVE SBOColumnSearch. 
                END.

                ASSIGN 
/*                   lUpdate     = FALSE  */
                  cSDOColumns = ENTRY(iSource,cContainedColumns,';':U).
              
                /*  The Column does not match */
                IF LOOKUP(cColumn,cSDOColumns) EQ 0 THEN
                DO:
                  lSourceFound = FALSE.
                  LEAVE SBOColumnSearch.
                END.
           
                IF LOOKUP(cObjectName,cDataSourceNames) = 0 THEN
                DO:
                  ASSIGN
                   lSourceFound = TRUE
                   cSource      = ENTRY(iSource,cContainedObjects) 
                   cMapping     = cMapping 
                                + (IF cMapping = "":U THEN "":U ELSE ",":U) 
                                + STRING(hTarget) + ",":U + cSource
                   cDataSourceNames = cDataSourceNames
                                + (IF cDataSourceNames = "":U THEN "":U ELSE ",":U)
                                + (IF cObjectName = ? THEN "?":U ELSE cObjectName).

                  /* Add this as an update target if the field is enabled */ 
                  IF lUpdate THEN
                     cUpdateTargetNames = cUpdateTargetNames
                               + (IF cUpdateTargetNames = "":U THEN "":U ELSE ",":U)
                               + (IF cObjectName = ? THEN "?":U ELSE cObjectName).
                END.
              END. /* DO iColumn = 1 TO NUM-ENTRIES(cDataColumns) */
            END.

            /* Unqualified columns, find ONE SDO that matches the columns. */
            ELSE  
            ContainedObjectSearch:
            DO iSource = 1 TO NUM-ENTRIES(cContainedObjects):
              ASSIGN
                lUpdate     = FALSE
                cSDOColumns = ENTRY(iSource,cContainedColumns,';':U).
              /* Check if all the columns mathes the contained columns for
                 this sdo  */

              DO iColumn = 1 TO NUM-ENTRIES(cDataColumns):
                ASSIGN
                  cColumn = ENTRY(iColumn, cDataColumns)
                  /* remove object qualifier e.g. dynlookup */
                  cColumn = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U).
                
                IF LOOKUP(cColumn,cSDOColumns) EQ 0 THEN
                   NEXT ContainedObjectSearch.
                
                /* If we haven't already found a matching enabled column,
                   check if this one is */  
                IF NOT lUpdate THEN 
                  lUpdate = LOOKUP(cColumn,cEnabledColumns) > 0.  

              END. /* DO iColumn -- locate each fld in the SDO. */
              
              /* If we get here all the columns in the target was in the
                 current containedObject, so update properties accordingly */
              ASSIGN
                lSourceFound = TRUE
                cSource      = ENTRY(iSource, cContainedObjects)
                hSource      = WIDGET-HANDLE(cSource).
              
              {get ObjectName cObjectName hSource} NO-ERROR.

              ASSIGN
                cMapping     = cMapping 
                             + (IF cMapping = "":U THEN "":U ELSE ",":U) 
                             + STRING(hTarget) + ",":U + cSource
                cDataSourceNames = cDataSourceNames
                             + (IF cDataSourceNames = "":U THEN "":U ELSE ",":U)
                             + (IF cObjectName = ? THEN "?":U ELSE cObjectName).
              
              /* Let's also avoid the need to loop in addRows, colValues etc.*/ 
              IF lUpdate THEN
                cUpdateTargetNames = cUpdateTargetNames
                           + (IF cUpdateTargetNames = "":U THEN "":U ELSE ",":U)
                           + (IF cObjectName = ? THEN "?":U ELSE cObjectName).
              /* No need to search anymore */
              LEAVE ContainedObjectSearch. 
            END. /* DO iSource = 1 */
            IF NOT lSourceFound THEN
              DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE,
               "Unable to find an apropriate data-source for object '" 
               + hTarget:FILE-NAME  + "'":U
               + chr(10) +   
               "All columns must exist in" 
               + (IF lSBOTarget THEN '':U ELSE ' ONE of') 
               + " the SmartBusinessObject's"
               + " contained objects.").

          END. /* cObjectList = 'RowObject' */
          ELSE 
          DO iSource = 1 TO NUM-ENTRIES(cObjectList):
            ASSIGN
              cObjectName = ENTRY(iSource,cObjectList)
              hSource     = {fnarg dataObjectHandle cObjectName} NO-ERROR.
            
            /* Add the two objects to the list with the outside object first */ 
            IF VALID-HANDLE(hSource) THEN 
            DO:
              cMapping = cMapping 
                       + (IF cMapping NE "":U THEN ",":U ELSE "":U)
                       + STRING(hTarget) + ",":U + STRING(hSource).

              IF NOT lSourceSpecified THEN
              DO:
                 cDataSourceNames = cDataSourceNames
                       + (IF cDataSourceNames = "":U THEN "":U ELSE ",":U)
                       +  cObjectName.
                 /* if the Object is a qualifier in enabledFields also 
                    the dataSource is also an UpdateTarget */   
                 IF cEnabledColumns BEGINS cObjectName + '.' 
                 OR INDEX(cEnabledColumns,',' + cObjectName + '.':U ) > 0 THEN
                    cUpdateTargetNames = cUpdateTargetNames
                       + (IF cUpdateTargetNames = "":U THEN "":U ELSE ",":U)
                       + cObjectName.

              END. /* If NOT lSourceDefined */
            END. /* if valid-handle(hSource) */
          END. /* if cObjectList <> RowObject do iSource = 1 to  */
                    /* Let's avoid the need to loop in getDataHandle and other methods */
          
          IF NUM-ENTRIES(cUpdateTargetNames) > 1 THEN
          DO iUpdLoop = 1 TO NUM-ENTRIES(cUpdateTargetNames):
              ASSIGN 
                cObjectName = ENTRY(iUpdLoop,cUpdateTargetNames)
                hUpd        =  {fnarg dataObjectHandle cObjectName}
                lOneToOne   = {fn hasOneToOneTarget hUpd}
                              OR 
                              {fn getUpdateFromSource hUpd}.

            IF NOT lOneToOne THEN
            DO:
              DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE,
                 "The SmartBusinessObject " 
                               + TARGET-PROCEDURE:FILE-NAME + " cannot update "
                 + REPLACE(cUpdateTargetNames,',':U,' and ':U) + ' together.' 
                 + " Either make sure that only fields from the SmartDataObject Update"
                 + " Target are enabled"
                 + " or if these objects have a one-to-one relationship and should be"
                 + " updated together, specify that the Data Target is to be updated"
                 + " from the Data Source in the SmartDataObject's Instance Properties."
                 + CHR(10) + CHR(10)
                 + " The enabled fields and the update link will be disabled for now.").

              {set EnabledFields '':U hTarget}.
              {set UpdateTargetNames '':U hTarget}. 
              {set UpdateTarget ? hTarget}.
              LEAVE.
            END. /* not one to one */
          END. /* num-entries(update targets ) > 1 then loop */
          
          IF NOT lSourceSpecified THEN
          DO:   
            {set DataSourceNames cDataSourceNames hTarget}. 
            {set UpdateTargetNames cUpdateTargetNames hTarget}. 
          END. /* if not source specified  */

          /* In support of browsers with no enabled fields we do 
             a final check to see if we are the object's updateTarget 
             and use the DataSourceNames as UpdateTargetNames. 
             We reread both properties in case Source was specified. */   
          {get UpdateTargetNames cUpdateTargetNames hTarget}.
          IF cUpdateTargetNames = '':U THEN
          DO:         
            {get UpdateTarget hUpdateTarget hTarget}.
            {get DataSourceNames cDataSourceNames hTarget}. 
            IF hUpdateTarget = TARGET-PROCEDURE 
            AND NUM-ENTRIES(cDataSourceNames) = 1 THEN
              {set UpdateTargetNames cDataSourceNames hTarget}. 
          END. /*IF cUpdateTargetNames = '':U */
        END. /* else do (visual objects)*/
        {set ObjectMapping cMapping}.
      END. /* DO if valid-handle(hTarget) */
    END. /* DO if lookup(cTarget,cMapping) = 0*/
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addNavigationSource Procedure 
PROCEDURE addNavigationSource :
/*------------------------------------------------------------------------------
  Purpose:  Update the ObjectMapping property that are used to broker messages
            between contained objects and objects linked to the SBO.       
  Parameters: phSource - the handle of the Source
  Notes:    Called from registerObject, which are subscribed as 
            NavigationSourceEvent and published from the NavigationSource's 
            initializeObject.  
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phSource AS HANDLE NO-UNDO.
  
DEFINE VARIABLE hSource     AS HANDLE    NO-UNDO.
DEFINE VARIABLE cSource     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMapping    AS CHARACTER NO-UNDO.
DEFINE VARIABLE hMaster     AS HANDLE    NO-UNDO.
DEFINE VARIABLE cObjectName AS CHARACTER NO-UNDO.
DEFINE VARIABLE hTarget     AS HANDLE    NO-UNDO.
DEFINE VARIABLE cPosition   AS CHARACTER NO-UNDO.

  {get MasterDataObject hMaster}.
  {get ObjectMapping cMapping}.
  
   ASSIGN 
     hSource = phSource 
     cSource = STRING(hSource).
   IF LOOKUP(cSource,cMapping) = 0 THEN
   DO:

     {get NavigationTargetName cObjectName hSource} NO-ERROR.
     IF cObjectName NE ? AND cObjectName NE "":U THEN
       hTarget = {fnarg dataObjectHandle cObjectName} NO-ERROR.
     ELSE 
       hTarget = hMaster.   /* Use MasterDataObject as a default. */
   
     IF VALID-HANDLE(hTarget) THEN
     DO:
       /* Send the current queryPosition to the NavigationSource */ 
       {get QueryPosition cPosition}.
       /*
       ghTargetProcedure = TARGET-PROCEDURE.
       RUN queryPosition IN hSource (cPosition).
       ghTargetProcedure = ?. 
       */
       /* Add the two objects to the list with the outside object first */ 
       cMapping = cMapping 
                + (IF cMapping NE "":U THEN ",":U ELSE "":U)
                + STRING(hSource) + ",":U + STRING(hTarget).

       {set ObjectMapping cMapping}.
     END.  /* Valid hTarget */
   END. /* DO if lookup (cSource,cMapping) = 0 */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignMaxGuess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignMaxGuess Procedure 
PROCEDURE assignMaxGuess :
/*------------------------------------------------------------------------------
  Purpose:     Receives the assignMaxGuess event from a contained SDO and 
               passes it on to the appropriate DATA-TARGET
  Parameters:  piMaxGuess AS INTEGER
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piMaxGuess AS INTEGER NO-UNDO.

DEFINE VARIABLE cMapping   AS CHAR   NO-UNDO.
DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
DEFINE VARIABLE iObject    AS INT    NO-UNDO.
DEFINE VARIABLE cHandle    AS CHAR   NO-UNDO.

  {get ObjectMapping cMapping}.
  cHandle = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, /* may be more than one match */
                   INPUT STRING(SOURCE-PROCEDURE),
                   INPUT cMapping,
                   INPUT FALSE,           /* Get entry/entries *before* this */
                   INPUT ",":U).          /* delimiter */

  DO iObject = 1 TO NUM-ENTRIES(cHandle):
    hObject = WIDGET-HANDLE(ENTRY(iObject, cHandle)).
    RUN assignMaxGuess IN hObject (piMaxGuess) NO-ERROR.
  END.    /* END DO iObject */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferCommitTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferCommitTransaction Procedure 
PROCEDURE bufferCommitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     database-side part of CommitTransaction to save all RowObjUpd 
               table updates and store them thru the server-side SDOs.
  Parameters:  OUTPUT pcMessages AS CHARACTER -- error messages
               OUTPUT pcUndoIds  AS CHARACTER -- rowids of error'd rows 
       Notes:  Intended for internal use by other APIs that manages the buffers
               for example received as table parameters like 
               serverCommitTransaction, remoteCommitTransaction 
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcMessages AS CHARACTER   NO-UNDO.
  DEFINE OUTPUT PARAMETER pcUndoIds  AS CHARACTER   NO-UNDO.
 
  DEFINE VARIABLE cContained  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iDO         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hDO         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTable      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cOrdering   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cASDivision AS CHARACTER  NO-UNDO.

  /* These vars are for foreign field assignment. */
  DEFINE VARIABLE hBuf           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFld           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQry           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSaveDO        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSaveTable     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignValues AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSaveBuf       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSaveQry       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSaveCol       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCol           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hCol           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowMod        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFld           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUndoIds       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateTables  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDynamicData AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lLocalHook     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lLogicHook     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hLogicObject   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cReturn        AS CHARACTER  NO-UNDO.

  {get ContainedDataObjects cContained}.
  {get DataObjectOrdering cOrdering}.
  {get ASDivision cASDivision}.
  {get UpdateTables cUpdateTables}.
  {get DynamicData lDynamicData}.
  {get DataLogicObject hLogicObject}.

  /* First do any validation the SBO needs to do at the very outset. */
  RUN bufferValidate IN TARGET-PROCEDURE ("pre":U).
  IF RETURN-VALUE NE "":U THEN
  DO:
      RUN prepareErrorsForReturn IN TARGET-PROCEDURE
                     (INPUT RETURN-VALUE, INPUT cASDivision,
                      INPUT-OUTPUT pcMessages).
      RETURN.
  END.      /* DO IF error return */

  DO iDO = 1 TO NUM-ENTRIES(cContained):
    /*  This will find which of the hard-coded AppBuilder-generated  */
    /*  update table definitions corresponds to this entry in the    */
    /*  ContainedDataObjects list.                                   */
    ASSIGN
      hDO = WIDGET-HANDLE(ENTRY(iDO, cContained))
      iEntry = LOOKUP(STRING(iDO), cOrdering)
      hTable = WIDGET-HANDLE(ENTRY(iEntry, cUpdateTables)).

    IF hTable:HAS-RECORDS THEN
      IF lDynamicData THEN  /* dynamic object, we're sharing tables */
        RUN bufferValidate IN hDO (INPUT "Pre":U).
      ELSE
        RUN pushTableAndValidate IN hDO (INPUT "Pre":U, 
                                         INPUT-OUTPUT TABLE-HANDLE hTable).
    IF RETURN-VALUE NE "":U THEN
    DO:
      RUN prepareErrorsForReturn IN TARGET-PROCEDURE
                                (INPUT RETURN-VALUE, INPUT cASDivision,
                                 INPUT-OUTPUT pcMessages).
      RETURN.
    END.     /* END DO IF error return */
  END.         /* END DO iDO -- for each contained SDO */

  DO TRANSACTION ON ERROR UNDO, LEAVE:
      /* First run any SBO specific logic for the transaction start. */
      RUN bufferValidate IN TARGET-PROCEDURE ("begin":U).
      IF RETURN-VALUE NE "":U THEN
      DO:
        RUN prepareErrorsForReturn IN TARGET-PROCEDURE
                                  (INPUT RETURN-VALUE, 
                                   INPUT cASDivision,
                                   INPUT-OUTPUT pcMessages).
        UNDO, RETURN.
      END.     /* END DO IF error return */

      DO iDO = 1 TO NUM-ENTRIES(cContained):
        ASSIGN
          hDO = WIDGET-HANDLE(ENTRY(iDO, cContained))
          iEntry = LOOKUP(STRING(iDO), cOrdering)
          hTable = WIDGET-HANDLE(ENTRY(iEntry, cUpdateTables)).

        IF hTable:HAS-RECORDS THEN
        DO:
          /* In this section we look to see if a parent and one or more child
             rows are being Added at the same time. If so, we copy ForeignField
             key values from the parent rec to all newly added child recs,
             *after* running serverCommit in the parent (so that the key values
             will have been assigned for it), and *before* running it for
             the child SDO. */
          IF VALID-HANDLE(hSaveDO) THEN
          DO:
          /* We have saved off keys from the previous table. See if that's
             a Data-Source for the current table. */
             {get DataSource hSource hDO}.
             IF hSource = hSaveDO THEN
             DO:
               /* The previous SDO was the current SDO's data-source,
                  so look for key values to assign. */
               {get ForeignFields cForeignFields hDO}.
               IF cForeignFields NE "":U THEN
               DO:
                   hSaveBuf = hSaveTable:DEFAULT-BUFFER-HANDLE.
                   CREATE QUERY hSaveQry.
                   hSaveQry:SET-BUFFERS(hSaveBuf).
                   hSaveQry:QUERY-PREPARE('For each ':U 
                                          + hSaveTable:NAME
                                          + ' WHERE ':U
                                          + hSaveTable:NAME
                                          + '.RowMod = "A"':U).
                   hSaveQry:QUERY-OPEN().
                   hSaveQry:GET-FIRST().
                   /* Now we have the buffer the the parent record. 
                      Create another query to loop through the children. */
                   ASSIGN hBuf    = hTable:DEFAULT-BUFFER-HANDLE
                          hRowMod = hBuf:BUFFER-FIELD('RowMod':U).
                   CREATE QUERY hQry.
                   hQry:SET-BUFFERS(hBuf).
                   hQry:QUERY-PREPARE('For each ':U 
                                      + hTable:NAME 
                                      + ' WHERE ':U
                                      + hTable:NAME
                                      + '.RowMod = "A"':U).
                   hQry:QUERY-OPEN().
                   hQry:GET-FIRST().
                   DO WHILE hBuf:AVAILABLE:
                     cForeignValues = "":U.
                     /* Assign the key values from the Saved record
                          to each added row in the current SDO. */
                     DO iCol = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
                         ASSIGN     /* This is the parent */
                           hSaveCol = hSaveBuf:BUFFER-FIELD(ENTRY(iCol + 1,
                                                            cForeignFields))
                           /* remove the ObjectName qualifier from the
                              field name for the child SDO. */
                           cFld = ENTRY(iCol, cForeignFields)
                            /* This is the child */
                           hCol = hBuf:BUFFER-FIELD(
                                     ENTRY(NUM-ENTRIES(cFld, ".":U), cFld, ".":U)
                                                   )
                           hCol:BUFFER-VALUE = hSaveCol:BUFFER-VALUE
                           cForeignValues    = cForeignValues 
                                             + (IF iCol = 1 THEN '':U ELSE CHR(1))
                                             + IF hSaveCol:BUFFER-VALUE = ?
                                               THEN '?' 
                                               ELSE hSaveCol:BUFFER-VALUE.
                     END.      /* END DO iCol == for each foreign field */ 
                     /* ForeignValues will be returned to the client and 
                        ensure that the query is not reopened as they will 
                        match the data on the client */ 
                     {set ForeignValues cForeignValues hDO}.
                     hQry:GET-NEXT().
                   END.          /* END DO WHILE AVAIL == for each child. */
                   hQry:QUERY-CLOSE().
                   hSaveQry:QUERY-CLOSE().
                   DELETE OBJECT hQry.
                   DELETE OBJECT hSaveQry.
               END.              /* END DO if foreign fields */
             END.                /* END DO IF SaveDO is DataSource */
          END.                   /* END DO IF ValidHandle SaveDO */

          /* no need to copy the table if DynSBO */
          IF lDynamicData THEN
            RUN bufferCommit IN hDO (OUTPUT pcMessages, OUTPUT cUndoIds).
          ELSE
            RUN serverCommit IN hDO (INPUT-OUTPUT TABLE-HANDLE hTable, 
                                     OUTPUT pcMessages, 
                                     OUTPUT cUndoIds).
           
          IF cUndoIds <> '':U THEN
          DO:
            /* Make the UndoIds into a semicolon separated list, in order to 
               identify which of the SDOs the UndoIds (RowNumCHR(3)text) belongs
               to. The intention is not to create another completely confusing 
               internal format, the semicolon separator is almost an SBO 
               standard used to identify SDO also in other parameters... OK? */ 
            IF pcUndoIds = '':U THEN
              pcUndoIds = FILL(';':U, NUM-ENTRIES(cContained) - 1).

            ENTRY(iDO,pcUndoIds,';':U) = cUndoIds.
          END.

          /* if we're on the Server-side of a divided SBO, serverCommit for
             the SDO will have put any error messages into pcMessages.
             Otherwise it will simply have logged them with addMessage. */
          IF (cASDivision = 'Server':U AND pcMessages NE "":U) OR
              DYNAMIC-FUNCTION ('anyMessage':U IN TARGET-PROCEDURE) THEN
          DO:
            UNDO, RETURN.
          END.

          /* Now that we're back from the commit, check to see if it
             was an Add. If so, save the DO and Table handles to use to
             create keys for the next table if appropriate. */
          hBuf = hTable:DEFAULT-BUFFER-HANDLE.
          CREATE QUERY hQry.
          hQry:SET-BUFFERS(hBuf).
          hQry:QUERY-PREPARE('For each ':U 
                              + hTable:NAME 
                              + ' WHERE ':U
                              + hTable:NAME
                              + '.RowMod = "A"':U).
          hQry:QUERY-OPEN().
          hQry:GET-FIRST().
          ASSIGN
            hSaveDO = ?
            hSaveTable = ?.
          IF hBuf:AVAILABLE THEN
          DO:
            hCol = hBuf:BUFFER-FIELD('RowMod':U).
            hQry:GET-NEXT(). 
            /* Only if one 'A' add record  */
            IF hQry:QUERY-OFF-END THEN
              ASSIGN hSaveDO    = hDO
                     hSaveTable = hTable.
          END.
          hQry:QUERY-CLOSE().
          DELETE OBJECT hQry.
        END.      /* END DO IF HAS-RECORDS */
      END.        /* END DO iDO -- serverCommit for each SDO */
      /* Finally do any validation the SBO needs to do at the very end
         of the transaction. */
      RUN bufferValidate IN TARGET-PROCEDURE ("end":U).
      IF RETURN-VALUE NE "":U THEN
      DO:
        RUN prepareErrorsForReturn IN TARGET-PROCEDURE
                                  (INPUT RETURN-VALUE, INPUT cASDivision,
                                   INPUT-OUTPUT pcMessages).
        UNDO, RETURN.
      END.     /* END DO IF error return */

  END.            /* END TRANSACTION */
          
  DO iDO = 1 TO NUM-ENTRIES(cContained):
      hDO = WIDGET-HANDLE(ENTRY(iDO, cContained)).
      iEntry = LOOKUP(STRING(iDO), cOrdering).
      hTable = WIDGET-HANDLE(ENTRY(iEntry, cUpdateTables)).
       
      IF hTable:HAS-RECORDS THEN
        IF lDynamicData THEN  /* we're sharing tables */
          RUN bufferValidate IN hDO (INPUT "Post":U).
        ELSE
          RUN pushTableAndValidate IN hDO (INPUT "Post":U, 
                                           INPUT-OUTPUT TABLE-HANDLE hTable).
      IF RETURN-VALUE NE "":U THEN
      DO:
          RUN prepareErrorsForReturn IN TARGET-PROCEDURE
                                    (INPUT RETURN-VALUE, INPUT cASDivision,
                                     INPUT-OUTPUT pcMessages).
          RETURN.
      END.      /* END DO IF error return */
  END.              /* END DO iDO -- for each contained SDO */

  /* Finally do any validation the SBO needs to do at the very end. */
  RUN bufferValidate IN TARGET-PROCEDURE ("post":U).
  IF RETURN-VALUE NE "":U THEN
  DO:
      RUN prepareErrorsForReturn IN TARGET-PROCEDURE
                                (INPUT RETURN-VALUE, INPUT cASDivision,
                                 INPUT-OUTPUT pcMessages).
      RETURN.
  END.     /* END DO IF error return */

  RETURN.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferFetchContainedData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferFetchContainedData Procedure 
PROCEDURE bufferFetchContainedData :
/*------------------------------------------------------------------------------
  Purpose:     server-side procedure to prepare and open a query on all
               the SDOs (rowObject buffers). 
               Overrides container because it can use assignQueries
  Parameters:  pcQueries AS CHARACTER -- CHR(1)-delimited-list of 
                  QueryString properties of the SDOs;
               pcPositions AS CHARACTER -- reserved for future use to
                  provide information on positioning each of the queries perhaps
    Notes:  This is the internal buffer logic used on the server side of 
            fetchContainedData and is called thru one of several 
            *fetchContainedData APIs that has output parameters for the table 
            handles.
        -   (it may actually also be called on the client, since openQuery
            will call fetchContainedData on client, but this is not tested... )             
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcQueries   AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcPositions AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hFirstSDO  AS HANDLE     NO-UNDO.
  
  hFirstSDO = {fnarg assignQueries pcQueries}.

  {fn openQuery hFirstSDO}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferValidate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferValidate Procedure 
PROCEDURE bufferValidate :
/*------------------------------------------------------------------------------
  Purpose:     SBO implementation of 'bufferValidate'
  Parameters:  INPUT pcValType AS CHARACTER -- "Pre", "Begin", "End", "Post"
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcValType AS CHAR   NO-UNDO.

DEFINE VARIABLE lLogicHook        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lLocalHook        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cHook             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hLogicObject      AS HANDLE     NO-UNDO.
DEFINE VARIABLE cReturn           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUpdateTables     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount            AS INTEGER    NO-UNDO.
DEFINE VARIABLE hTable            AS HANDLE     NO-UNDO.

  {get DataLogicObject hLogicObject}.
   
  ASSIGN
    cHook      = pcValType + "TransactionValidate":U
    lLocalHook = LOOKUP(cHook,TARGET-PROCEDURE:INTERNAL-ENTRIES) > 0
    lLogicHook = VALID-HANDLE(hLogicObject) 
                 AND LOOKUP(cHook, hLogicObject:INTERNAL-ENTRIES) > 0.

   /* We need to identify where the hook is because if the hook is ONLY in 
      the Logical Object then the TT need to be transfered back and forth.
      If the hook is local then we cannot transfer here asa th elocal then would
      change a different TT. It there for some reason should be hooks both
      locally and in the logic procedure the local hook would be a complete 
      overrride or it would need to do the transfer itself  */
   
   IF NOT lLocalHook AND lLogicHook THEN DO:
     /* no need to define these variables unnecessarily */
     DEFINE VARIABLE hTable1         AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable2         AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable3         AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable4         AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable5         AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable6         AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable7         AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable8         AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable9         AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable10        AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable11        AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable12        AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable13        AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable14        AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable15        AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable16        AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable17        AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable18        AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable19        AS HANDLE     NO-UNDO.
     DEFINE VARIABLE hTable20        AS HANDLE     NO-UNDO.

     {get UpdateTables cUpdateTables}.

     /* Create a set of table handles that need to be passed back and forth */
     /* to the DataLogic procedure hooks. The tables are already in the */
     /* correct order */
     DO iCount = 1 TO NUM-ENTRIES(cUpdateTables):
       hTable = WIDGET-HANDLE(ENTRY(iCount, cUpdateTables)).
       CASE iCount:
          WHEN 1 THEN hTable1 = hTable.
          WHEN 2 THEN hTable2 = hTable.
          WHEN 3 THEN hTable3 = hTable.
          WHEN 4 THEN hTable4 = hTable.
          WHEN 5 THEN hTable5 = hTable.
          WHEN 6 THEN hTable6 = hTable.
          WHEN 7 THEN hTable7 = hTable.
          WHEN 8 THEN hTable8 = hTable.
          WHEN 9 THEN hTable9 = hTable.
          WHEN 10 THEN hTable10 = hTable.
          WHEN 11 THEN hTable11 = hTable.
          WHEN 12 THEN hTable12 = hTable.
          WHEN 13 THEN hTable13 = hTable.
          WHEN 14 THEN hTable14 = hTable.
          WHEN 15 THEN hTable15 = hTable.
          WHEN 16 THEN hTable16 = hTable.
          WHEN 17 THEN hTable17 = hTable.
          WHEN 18 THEN hTable18 = hTable.
          WHEN 19 THEN hTable19 = hTable.
          WHEN 20 THEN hTable20 = hTable.
       END CASE.
     END.
     RUN setLogicRows IN TARGET-PROCEDURE 
            (INPUT TABLE-HANDLE hTable1, 
             INPUT TABLE-HANDLE hTable2,
             INPUT TABLE-HANDLE hTable3,
             INPUT TABLE-HANDLE hTable4,
             INPUT TABLE-HANDLE hTable5,
             INPUT TABLE-HANDLE hTable6,
             INPUT TABLE-HANDLE hTable7,
             INPUT TABLE-HANDLE hTable8,
             INPUT TABLE-HANDLE hTable9,
             INPUT TABLE-HANDLE hTable10,
             INPUT TABLE-HANDLE hTable11,
             INPUT TABLE-HANDLE hTable12,
             INPUT TABLE-HANDLE hTable13,
             INPUT TABLE-HANDLE hTable14,
             INPUT TABLE-HANDLE hTable15,
             INPUT TABLE-HANDLE hTable16,
             INPUT TABLE-HANDLE hTable17,
             INPUT TABLE-HANDLE hTable18,
             INPUT TABLE-HANDLE hTable19,
             INPUT TABLE-HANDLE hTable20).
   END.

   RUN VALUE(cHook) IN TARGET-PROCEDURE NO-ERROR.
   cReturn = RETURN-VALUE.
   
   /* if the hook was in a DL procedure, we need to get the tables back */
   IF NOT lLocalHook AND lLogicHook THEN
     RUN getLogicRows IN TARGET-PROCEDURE 
           (OUTPUT TABLE-HANDLE hTable1, 
            OUTPUT TABLE-HANDLE hTable2,
            OUTPUT TABLE-HANDLE hTable3,
            OUTPUT TABLE-HANDLE hTable4,
            OUTPUT TABLE-HANDLE hTable5,
            OUTPUT TABLE-HANDLE hTable6,
            OUTPUT TABLE-HANDLE hTable7,
            OUTPUT TABLE-HANDLE hTable8,
            OUTPUT TABLE-HANDLE hTable9,
            OUTPUT TABLE-HANDLE hTable10,
            OUTPUT TABLE-HANDLE hTable11,
            OUTPUT TABLE-HANDLE hTable12,
            OUTPUT TABLE-HANDLE hTable13,
            OUTPUT TABLE-HANDLE hTable14,
            OUTPUT TABLE-HANDLE hTable15,
            OUTPUT TABLE-HANDLE hTable16,
            OUTPUT TABLE-HANDLE hTable17,
            OUTPUT TABLE-HANDLE hTable18,
            OUTPUT TABLE-HANDLE hTable19,
            OUTPUT TABLE-HANDLE hTable20).

   RETURN cReturn.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelNew) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelNew Procedure 
PROCEDURE cancelNew :
/*------------------------------------------------------------------------------
  Purpose:     Receives the cancelNew event from a contained SDO and 
               passes it on to the appropriate DATA-TARGET
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMapping   AS CHAR   NO-UNDO.
DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
DEFINE VARIABLE iObject    AS INT    NO-UNDO.
DEFINE VARIABLE cHandle    AS CHAR   NO-UNDO.

  {get ObjectMapping cMapping}.
  cHandle = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, /* may be more than one match */
                   INPUT STRING(SOURCE-PROCEDURE),
                   INPUT cMapping,
                   INPUT FALSE,           /* Get entry/entries *before* this */
                   INPUT ",":U).          /* delimiter */

  DO iObject = 1 TO NUM-ENTRIES(cHandle):
    hObject = WIDGET-HANDLE(ENTRY(iObject, cHandle)).
    RUN cancelNew IN hObject NO-ERROR.
  END.    /* END DO iObject */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-commitTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE commitTransaction Procedure 
PROCEDURE commitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     client-side event procedure to receive the Commit event,
               gather up the updates from contained SDOs, and pass then
               on to the server.
  Parameters:  <none>
  Notes:      Repositioning with error: 
               We roll back the last SDO first. As soon as we find an SDO with 
               uncommitted changes after rollback, we change Undoids for all its 
               dataSources (rowNum of '?'). This will in turn be passed to 
               doReturnUpd, which will use this as a signal that it has
               to keep the current position and disregard the undoIds which it 
               normally would reposition to. We know the parents current 
               position is ok because you cannot navigate parents that has 
               changes in children.  
           -   We always publish dataavailable 'RESET', because this always
               resets panels, visual targets and ForeignValues and is changed
               to 'different' if hasForeignKeyChanged, except if any uncommitted 
               changes are found.                     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAsHandle       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAppService     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cASDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lASBound        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cOperatingMode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cServerFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBindScope      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContained      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDO             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDO             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable1         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable2         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable3         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable4         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable5         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable6         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable7         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable8         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable9         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable10        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable11        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable12        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable13        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable14        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable15        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable16        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable17        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable18        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable19        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable20        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMessages       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUndoIds        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOrdering       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHASRecords     AS CHARACTER  NO-UNDO INIT "":U.
  DEFINE VARIABLE cHasNewRecords  AS CHARACTER  NO-UNDO INIT "":U.
  DEFINE VARIABLE cHandle         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAutoCommit     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCommitOk       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCancel         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lError          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hTopDO          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lHasNewRow      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iSource         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lRowUpdated     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hROwObject      AS HANDLE     NO-UNDO.

  DEFINE VARIABLE rRowid          AS ROWID   EXTENT 20  NO-UNDO.
  DEFINE VARIABLE cErrorKeys      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorType      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorTypeList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorKeyList   AS CHARACTER  NO-UNDO.

  {get AutoCommit lAutoCommit}.
  IF NOT lAutoCommit THEN
  DO:
    /* Visual dataTargets subscribes to this */
    PUBLISH 'confirmCommit':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
    IF lCancel THEN RETURN.
  END.

  {get ContainedDataObjects cContained}.
  /* If we're on the client side pass the RowObjUpd table to the server. 
     Rearrange the table order as necessary to match the AppBuilder-generated 
     order, which is the order of the parameters. */
  {get DataObjectOrdering cOrdering}.

  DO iDO = 1 TO NUM-ENTRIES(cOrdering):
      hDO = WIDGET-HANDLE(ENTRY(INTEGER(ENTRY(iDO, cOrdering)), cContained)).
      {get RowObjUpdTable hTable hDO}.
      {get RowObject hRowObject hDO}.
      /* Skip SDOs that have no updates, and keep track of them for use
          after the server transaction. */
      IF hTable:HAS-RECORDS THEN  
      DO:
        cHasRecords = cHasRecords + 
             (IF cHasRecords = "":U THEN "":U ELSE ",":U) +
             ENTRY(iDO, cOrdering).
        /* keep track of NEW records in the SDOs so that we can reposition */
        /* the DataQuery - if necessary */
        {get HasNewRow lHasNewRow hDO}. 
        IF lHasNewRow THEN
           cHasNewRecords = cHasNewRecords + 
                 (IF cHasNewRecords = "":U THEN "":U ELSE ",":U) +
                 ENTRY(iDO, cOrdering).
        rRowid[iDO] = hROwObject:ROWID.
        RUN doBuildUpd IN hDO. /* (OUTPUT TABLE-HANDLE hTable) REMOVED! */
      END.         /* END DO IF HAS-RECORDS */
      CASE iDO:
          WHEN 1 THEN hTable1 = hTable.
          WHEN 2 THEN hTable2 = hTable.
          WHEN 3 THEN hTable3 = hTable.
          WHEN 4 THEN hTable4 = hTable.
          WHEN 5 THEN hTable5 = hTable.
          WHEN 6 THEN hTable6 = hTable.
          WHEN 7 THEN hTable7 = hTable.
          WHEN 8 THEN hTable8 = hTable.
          WHEN 9 THEN hTable9 = hTable.
          WHEN 10 THEN hTable10 = hTable.
          WHEN 11 THEN hTable11 = hTable.
          WHEN 12 THEN hTable12 = hTable.
          WHEN 13 THEN hTable13 = hTable.
          WHEN 14 THEN hTable14 = hTable.
          WHEN 15 THEN hTable15 = hTable.
          WHEN 16 THEN hTable16 = hTable.
          WHEN 17 THEN hTable17 = hTable.
          WHEN 18 THEN hTable18 = hTable.
          WHEN 19 THEN hTable19 = hTable.
          WHEN 20 THEN hTable20 = hTable.
      END CASE.
  END.          /* END DO iDO */
  
  {get ASDivision cASDivision}.
  IF cASDivision = "Client":U THEN
  DO:
    /* Checks AppServer properties to see if the object has no current or future 
       server bindings and is using a stateless operating mode.*/    
    IF {fn hasNoServerBinding} THEN
    DO:
      RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppService).
      IF hAppService = ? THEN
        RETURN 'ADM-ERROR':U.
    END.
    ELSE 
      {get ASHandle hAsHandle}.
    cContext = {fn obtainContextForServer}.
  END.
  
  IF VALID-HANDLE(hAppService)  THEN
  DO:
    {get ServerFileName cServerFileName}.
    RUN adm2/committransaction ON hAppService
        (cServerFileName,
         INPUT-OUTPUT cContext,
         INPUT-OUTPUT TABLE-HANDLE hTable1, 
         INPUT-OUTPUT TABLE-HANDLE hTable2,
         INPUT-OUTPUT TABLE-HANDLE hTable3,
         INPUT-OUTPUT TABLE-HANDLE hTable4,
         INPUT-OUTPUT TABLE-HANDLE hTable5,
         INPUT-OUTPUT TABLE-HANDLE hTable6,
         INPUT-OUTPUT TABLE-HANDLE hTable7,
         INPUT-OUTPUT TABLE-HANDLE hTable8,
         INPUT-OUTPUT TABLE-HANDLE hTable9,
         INPUT-OUTPUT TABLE-HANDLE hTable10,
         INPUT-OUTPUT TABLE-HANDLE hTable11,
         INPUT-OUTPUT TABLE-HANDLE hTable12,
         INPUT-OUTPUT TABLE-HANDLE hTable13,
         INPUT-OUTPUT TABLE-HANDLE hTable14,
         INPUT-OUTPUT TABLE-HANDLE hTable15,
         INPUT-OUTPUT TABLE-HANDLE hTable16,
         INPUT-OUTPUT TABLE-HANDLE hTable17,
         INPUT-OUTPUT TABLE-HANDLE hTable18,
         INPUT-OUTPUT TABLE-HANDLE hTable19,
         INPUT-OUTPUT TABLE-HANDLE hTable20,
         OUTPUT cMessages, 
         OUTPUT cUndoIds).
    {fnarg applyContextFromServer cContext}.
  END.
  ELSE IF VALID-HANDLE(hAsHandle) THEN 
  DO:
    RUN remoteCommitTransaction IN hAsHandle
      (INPUT-OUTPUT cContext,
       INPUT-OUTPUT TABLE-HANDLE hTable1, 
       INPUT-OUTPUT TABLE-HANDLE hTable2,
       INPUT-OUTPUT TABLE-HANDLE hTable3,
       INPUT-OUTPUT TABLE-HANDLE hTable4,
       INPUT-OUTPUT TABLE-HANDLE hTable5,
       INPUT-OUTPUT TABLE-HANDLE hTable6,
       INPUT-OUTPUT TABLE-HANDLE hTable7,
       INPUT-OUTPUT TABLE-HANDLE hTable8,
       INPUT-OUTPUT TABLE-HANDLE hTable9,
       INPUT-OUTPUT TABLE-HANDLE hTable10,
       INPUT-OUTPUT TABLE-HANDLE hTable11,
       INPUT-OUTPUT TABLE-HANDLE hTable12,
       INPUT-OUTPUT TABLE-HANDLE hTable13,
       INPUT-OUTPUT TABLE-HANDLE hTable14,
       INPUT-OUTPUT TABLE-HANDLE hTable15,
       INPUT-OUTPUT TABLE-HANDLE hTable16,
       INPUT-OUTPUT TABLE-HANDLE hTable17,
       INPUT-OUTPUT TABLE-HANDLE hTable18,
       INPUT-OUTPUT TABLE-HANDLE hTable19,
       INPUT-OUTPUT TABLE-HANDLE hTable20,
       OUTPUT cMessages, 
       OUTPUT cUndoIds).
    {fnarg applyContextFromServer cContext}.
    RUN endClientDataRequest IN TARGET-PROCEDURE. 
  END. /* Bound or state-aware or Scope is 'strong' or 'this' */
  ELSE IF {fn getDynamicData} THEN
    /* A dynamic SBO simply points to the SDO tables */
    /* since custom logic is in the DataLogic Procedure */
    RUN bufferCommitTransaction IN TARGET-PROCEDURE
                   (OUTPUT cMessages, OUTPUT cUndoIds). 
  ELSE DO:
    /* ..but a static SBO must transfer the SDO tables since */
    /* it maintains a static copy for support of custom hooks */
    RUN serverCommitTransaction IN TARGET-PROCEDURE
       (INPUT-OUTPUT TABLE-HANDLE hTable1, 
        INPUT-OUTPUT TABLE-HANDLE hTable2,
        INPUT-OUTPUT TABLE-HANDLE hTable3,
        INPUT-OUTPUT TABLE-HANDLE hTable4,
        INPUT-OUTPUT TABLE-HANDLE hTable5,
        INPUT-OUTPUT TABLE-HANDLE hTable6,
        INPUT-OUTPUT TABLE-HANDLE hTable7,
        INPUT-OUTPUT TABLE-HANDLE hTable8,
        INPUT-OUTPUT TABLE-HANDLE hTable9,
        INPUT-OUTPUT TABLE-HANDLE hTable10,
        INPUT-OUTPUT TABLE-HANDLE hTable11,
        INPUT-OUTPUT TABLE-HANDLE hTable12,
        INPUT-OUTPUT TABLE-HANDLE hTable13,
        INPUT-OUTPUT TABLE-HANDLE hTable14,
        INPUT-OUTPUT TABLE-HANDLE hTable15,
        INPUT-OUTPUT TABLE-HANDLE hTable16,
        INPUT-OUTPUT TABLE-HANDLE hTable17,
        INPUT-OUTPUT TABLE-HANDLE hTable18,
        INPUT-OUTPUT TABLE-HANDLE hTable19,
        INPUT-OUTPUT TABLE-HANDLE hTable20,
        OUTPUT cMessages, 
        OUTPUT cUndoIds). 
    /* The serverCommitTransaction sets the RowObjUpd properties so we need to 
       restore them back to the client setting */ 
    DO iDO = 1 TO NUM-ENTRIES(cOrdering):
      hDO = WIDGET-HANDLE(ENTRY(INTEGER(ENTRY(iDO, cOrdering)), cContained)).
      CASE iDO:
        WHEN 1 THEN hTable = hTable1.
        WHEN 2 THEN hTable = hTable2.
        WHEN 3 THEN hTable = hTable3.
        WHEN 4 THEN hTable = hTable4.
        WHEN 5 THEN hTable = hTable5.
        WHEN 6 THEN hTable = hTable6.
        WHEN 7 THEN hTable = hTable7.
        WHEN 8 THEN hTable = hTable8.
        WHEN 9 THEN hTable = hTable9.
        WHEN 10 THEN hTable = hTable10.
        WHEN 11 THEN hTable = hTable11.
        WHEN 12 THEN hTable = hTable12.
        WHEN 13 THEN hTable = hTable13.
        WHEN 14 THEN hTable = hTable14.
        WHEN 15 THEN hTable = hTable15.
        WHEN 16 THEN hTable = hTable16.
        WHEN 17 THEN hTable = hTable17.
        WHEN 18 THEN hTable = hTable18.
        WHEN 19 THEN hTable = hTable19.
        WHEN 20 THEN hTable = hTable20.
      END CASE.
      {set RowObjUpdTable hTable hDO}.
      {get RowObject hRowObject hDO}.
      IF rROwid[iDO] <> ? AND rROwid[iDO] <> hRowObject:ROWID THEN
        hRowObject:FIND-BY-ROWID(rRowid[iDO]).  
    END.
  END.

  /* If we're running standalone (not divided), then errors are logged
     via addMessage. Otherwise, if we're the client of a divided SBO,
     messages will have been returned from the server and we log them here. */
  
  IF cASDivision = 'Client':U AND cMessages NE "":U THEN
    RUN addMessage IN TARGET-PROCEDURE (cMessages, ?, ?).
  
  lCommitOk = NOT DYNAMIC-FUNCTION ('anyMessage':U IN TARGET-PROCEDURE) 
              AND cUndoIds = '':U. 
  
  /* We currently do this before we disconnect in case foreignKey 
     has changed, which will make dataAvailable call openquery */
  IF lCommitOk THEN DO:
    {set RowObjectState 'NoUpdates':U}. 
    {set LastCommitErrorType '':U}.
    {set LastCommitErrorKeys '':U}.
    DO iDO = 1 TO NUM-ENTRIES(cContained):
      hDO = WIDGET-HANDLE(ENTRY(iDO,cContained)).
      RUN doReturnUpd IN hDO ('':U).
      IF LOOKUP(STRING(iDO), cHasRecords) NE 0 THEN
      DO:
        IF hTopDO = ? THEN 
            hTopDO = hDO.
        IF lAutoCommit AND LOOKUP(STRING(iDO), cHasNewRecords) NE 0 THEN
          RUN reopenToRowid IN hDO (?). /* ? = Current Row */
      END.
    END. /* DO iDO doReturnUpd in all SDOs. */    
    IF VALID-HANDLE(hTopDO) THEN
      PUBLISH 'DataAvailable':U FROM hTopDO  ('RESET':U).  
  END.
  ELSE DO:
    lRowUpdated = ?.
          /* Now return any changed rows back to the individual SDOs. */
    /* We need this to logg reposition during return of errros */
    DO iDO = NUM-ENTRIES(cContained) TO 1 BY -1:
      hDO    = WIDGET-HANDLE(ENTRY(iDO,cContained)).
      RUN doReturnUpd IN hDO (IF cUndoIds <> '':U 
                              THEN ENTRY(iDO,cUndoIds,';':U)
                              ELSE '':U).       
      IF LOOKUP(STRING(iDO), cHasRecords) NE 0 THEN
      DO:
        hTopDO = hDO. /* we started from bottom so the last will be top */
        IF lAutoCommit AND LOOKUP(STRING(iDO), cHasNewRecords) NE 0 THEN
           RUN doReturnToaddMode IN hDO.
        /* Keep track of state, if all changes was delete everything is rolled
           back in doReturnUpd */ 
        {get RowObjectState cRowObjectState hDO}.      
        IF lRowUpdated <> TRUE AND cRowObjectState = 'NoUpdates':U THEN
          lRowUpdated = FALSE.
        ELSE DO:  
          /* Ensure that ALL parents of this SDO stays in position */ 
          lRowUpdated = TRUE.
          {get DataSource hSource hDO}.
          DO WHILE VALID-HANDLE(hSource):
            iSource  = LOOKUP(STRING(hSource),cContained).
            IF iSource > 0 THEN
            DO:
              IF cUndoIds = '':U THEN 
                  ASSIGN cUndoIds = FILL(';',NUM-ENTRIES(cContained) - 1).
             /* Just add a new entry with '?' as RowNum to the current undoId
                list for the source. DoReturnUpd only uses the first entry,
                but we keep the whole list just in case  */
              ENTRY(iSource,cUndoIds,';':U) = '?':U + CHR(3) + ",":U 
                                             + ENTRY(iSource,cUndoIds,';':U).
            END.
            {get DataSource hSource hSource}.
          END. /* do while valid-handle(hSource) */
        END.
      END.  /* IF Has-records */    

      /* Get the error info properties from the SDO. Create ';' separated list fro the SBO */
      {get LastCommitErrorKeys cErrorKeys hdo}.
      {get LastCommitErrorType cErrorType hdo}.
      ASSIGN 
          cErrorTypeList = cErrorType + (IF ido = num-entries(cContained) THEN '':U ELSE ';':U) + cErrorTypeList
          cErrorKeyList = cErrorKeys + (IF ido = num-entries(cContained) THEN '':U ELSE ';':U) + cErrorKeyList.
    END. /* do ido = 1 to num-entries(cContained)  */
    
    {set LastCommitErrorType cErrorTypeList}.
    {set LastCommitErrorKeys cErrorKeyList}.

    IF NOT lRowUpdated THEN
      {set RowObjectState 'NoUpdates':U}. 
    
    IF DYNAMIC-FUNCTION ('anyMessage':U IN TARGET-PROCEDURE) THEN
    DO:
      {get CommitSource hSource}.
      IF hSource = SOURCE-PROCEDURE THEN   /* coming from commit panel */
      DO:                                  /* process the erro here */
          DEFINE VARIABLE cDummy AS CHARACTER  NO-UNDO.
          /* Get the client object (any one will do) to display the errors. */
          {get UpdateSource cHandle}.         /* There may be more than one. */
          hSource = WIDGET-HANDLE(ENTRY(1, cHandle)).
          IF VALID-HANDLE (hSource) THEN      
            RUN showDataMessagesProcedure IN hSource (OUTPUT cDummy) .
      END.
      lError = TRUE.
    END.       /* END DO if there are error messages */
    
    /* Now let external client objects know we might have changed data.*/  
    PUBLISH 'dataAvailable':U FROM hTopDO('RESET':U).
  END. /* if not lCommitOk */  
  
  RETURN IF lError THEN "ADM-ERROR":U ELSE '':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmContinue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmContinue Procedure 
PROCEDURE confirmContinue :
/*------------------------------------------------------------------------------
  Purpose:  Check for pending updates in data targets and ask if it is 
            ok to continue.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pioCancel AS LOGICAL NO-UNDO.  
   
  /* don't ask data-targets if already cancelled */  
  IF NOT pioCancel THEN
    PUBLISH "confirmContinue":U FROM TARGET-PROCEDURE (INPUT-OUTPUT pioCancel). 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createData Procedure 
PROCEDURE createData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT         PARAMETER pcColumnNames AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT  PARAMETER pcNewValues   AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT        PARAMETER pcError       AS CHARACTER  NO-UNDO.

 RUN processOpenCall IN TARGET-PROCEDURE
                    ('CREATE':U, 
                      pcColumnNames,  
                      '':U,  /* old values N/A */
                      INPUT-OUTPUT pcNewValues,
                      OUTPUT pcError).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:  Override to ensure SDOs are created and prepared    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE lInitialized    AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lCreated        AS LOGICAL    NO-UNDO.
   
   DEFINE VARIABLE cAsdivision     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cBindScope      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cSDOs           AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hSDO            AS HANDLE     NO-UNDO.
   DEFINE VARIABLE iSDO            AS INTEGER    NO-UNDO.
   DEFINE VARIABLE lFetchDefs      AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE lCheckDefs      AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE hRowObjectTable AS HANDLE     NO-UNDO.
   
   {get ObjectInitialized lInitialized}. 
   {get ObjectsCreated lCreated}. 
   IF lCreated OR lInitialized THEN
     RETURN.

   RUN SUPER.  
   
   {get AsDivision cAsDivision}.
   IF cAsDivision <> 'SERVER':U THEN
   DO:
     /* In design mode where the SBO is running standalone we may need to 
        fetch definitions from server. This can only happen if we are not 
        running in a container. The check for BindScope <> 'data' avoids this 
        if running standalone, when initializeObject is called, except in the 
        case where OpenOnInit is false, but in that case we may as well do the 
        fetch here. */
     {get BindScope cBindScope}.
     {get ContainerSource hContainer}.
     IF cBindScope <> 'Data':U AND NOT VALID-HANDLE(hContainer) THEN 
     DO:
       IF cAsDivision = 'CLIENT':U THEN
         lCheckDefs = TRUE.
     END.
  
     {get ContainedDataObjects cSDOS}.
     DO iSDO = 1 TO NUM-ENTRIES(cSDOs): 
       hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).     
       RUN createObjects IN hSDO.
       /* An SDO that does not have a TT after createObjects is relying on 
          the container to get the defintions. See logic to set CheckDefs above */
       IF lCheckDefs THEN
       DO:
         {get RowObjectTable hRowObjectTable hSDO}.
         IF NOT VALID-HANDLE(hRowObjectTable) THEN
           lFetchDefs = TRUE.
       END.
     END.    
  
     /* See logic above, for setting of FetchDefs.   
        This will be handled in initializeObject or by the DataContainer
        in normal run time scenarios */
     IF lFetchDefs THEN
       RUN fetchContainedData IN TARGET-PROCEDURE('DEFINE':U).
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     This version of dataAvailable basically just notifies other
               objects (Data-Targets) that the current row has been changed.
               Or if the DataSource is an external object, use the Foreign
               Fields property to get the key field values to use to reopen
               the Master object's query.
  Parameters:  pcRelative AS CHARACTER (see data.p for details)
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNewSource      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iField          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLocalFields    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLocalField     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLocalSDO       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceField    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValues         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iEntry          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDO             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMapping        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHandles        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitted        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDataTargets    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lBlockDataAvailable AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lOpenOnInit     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOpen           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hContainer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDataIsFetched  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSourceProcedure    AS HANDLE     NO-UNDO.

  {get ObjectInitialized lInitted}.
  
  /* Let the SBO call this later*/
  IF NOT lInitted THEN 
     RETURN.  
  
  /* First find out whether this came from our own dataSource or one
     of the contained DataObjects. */
  {get DataSource hSource}.    
  hSourceProcedure = SOURCE-PROCEDURE.

  /* check if SBO is calling */
  IF {fn getObjectType  SOURCE-PROCEDURE} = 'SUPER':U THEN
    {get TargetProcedure hSourceProcedure SOURCE-PROCEDURE}.

  /* identifies call from intializeObject*/ 
  IF hSource = hSourceProcedure OR pcRelative = 'initialize':U THEN
  DO:
      /* It did come from an external DataSource. If it's not just the
         SAME row as before, get the foreign fields and prepare the Query
         for the Master DataObject using those values. */
      {get ForeignFields cForeignFields}.
      IF cForeignFields = "":U OR pcRelative = "SAME":U THEN
         RETURN.
      
      {get DataIsFetched lDataIsFetched}.        
      IF pcRelative = 'RESET':U AND NOT lDataIsFetched THEN
      DO:
        /* If the originator of the publish is a DataContainer during 
           initialization and this Object has OpenOnInit false we must 
           keep 'reset' to avoid an attempt to reopen ( the hasForeignKey 
           check would fail) */
        {get OpenOnInit lOpen}.
        IF NOT lOpen THEN
        DO:
          {get ContainerSource hContainer}.
          IF VALID-HANDLE(hContainer) THEN       
            lOpen =  NOT {fn isFetchPending hContainer}.
          ELSE 
            lOpen = TRUE.
        END.
        IF lOpen THEN
        DO:
          {get RowObjectState cRowObjectState}.
          /* there are logic in query.p that makes this into 'reset' again 
             if the source is in newMode or not available */ 
          IF cRowObjectState = 'NoUpdates':U 
          AND {fn hasForeignKeyChanged}  THEN
            pcRelative = 'DIFFERENT':U.
        END.    
      END.  /* reset */

      /* Don't deal with a row that's just being created. */        
      {get NewMode lNewSource hSource}.      
      IF NOT lNewSource THEN
      DO:
        DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
          ASSIGN           /* 1st of each pair is SDO fld  */
            cLocalField  = ENTRY(iField, cForeignFields)
            cLocalFields = cLocalFields 
                         + (IF cLocalFields NE "":U THEN ",":U ELSE "":U) +
                            cLocalField
            cSourceFields = cSourceFields +   /* 2nd of pair is source fld */
              (IF cSourceFields NE "":U THEN ",":U ELSE "":U) +
                 ENTRY(iField + 1, cForeignFields).

        END.        /* END DO iField */
    
        cValues = {fnarg colValues cSourceFields hSource} NO-ERROR.
        
        /* Throw away the RowIdent entry returned by colValues*/
        IF cValues NE ? THEN cValues = SUBSTR(cValues, INDEX(cValues, CHR(1)) + 1).
  
      END. /* not lNewSource  */
      
      {get MasterDataObject hMaster}.
      /* NOTE: NOT (lNewSource = FALSE) because lNewSource = ? when 
         source closed */
      IF NOT (lNewSource = FALSE) OR cValues = ? THEN 
      DO:                     /* No row available in the Source. */      
        {fn closeQuery hMaster}.      /* Close the previous query. */
        RETURN.
      END.
      /* The ForeignValues of the SBO is not retrieved from the server 
         so we need to store it also when DataIsFetched. 
         DataIsFetched is the flag set by the DataContainer to avoid reopen */ 
      IF pcRelative <> 'RESET':U OR lDataIsFetched THEN
      DO:
         /* Save FF values for later querying. */
        {set ForeignValues cValues}.  
        {get MasterDataObject hMaster}.
        IF VALID-HANDLE(hMaster) THEN
          {set ForeignValues cValues hMaster}.
        /* This is a one-time-only flag so set to false immediately */
        {set DataIsFetched FALSE}.       
      END.
      IF pcRelative = 'RESET':U OR lDataIsFetched THEN
        RUN dataAvailable IN hMaster ('RESET':U).
      ELSE DO:
        DYNAMIC-FUNCTION("assignQuerySelection":U IN TARGET-PROCEDURE, 
                          cLocalFields,
                          cValues,
                           '':U).        
        {fn openQuery}.
      END.
  END.      /* END DO IF this came from an external Object. */
  ELSE DO:     
     /* Find out if this came from one of our Data-*Target*s (such as a
        Browser). if so, send the event on to the associated SDO. 
        We must check that the SOURCE is the first entry of a pair,
        which means its an external object linked to an internal SDO. */
     {get ObjectMapping cMapping}.
     cHandles = DYNAMIC-FUNCTION ('mappedEntry':U IN TARGET-PROCEDURE,
                                  INPUT STRING(SOURCE-PROCEDURE),
                                  INPUT cMapping,
                                  INPUT TRUE, /* Return entry after this */
                                  INPUT ",":U).
     
     {get DataTarget cDataTargets}.
     
     IF cHandles NE ? THEN
     DO iEntry = 1 TO NUM-ENTRIES(cHandles):
         hDO = WIDGET-HANDLE(ENTRY(iEntry, cHandles)).
          /* Allow for the possibility of more than one match.  
             
             The SDO (9.1C) must receive 'value-changed' to just pass the 
             event on without applying ForeignFields and reopen the query 
             (This is the future event that any object can pass without 
             the SDO/SBO requiring to know who the caller is, but we still 
             support 'different' and 9.1C browsers still passes that, so check
             whether the caller is a target) */
        RUN dataAvailable IN hDO
              (IF pcRelative = 'DIFFERENT':U 
               AND CAN-DO(cDataTargets,STRING(SOURCE-PROCEDURE))  
               THEN 'VALUE-CHANGED':U 
               ELSE pcRelative) NO-ERROR.
     END.       /* END DO iEntry */
     ELSE DO:
         /* The event came from one of our internal DataObjects. Locate
            the external object mapped to it and pass the event along. */
        /* First check if outgoing DataAvailable is blocked, 
           Usually because of an ongoing update to avoid a lot of messages */  
        {get BlockDataAvailable lBlockDataAvailable}.
        IF NOT lBlockDataAvailable THEN
        DO:
          cHandles = DYNAMIC-FUNCTION ('mappedEntry':U IN TARGET-PROCEDURE,
                                  INPUT STRING(SOURCE-PROCEDURE),
                                  INPUT cMapping,
                                  INPUT FALSE, /* Return entry *before* this */
                                  INPUT ",":U).
          /* Allow for the possibility of more than one match. */
          IF cHandles NE ? THEN
          DO iEntry = 1 TO NUM-ENTRIES(cHandles):
            hDO = WIDGET-HANDLE(ENTRY(iEntry, cHandles)).
            /* child SBO will need to know who the parent is */
            IF {fn getObjectType hDO} = 'smartBusinessObject':U THEN
               ghTargetProcedure = TARGET-PROCEDURE.
            RUN dataAvailable IN hDO
                  (INPUT pcRelative) NO-ERROR.
            ghTargetProcedure = ?. 
          END.    /* END DO iEntry */
        END.
     END.       /* END ELSE DO (if not from a data-target) */
  END.           /* END ELSE DO (if not from an external object) */

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete Procedure 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:     Receives the deleteComplete event from a contained SDO and 
               passes it on to the appropriate DATA-TARGET
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMapping   AS CHAR   NO-UNDO.
DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
DEFINE VARIABLE iObject    AS INT    NO-UNDO.
DEFINE VARIABLE cHandle    AS CHAR   NO-UNDO.

  {get ObjectMapping cMapping}.
  cHandle = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, /* may be more than one match */
                   INPUT STRING(SOURCE-PROCEDURE),
                   INPUT cMapping,
                   INPUT FALSE,           /* Get entry/entries *before* this */
                   INPUT ",":U).          /* delimiter */

  DO iObject = 1 TO NUM-ENTRIES(cHandle):
    hObject = WIDGET-HANDLE(ENTRY(iObject, cHandle)).
    RUN deleteComplete IN hObject NO-ERROR.
  END.    /* END DO iObject */

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteData Procedure 
PROCEDURE deleteData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT         PARAMETER pcColumnNames AS CHARACTER  NO-UNDO.
 DEFINE INPUT         PARAMETER pcOldValues   AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT        PARAMETER pcError       AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE dummy AS CHARACTER  NO-UNDO.

 RUN processOpenCall IN TARGET-PROCEDURE
                    ('DELETE':U, 
                      pcColumnNames,  
                      pcOldValues,  
                      INPUT-OUTPUT dummy,  /* new values N/A */
                      OUTPUT pcError).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchBatch Procedure 
PROCEDURE fetchBatch :
/*------------------------------------------------------------------------------
  Purpose:     Returns the next batch of rows to a browse object, communicating
               with its SDO.
  Parameters:
    INPUT plForwards - TRUE if we should retrieve a batch of rows after 
                       the current rows,
                       FALSE if before.  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER plForwards AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cMapping      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hSDO          AS HANDLE    NO-UNDO.
  
  /* Get the mapping of objects to DataObjects to locate the SDO for this
     browse.  */
  {get ObjectMapping cMapping}.
  
  iEntry = LOOKUP(STRING(SOURCE-PROCEDURE), cMapping).
 
  IF iEntry NE 0 THEN
  DO:
    hSDO = WIDGET-HANDLE(ENTRY(iEntry + 1, cMapping)).
    RUN fetchBatch IN hSDO(INPUT plForwards).
  END.         /* END DO IF SOURCE matches current Entry */
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchContainedData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchContainedData Procedure 
PROCEDURE fetchContainedData :
/*------------------------------------------------------------------------------
  Purpose:     client-side procedure to get a set of data back from the
               server.
  Parameters:  pcObject AS CHARACTER 
               - Blank - openQuery request to retireve data for all SDOs
               - if specified, then fetch data sets from that Object down only.
               - 'DEFINE' - Special not-open , but get defs case for SDOs with
                            dynamic SDOs running on a client   
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcObject AS CHARACTER  NO-UNDO.
 
  DEFINE VARIABLE cASDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllQueries     AS CHARACTER  NO-UNDO INIT "":U.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cServerFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hAsHandle       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAppServer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject1     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject2     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject3     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject4     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject5     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject6     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject7     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject8     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject9     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject10    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject11    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject12    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject13    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject14    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject15    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject16    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject17    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject18    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject19    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject20    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFirstSDO       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMaster         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOs           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDONames       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignValues  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iSDONum         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTTList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitialized    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hRowObjectTT    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjUpdTable AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDynamic        AS LOGICAL    NO-UNDO.
  
  {get ASDivision cASDivision}.
  RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).
  
  IF cASDivision = 'Client':U THEN
  /* This is the Client half of a divided SBO; get the server to
     apply the where clause, open the server-side queries, and
     return the resulting temp-tables. */
  DO:
    /* Special case.. retrieve definitions when OpenOnInit is false */
    IF pcObject = 'DEFINE':U THEN
    DO:
      {get ContainedDataObjects cSDOS}.
      DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
        hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
        {get RowObjectTable hRowObjectTT hSDO}.
        ASSIGN
         cAllQueries = (cAllQueries 
                        + (IF iSDO = 1 THEN '':U ELSE CHR(1))
                        + 'SKIP':U).
         cTTList     = cTTList 
                     + (IF iSDO = 1 THEN '':U ELSE ',':U)
                     + (IF VALID-HANDLE(hRowObjectTT)
                        THEN STRING(hRowObjectTT)
                        ELSE '?':U).                     
      END.
    END.
    ELSE DO:
      RUN prepareQueriesForFetch IN TARGET-PROCEDURE
                   (INPUT pcObject,
                    INPUT '':U,
                    OUTPUT cAllQueries,
                    OUTPUT cTTList).
      IF RETURN-VALUE BEGINS 'ADM-ERROR':U THEN
        RETURN RETURN-VALUE.
    END.
    ASSIGN 
       hRowObject1  = WIDGET-H(ENTRY(1,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 1
       hRowObject2  = WIDGET-H(ENTRY(2,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 2
       hRowObject3  = WIDGET-H(ENTRY(3,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 3
       hRowObject4  = WIDGET-H(ENTRY(4,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 4
       hRowObject5  = WIDGET-H(ENTRY(5,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 5
       hRowObject6  = WIDGET-H(ENTRY(6,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 6
       hRowObject7  = WIDGET-H(ENTRY(7,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 7
       hRowObject8  = WIDGET-H(ENTRY(8,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 8
       hRowObject9  = WIDGET-H(ENTRY(9,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 9
       hRowObject10 = WIDGET-H(ENTRY(10,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 10
       hRowObject11 = WIDGET-H(ENTRY(11,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 11
       hRowObject12 = WIDGET-H(ENTRY(12,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 12
       hRowObject13 = WIDGET-H(ENTRY(13,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 13
       hRowObject14 = WIDGET-H(ENTRY(14,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 14
       hRowObject15 = WIDGET-H(ENTRY(15,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 15
       hRowObject16 = WIDGET-H(ENTRY(16,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 16
       hRowObject17 = WIDGET-H(ENTRY(17,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 17
       hRowObject18 = WIDGET-H(ENTRY(18,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 18
       hRowObject19 = WIDGET-H(ENTRY(19,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 19
       hRowObject20 = WIDGET-H(ENTRY(20,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 20.
    
    {get DataObjectNames cSDONames}.
    /* prepareQueriesForFetch will give error if not valid objectname */
    IF pcObject = ? OR pcObject = 'DEFINE':U THEN
      iSDONum = 1.
    ELSE 
      iSDONum = LOOKUP(pcObject, cSDONames).
    /* The ForeignValues passed as part of context for the table that 
       is on top is correct on the client, while the value returned from 
       the server is wrong, so let's log the current value so that we can
       reapply it further down */
    hFirstSDO = {fnarg DataObjectHandle ENTRY(iSDONum,cSDONames)}.
    cContext = {fn obtainContextForServer}.
    {get ForeignValues cForeignValues hFirstSDO}.    
    /* Check AppServer properties to see if the object has no current or future 
       server bindings and is using a stateless operating mode.*/    
    IF {fn hasNoServerBinding} THEN
    DO:
      RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppServer).
      {get ServerFileName cServerFileName}.
      RUN adm2/fetchcontaineddata.p ON hAppServer
          (cServerFileName,
           INPUT-OUTPUT cContext,
           cAllQueries, 
           '':U, 
           OUTPUT TABLE-HANDLE hRowObject1, 
           OUTPUT TABLE-HANDLE hRowObject2,
           OUTPUT TABLE-HANDLE hRowObject3,
           OUTPUT TABLE-HANDLE hRowObject4,
           OUTPUT TABLE-HANDLE hRowObject5,
           OUTPUT TABLE-HANDLE hRowObject6,
           OUTPUT TABLE-HANDLE hRowObject7,
           OUTPUT TABLE-HANDLE hRowObject8,
           OUTPUT TABLE-HANDLE hRowObject9,
           OUTPUT TABLE-HANDLE hRowObject10,
           OUTPUT TABLE-HANDLE hRowObject11,
           OUTPUT TABLE-HANDLE hRowObject12,
           OUTPUT TABLE-HANDLE hRowObject13,
           OUTPUT TABLE-HANDLE hRowObject14,
           OUTPUT TABLE-HANDLE hRowObject15,
           OUTPUT TABLE-HANDLE hRowObject16,
           OUTPUT TABLE-HANDLE hRowObject17,
           OUTPUT TABLE-HANDLE hRowObject18,
           OUTPUT TABLE-HANDLE hRowObject19,
           OUTPUT TABLE-HANDLE hRowObject20,
           OUTPUT cError). /* not used yet */
      {fnarg applyContextFromServer cContext}.
    END.
    ELSE DO:         
      {get ASHandle hAsHandle}.
      RUN remoteFetchContainedData IN hAsHandle
          (INPUT-OUTPUT cContext,
           INPUT cAllQueries, 
           INPUT '':U, 
           OUTPUT TABLE-HANDLE hRowObject1, 
           OUTPUT TABLE-HANDLE hRowObject2,
           OUTPUT TABLE-HANDLE hRowObject3,
           OUTPUT TABLE-HANDLE hRowObject4,
           OUTPUT TABLE-HANDLE hRowObject5,
           OUTPUT TABLE-HANDLE hRowObject6,
           OUTPUT TABLE-HANDLE hRowObject7,
           OUTPUT TABLE-HANDLE hRowObject8,
           OUTPUT TABLE-HANDLE hRowObject9,
           OUTPUT TABLE-HANDLE hRowObject10,
           OUTPUT TABLE-HANDLE hRowObject11,
           OUTPUT TABLE-HANDLE hRowObject12,
           OUTPUT TABLE-HANDLE hRowObject13,
           OUTPUT TABLE-HANDLE hRowObject14,
           OUTPUT TABLE-HANDLE hRowObject15,
           OUTPUT TABLE-HANDLE hRowObject16,
           OUTPUT TABLE-HANDLE hRowObject17,
           OUTPUT TABLE-HANDLE hRowObject18,
           OUTPUT TABLE-HANDLE hRowObject19,
           OUTPUT TABLE-HANDLE hRowObject20,
           OUTPUT cError). /* not used yet */
      {fnarg applyContextFromServer cContext}.
      /* Unbind  from AppServer if bound here or bindScope =data  */
      RUN endClientDataRequest IN TARGET-PROCEDURE.
    END. /* StateAware or already bound */
      /* Reset client values for upper table */
    {set ForeignValues cForeignValues hFirstSDO}.

    {get ContainedDataObjects cSDOS}.
    DO iSDO = iSDONum TO NUM-ENTRIES(cSDOs):
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
      {set AsHasStarted YES hSDO}.
      /* A dynamic dataobject may have gotten its table def here */          
      IF ENTRY(iSDO,cTTList) = '?':U THEN
      DO:
        CASE iSDO:
          WHEN  1 THEN hRowObjectTT = hRowObject1.
          WHEN  2 THEN hRowObjectTT = hRowObject2.
          WHEN  3 THEN hRowObjectTT = hRowObject3.
          WHEN  4 THEN hRowObjectTT = hRowObject4.
          WHEN  5 THEN hRowObjectTT = hRowObject5.
          WHEN  6 THEN hRowObjectTT = hRowObject6.
          WHEN  7 THEN hRowObjectTT = hRowObject7.
          WHEN  8 THEN hRowObjectTT = hRowObject8.
          WHEN  9 THEN hRowObjectTT = hRowObject9.
          WHEN 10 THEN hRowObjectTT = hRowObject10.
          WHEN 11 THEN hRowObjectTT = hRowObject11.
          WHEN 12 THEN hRowObjectTT = hRowObject12.
          WHEN 13 THEN hRowObjectTT = hRowObject13.
          WHEN 14 THEN hRowObjectTT = hRowObject14.
          WHEN 15 THEN hRowObjectTT = hRowObject15.
          WHEN 16 THEN hRowObjectTT = hRowObject16.
          WHEN 17 THEN hRowObjectTT = hRowObject17.
          WHEN 18 THEN hRowObjectTT = hRowObject18.
          WHEN 19 THEN hRowObjectTT = hRowObject19.
          WHEN 20 THEN hRowObjectTT = hRowObject20.
        END CASE.
        /* A dynamic dataobject may have gotten its table def here */          
        IF ENTRY(iSDO,cTTList) = '?':U THEN
        DO:
          {set RowObjectTable hRowObjectTT hSDO}.
          {get RowObjUpdTable hRowObjUpdTable hSDO}.
          IF NOT VALID-HANDLE(hRowObjUpdTable) THEN
            {fn createRowObjUpdTable hSDO}.
        END.
      END.

      /* Now reopen the RowObject query for each SDO, unless this was empty 
         definitions. */      
      IF ENTRY(iSDO,cAllQueries,CHR(1)) <> 'SKIP':U THEN
        {fnarg openDataQuery 'FIRST':U hSDO}.    
    END.  /* END DO iSDO */

   /* Publish dataavailble from the top most sdo so all child sdos are reset 
      without reopening queries, this will also reach all affected client 
      objects */
    IF pcObject <> 'DEFINE':U THEN
       PUBLISH 'dataAvailable':U FROM hFirstSDO (INPUT "RESET":U).
  END.                 /* END DO IF 'Client' */
  ELSE DO:
    /* If this is just a stand-alone (non-divided) sbo, then just
       open the query in the main Data Object or run dataavailable if its
       not the master. */
    {get MasterDataObject hMaster}.
    IF pcObject <> ? THEN 
      hFirstSDO = {fnarg DataObjectHandle pcObject} NO-ERROR. 

    IF pcObject = ? OR hFirstSDO = hMaster THEN
      {fn openQuery hMaster} NO-ERROR.
    ELSE  
      RUN dataAvailable IN hFirstSDO (?). /* unknown ensures foreignfield mapping */  
  END. /* not client */
  
  RUN changeCursor IN TARGET-PROCEDURE('':U).
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchContainedRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchContainedRows Procedure 
PROCEDURE fetchContainedRows :
/*------------------------------------------------------------------------------
  Purpose:     client-side procedure to get a batch of data from one 
               SDO and all tables from SDOs below in the data-link chain/tree .
               
  Parameters:  pcObject AS CHARACTER -- if specified, then fetch data sets
               from that Object down only.
               Intended for Internal use. 
               Called from clientSendRows in the contained SDO.
               The caller is responsible for publish of dataAvailable.  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObject       AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
  DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
  DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.
  
  DEFINE VARIABLE cASDivision     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllQueries     AS CHARACTER  NO-UNDO INIT "":U.
  DEFINE VARIABLE hAsHandle       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAppServer      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cServerFileName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject1     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject2     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject3     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject4     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject5     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject6     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject7     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject8     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject9     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject10    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject11    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject12    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject13    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject14    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject15    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject16    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject17    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject18    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject19    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObject20    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDONames       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOs           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iSDO            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iSDONum         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTTList         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cForeignValues  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataContainer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.

  {get ASDivision cASDivision}.  
  IF cAsDivision <> 'client':U THEN
  DO:
    DYNAMIC-FUNCTION ('showMessage' IN TARGET-PROCEDURE,
      'fetchContainedRows should only be called on the client half of an SBO':U).
     RETURN 'ADM-ERROR':U.
  END.

  {get DataObjectNames cSDONames}.
  
  /* prepareQueriesForFetch handles the error if not valid objectname */
  IF pcObject = ? THEN
    iSDONum = 1.
  ELSE 
    iSDONum = LOOKUP(pcObject, cSDONames).

  /* Check if a data Container can handle the request 
    (we currently only do this for the master object) */
  IF iSDOnum = 1 THEN
  DO:
    hDataContainer = {fn dataContainerHandle}.
    IF VALID-HANDLE(hDataContainer) THEN
    DO:
      {get ObjectName cObjectName}.
       RUN fetchContainedRows IN hDataContainer 
        (cObjectName, 
         piStartRow, 
         pcRowIdent, 
         plNext, 
         piRowsToReturn, 
         OUTPUT piRowsReturned).    
      RETURN.
    END.
  END.

  RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).

  RUN prepareQueriesForFetch IN TARGET-PROCEDURE
                 (INPUT pcObject,
                  INPUT 'EmptyChildren':U, /* Empty temptables below pcObject*/
                  OUTPUT cAllQueries,
                  OUTPUT cTTList).
  
  IF RETURN-VALUE BEGINS 'ADM-ERROR':U THEN
     RETURN RETURN-VALUE.

  ASSIGN 
    hRowObject1  = WIDGET-H(ENTRY(1,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 1
    hRowObject2  = WIDGET-H(ENTRY(2,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 2
    hRowObject3  = WIDGET-H(ENTRY(3,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 3
    hRowObject4  = WIDGET-H(ENTRY(4,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 4
    hRowObject5  = WIDGET-H(ENTRY(5,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 5
    hRowObject6  = WIDGET-H(ENTRY(6,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 6
    hRowObject7  = WIDGET-H(ENTRY(7,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 7
    hRowObject8  = WIDGET-H(ENTRY(8,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 8
    hRowObject9  = WIDGET-H(ENTRY(9,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 9
    hRowObject10 = WIDGET-H(ENTRY(10,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 10
    hRowObject11 = WIDGET-H(ENTRY(11,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 11
    hRowObject12 = WIDGET-H(ENTRY(12,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 12
    hRowObject13 = WIDGET-H(ENTRY(13,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 13
    hRowObject14 = WIDGET-H(ENTRY(14,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 14
    hRowObject15 = WIDGET-H(ENTRY(15,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 15
    hRowObject16 = WIDGET-H(ENTRY(16,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 16
    hRowObject17 = WIDGET-H(ENTRY(17,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 17
    hRowObject18 = WIDGET-H(ENTRY(18,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 18
    hRowObject19 = WIDGET-H(ENTRY(19,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 19
    hRowObject20 = WIDGET-H(ENTRY(20,cTTList)) WHEN NUM-ENTRIES(cTTList) >= 20.  
    
  /* The ForeignValues passed as part of context for the table that 
     is on top is correct on the client, while the value returned from 
     the server is wrong, so let's log the current value so that we can
     reapply it further down */

  hMaster = {fnarg DataObjectHandle ENTRY(iSDONum,cSDONames)}.
  {get ForeignValues cForeignValues hMaster}.    
  cContext = {fn obtainContextForServer}.  
   /* Check AppServer properties to see if the object has no current or future 
      server bindings and is using a stateless operating mode.*/    
  IF {fn hasNoServerBinding} THEN   
  DO:
    RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppServer).
    {get ServerFileName cServerFileName}.
    RUN adm2/fetchcontainedrows.p ON hAppServer
          (cServerFileName,
           INPUT-OUTPUT cContext,
           cAllQueries,
           piStartRow, 
           pcRowIdent, 
           plNext, 
           piRowsToReturn, 
           OUTPUT piRowsReturned,
           OUTPUT TABLE-HANDLE hRowObject1 APPEND, 
           OUTPUT TABLE-HANDLE hRowObject2 APPEND,
           OUTPUT TABLE-HANDLE hRowObject3 APPEND,
           OUTPUT TABLE-HANDLE hRowObject4 APPEND,
           OUTPUT TABLE-HANDLE hRowObject5 APPEND,
           OUTPUT TABLE-HANDLE hRowObject6 APPEND,
           OUTPUT TABLE-HANDLE hRowObject7 APPEND,
           OUTPUT TABLE-HANDLE hRowObject8 APPEND,
           OUTPUT TABLE-HANDLE hRowObject9 APPEND,
           OUTPUT TABLE-HANDLE hRowObject10 APPEND,
           OUTPUT TABLE-HANDLE hRowObject11 APPEND,
           OUTPUT TABLE-HANDLE hRowObject12 APPEND,
           OUTPUT TABLE-HANDLE hRowObject13 APPEND,
           OUTPUT TABLE-HANDLE hRowObject14 APPEND,
           OUTPUT TABLE-HANDLE hRowObject15 APPEND,
           OUTPUT TABLE-HANDLE hRowObject16 APPEND,
           OUTPUT TABLE-HANDLE hRowObject17 APPEND,
           OUTPUT TABLE-HANDLE hRowObject18 APPEND,
           OUTPUT TABLE-HANDLE hRowObject19 APPEND,
           OUTPUT TABLE-HANDLE hRowObject20 APPEND,
           OUTPUT cError). /* not used yet */
    {fnarg applyContextFromServer cContext}.
  END.
  ELSE DO:
    {get ASHandle hAsHandle}.
    RUN remoteFetchContainedRows IN hAsHandle
     (INPUT-OUTPUT cContext,
      cAllQueries,
      piStartRow, 
      pcRowIdent, 
      plNext, 
      piRowsToReturn, 
      OUTPUT piRowsReturned,
      OUTPUT TABLE-HANDLE hRowObject1 APPEND, 
      OUTPUT TABLE-HANDLE hRowObject2 APPEND,
      OUTPUT TABLE-HANDLE hRowObject3 APPEND,
      OUTPUT TABLE-HANDLE hRowObject4 APPEND,
      OUTPUT TABLE-HANDLE hRowObject5 APPEND,
      OUTPUT TABLE-HANDLE hRowObject6 APPEND,
      OUTPUT TABLE-HANDLE hRowObject7 APPEND,
      OUTPUT TABLE-HANDLE hRowObject8 APPEND,
      OUTPUT TABLE-HANDLE hRowObject9 APPEND,
      OUTPUT TABLE-HANDLE hRowObject10 APPEND,
      OUTPUT TABLE-HANDLE hRowObject11 APPEND,
      OUTPUT TABLE-HANDLE hRowObject12 APPEND,
      OUTPUT TABLE-HANDLE hRowObject13 APPEND,
      OUTPUT TABLE-HANDLE hRowObject14 APPEND,
      OUTPUT TABLE-HANDLE hRowObject15 APPEND,
      OUTPUT TABLE-HANDLE hRowObject16 APPEND,
      OUTPUT TABLE-HANDLE hRowObject17 APPEND,
      OUTPUT TABLE-HANDLE hRowObject18 APPEND,
      OUTPUT TABLE-HANDLE hRowObject19 APPEND,
      OUTPUT TABLE-HANDLE hRowObject20 APPEND,
      OUTPUT cError).                        /* not used yet */
    {fnarg applyContextFromServer cContext}.
    /* Unbind or read data properties from appserver */
    RUN endClientDataRequest IN TARGET-PROCEDURE.
  END.
  
  /* Reset client values for upper table */
  {set ForeignValues cForeignValues hMaster}.   

  {get ContainedDataObjects cSDOs}.
  /* prepareQueriesForFetch will give error if not valid objectname */
  DO iSDO = iSDONum TO NUM-ENTRIES(cSDOs):
    hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
    /* Now reopen the RowObject query for child SDOs 
       clientSendRows takes care of the first  */
    IF iSDO > iSDONum THEN
    DO:
      {fnarg openDataQuery 'FIRST':U hSDO}.    
      {set DataIsFetched TRUE hSDO}.
    END.

  END.  /* END DO iSDO */

  RUN changeCursor IN TARGET-PROCEDURE('':U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchDOProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchDOProperties Procedure 
PROCEDURE fetchDOProperties :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves any properties from the server-side SBO and its SDOs
               and sets them in the contained SDOs on the client.
  Parameters:  <none>
  Note:        In 9.1C this was always called from postCreateObjects, but
               now this is only called at the first call in the case we do a 
               connection (getAsHandle or bindserver) before the actual data 
               request.
            -  This means that this is not a guaranteed to be called and should 
               not be used as an override event to capture first-time connections
            -  We try to avoid using this altogether as we try to postpone the 
               connection until we do the actual data request in which case 
               the 'first-time' context comes back as part of that call instead 
               of here. But we run this from initializeServerObject if 
               AsHasStarted is false, in order to provide an optional backwards 
               compatibilty, but it will require a forced connection before the 
               data request to ensure that this is called. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContext    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cAsDivision AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lASBound      AS LOGICAL   NO-UNDO.
  
  {get AsDivision cAsDivision}.  
  {get ASBound lAsbound}.
  /* We cannot call this when unbound since it may be part of the startup
     from getashandle */
  IF cAsDivision = 'Client':U AND lAsBound THEN
  DO:
    {get ASHandle hAppServer}.
    RUN serverFetchDOProperties IN hAppServer (OUTPUT cContext).
    {fnarg applyContextFromServer cContext}.

    /* Unbind just in case.... 
       Although this currently is (and always have been) called when bound 
       we don't want to enforce it since it can be used to retrieve properties 
       at an early stage under other circumstances for example if openoninit 
       is false.. */
    RUN unbindServer IN TARGET-PROCEDURE (?). 

  END. /* Asdivision = 'client' */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirst Procedure 
PROCEDURE fetchFirst :
/*------------------------------------------------------------------------------
  Purpose:     SBO version of the event procedure to retrieve the first row
               in one of the ContainedDataObjects. It uses the ObjectMapping
               SBO property to match the caller to its Target, or uses
               the MasterDataObject by default.
  Parameters:  <none>
     Notes:    Uses the MasterDataObject by default.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hObject     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cMapping    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iObject     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hRequester  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cNavSource  AS CHARACTER   NO-UNDO.
    
    {get NavigationSource cNavSource}.    
    /* A browser target may run fetchFirst and have to set the Target to
      be identified */ 
    IF LOOKUP(STRING(SOURCE-PROCEDURE),cNavSource) = 0 THEN
    DO:
      {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.   
      IF NOT VALID-HANDLE(hRequester) THEN
        hRequester = SOURCE-PROCEDURE.
    END.
    ELSE 
      hRequester = SOURCE-PROCEDURE.

    {get ObjectMapping cMapping}.
    iObject = LOOKUP(STRING(hRequester), cMapping).
    IF iObject NE 0 THEN
        hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
    IF NOT VALID-HANDLE(hObject) THEN
        {get MasterDataObject hObject}.
    RUN fetchFirst IN hObject.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast Procedure 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose:     SBO version of the event procedure to retrieve the last row
               in one of the ContainedDataObjects. It uses the ObjectMapping
               SBO property to match the caller to its Target, or uses
               the MasterDataObject by default.
  Parameters:  <none>
     Notes:    Uses the MasterDataObject by default.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hObject     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cMapping    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iObject     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE hRequester  AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cNavSource  AS CHARACTER   NO-UNDO.

    {get NavigationSource cNavSource}.    
    /* A browser target may run fetchLast and have to set the Target to
      be identified */ 
    IF LOOKUP(STRING(SOURCE-PROCEDURE),cNavSource) = 0 THEN
    DO:
      {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.   
      IF NOT VALID-HANDLE(hRequester) THEN
        hRequester = SOURCE-PROCEDURE.
    END.
    ELSE 
      hRequester = SOURCE-PROCEDURE.

    {get ObjectMapping cMapping}.
    iObject = LOOKUP(STRING(hRequester), cMapping).
    IF iObject NE 0 THEN
        hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
    IF NOT VALID-HANDLE(hObject) THEN
        {get MasterDataObject hObject}.
    RUN fetchLast IN hObject.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchNext Procedure 
PROCEDURE fetchNext :
/*------------------------------------------------------------------------------
  Purpose:     SBO version of the event procedure to retrieve the next row
               in one of the ContainedDataObjects. It uses the ObjectMapping
               SBO property to match the caller to its Target, or uses
               the MasterDataObject by default.
  Parameters:  <none>
     Notes:    Uses the MasterDataObject by default.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hObject     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cMapping    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iObject     AS INTEGER     NO-UNDO.

    {get ObjectMapping cMapping}.
    iObject = LOOKUP(STRING(SOURCE-PROCEDURE), cMapping).
    IF iObject NE 0 THEN
        hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
    IF NOT VALID-HANDLE(hObject) THEN
        {get MasterDataObject hObject}.
    RUN fetchNext IN hObject.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrev Procedure 
PROCEDURE fetchPrev :
/*------------------------------------------------------------------------------
  Purpose:     SBO version of the event procedure to retrieve the previous row
               in one of the ContainedDataObjects. It uses the ObjectMapping
               SBO property to match the caller to its Target, or uses
               the MasterDataObject by default.
  Parameters:  <none>
     Notes:    Uses the MasterDataObject by default.
------------------------------------------------------------------------------*/

    DEFINE VARIABLE hObject     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cMapping    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iObject     AS INTEGER     NO-UNDO.

    {get ObjectMapping cMapping}.
    iObject = LOOKUP(STRING(SOURCE-PROCEDURE), cMapping).
    IF iObject NE 0 THEN
        hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
    IF NOT VALID-HANDLE(hObject) THEN
        {get MasterDataObject hObject}.
    RUN fetchPrev IN hObject.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-filterContainerHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterContainerHandler Procedure 
PROCEDURE filterContainerHandler :
/*------------------------------------------------------------------------------
  Purpose:     Adds the Filter link between itself and a Filter container.  
               Called from startFilter after the Filter container is 
               contructed.  
  Parameters:  phFilterContainer AS HANDLE - handle of the Filter container
  Notes:       The code to add the Filter link has been separated from 
               startFilter so that filterContainerHandler can be overridden
               to add other links between this object and the Filter container.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER phFilterContainer AS HANDLE NO-UNDO.

  RUN addLink IN TARGET-PROCEDURE ( phFilterContainer , 'Filter':U , TARGET-PROCEDURE  ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeLogicObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeLogicObject Procedure 
PROCEDURE initializeLogicObject :
/*------------------------------------------------------------------------------
  Purpose:     Start the logic procedure for the data object
  Parameters:  <none>
  Notes:       The Logic Procedure is an optional object that can contain 
               validation and business logic for a particular table.  
               Rules: 
               - The RUN is ALWAYS executed with (or without) the extension that 
                 is defined in DataLogicProcedure property 
                 ( this ensures that program-name and :file-name behave as expected)
               - follows Progress core run rules:       
                1. ANY extention will run r-code if found 
                2. will run .r if NO period in run name 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLogicProc   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDummy       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDotRFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMemberFile  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDbList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDb          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lUseProxy    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSourceExt   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iExt         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cProxyName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProxyDotR   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExtension   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lWebClient   AS LOGICAL    NO-UNDO.

  {get DataLogicProcedure cLogicProc}.
  
  IF cLogicProc = '':U THEN
    RETURN.

  {get DataLogicObject hObject}.
  IF VALID-HANDLE(hObject) THEN
    RETURN.

  iExt = R-INDEX(cLogicProc,'.':U).
  
  IF iExt > 1 THEN
    ASSIGN
      cFile      = SUBSTR(cLogicProc,1,iExt - 1)
      cExtension = SUBSTR(cLogicProc,iExt).
  ELSE
    cFile = cLogicProc.

  lWebClient = SESSION:CLIENT-TYPE = 'WEBCLIENT':U.
  
  /* If not web client and any db connections find r-code for inspection */   
  IF NOT lWebClient AND NUM-DBS > 0 THEN
  DO:
    ASSIGN /* Find the .r file */
      FILE-INFO:FILE-NAME = cFile + ".r":U
      cDotRFile           = FILE-INFO:FULL-PATHNAME
       /* If .r in proc lib, get the member name (ie, filename). */
      cMemberFile = MEMBER(cDotRFile).
  
    IF cMemberFile <> ? THEN
      cDotRFile = cMemberFile.
  END. /* any db */
  ELSE
    lUseProxy = TRUE.

  /* We have found the base .r */
  IF cDotRFile NE ? THEN 
  DO:  
    ASSIGN 
      RCODE-INFO:FILE-NAME = cDotRFile
      cDBList              = RCODE-INFO:DB-REFERENCES.
    DO iDB = 1 TO NUM-ENTRIES(TRIM(cDBList)):   /* Remove blank when no db */
      IF NOT CONNECTED(ENTRY(iDB,cDBList)) THEN 
      DO:
        lUseProxy = TRUE. /* Flag that we can't use the base file. */
        LEAVE.
      END.  /* Found a DB that needs to be connected that isn't */
    END.  /* Do for each required DB */
    IF NOT lUseProxy THEN
      cRunName = cFile + cExtension.
  END.
  
  /* if not connected or no r-code found check if there is proxy r-code */
  IF cRunName = '':U THEN
  DO:
    ASSIGN
      cProxyName = cFile      + '_cl':U
      cProxyDotR = cProxyName + '.r':U.
    
    /* if no proxy r-code, check if we have source code */
    IF /* NOT lWebClient AND*/ SEARCH(cProxyDotR) = ? THEN
    DO:
      IF cExtension > '':U THEN
      DO:
        IF lUseProxy THEN
          cRunName = cProxyName + cExtension.
        ELSE 
          cRunName = cFile + cExtension.        
        IF SEARCH(cRunName) = ? THEN
          cRunName = '':U.
      END.
    END.
    ELSE
      cRunName = cProxyName + cExtension.
  END.
  
  IF cRunName > '':U THEN
  DO: 
    DO ON STOP UNDO, LEAVE:   
      RUN VALUE(cRunName) PERSISTENT SET hObject.
      TARGET-PROCEDURE:ADD-SUPER-PROCEDURE(hObject, SEARCH-TARGET).
      {set DataLogicObject hObject}.   
    END.
    /* Cannot run without the specified data logic */
    IF NOT VALID-HANDLE(hObject) THEN
      RUN destroyObject IN TARGET-PROCEDURE. 
  END.  
  ELSE IF NOT lUseProxy THEN
  DO:
    RUN showMessageProcedure IN TARGET-PROCEDURE("33,":U + cLogicProc, 
                                                 OUTPUT cDummy).
    RUN destroyObject IN TARGET-PROCEDURE. 
  END.
     
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     SBO-specific code for initializeObject. 
  Parameters:  <none>
  Notes:       This procedure establishes the AppServer connection.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAppService      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppservice      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSvrFileName     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataSource      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOpenOnInit      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lFetchPending    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cValues          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lInitialized     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cOrdering        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAsDivision      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOs            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRowObjectTable  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lFetchDefs       AS LOGICAL    NO-UNDO.
  /* Skip all this if we're in design mode. */
  {get UIBMode cUIBMode}.

  /* If the object has a Partition name, then connect */
  IF cUIBMode = "":U THEN
  DO:
    /* Ensure that initialization only happens once */
    {get ObjectInitialized lInitialized}.
    IF lInitialized THEN
      RETURN. 
  
    {get AppService cAppService}. 
    IF cAppService NE "":U THEN
    DO:
      RUN connectServer IN TARGET-PROCEDURE (OUTPUT hAppService). 
      IF hAppService = ? THEN
        RETURN ERROR 'ADM-ERROR':U.    
      {get ContainerSource hContainerSource}.                       
      {fnarg registerAppService cAppservice hContainerSource}. 
    END.  /* IF AppService NE "":U */
    ELSE
    DO:
      /* If no AppService defined, check if the user is running the client
         proxy. If so, there can't be any required databases connected for
         the object to show data. Probably an AppServer setup problem. */
      IF TARGET-PROCEDURE:FILE-NAME MATCHES '*_cl.w':U OR
         TARGET-PROCEDURE:FILE-NAME MATCHES '*_cl.r':U THEN
      DO:
        cSvrFileName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.w":U, ".w":U).
        IF cSvrFileName = TARGET-PROCEDURE:FILE-NAME THEN
          cSvrFileName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.r":U, ".w":U).
        DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, cSvrFileName + 
        " SmartBusinessObject has no AppServer partition defined and is ":U +
        "running locally without proper database connection(s).":U).
        RETURN "ADM-ERROR":U.
      END.        /* END DO IF proxy (_cl) */
    END.          /* END ELSE DO IF AppService = "" */
  END.            /* END DO IF UIBMode ne "" */
  
  /* SDOs publishes queryPosition to the toolbar as soon as they are 
     initialized and the toolbars activeTarget check requires a non-hidden 
     object */  
  {set ObjectHidden no}.
  
  PUBLISH 'registerObject':u FROM TARGET-PROCEDURE.

  {get ContainerSource hContainerSource}.                       
  
  {get OpenOnInit lOpenOnInit}.
  /* we set openOninit false if fetchPending below since all the logic 
     after this is similar if OpenOnInit is false Or fetchIsPending */
  IF VALID-HANDLE(hContainerSource) 
  AND VALID-HANDLE(hAppService) AND hAppService <> SESSION THEN
  DO:
    /* Check AppServer properties to see if the object has no current or future 
       server bindings and is using a stateless operating mode. */   
    IF  {fn hasNoServerBinding} 
    AND {fn IsFetchPending hContainerSource}  THEN
      lFetchPending = TRUE. 
  END.
  
  /* Set BindScope before SUPER as createObjects will use it to identify 
     that this a data request is pending also when no container */
  IF lOpenOnInit AND NOT lFetchPending THEN
    {set BindScope 'Data':U}.

  /* Continue with std container initialization. This will start-up the 
     contained SDOs */
  RUN SUPER.

  /* if we have failed to initialize our contents do not 
     attempt to 'openQuery' etc. to avoid ugly errors */
  IF RETURN-VALUE = "ADM-ERROR":U 
  OR {fn fetchMessages} > "":U THEN 
    RETURN "ADM-ERROR":U.

  RUN registerLinkedObjects IN TARGET-PROCEDURE.

  IF cUIBmode = '':U THEN
  DO:
    IF lOpenOnInit AND NOT lFetchPending THEN
    DO:
      {get DataSource hDataSource}.
      IF VALID-HANDLE(hDataSource) THEN
        RUN dataAvailable IN TARGET-PROCEDURE ('initialize':U).
      ELSE
        {fn openQuery}.
    END. /* openOnInit */

    /* If we are not managed by a datacontainer check if any definitions 
       are missing. This is typically if openOnInit is false, but we need to 
       check when we have a valid source as definitions may still be invalid 
       also if the source's OpenOnInit is false */  
    {get AsDivision cAsDivision}.
    IF cAsDivision = 'CLIENT':U 
    AND (NOT lOpenOnInit OR VALID-HANDLE(hDataSource))
    AND NOT lFetchPending THEN
    DO:
      {get ContainedDataObjects cSDOS}.
      DO iSDO = 1 TO NUM-ENTRIES(cSDOs): 
        hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).     
        {get RowObjectTable hRowObjectTable hSDO}.       
        IF NOT VALID-HANDLE(hRowObjectTable) THEN
        DO:
          lFetchDefs = TRUE.
          LEAVE.
        END.
      END.
      IF lFetchDefs THEN
        RUN fetchContainedData IN TARGET-PROCEDURE('DEFINE':U).
    END.

    RUN unbindServer IN TARGET-PROCEDURE ('unconditionally':U).
    IF VALID-HANDLE(hDataSource) THEN
    DO:
      {get ForeignValues cValues}.  /* Save FF values for later querying. */
      {get MasterDataObject hMaster}.
      IF VALID-HANDLE(hMaster) THEN
        {set ForeignValues cValues hMaster}.
    END.
  END. /* if cuibmode = ''  */
  
  /* We need to do this here to account for any dynamic SDOs that were just 
     started up. Any static SDOs are alreday processed */
  cOrdering = {fn initDataObjectOrdering}. /* also sets 'UpdateTables' */
  {set DataObjectOrdering cOrdering}.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeServerObject Procedure 
PROCEDURE initializeServerObject :
/*------------------------------------------------------------------------------
  Purpose:   Set context and initialize the server object   
  Parameters:  <none>
  Notes:    This procedure is not considered to be part of the public API. It 
            is part of the start of the server object called from: 
           (bindServer ->) getAsHandle -> restartServerObject -> runServerObject.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAsHandle     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lASBound      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cContext      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lAsHasStarted AS LOGICAL   NO-UNDO.

  {get ASBound lASBound}.

  IF lASBound THEN
  DO:
    {get AsHandle hAsHandle}.
    {get AsHasStarted lAsHasStarted}.
    /* FetchDoProperties is not really needed anymore, it is only used here 
       and it's not even guaranteed to be called as we try to avoid a 
       connection until we do the actual data request in which case the 
       'first-time' context comes back as part of that call 
      But we keep it since it does provide some sort of backwards compatibilty
      although it would require a forced connection before the data request */  
    IF NOT lAsHasStarted THEN
      RUN FetchDOProperties IN TARGET-PROCEDURE. 
    ELSE 
      RUN SUPER.
  END. /* if bound */

  RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isUpdatePending) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isUpdatePending Procedure 
PROCEDURE isUpdatePending :
/*------------------------------------------------------------------------------
  Purpose:  Published through data-targets to check if any updates are pending.
            This SBO version of the event turns around and RUNS it in 
            the SDO to which the caller is mapped. 
            If no pending updates found it publishes isUpdatePending 
            to its targets     
  Parameters: input-output plUpdate 
              Returns TRUE and stops the publishing if update is pending. 
  Notes:      New is included as a pending update. 
              Called from canNavigate, which is used by navigating objects to 
              check if they can trust an updateState('updatecomplete') message 
------------------------------------------------------------------------------*/
 DEFINE INPUT-OUTPUT PARAMETER plUpdate AS LOGICAL    NO-UNDO.

 DEFINE VARIABLE cMapping     AS CHAR       NO-UNDO.
 DEFINE VARIABLE iObject      AS INT        NO-UNDO.
 DEFINE VARIABLE hObject      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cHandles     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hTarget      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cSubscribed  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTargets     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContained   AS CHARACTER  NO-UNDO.
 
 IF NOT plUpdate THEN
 DO:
   {get ObjectMapping cMapping}.
   /* Find out if this came from one of our Data-*Target*s (such as a
     Browser). if so, check the associated SDO, which will publish it 
     back...  
     We must check that the SOURCE is the first entry of a pair,
     which means its an external object linked to an internal SDO. */
   {get ObjectMapping cMapping}.
   cHandles = DYNAMIC-FUNCTION ('mappedEntry':U IN TARGET-PROCEDURE,
                                INPUT STRING(SOURCE-PROCEDURE),
                                INPUT cMapping,
                                INPUT TRUE, /* Return entry after this */
                                INPUT ",":U).

   IF cHandles <> ? THEN
   DO iObject = 1 TO NUM-ENTRIES(cHandles):
     hObject  = WIDGET-HANDLE(ENTRY(iObject,cHandles)).
     IF VALID-HANDLE(hObject) THEN
     DO:
       RUN isUpdatePending IN hObject (INPUT-OUTPUT plUpdate).     
       IF plUpdate THEN 
         RETURN.
     END.
   END.
   ELSE DO: 
     /* Check if this is from an inside SDO and run the event in its 
        the targets that are mapped */ 
     cHandles = DYNAMIC-FUNCTION ('mappedEntry':U IN TARGET-PROCEDURE,
                                   INPUT STRING(SOURCE-PROCEDURE),
                                   INPUT cMapping,
                                   INPUT FALSE, /* Return entry before this */
                                   INPUT ",":U).
     {get DataTarget cTargets}.
     IF cHandles <> ? THEN
     DO iObject = 1 TO NUM-ENTRIES(cHandles):
       hObject  = WIDGET-HANDLE(ENTRY(iObject, cHandles)).
       IF VALID-HANDLE(hObject) AND LOOKUP(STRING(hObject),cTargets) > 0 THEN
       DO:
         {get DataSourceEvents cSubscribed hObject}.
         IF LOOKUP('isUpdatePending':U,cSubscribed) > 0 THEN
         DO:
           RUN isUpdatePending IN hObject (INPUT-OUTPUT plUpdate) NO-ERROR.
           IF plUpdate THEN 
             RETURN.
         END.
       END.
     END.
     ELSE DO: /* unknown publisher, just call the master */        
       {get ContainedDataObjects cContained}.
       IF LOOKUP(STRING(SOURCE-PROCEDURE),cContained) = 0 THEN
       DO:
         {get MasterDataObject hObject} NO-ERROR.
         IF VALID-HANDLE(hObject) THEN
           RUN isUpdatePending IN hObject (INPUT-OUTPUT plUpdate).  
       END.
     END.
   END.
 END. /* not plUpdate */
 
 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkState Procedure 
PROCEDURE linkState :
/*------------------------------------------------------------------------------
  Purpose:  Handle linkstate form data targets   
  Parameters:  <none>
  Notes:    We currently handle linkstate from visual targets only.
            1. Use it to swap the NavigationSourceName so that one toolbar
               can navigate the 'active' target given by the 'active' visual 
               object. We do this by simply running resetNavigation after the switch                
            2. Republish when linkState is 'inactive'. 
               Even if the SBO does not support inactivate/activate of its 
               targets it does publish linksstate ('inactive') by itself and
               may be inactivated by its source, so we need to make sure that 
               visual objects that are activated also activates source links.        
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcState  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cNavSource         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNavSource         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hNavTarget         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cDataSourceNames   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUpdateTargetNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMapping           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOnHide            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cHandle            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObject            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryObject       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cNavTarget         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNavDataTargets    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNumTargets        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDataTarget        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPage              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPageList          AS CHARACTER  NO-UNDO.

 {get ObjectMapping cMapping}.
   
  /* Check if it's from the outside */
  cHandle = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, 
                  INPUT STRING(SOURCE-PROCEDURE),
                  INPUT cMapping,
                  INPUT TRUE,       /* Get entries after this */
                  INPUT ",":U).      /* delimiter */
   /*
  /* Check if we are supposed to toggle DataTarget links active/inactive */ 
    {get ToggleDataTargets lToggleTargets}.
    IF NOT lTofggleTargerts THEN RETURN.
    DEFINE VARIABLE lToggleTargets   AS LOGICAL    NO-UNDO.
     */

   
  /* Outside caller */
  IF cHandle <> '':U THEN
  DO:
    {get QueryObject lQueryObject SOURCE-PROCEDURE}.
    IF NOT lQueryObject THEN 
    DO:
      {get NavigationSource cNavSource}.
      IF NUM-ENTRIES(cNavSource) = 1 THEN 
      DO:
        /* Get the object the NavigationSource is mapped to in order to 
           get that object's DataTargets to keep track of their pages. 
           The mapping of the NavigationSource is not replaced down 
           below if the DataTargets of the replacement are on the same page 
           as this object's DataTargets. */
        cNavTarget = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                      INPUT cNavSource,
                                      INPUT cMapping,
                                      INPUT TRUE,
                                      INPUT ',':U).
        /* Get the mapped objects for the Navigation Target */
        cNavDataTargets = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                           INPUT cNavTarget,
                                           INPUT cMapping,
                                           INPUT FALSE,
                                           INPUT ',':U).
        
        /* Create a list of pages for the data targets */  
        DO iNumTargets = 1 TO NUM-ENTRIES(cNavDataTargets):
          /* Skip the NavigationSource mapped entry, it is not a data target */
          IF ENTRY(iNumTargets,cNavDataTargets) = cNavSource THEN NEXT.
          hDataTarget = WIDGET-HANDLE(ENTRY(iNumTargets,cNavDataTargets)).
          {get ObjectPage iPage hDataTarget}.
          cPageList = cPageList + (IF NUM-ENTRIES(cPageList) > 0 THEN ',':U ELSE '':U) + 
                      STRING(iPage).
        END.  /* do iNumTargets 1 to number of targets */

        hNavSource = WIDGET-HANDLE(cNavSource).
        {get NavigationTargetName cObjectName hNavSource}. 
        {get DeactivateTargetOnHide lOnHide hNavSource}.

        IF  (pcstate = 'active':U OR lOnHide) 
        AND (cObjectName = '':U OR cObjectName = ?) THEN
        DO:
          /* use no-error, since a pass-thru container may get here */   
          {get UpdateTargetNames cObjectName SOURCE-PROCEDURE} NO-ERROR. 
          IF cObjectName = '':U OR cObjectName = ? THEN
            {get DataSourceNames cObjectName SOURCE-PROCEDURE} NO-ERROR. 
          IF cObjectName > '':U THEN 
          DO:
            ASSIGN
              cObjectName = ENTRY(1,cObjectName)
              hNavTarget  = {fnarg dataObjectHandle cObjectName}.

            /* Get the data targets of the object about to be mapped to 
               the NavigationSource, only change the mapping if one of the
               data target objects is on a different page than the data target
               objects of the object that is already mapped */
            cNavDataTargets = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                               INPUT STRING(hNavTarget),
                                               INPUT cMapping,
                                               INPUT FALSE,
                                               INPUT ',':U).
            DO iNumTargets = 1 TO NUM-ENTRIES(cNavDataTargets):
              IF ENTRY(iNumTargets,cNavDataTargets) = cNavSource THEN NEXT.
              hDataTarget = WIDGET-HANDLE(ENTRY(iNumTargets,cNavDataTargets)).
              {get ObjectPage iPage hDataTarget}.
              IF LOOKUP(STRING(iPage),cPageList) = 0 THEN
              DO:
                ENTRY(LOOKUP(STRING(hNavSource),cMapping) + 1,cMapping) = STRING(hNavTarget).
                {set ObjectMapping cMapping}.
                RUN resetNavigation IN hNavSource.
              END.  /* if page is different than list */
            END.  /* do iNumTargets 1 to number of targets */
          END.
        END.
      END.
    END. /* not queryobject */
    IF pcstate = 'active':U THEN
       PUBLISH 'linkState':U FROM TARGET-PROCEDURE ('active').
  END.  /* from outside */
  /**********  Deactivation of an SDOs inside an SBO not yet supported
  /* published from the inside */
  ELSE DO:
    {get DataSource cDataSources}.
    IF cDataSources = '':U  THEN
       RETURN.

    IF NOT {fnarg hasActiveTargets SOURCE-PROCEDURE} THEN
    DO:
      DO iMap = 1 TO NUM-ENTRIES(cDataSources):
        cObject = ENTRY(1,cDataSources).
        hObject = WIDGET-HANDLE(cObject).
        IF CAN-DO(cMapping,cObject) THEN
        DO:
          cDataObjects = cDataObjects 
                         + (IF cDataObjects = '':U THEN '':U ELSE ',':U)
                         + cObject.
        END.
      END.
      /* publish to the datasource */
      DO iMap = 1 TO NUM-ENTRIES(cDataObjects):
        cObject = ENTRY(iMap,cDataObjects).
        hObject = WIDGET-HANDLE(cObject).
        ghTargetProcedure = TARGET-PROCEDURE.
        RUN linkState IN hObject (pcState).
        ghTargetProcedure = ?.
      END.
    END.
  END.
  *******/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkStateHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler Procedure 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phObject  AS HANDLE     NO-UNDO.
  DEFINE INPUT PARAMETER pcLink    AS CHARACTER  NO-UNDO.
 
  DEFINE VARIABLE cInactiveLinks  AS CHAR    NO-UNDO.
  DEFINE VARIABLE lDataInactive   AS LOGICAL NO-UNDO.

  IF pcstate = 'active':U AND pcLink = 'DataSource':U  THEN
  DO:
    /* if the source is inactive then just wait for the dataavailable
       that it will publish when it becomes active */ 
    {get InactiveLinks cInactiveLinks phObject}.
    IF NOT CAN-DO(cInactiveLinks,'DataSource':U) THEN 
    DO:
      {get InactiveLinks cInactiveLinks}.
      lDataInactive = CAN-DO(cInactiveLinks,'DataSource':U).
    END.
    
  END.
  
  RUN SUPER(pcState,phObject,pcLink).

  IF lDataInactive THEN DO:
    ghTargetProcedure = phObject.
    RUN dataAvailable IN TARGET-PROCEDURE('RESET':U).
    ghTargetProcedure = ?.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-postCreateObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects Procedure 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run at the end of createObjects, after all
               contained Objects have been created (but not initialized).
               It sets various properties that are dependent on knowing
               the handles and Instance Properties of all contained objects,
               and also fetches property settings from the server-side SBO.
  Parameters:  <none>
  Notes:       This is a new "hook" as of 9.1B, run from createObjects
               after adm-create-objects.
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cTargets          AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iTarget           AS INTEGER     NO-UNDO.
  DEFINE VARIABLE hTarget           AS HANDLE      NO-UNDO.
  DEFINE VARIABLE lQuery            AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE cDataColumns      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cContainedColumns AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cContainedObjects AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cObjectName       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cDONames          AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSBODataColumns   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iColumn           AS INTEGER     NO-UNDO.
  DEFINE VARIABLE hSource           AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hMDO              AS HANDLE      NO-UNDO.
  DEFINE VARIABLE cQueryString      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cDOName           AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iEntry            AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cSourceList       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cOrdering         AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTables           AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cObjectType       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iDO               AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cAsDivision       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lOpenOnInit       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAsBound          AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lDynamicData    AS LOGICAL    NO-UNDO.

  /* Find the SDO with no Data-Source; this is considered the "Master". 
     If there's more than one then the SDOs are independent and there
     is no master, so we set the property to null. At the same time,
     turn off the AppService in each SDO, so they do not attempt to
     connect to the AppServer on their own, and get them to create the
     dynamic objects needed to receive data through the SBO. 
     The DataObjectNames property is an instance property, so this will
     be set in the preferred Object order. Set ContainedDataObjects
     and the Columns property in the same order.
     Also build a master list of all ContainedDataColumns from all SDOs. 
     Also build the DataColumns variant of this list, which is one
     list of qualified column names.
     Also build a list of the contained objects' handles. 
     Also subscribe to the dataAvailable event. */
  {get ContainerTarget cTargets}.
  {get DataObjectNames cDONames}.   /* This is the Instance Property */
  
  /* if it's been explicitly set, then build the list of handles in the
     same order; the master is the first SDO in the list. */
  IF cDONames NE "":U THEN
  DO:
    DO iEntry = 1 TO NUM-ENTRIES(cDONames):
      cDOName = ENTRY(iEntry, cDONames).
        /* Locate the ObjectName among the Container-Targets */
      DO iTarget = 1 TO NUM-ENTRIES(cTargets):
         hTarget = WIDGET-HANDLE(ENTRY(iTarget, cTargets)).
         {get ObjectName cObjectName hTarget}.
         IF cObjectName = cDOName THEN
           LEAVE.
      END.    /* END DO iTarget -- searching for ObjectName match */          
      IF iEntry = 1 THEN
        {set MasterDataObject hTarget}.
      cContainedObjects = cContainedObjects 
                        + (IF cContainedObjects = "":U THEN "":U ELSE ",":U) 
                        + STRING(hTarget).
    END.  /* END DO iEntry */
  END.   /* END DO if cDONames set */
  ELSE DO:
    /* If the property hasn't been set yet, build the list starting
        with the Master. */
    {get ContainerTarget cTargets}.
    DO iTarget = 1 TO NUM-ENTRIES(cTargets):
        hTarget = WIDGET-HANDLE(ENTRY(iTarget, cTargets)).
        {get QueryObject lQuery hTarget} NO-ERROR.
        IF lQuery THEN
          /* QueryObject is considered the definition of an SDO. */
        DO:
          /* First locate the 'master' -- with no Data-Source. */
          {get DataSource hSource hTarget}.
          IF hSource = ? THEN       /* This one has no Data-Source. */
          DO:
            hMDO = hTarget.   /*   hang on to that handle. */ 
            {set MasterDataObject hMDO}.
            LEAVE.
          END.      /* END DO IF no hSource */
        END.        /* END DO IF lQuery */
    END.          /* END DO iTarget -- initial search for Master DO */
 
    /* Now start with the Master DataObject and built a list of its 
       DataTargets, recursing as necessary. */
    IF VALID-HANDLE(hMDO) THEN     /* Could be ? if no SDOs at all */
          appendContainedObjects(INPUT-OUTPUT cContainedObjects, INPUT hMDO).   
      /* Now search for any "orphan" SDOs with no connection to the others. 
         NOTE: This currently presumes that the first one found with no
         Data-Source is the proper Master. */
    DO iTarget = 1 TO NUM-ENTRIES(cTargets):
          hTarget = WIDGET-HANDLE(ENTRY(iTarget, cTargets)).
          {get QueryObject lQuery hTarget} NO-ERROR.
          IF lQuery AND LOOKUP(STRING(hTarget), cContainedObjects) = 0 THEN
              appendContainedObjects(INPUT-OUTPUT cContainedObjects, 
                                     INPUT hTarget).

    END.        /* END DO iTarget -- re-search ContainerTargets */
      /* Now build the list of ObjectNames of the SDOs, in the same order
         as ContainedObjects. */
    DO iTarget = 1 TO NUM-ENTRIES(cContainedObjects):
          hTarget = WIDGET-HANDLE(ENTRY(iTarget, cContainedObjects)).
          {get ObjectName cDOName hTarget}.
          cDONames = cDONames + 
              (IF cDONames = "":U THEN "":U ELSE ",":U) + cDOName.
    END.       /* END DO iTarget == each contained object */
    {set DataObjectNames cDONames}.
  END.           /* END ELSE DO If ObjectNames not yet set. */
 
  /* Subscribe the SBO to all SDO events that are intended for objects linked
     to the SBO. 
     Also ensure that AppServer properties are correct */    
  {get AsDivision cAsDivision}.
  {get OpenOnInit lOpenOnInit}.

  DO iTarget = 1 TO NUM-ENTRIES(cContainedObjects):
      cObjectName = ENTRY(iTarget, cDONames).
      hTarget = WIDGET-HANDLE(ENTRY(iTarget, cContainedObjects)).
      cDataColumns = DYNAMIC-FUNCTION('getDataColumns':U IN hTarget).
      cContainedColumns = cContainedColumns +
        (IF cContainedColumns NE "":U THEN ";":U ELSE "":U) +
           cDataColumns.
      /* This is the form of the column list with SDO Name qualifiers. */
      DO iColumn = 1 TO NUM-ENTRIES(cDataColumns):
          cSBODataColumns = cSBODataColumns + 
              (IF cSBODataColumns NE "":U THEN ",":U ELSE "":U) +
               cObjectName + ".":U + ENTRY(iColumn, cDataColumns).
      END.         /* END DO iColumn */
      
      {set OpenOnInit lOpenOnInit hTarget}.  

       /* No AppService for contained SDOs */
      {set AppService '':U hTarget}.  
      /* The logic in data.i that sets 'server' when source-procedure = ? is 
         not correct when the SDOs are started from this SBO object, so we copy 
         AsDivision to the SDOs. */
      {set AsDivision cAsDivision hTarget}.       
      /* SDOs in SBOs don't commit themselves in any case, so set their
         AutoCommit property to false. */ 
      {set AutoCommit FALSE hTarget}.       
      
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'dataAvailable':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'queryPosition':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'updateState':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'assignMaxGuess':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'deleteComplete':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'refreshBrowse':U  IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'cancelNew':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'linkState':U IN hTarget.
      SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO 'isUpdatePending':U IN hTarget.      
  END.  /* END DO iTarget */

  /* Set the SBO's property based on whether there's a CommitSource, 
     just as an SDO would do.  */
  {get CommitSource hSource}.
  IF hSource = ? THEN
    {set AutoCommit TRUE}.   /* It's false by default in the SBO. */
  
  {set ContainedDataObjects cContainedObjects}.
  {set ContainedDataColumns cContainedColumns}.
  {set DataColumns cSBODataColumns}.


  /* This maps the AppBuilder-generated Update Table order to the 
     DataObjectNames order. The code is in sbo.i for static SBOs 
     and in sbo.p for dynamic SBOs. For dynamic SBOs we want to wait 
     for the SDOs to be initialized first before we run this function */
  {get DynamicData lDynamicData}.
  IF NOT lDynamicData THEN DO:
    cOrdering = DYNAMIC-FUNCTION ('initDataObjectOrdering':U IN TARGET-PROCEDURE).
    {set DataObjectOrdering cOrdering}.
  END.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareDataForFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareDataForFetch Procedure 
PROCEDURE prepareDataForFetch :
/*------------------------------------------------------------------------------
  Purpose:    Prepare the object and retrieve all info for a stateless server
              request.     
  Parameters: 
    phTopContainer Handle of the container that manages the request 
    pcAppService   AppService of this request      
    pcSourceName   Qualified DataSource name
                   Blank if this is the top level in this request.
                   For a 'POSITION' request the position information is 
                   appended. 
                   
    pcOptions      Options for this request         
                   - 'INIT', initialization, used to skip DataObjects where 
                      OpenOnInit is false.
                   - 'BATCH', request for another batch, tells prepareForFetch
                     to keep the temp-table.        
                   - 'POSITION', Not supported for SBOs
                                 (cannot be source for an SDF)
i-o pcHandles      Data object handle, comma-separated 
i-o pcRunNames     Name that the server can use to start the object, comma-separated. Currently the physical name only.
i-o pcQualNames    [ContainerName: [Containername:].. InstanceName, comma-separated
                   Passed to server to be able to set context in correct objects
i-o pcQueryFields  Contains ForeignField information and position information
i-o pcQueries      QueryString, chr(1)-separated.
i-o pcTempTables   Temp-table handles. comma-separated                     
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT        PARAMETER phTopContainer  AS HANDLE     NO-UNDO.
 DEFINE INPUT        PARAMETER pcAppService    AS CHARACTER  NO-UNDO.
 DEFINE INPUT        PARAMETER pcSourceName    AS CHARACTER  NO-UNDO.
 DEFINE INPUT        PARAMETER pcOptions       AS CHARACTER  NO-UNDO.
 
 DEFINE INPUT-OUTPUT PARAMETER pcHandles       AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcPhysicalNames AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcQualNames     AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcForeignFields AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcQueries       AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcTables        AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE cContained       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAllQueries      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTtList          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cContainerName   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cQualName        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cForeignFields   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iField           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cField           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cPhysicalName    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lFirst           AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cTargets         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hTarget          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iTarget          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lQuery           AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cAppService      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lOpenOnInit      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cInactiveLinks   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContainerType   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lVisualTargets   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lInit            AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hSDO             AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRowObject       AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iLoop            AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lSkip            AS LOGICAL    NO-UNDO.

 {get AppService cAppService}.

 IF pcAppservice <> ? AND cAppService <> pcAppservice THEN
  RETURN.

 /* An SBO cannot be source for a SmartSelect, so there should not be a 
    position request, but just in case ) */
 IF LOOKUP('POSITION':U,pcOptions) > 0 THEN
   RETURN.

 ASSIGN
   lInit         = LOOKUP('INIT':U,pcOptions) > 0  
   lVisualTargets = LOOKUP('VISUALTARGETS':U,pcOptions) > 0.

 /* Return or set Skip flag if this is initialization and OpenOnInit is false 
    (the skip falg is set if we need to get the rowObject defintion from server)*/  
 IF lInit THEN
 DO:
   {get OpenOnInit lOpenOnInit}.
   IF NOT lOpenOnInit THEN 
   DO:
     /* We check for undefined dynamic sDOs and set a flag if any is found
        as we then will continue so the definition can be retrieved from server*/  
     {get ContainedDataObjects cContained}.
     DO iLoop = 1 TO NUM-ENTRIES(cContained):
       hSDO = WIDGET-HANDLE(ENTRY(iloop,cContained)). 
         
       IF VALID-HANDLE(hSDO) THEN
         {get RowObject hRowObject hSDO}.
  
       IF NOT VALID-HANDLE(hRowObject) THEN
       DO:
         lSkip = TRUE.
         LEAVE. /* sdo loop */
       END.
     END.
     IF NOT lSkip THEN
       RETURN.
   END.   /* openoninit false */
 END. /* init */

  /* Skip this data object if the DataSource link is inactive */
 {get Inactivelinks cInactiveLinks}.
 IF LOOKUP('DataSource':U,cInactiveLinks) > 0 AND NOT lSkip THEN
   RETURN.

 /* We figure out where we are in the container hierarchy by looping
    upwards from our container uptil the container that originated the 
    request. Each containername is used as qualifier */  
 {get ContainerSource hContainerSource}.
 DO WHILE hContainerSource <> phTopContainer:
   {get ObjectName cContainerName hContainerSource}
   cQualName = cContainerName
               + (IF cQualName = '':U THEN '':U ELSE ':':U)
               + cQualName
               + (IF cQualName = '':U THEN ':':U ELSE '':U).
   {get ContainerSource hContainerSource hContainerSource}.
   
   IF hContainerSource = ? THEN RETURN.
 END.
 
 {get ObjectName cObjectName}.
 cQualName = cQualName + cObjectName.  
 IF NOT lVisualTargets THEN
 DO:
   RUN prepareQueriesForFetch IN TARGET-PROCEDURE
               (INPUT ?,                
                INPUT IF pcSourceName > '':U 
                      THEN 'ParentIsChild':U 
                      ELSE IF LOOKUP('BATCH':U,pcOptions) > 0
                      THEN 'EmptyChildren':U
                      ELSE '':U,
                OUTPUT cAllQueries,
                OUTPUT cTTList).

   /* Set query entries to 'skip' if openoninit false, but undefined dynsdo
      found */
   IF lSkip THEN
   DO iLoop = 1 TO NUM-ENTRIES(cAllQueries,CHR(1)):
     ENTRY(iLoop,cAllQueries,CHR(1)) = 'SKIP':U.
   END.

   IF RETURN-VALUE BEGINS 'ADM-ERROR':U THEN
      RETURN RETURN-VALUE.

   {get ContainedDataObjects cContained}.

   IF pcSourceName <> ? AND pcSourceName <> '':U THEN
   DO:
     {get ForeignFields cForeignFields}.
      cForeignFields = pcSourceName + ',':U + cForeignFields. 
   END.
 
   /* Will use LogicalObjectName for repository objectws in the future */ 
   {get ServerFileName cPhysicalName}.
 
   ASSIGN
     lFirst          = pcHandles = '':U  
     pcHandles       = pcHandles
                     + (IF lFirst THEN '':U ELSE ',':U)
                     + cContained
     pcQueries       = pcQueries
                     + (IF lFirst THEN '':U ELSE CHR(1))
                     + cAllQueries
     pcTables        = pcTables
                     + (IF lFirst THEN '':U ELSE ',':U)
                     + cTtList
     pcQualNames     = pcQualNames
                     + (IF lFirst THEN '':U ELSE ',':U)
                     + cQualName  + FILL(',':U,NUM-ENTRIES(cContained) - 1) 
     pcPhysicalNames = pcPhysicalNames
                     + (IF lFirst THEN '':U ELSE ',':U)
                     + cPhysicalName  + FILL(',':U,NUM-ENTRIES(cContained) - 1)
     pcForeignFields = pcForeignfields
                     + (IF lFirst THEN '':U ELSE CHR(1))
                     + cForeignFields + FILL(CHR(1),NUM-ENTRIES(cContained) - 1).   
 END. /* not looking for visualtargets */

 {get DataTarget cTargets}.
 DO iTarget = 1 TO NUM-ENTRIES(cTargets):
   hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)).
   lQuery = FALSE.
   {get QueryObject lQuery hTarget}.
   {get ContainerType cContainerType hTarget}.  
   
   IF lQuery THEN
     /* prepare data object data targets */
     RUN prepareDataForFetch IN hTarget
          (phTopContainer,
           IF pcAppService = ? THEN cAppService ELSE pcAppService,
           cQualName,
           pcOptions,
           INPUT-OUTPUT pcHandles,
           INPUT-OUTPUT pcPhysicalNames,
           INPUT-OUTPUT pcQualNames,
           INPUT-OUTPUT pcForeignFields,
           INPUT-OUTPUT pcQueries,
           INPUT-OUTPUT pcTables).     

   ELSE IF lVisualTargets AND cContainerType > '':U THEN
     /* prepare Visual container targets 
           -> prepare position info for their SDF data Sources    */    
     RUN prepareDataForFetch IN hTarget
          (phTopContainer,
           IF pcAppService = ? THEN cAppService ELSE pcAppService,
           cQualName,
           'POSITION':U + IF lInit THEN ',INIT':U ELSE '':U,
           INPUT-OUTPUT pcHandles,
           INPUT-OUTPUT pcPhysicalNames,
           INPUT-OUTPUT pcQualNames,
           INPUT-OUTPUT pcForeignFields,
           INPUT-OUTPUT pcQueries,
           INPUT-OUTPUT pcTables).  
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareErrorsForReturn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareErrorsForReturn Procedure 
PROCEDURE prepareErrorsForReturn :
/*------------------------------------------------------------------------------
  Purpose:  This appends the RETURN-VALUE from the user-defined transaction
            validation procedure or other update-related error to the list
            of any errors already in the log, and formats this string to
            prepare for returning it to the client.
    Notes:  invoked internally from serverCommitTransaction.
------------------------------------------------------------------------------*/
 DEFINE INPUT        PARAMETER pcReturnValue AS CHARACTER NO-UNDO.
 DEFINE INPUT        PARAMETER pcASDivision  AS CHARACTER NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcMessages    AS CHARACTER NO-UNDO.  
 
  IF pcReturnValue NE "":U THEN
    RUN addMessage IN TARGET-PROCEDURE (pcReturnValue, ?, ?).
  IF pcASDivision = 'Server':U THEN
     pcMessages = LEFT-TRIM(pcMessages + CHR(3) + 
         DYNAMIC-FUNCTION ('fetchMessages' IN TARGET-PROCEDURE),CHR(3)).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareQueriesForFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareQueriesForFetch Procedure 
PROCEDURE prepareQueriesForFetch :
/*------------------------------------------------------------------------------
   Purpose: Prepare the Queries in the SDOs for a fetch of data from the 
            server.   
Parameters: 
    INPUT pcOptions char 
          Option. 
          - 'EmptyChildren' - empty temp-tables for chidren.
          -  Note that the default behavior has been changed to empty temp-tables
             for all SDOs. (as this is more efficient than the implicit delete
             that happens in output table-handle).   
             So the 'EmptyChildren' now really means keep the parent temp-table.                                
    OUTPUT pocQueries 
            A CHR(1) delimited list that corrsponds to ContainedDataObjects with
            the Query expressions to pass to the server in the call to fetch new 
            temp-tables. A 'SKIP' is used as the entry for the objects that are 
            not part of this request, while a blank entry indicates that the 
            server should use the base query. 
    OUTPUT pocTempTables 
            A comma separatedf list The temp-table handle. '?' for objects that are not part 
            of the fetch we are preparing for.  
    Notes:  This procedure exists in order to have common logic for 
            fetchContainedData and fetchContainedRows. This logic is a bit 
            complex and are also very likely to change. 
         -  A manually changed setQueryWhere is always used. This may have 
            very weird results if done for a new batch ..... It is considered 
            to be a user error to setQueryWhere without an immediate openQuery 
            if the object is batched. 
Note date: 2002/02/14            
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcOptions     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pocQueries    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER poctempTables AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDataObjectHandles AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iStartOnSDO        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSDONames          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hSDO               AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cQuery             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hTempTable         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cMode              AS CHARACTER  NO-UNDO.

  IF pcObjectName NE "":U AND pcObjectName NE ? THEN
  DO:
    {get DataObjectNames cSDONames}.
    iStartOnSDO = LOOKUP(pcObjectName, cSDONames).
    IF iStartOnSDO = 0 THEN
    DO:
      DYNAMIC-FUNCTION ('showMessage' IN TARGET-PROCEDURE,
        'Unknown Object Name ~'' 
        + pcObjectName 
        + '~'passed to prepareQueriesforFetch':U).
      RETURN "ADM-ERROR":U.
    END.
  END.     /* END DO IF pcObject specified. */
  ELSE iStartOnSDO = 1.  /* Signal to start at the top. */

  /* Get the handles of the dynamic temp-tables from the SDOs. */
  {get ContainedDataObjects cDataObjectHandles}.

  DO iSDO = 1 TO NUM-ENTRIES(cDataObjectHandles):
    /* If the caller requested to start at a specific SDO, then set
       all prior handles to ? and signal not to use them. */
    IF iStartOnSDO > iSDO THEN
      ASSIGN
        hTempTable = ?
        cQuery     = "SKIP":U.

    ELSE DO:      
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cDataObjectHandles)).      
      
      /* If 'EmptyChildren' and we're not yet at a child then pass 'Batch' 
        (keep TT and batch properties) */ 
      IF CAN-DO(pcOptions,'EmptyChildren':U) AND iSDO = iStartOnSDO THEN
        cMode = 'Batch':U. 
      ELSE IF CAN-DO(pcOptions,'ParentIsChild':U) OR iSDO > iStartOnSDO THEN 
        cMode = 'Child':U.      
      ELSE 
        cMode = '':U.     
      
      cQuery = {fnarg prepareForFetch cMode hSDO}.        
      {get RowObjectTable hTempTable hSDO}.
    END.  /* if this isn't a "SKIP" query */
    ASSIGN
      pocQueries    = pocQueries 
                      + (IF iSDO > 1 THEN CHR(1) ELSE "":U) 
                      + cQuery
      pocTempTables = pocTempTables 
                      + (IF iSDO > 1 THEN ",":U ELSE "":U) 
                      + (IF VALID-HANDLE(hTempTable)
                         THEN STRING(hTempTable)
                         ELSE '?':U).
  END. /* do iSDO = 1 to  */

  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processOpenCall) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processOpenCall Procedure 
PROCEDURE processOpenCall :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT         PARAMETER pcMode              AS CHARACTER NO-UNDO.
 DEFINE INPUT         PARAMETER pcColumnNames AS CHARACTER  NO-UNDO.
 DEFINE INPUT         PARAMETER pcOldValues   AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT  PARAMETER pcNewValues   AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT        PARAMETER pcError       AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE iCount         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iCount2        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cDefaultSDO    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lAutoCommit    AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cSDONames      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDataDelimiter AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hSDO           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cSDO           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cColumn        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cColumnList    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewList       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOldList       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cError         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cPosList       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lErrors        AS LOGICAL    NO-UNDO.

 /* Make sure that column names are properly qualified. This means that */
 /* either the first column ONLY is qualified or ALL are qualified */
 IF IsColumnListQualified(pcColumnNames) = FALSE THEN DO:
     pcError = "Column Names are not properly qualified with SDO name":U.
     RETURN.
 END.

 /* if all columns are qualified then process one SDO at a time  */
 IF NUM-ENTRIES(pcColumnNames, '.':U) > 2 THEN DO:
   {get DataObjectNames cSDONames}.
   /* loop through all SDOs and extract the columns and values */
   DO iCount = 1 TO NUM-ENTRIES(cSDONames):
     ASSIGN
         cSDO = ENTRY(iCount, cSDONames)
         hSDO = {fnarg dataObjectHandle cSDO}
         cColumnList = '':U
         cNewList = '':U
         cOldList = '':U
         cPosList = '':U.
     {get DataDelimiter cDataDelimiter hSDO}.
     DO iCount2 = 1 TO NUM-ENTRIES(pcColumnNames):
       cColumn = ENTRY(iCount2, pcColumnNames).
       IF ENTRY(1, cColumn, '.':U) = cSDO THEN DO:
         cColumnList = cColumnList + (IF cColumnList = '' THEN '' ELSE ',') +
                         ENTRY(2, cColumn, '.':U).
         CASE pcMode:
           WHEN 'CREATE':U THEN
             ASSIGN
               cNewList = cNewList + (IF NUM-ENTRIES(cNewList, cDataDelimiter) = 0 THEN '' ELSE cDataDelimiter) +
                          ENTRY(iCount2, pcNewValues, cDataDelimiter)
               cPosList = cPosList + (IF NUM-ENTRIES(cPosList, cDataDelimiter) = 0 THEN '' ELSE ',') + STRING(iCount2).
           WHEN 'DELETE':U THEN
             cOldList = cOldList + (IF NUM-ENTRIES(cOldList, cDataDelimiter) = 0 THEN '' ELSE cDataDelimiter) +
                           ENTRY(iCount2, pcOldValues, cDataDelimiter).
           WHEN 'UPDATE':U THEN
             ASSIGN
             cNewList = cNewList + (IF NUM-ENTRIES(cNewList, cDataDelimiter) = 0 THEN '' ELSE cDataDelimiter) +
                           ENTRY(iCount2, pcNewValues, cDataDelimiter)
             cPosList = cPosList + (IF NUM-ENTRIES(cPosList, cDataDelimiter) = 0 THEN '' ELSE ',') + STRING(iCount2)
             cOldList = cOldList + (IF NUM-ENTRIES(cOldList, cDataDelimiter) = 0 THEN '' ELSE cDataDelimiter) +
                           ENTRY(iCount2, pcOldValues, cDataDelimiter).
         END CASE.
       END.
     END. /* DO iCount2 */

     IF cColumnList > '':U THEN  /* post data if we have columns for current sdo */
       CASE pcMode:
         WHEN 'CREATE':U THEN DO:
           RUN createData IN hSDO (cColumnList, INPUT-OUTPUT cNewList, OUTPUT cError).
           /* update the pcNewValues list with the new values */
           DO iCount2 = 1 TO NUM-ENTRIES(cPosList):
             ENTRY(INT(ENTRY(iCount2, cPosList)), pcNewValues, cDataDelimiter) = 
                  ENTRY(iCount2, cNewList, cDataDelimiter).
           END.
         END.
         WHEN 'DELETE':U THEN
           RUN deleteData IN hSDO (cColumnList, cOldList, OUTPUT cError).
         WHEN 'UPDATE':U THEN DO:
           RUN updateData IN hSDO (cColumnList, cOldList, INPUT-OUTPUT cNewList, OUTPUT cError).
           /* update the pcNewValues list with the new values */
           DO iCount2 = 1 TO NUM-ENTRIES(cPosList):
             ENTRY(INT(ENTRY(iCount2, cPosList)), pcNewValues, cDataDelimiter) = 
                  ENTRY(iCount2, cNewList, cDataDelimiter).
           END.
         END.
       END CASE.

     lErrors = lErrors OR (cError > '':U).
     IF iCount = 1 THEN
       pcError = cError.
     ELSE
       pcError = pcError + ';':U + cError.
   END. /* DO iCount1 */
   IF NOT lErrors THEN
     pcError = '':U.
 END.
 ELSE DO:  /* all columns are from 1 SDO */
   ASSIGN
     cSDO = ENTRY(1, pcColumnNames, '.':U)
     hSDO = {fnarg dataObjectHandle cSDO}
     pcColumnNames = ENTRY(2, pcColumnNames, '.':U).
   CASE pcMode:
     WHEN 'CREATE' THEN
       RUN createData IN hSDO (pcColumnNames, INPUT-OUTPUT pcNewValues, OUTPUT pcError).
     WHEN 'DELETE' THEN
       RUN deleteData IN hSDO (pcColumnNames, pcOldValues, OUTPUT pcError).
     WHEN 'UPDATE' THEN
       RUN updateData IN hSDO (pcColumnNames, pcOldValues, INPUT-OUTPUT pcNewValues, OUTPUT pcError).
   END CASE.
 END.

 IF pcError > '':U THEN RETURN.

 /* if the SBO is AutoCommit then commit now */
 {get AutoCommit lAutoCommit}.
 IF lAutoCommit THEN DO:
   RUN commitTransaction IN TARGET-PROCEDURE.

   IF {fn anyMessage} THEN DO:
     pcError = {fn fetchMessages}.
     /* clean-up temp tables to be ready for next request */
     RUN undoTransaction IN TARGET-PROCEDURE.
   END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-queryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryPosition Procedure 
PROCEDURE queryPosition :
/*------------------------------------------------------------------------------
  Purpose:    Receives the queryPosition event from a contained SDO and
              passes it on to the appropriate Navigation-Source or other
              object.
  Parameters: pcPosition AS CHARACTER
  Notes:      Sets the ghTargetProcedure so that the toolbar can recognize the 
              actual target instance .
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pcPosition AS CHAR   NO-UNDO.

   DEFINE VARIABLE cMapping      AS CHAR      NO-UNDO.
   DEFINE VARIABLE hObject       AS HANDLE    NO-UNDO.
   DEFINE VARIABLE iObject       AS INT       NO-UNDO.
   DEFINE VARIABLE cHandle       AS CHAR      NO-UNDO.
   DEFINE VARIABLE cSDONames     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cSourceName   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cSubscribed   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE hNavTarget    AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hDataSource   AS HANDLE     NO-UNDO.
   DEFINE VARIABLE lBlockQueryPosition  AS LOGICAL    NO-UNDO.

   {get BlockQueryPosition lBlockQueryPosition}.
   IF NOT lBlockQueryPosition THEN
   DO:
     {get ObjectMapping cMapping}.
                /* may be more than one match */
     cHandle = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, 
                    INPUT STRING(SOURCE-PROCEDURE),
                     INPUT cMapping,
                     INPUT FALSE,           /* Get entry/entries *before* this */
                     INPUT ",":U).          /* delimiter */
     
     DO iObject = 1 TO NUM-ENTRIES(cHandle): 
       hObject = WIDGET-HANDLE(ENTRY(iObject, cHandle)).
       IF VALID-HANDLE(hObject) THEN
       DO:
         /* We check what kind of link we have to this object and if the object 
            subscribes to this event from that link */ 
         ASSIGN
           hNavTarget  = ?
           hDataSource = ?
           cSubscribed = ''.

         {get NavigationTarget hNavTarget hObject} NO-ERROR.
         IF VALID-HANDLE(hNavTarget) THEN 
         DO: 
            IF hNavTarget = TARGET-PROCEDURE THEN
              {get NavigationTargetEvents cSubscribed hObject}.
         END.
         ELSE DO:
            {get DataSource hdataSource hObject} NO-ERROR.
            IF VALID-HANDLE(hDataSource) AND hDataSource = TARGET-PROCEDURE THEN 
              {get DataSourceEvents cSubscribed hObject}.
         END.

         IF CAN-DO(cSubscribed,'queryPosition':U) THEN
         DO:
           cSDONames = '':U.
          /* Currently we avoid passing QueryPosition to secondary or 
              not updatable tables in visual objects. Note that in the future 
              this will probably be dealt with in the visual object */       
           {get UpdateTargetNames cSDONames hObject} NO-ERROR.
           IF cSDONames = ? OR cSDONames = '':U THEN
             {get DataSourceNames cSDONames hObject} NO-ERROR.

           IF cSDONames <> ? AND cSDONames <> '':U THEN
           DO:
             {get ObjectName cSourceName SOURCE-PROCEDURE}.
           
             IF cSourceName <> ENTRY(1,cSDONames) THEN
               NEXT. /* deal with the next visual object */ 
           END. /* cSDONames <> ? or <> ''  */
           ghTargetProcedure = TARGET-PROCEDURE.
           RUN queryPosition IN hObject (pcPosition) NO-ERROR.
           ghTargetProcedure = ?. 
         END. /* lookup DataSourceEvents,queryposition */
       END.
     END.   /* END DO iObject */
   END.  /* END BlockQueryPosition */
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshBrowse Procedure 
PROCEDURE refreshBrowse :
/*------------------------------------------------------------------------------
  Purpose:    Receives the refreshBrowse event from a contained SDO and
              passes it on to the appropriate DataTarget.
  Notes:      
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pcPosition AS CHAR   NO-UNDO.

   DEFINE VARIABLE cMapping      AS CHAR      NO-UNDO.
   DEFINE VARIABLE hObject       AS HANDLE    NO-UNDO.
   DEFINE VARIABLE iObject       AS INT       NO-UNDO.
   DEFINE VARIABLE cHandle       AS CHAR      NO-UNDO.
   DEFINE VARIABLE cSourceName   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cSubscribed   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hDataSource   AS HANDLE    NO-UNDO.
   
   {get ObjectMapping cMapping}.
              /* may be more than one match */
   cHandle = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, 
                    INPUT STRING(SOURCE-PROCEDURE),
                    INPUT cMapping,
                    INPUT FALSE,           /* Get entry/entries *before* this */
                    INPUT ",":U).          /* delimiter */
   DO iObject = 1 TO NUM-ENTRIES(cHandle): 
     hObject = WIDGET-HANDLE(ENTRY(iObject, cHandle)).
     IF VALID-HANDLE(hObject) THEN
     DO:
       /* We check what kind of link we have to this object and if the object 
          subscribes to this event from that link */ 
       ASSIGN
         hDataSource = ?
         cSubscribed = '':U.

       {get DataSource hDataSource hObject} NO-ERROR.
       IF VALID-HANDLE(hDataSource) AND hDataSource = TARGET-PROCEDURE THEN 
         {get DataSourceEvents cSubscribed hObject}.
       
       IF CAN-DO(cSubscribed,'refreshBrowse':U) THEN
         RUN refreshBrowse IN hObject NO-ERROR.
     END.
   END.    /* END DO iObject */

   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerLinkedObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE registerLinkedObjects Procedure 
PROCEDURE registerLinkedObjects :
/*------------------------------------------------------------------------------
  Purpose: Register objects in the ObjectMapping and other properties.            
           This currently applies to navigationSources and Datatargets 
          (Currently we assume that updateSources also are DataTargets)          
  Notes:   This procedure is used to register objects that already were 
           initialized when the sbo is initialized. The sbo also subscribes 
           to 'registerObject' in these objects, which they publish at 
           initialization.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjects AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hObject  AS HANDLE    NO-UNDO.

  {get NavigationSource cObjects}.

  DO i = 1 TO NUM-ENTRIES(cObjects):
    hObject = WIDGET-HANDLE(ENTRY(i,cObjects)).
    IF VALID-HANDLE(hObject) THEN
      RUN addNavigationSource IN TARGET-PROCEDURE (hObject).       
  END.
    
  {get DataTarget cObjects}.
  DO i = 1 TO NUM-ENTRIES(cObjects):
    hObject = WIDGET-HANDLE(ENTRY(i,cObjects)).
    IF VALID-HANDLE(hObject) THEN
       RUN addDataTarget IN TARGET-PROCEDURE (hObject).       
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE registerObject Procedure 
PROCEDURE registerObject :
/*------------------------------------------------------------------------------
  Purpose: General purpose 'register' event published from objects at 
           initialization. This object defines this as navigationSourceEvent 
           and dataTargetEvent. The event is used to register objects in the 
           ObjectMapping and other properties. 
          (Currently we assume that updateSources also are DataTargets)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSource AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
 
  {get NavigationSource cSource}.
   
  /* If this is a NavigationSource add it as such */
  IF CAN-DO(cSource,STRING(SOURCE-PROCEDURE)) THEN
     RUN addNavigationSource IN TARGET-PROCEDURE (SOURCE-PROCEDURE).
  ELSE DO:
    /* The other current possibility is that this is a Datatarget
       if that's the case then add DataTarget 
        (which also registers updateSources ) */
    {get DataTarget cTarget}.
    
    IF CAN-DO(cTarget,STRING(SOURCE-PROCEDURE)) THEN
      RUN addDataTarget IN TARGET-PROCEDURE (SOURCE-PROCEDURE).
  END.
 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-remoteCommitTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remoteCommitTransaction Procedure 
PROCEDURE remoteCommitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER pccontext AS CHAR NO-UNDO.

DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd1. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd2. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd3. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd4. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd5. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd6. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd7. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd8. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd9. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd10. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd11. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd12. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd13. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd14. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd15. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd16. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd17. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd18. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd19. 
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE phRowObjUpd20. 

DEFINE OUTPUT PARAMETER pcMessages AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER pcUndoIds  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cUpdateTables AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.

  RUN setContextAndInitialize IN TARGET-PROCEDURE(pcContext).

  DO iCount = 1 TO 20:
    CASE iCount:
      WHEN 1 THEN
        IF VALID-HANDLE(phRowObjUpd1) THEN
          cUpdateTables = STRING(phRowObjUpd1).
        ELSE LEAVE.
      WHEN 2 THEN
        IF VALID-HANDLE(phRowObjUpd2) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd2).
        ELSE LEAVE.
      WHEN 3 THEN
        IF VALID-HANDLE(phRowObjUpd3) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd3).
        ELSE LEAVE.
      WHEN 4 THEN
        IF VALID-HANDLE(phRowObjUpd4) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd4).
        ELSE LEAVE.
      WHEN 5 THEN
        IF VALID-HANDLE(phRowObjUpd5) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd5).
        ELSE LEAVE.
      WHEN 6 THEN
        IF VALID-HANDLE(phRowObjUpd6) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd6).
        ELSE LEAVE.
      WHEN 7 THEN
        IF VALID-HANDLE(phRowObjUpd7) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd7).
        ELSE LEAVE.
      WHEN 8 THEN
        IF VALID-HANDLE(phRowObjUpd8) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd8).
        ELSE LEAVE.
      WHEN 9 THEN
        IF VALID-HANDLE(phRowObjUpd9) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd9).
        ELSE LEAVE.
      WHEN 10 THEN
        IF VALID-HANDLE(phRowObjUpd10) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd10).
        ELSE LEAVE.
      WHEN 11 THEN
        IF VALID-HANDLE(phRowObjUpd11) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd11).
        ELSE LEAVE.
      WHEN 12 THEN
        IF VALID-HANDLE(phRowObjUpd12) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd12).
        ELSE LEAVE.
      WHEN 13 THEN
        IF VALID-HANDLE(phRowObjUpd13) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd13).
        ELSE LEAVE.
      WHEN 14 THEN
        IF VALID-HANDLE(phRowObjUpd14) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd14).
        ELSE LEAVE.
      WHEN 15 THEN
        IF VALID-HANDLE(phRowObjUpd15) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd15).
        ELSE LEAVE.
      WHEN 16 THEN
        IF VALID-HANDLE(phRowObjUpd16) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd16).
        ELSE LEAVE.
      WHEN 17 THEN
        IF VALID-HANDLE(phRowObjUpd17) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd17).
        ELSE LEAVE.
      WHEN 18 THEN
        IF VALID-HANDLE(phRowObjUpd18) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd18).
        ELSE LEAVE.
      WHEN 19 THEN
        IF VALID-HANDLE(phRowObjUpd19) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd19).
        ELSE LEAVE.
      WHEN 20 THEN
        IF VALID-HANDLE(phRowObjUpd20) THEN
          cUpdateTables = cUpdateTables + "," + STRING(phRowObjUpd20).
        ELSE LEAVE.
    END CASE.
  END.
  {set UpdateTables cUpdateTables}.

  RUN bufferCommitTransaction IN TARGET-PROCEDURE
                 (OUTPUT pcMessages, OUTPUT pcUndoIds). 

  pccontext = {fn obtainContextForClient}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-remoteFetchContainedData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remoteFetchContainedData Procedure 
PROCEDURE remoteFetchContainedData :
/*------------------------------------------------------------------------------
  Purpose:     server-side procedure to prepare and open a query
               and return all the resulting data to the client side.
  Parameters:  pcContext - input-output context from-to client  
               pcQueries AS CHARACTER -- CHR(1)-delimited-list of 
                  QueryString properties of the SDOs;
               pcPositions AS CHARACTER -- reserved for future use to
                  provide information on positioning each of the queries perhaps;
               phRowObject1-20 AS HANDLE -- temp-table handle of each SDO
               pocMessages - Errors 
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pcContext AS CHARACTER  NO-UNDO.

  DEFINE INPUT  PARAMETER pcQueries   AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcPositions AS CHARACTER NO-UNDO.

  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.

  DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cSDOs        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO         AS HANDLE     NO-UNDO.

  RUN setContextAndInitialize IN TARGET-PROCEDURE (pcContext). 

  RUN bufferFetchContainedData IN TARGET-PROCEDURE 
                     (pcQueries,
                      pcPositions).

  {get ContainedDataObjects cSDOs}.    
  
  DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
    IF ENTRY(iSDO,pcQueries,CHR(1)) <> 'SKIP':U THEN
    DO:
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
      CASE iSDO:
        WHEN 1 THEN
          {get RowObjectTable phRowObject1 hSDO}.
        WHEN 2 THEN
          {get RowObjectTable phRowObject2 hSDO}.
        WHEN 3 THEN
          {get RowObjectTable phRowObject3 hSDO}.
        WHEN 4 THEN
          {get RowObjectTable phRowObject4 hSDO}.
        WHEN 5 THEN
          {get RowObjectTable phRowObject5 hSDO}.
        WHEN 6 THEN
          {get RowObjectTable phRowObject6 hSDO}.
        WHEN 7 THEN
          {get RowObjectTable phRowObject7 hSDO}.
        WHEN 8 THEN
          {get RowObjectTable phRowObject8 hSDO}.
        WHEN 9 THEN
          {get RowObjectTable phRowObject9 hSDO}.
        WHEN 10 THEN
          {get RowObjectTable phRowObject10 hSDO}.
        WHEN 11 THEN
          {get RowObjectTable phRowObject11 hSDO}.
        WHEN 12 THEN
          {get RowObjectTable phRowObject12 hSDO}.
        WHEN 13 THEN
          {get RowObjectTable phRowObject13 hSDO}.
        WHEN 14 THEN
          {get RowObjectTable phRowObject14 hSDO}.
        WHEN 15 THEN
          {get RowObjectTable phRowObject15 hSDO}.
        WHEN 16 THEN
          {get RowObjectTable phRowObject16 hSDO}.
        WHEN 17 THEN
          {get RowObjectTable phRowObject17 hSDO}.
        WHEN 18 THEN
          {get RowObjectTable phRowObject18 hSDO}.
        WHEN 19 THEN
          {get RowObjectTable phRowObject19 hSDO}.
        WHEN 20 THEN
          {get RowObjectTable phRowObject20 hSDO}.
      END CASE.    
    END. /* entry(iSDO,pcqueries,chr(1)) <> 'skip' */
  END. /* Do iSDO */
   
  IF {fn anyMessage} THEN
    pocMessages = {fn fetchMessages}.

  pcContext = {fn obtainContextForClient}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-remoteFetchContainedRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remoteFetchContainedRows Procedure 
PROCEDURE remoteFetchContainedRows :
/*------------------------------------------------------------------------------
  Purpose:     server-side procedure to prepare and open a query
               and return all the resulting data to the client side.
  Parameters:  pcContext - input-output context from-to client  
               pcQueries AS CHARACTER -- CHR(1)-delimited-list of 
                  QueryString properties of the SDOs;
               pcPositions AS CHARACTER -- reserved for future use to
                  provide information on positioning each of the queries perhaps;
               phRowObject1-20 AS HANDLE -- temp-table handle of each SDO
               pocMessages - Errors (not in use)
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pcContext AS CHARACTER  NO-UNDO.
  
  DEFINE INPUT  PARAMETER pcQueries      AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER piStartRow     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER plNext         AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.
  
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.

  DEFINE OUTPUT PARAMETER pocMessages AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cSDOs        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO         AS HANDLE     NO-UNDO.

  RUN setContextAndInitialize IN TARGET-PROCEDURE (pcContext). 

  RUN bufferFetchContainedRows IN TARGET-PROCEDURE 
                     (pcQueries,
                      piStartRow, 
                      pcRowIdent, 
                      plNext, 
                      piRowsToReturn, 
                      OUTPUT piRowsReturned).

  {get ContainedDataObjects cSDOs}.    
  
  DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
    IF ENTRY(iSDO,pcQueries,CHR(1)) <> 'SKIP':U THEN
    DO:
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
      CASE iSDO:
        WHEN 1 THEN
          {get RowObjectTable phRowObject1 hSDO}.
        WHEN 2 THEN
          {get RowObjectTable phRowObject2 hSDO}.
        WHEN 3 THEN
          {get RowObjectTable phRowObject3 hSDO}.
        WHEN 4 THEN
          {get RowObjectTable phRowObject4 hSDO}.
        WHEN 5 THEN
          {get RowObjectTable phRowObject5 hSDO}.
        WHEN 6 THEN
          {get RowObjectTable phRowObject6 hSDO}.
        WHEN 7 THEN
          {get RowObjectTable phRowObject7 hSDO}.
        WHEN 8 THEN
          {get RowObjectTable phRowObject8 hSDO}.
        WHEN 9 THEN
          {get RowObjectTable phRowObject9 hSDO}.
        WHEN 10 THEN
          {get RowObjectTable phRowObject10 hSDO}.
        WHEN 11 THEN
          {get RowObjectTable phRowObject11 hSDO}.
        WHEN 12 THEN
          {get RowObjectTable phRowObject12 hSDO}.
        WHEN 13 THEN
          {get RowObjectTable phRowObject13 hSDO}.
        WHEN 14 THEN
          {get RowObjectTable phRowObject14 hSDO}.
        WHEN 15 THEN
          {get RowObjectTable phRowObject15 hSDO}.
        WHEN 16 THEN
          {get RowObjectTable phRowObject16 hSDO}.
        WHEN 17 THEN
          {get RowObjectTable phRowObject17 hSDO}.
        WHEN 18 THEN
          {get RowObjectTable phRowObject18 hSDO}.
        WHEN 19 THEN
          {get RowObjectTable phRowObject19 hSDO}.
        WHEN 20 THEN
          {get RowObjectTable phRowObject20 hSDO}.
      END CASE.    
    END. /* entry(iSDO,pcqueries,chr(1)) <> 'skip' */
  END. /* Do iSDO */
     
  IF {fn anyMessage} THEN
    pocMessages = {fn fetchMessages}.

   pcContext = {fn obtainContextForClient}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-restartServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE restartServerObject Procedure 
PROCEDURE restartServerObject :
/*------------------------------------------------------------------------------
  Purpose:    When a SmartBusinessObject is split and running Statelessly on an
              AppServer, it is shutdown after each use and then restarted for
              the next.  restartServerObject is run on the client to restart
              the SmartBusinessObject on the server. 
  Notes:      This override is for error handling to show error message and
              return 'adm-error'. 
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cMsg AS CHARACTER  NO-UNDO.
  
  RUN SUPER NO-ERROR.
  
 /* Handles only one message, which is sufficent with the current appserver 
    class */
  IF {fn anyMessage} THEN
  DO:
     cMsg = ENTRY(1,{fn fetchMessages},CHR(4)).
    {fnarg showMessage cMsg}.
    RETURN ERROR 'ADM-ERROR':U.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverContainedSendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverContainedSendRows Procedure 
PROCEDURE serverContainedSendRows :
/*------------------------------------------------------------------------------
  Purpose: OBSOLETE!  use fetchContainedRows --> containedRows  
             Server-side SBO version of serverSendRows.
               Receives the SDO Object Name and runs SendRows in that,
               returning the RowObject table.
           
           OBSOLETE !!! 
                              
   Parameters:  
    INPUT  piStartRow     - The RowNum value of the record to start the batch
                            to return.  Typically piStartRow is ? as a flag to 
                            use pcRowIdent instead of piStartRow.
    INPUT  pcRowIdent     - The RowIdent of the first record of the batch to
                            to return.  Can also be "FIRST" or "LAST" to force
                            the retrieval of the first (or last) batch of 
                            RowObject records.
    INPUT  plNext         - True if serverSendRows is to start on the "next"
                            record from what is indicated by piStartRow or
                            piRowIdent.
    INPUT  piRowsToReturn - The number of rows in a batch.
    INPUT  pcObjectName   - the ObjectName of the SDO to get data from.
    OUTPUT piRowsReturned - The actual number of rows returned. This number
                            will either be the same as piRowsToReturn or
                            less when there are not enough records to fill
                            up the batch.
    OUTPUT TABLE-HANDLE   - The batch of rows in the RowObject table.
  
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER piStartRow     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plNext         AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectName   AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject.
 
  DEFINE VARIABLE cContained  AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iObject     AS INTEGER     NO-UNDO.
  DEFINE VARIABLE hObject     AS HANDLE      NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER   NO-UNDO.
  
  {get ContainedDataObjects cContained}.
  DO iObject = 1 TO NUM-ENTRIES(cContained):
      hObject = WIDGET-HANDLE(ENTRY(iObject, cContained)).
      {get ObjectName cObjectName hObject}.
      IF cObjectName = pcObjectName THEN
      DO:
          /* sendRows will populate the temp-table, and we can get its
             handle directly afterwards, so we can just call sendRows
             directly and *then* get the table as a simple handle. */
          RUN sendRows IN hObject
              (INPUT piStartRow, INPUT pcRowIdent,
               INPUT plNext, INPUT piRowsToReturn,
               OUTPUT piRowsReturned).
          {get RowObjectTable phRowObject hObject}.
      END.
  END.               /* END DO iObject -- match ObjectNames */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverFetchContainedData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchContainedData Procedure 
PROCEDURE serverFetchContainedData :
/*------------------------------------------------------------------------------
  Purpose:     server-side procedure to prepare and open a query
               and return all the resulting data to the client side.
  Parameters:  pcQueries AS CHARACTER -- CHR(1)-delimited-list of 
                  QueryString properties of the SDOs;
               pcPositions AS CHARACTER -- reserved for future use to
                  provide information on positioning each of the queries perhaps;
               phRowObject1-20 AS HANDLE -- temp-table handle of each SDO
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcQueries   AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcPositions AS CHARACTER NO-UNDO.

  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.

  DEFINE VARIABLE cSDOs        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO         AS HANDLE     NO-UNDO.

  RUN bufferFetchContainedData IN TARGET-PROCEDURE 
                     (pcQueries,
                      pcPositions).

  {get ContainedDataObjects cSDOs}.    
  
  DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
    IF ENTRY(iSDO,pcQueries,CHR(1)) <> 'SKIP':U THEN
    DO:
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
      CASE iSDO:
        WHEN 1 THEN
          {get RowObjectTable phRowObject1 hSDO}.
        WHEN 2 THEN
          {get RowObjectTable phRowObject2 hSDO}.
        WHEN 3 THEN
          {get RowObjectTable phRowObject3 hSDO}.
        WHEN 4 THEN
          {get RowObjectTable phRowObject4 hSDO}.
        WHEN 5 THEN
          {get RowObjectTable phRowObject5 hSDO}.
        WHEN 6 THEN
          {get RowObjectTable phRowObject6 hSDO}.
        WHEN 7 THEN
          {get RowObjectTable phRowObject7 hSDO}.
        WHEN 8 THEN
          {get RowObjectTable phRowObject8 hSDO}.
        WHEN 9 THEN
          {get RowObjectTable phRowObject9 hSDO}.
        WHEN 10 THEN
          {get RowObjectTable phRowObject10 hSDO}.
        WHEN 11 THEN
          {get RowObjectTable phRowObject11 hSDO}.
        WHEN 12 THEN
          {get RowObjectTable phRowObject12 hSDO}.
        WHEN 13 THEN
          {get RowObjectTable phRowObject13 hSDO}.
        WHEN 14 THEN
          {get RowObjectTable phRowObject14 hSDO}.
        WHEN 15 THEN
          {get RowObjectTable phRowObject15 hSDO}.
        WHEN 16 THEN
          {get RowObjectTable phRowObject16 hSDO}.
        WHEN 17 THEN
          {get RowObjectTable phRowObject17 hSDO}.
        WHEN 18 THEN
          {get RowObjectTable phRowObject18 hSDO}.
        WHEN 19 THEN
          {get RowObjectTable phRowObject19 hSDO}.
        WHEN 20 THEN
          {get RowObjectTable phRowObject20 hSDO}.
      END CASE.    
    END. /* entry(iSDO,pcqueries,chr(1)) <> 'skip' */
  END. /* Do iSDO */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverFetchContainedRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchContainedRows Procedure 
PROCEDURE serverFetchContainedRows :
/*------------------------------------------------------------------------------
  Purpose:     server-side procedure that retrieves a batch of data 
               in one of the contained SDOs and returns all the resulting 
               data to the client side.
  Parameters:  
    INPUT  pcQueries     -  CHR(1)-delimited-list of QueryString properties of 
                            the SDOs. SKIP indicates 
    INPUT  pcObject      -  The object to retrieve the batch from (? = Master)      
    INPUT  piStartRow    -  The RowNum value of the record to start the batch
                            to return.  Typically piStartRow is ? as a flag to 
                            use pcRowIdent instead of piStartRow.
    INPUT  pcRowIdent     - The RowIdent of the first record of the batch to
                            to return.  Can also be "FIRST" or "LAST" to force
                            the retrieval of the first (or last) batch of 
                            RowObject records.
    INPUT  plNext         - True if serverSendRows is to start on the "next"
                            record from what is indicated by piStartRow or
                            piRowIdent.
    INPUT  piRowsToReturn - The number of rows in a batch.
    OUTPUT piRowsReturned - The actual number of rows returned. This number
                            will either be the same as piRowsToReturn or
                            less when there are not enough records to fill
                            up the batch.
    
    OUTPUT TABLE-HANDLE phRowObject1-20 AS HANDLE 
                           - temp-table handle of each SDO
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcQueries      AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER piStartRow     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER plNext         AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.

  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject1.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject2.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject3.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject4.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject5.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject6.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject7.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject8.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject9.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject10.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject11.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject12.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject13.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject14.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject15.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject16.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject17.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject18.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject19.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phRowObject20.

  DEFINE VARIABLE hMaster      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSDOs        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSDO         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSDO         AS HANDLE     NO-UNDO.

  RUN bufferFetchContainedRows IN TARGET-PROCEDURE 
                       (pcQueries,
                        piStartRow,
                        pcRowident,
                        plNext,
                        piRowsToReturn,
                        OUTPUT piRowsReturned).

  {get ContainedDataObjects cSDOs}.    
  DO iSDO = 1 TO NUM-ENTRIES(cSDOs):
    IF ENTRY(iSDO,pcQueries,CHR(1)) <> 'SKIP':U THEN
    DO:
      hSDO = WIDGET-HANDLE(ENTRY(iSDO, cSDOs)).
      CASE iSDO:
        WHEN 1 THEN
          {get RowObjectTable phRowObject1 hSDO}.
        WHEN 2 THEN
          {get RowObjectTable phRowObject2 hSDO}.
        WHEN 3 THEN
          {get RowObjectTable phRowObject3 hSDO}.
        WHEN 4 THEN
          {get RowObjectTable phRowObject4 hSDO}.
        WHEN 5 THEN
          {get RowObjectTable phRowObject5 hSDO}.
        WHEN 6 THEN
          {get RowObjectTable phRowObject6 hSDO}.
        WHEN 7 THEN
          {get RowObjectTable phRowObject7 hSDO}.
        WHEN 8 THEN
          {get RowObjectTable phRowObject8 hSDO}.
        WHEN 9 THEN
          {get RowObjectTable phRowObject9 hSDO}.
        WHEN 10 THEN
          {get RowObjectTable phRowObject10 hSDO}.
        WHEN 11 THEN
          {get RowObjectTable phRowObject11 hSDO}.
        WHEN 12 THEN
          {get RowObjectTable phRowObject12 hSDO}.
        WHEN 13 THEN
          {get RowObjectTable phRowObject13 hSDO}.
        WHEN 14 THEN
          {get RowObjectTable phRowObject14 hSDO}.
        WHEN 15 THEN
          {get RowObjectTable phRowObject15 hSDO}.
        WHEN 16 THEN
          {get RowObjectTable phRowObject16 hSDO}.
        WHEN 17 THEN
          {get RowObjectTable phRowObject17 hSDO}.
        WHEN 18 THEN
          {get RowObjectTable phRowObject18 hSDO}.
        WHEN 19 THEN
          {get RowObjectTable phRowObject19 hSDO}.
        WHEN 20 THEN
          {get RowObjectTable phRowObject20 hSDO}.
      END CASE.    
    END. /* entry(iSDO,pcqueries,chr(1)) <> 'skip' */
  END. /* Do iSDO */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverFetchDOProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverFetchDOProperties Procedure 
PROCEDURE serverFetchDOProperties :
/*------------------------------------------------------------------------------
  Purpose:     Server-side procedure run at startup to return property values
               needed on the client.
  Parameters:  OUTPUT pcPropList AS CHARACTER
                 Properties and Values in internal format that can be 
                 used to assign 
  Notes:       Currently returns the OpenQuery and IndexInformation property of 
               each SDO. 
               There's no need to do a call to initializeObject before calling
               this as it is initialized here if required.  
             - See FetchDOProperties about usage.   
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER pcContext   AS CHARACTER NO-UNDO.
   
   DEFINE VARIABLE lInitialized        AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE lFirstCall          AS LOGICAL  NO-UNDO.

   {get ObjectInitialized lInitialized}.
   
   IF NOT lInitialized THEN
   DO:
     {set OpenOnInit FALSE}.
     RUN initializeObject IN TARGET-PROCEDURE.
   END. /* if not initialized */

   /* This is a dedicated 'first time' call, so set ServerFirstCall = true*/ 
   {set ServerFirstCall TRUE}.
   pcContext = {fn obtainContextForClient}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContextAndInitialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setContextAndInitialize Procedure 
PROCEDURE setContextAndInitialize :
/*------------------------------------------------------------------------------
  Purpose:  Reset context and initialize this server side object   
  Parameters:  pcContext 
               Properties in the format returned from 
               containedProperties to be passed to assignContainedProperties 
  Notes:    Called from a stateless client before a request.
            The format is subject to change
         -  This overrides the containr class in order to set OpenOnInit, which
            the container does not have.           
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcContext AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iEntry                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPos                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPropList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropValue             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lCreated               AS LOGICAL    NO-UNDO.


  {get ObjectsCreated lCreated}.
  IF NOT lCreated THEN DO:
    /* dig out any required pre-createObjects properties from the passed context */
    /* (cannot wait for 'assignContainedProperties') */
    ASSIGN
      cPropList = ENTRY(1, pcContext, CHR(3))
      iEntry = LOOKUP('THIS':U, cPropList, ';').
    IF iEntry > 0 THEN DO:
      /* Get the 'LogicalObjectName' and set it in the newly created object */
      /* This is necessary so that a DynSBO object can get and instantiate its */
      /* contents from the repository */
      iPos = LOOKUP('LogicalObjectName':U, ENTRY(iEntry + 1, cPropList, ';':U)).
      IF iPos > 0 THEN DO:
        cPropValue = ENTRY(iPos, ENTRY(iEntry + 2, pcContext, CHR(3)), CHR(4)).
        {set LogicalObjectName cPropValue}.
      END.
    END.
    
    RUN createObjects IN TARGET-PROCEDURE.
  END.
 
  DYNAMIC-FUNCTION('assignContainedProperties':U IN TARGET-PROCEDURE,
                    pcContext,
                    '':U). 
 
  {set OpenOnInit FALSE}. 

  RUN initializeObject IN TARGET-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPropertyList Procedure 
PROCEDURE setPropertyList :
/*------------------------------------------------------------------------------
  Purpose:     To set a list of properties taken from a CHR(3) delimitted list
               of "propCHR(4)value" pairs.
  
  Parameters:  
    INPUT pcProperties - the CHR(3) delimitted list of "propCHR(4)value" pairs
                         to be set.
  
  Notes:      COPY of data.p () 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcProperties AS CHARACTER                    NO-UNDO.
  
  DEFINE VARIABLE iProp        AS INTEGER                             NO-UNDO.
  DEFINE VARIABLE cProp        AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE cValue       AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE cSignature   AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE iCnt         AS INTEGER                             NO-UNDO.

  iCnt = NUM-ENTRIES(pcProperties,CHR(3)).
  DO iProp = 1 TO iCnt:
    /* Process Prop<->Value pairs */
    ASSIGN cProp  = ENTRY(iProp,pcProperties,CHR(3))
           cValue = ENTRY(2,cProp,CHR(4))
           cProp  = ENTRY(1,cProp,CHR(4)).

    /* Get the datatype of the property */
    cSignature = DYNAMIC-FUNCTION("Signature":U IN TARGET-PROCEDURE, "get":U + cProp).
    IF cSignature EQ "":U THEN  /* It wasn't found */
      DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "Property ":U + cProp + " not defined.":U).
    ELSE CASE ENTRY(2, cSignature):
      WHEN "CHARACTER":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, 
                         IF cValue = "?" THEN ? ELSE cValue).
      WHEN "INTEGER":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, 
                         INT(IF cValue = "?" THEN ? ELSE cValue)).
      WHEN "LOGICAL":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE,
                         IF cValue = "YES" THEN yes ELSE no).
      WHEN "DECIMAL":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, 
                         DEC(IF cValue = "?" THEN ? ELSE cValue)).
    END.  /* CASE on property type */
  END.  /* DO iProp = 1 TO NUM-ENTRIES */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startFilter Procedure 
PROCEDURE startFilter :
/*------------------------------------------------------------------------------
  Purpose:     View/Start the filter-source
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hFilterSource    AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hWindow          AS HANDLE    NO-UNDO.
   DEFINE VARIABLE lHide            AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE hFilterContainer AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hMyContainer     AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cFilterWindow    AS CHARACTER NO-UNDO.
      
   {get FilterSource hFilterSource}.
   
   IF VALID-HANDLE(hFilterSource) THEN 
   DO:
     {get ContainerSource hFilterContainer hFilterSource}.
     {get ContainerSource hMyContainer}.    
     IF hMyContainer <> hFilterContainer THEN
     DO:
       {set FilterWindow hFilterContainer:FILE-NAME}.
       {get HideOnInit lHide hFilterContainer}. 
     
       /* Workaround to make it visible if it's hideoninit */
       IF lHide THEN 
        RUN destroyObject in hFilterContainer.
     END.
   END.
   
   IF NOT VALID-HANDLE(hFilterContainer) THEN 
   DO:
     {get FilterWindow cFilterWindow}.     
     IF cFilterWindow <> '':U THEN
     DO:
       {get ContainerSource hMyContainer}.    
       {get ContainerHandle hWindow}.
      
       RUN constructObject IN hMyContainer (
             INPUT  cFilterWindow,
             INPUT  hWindow,
             INPUT  'HideOnInit' + CHR(4) + 'no' + CHR(3) 
                    + 
                    'DisableOnInit' + CHR(4) + 'no' + CHR(3) 
                    + 
                    'ObjectLayout' + CHR(4),
             OUTPUT hFilterContainer).
      /* filterContainerHandler adds the Filter link between this object
         and the Filter container */
       RUN filterContainerHandler IN TARGET-PROCEDURE ( hFilterContainer ).
       RUN initializeObject IN hFilterContainer.  
     END.
   END.    
   
   RUN viewObject IN hFilterContainer.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startServerObject Procedure 
PROCEDURE startServerObject :
/*------------------------------------------------------------------------------
  Purpose:    When a SmartBusinessObject is split and running Statelessly on an
              AppServer, startServerObject is run on the client to start
              the SmartBusinessObject on the server.
  Parameters:  <none>
  Notes:      This override is for error handling to show error message and
              return 'adm-error'. 
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE cMsg AS CHARACTER  NO-UNDO.
  
  RUN SUPER NO-ERROR.
  
  /* Handles only one message, which is sufficent with the current appserver 
    class */
  IF {fn anyMessage} THEN
  DO:
    cMsg = ENTRY(1,{fn fetchMessages},CHR(4)).
    {fnarg showMessage cMsg}.
    RETURN ERROR 'ADM-ERROR':U.
  END.
  ELSE IF ERROR-STATUS:ERROR THEN
    RETURN ERROR RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-undoTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE undoTransaction Procedure 
PROCEDURE undoTransaction :
/*------------------------------------------------------------------------------
  Purpose:     Passes the undoTransaction event on to each contained
               DataObject that has any uncommitted changes.
  Parameters:  <none>
------------------------------------------------------------------------------*/ 
 DEFINE VARIABLE iDO          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cContained   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hROUTable    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hDO          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hMaster      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cCurRowident AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cNewRowident AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRefresh     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hSource      AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iSource      AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lCancel      AS LOGICAL    NO-UNDO.
 
 /* Visual dataTargets subscribes to this */
 PUBLISH 'confirmUndo':U FROM TARGET-PROCEDURE (INPUT-OUTPUT lCancel).
 IF lCancel THEN RETURN.
  
 {get ContainedDataObjects cContained}.
 cRefresh = FILL(',',NUM-ENTRIES(cContained)).
 SDOLoop:
 DO iDO = 1 TO NUM-ENTRIES(cContained):
   hDO = WIDGET-HANDLE(ENTRY(iDO, cContained)).
   {get RowObjUpdTable hROUTable hDO}.
   IF hROUTable:HAS-RECORDS THEN 
   DO:
     {get Rowident cCurRowident hDO}. 
     RUN undoTransaction IN hDO.
     {get Rowident cNewRowident hDO}. 
     /* The undo changed position, so we need to publish to SDO datatargets */ 
     IF cCurRowident <> cNewRowident THEN
     DO:
       /* Check if we have changed position of any source, which means that we 
          will receive a dataAvailable from that and don't need to mark this 
          to be refresh */  
       hSource = hDO. 
       DO WHILE VALID-HANDLE(hSource):
         {get DataSource hSource hSource}.
         iSource = LOOKUP(STRING(hSource),cContained). 
         /* we have a parent that will be refreshed, so undo the next SDO */
         IF iSource > 0 AND ENTRY(iSource, cRefresh) <> '':U THEN
            NEXT SDOLoop.
       END.      
       /* Set the refresh flag */
       ENTRY(ido,cRefresh) = '1':U.      
     END.      
   END. /* ROUTable:has-records */   
 END.     /* END DO iDO */

 {set RowObjectState 'NoUpdates':U}.
 
 /* Block outgoing messages while we may do an internal dataAvailable in cases 
    where the position changed, since we always do an external dataAvailable of
    all data further down also when position has not changed */ 
 {set BlockDataAvailable YES}.
 DO iDO = 1 TO NUM-ENTRIES(cContained):
   hDO = WIDGET-HANDLE(ENTRY(iDO, cContained)).
   /* The popsition changed during undo so publish */
   IF ENTRY(iDO,cRefresh) <> '':U THEN
     PUBLISH 'dataAvailable':U FROM hDO (INPUT "DIFFERENT":U).
 END.
 {set BlockDataAvailable NO}.
 
 /* Now let external client objects know we might have changed data. */  
 PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE (INPUT "DIFFERENT":U).

 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-unRegisterObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unRegisterObject Procedure 
PROCEDURE unRegisterObject :
/*------------------------------------------------------------------------------
  Purpose: General purpose 'unregister' event that can be published from objects 
           when they are destroyed. Deletes entries from object mapping:
           nav source, nav target pair 
           data target, data source pair 
           Note: the first object in the pair is the one that publishes the msg
           and it is the one this routine looks for to identify the pairs to
           delete from object mapping.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTmp     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSource  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i        AS INTEGER   NO-UNDO.
  
  {get ObjectMapping cMapping}.
  
   ASSIGN 
     cTmp = cMapping
     cSource = STRING(SOURCE-PROCEDURE).  /* the object that published the msg */

   i = LOOKUP(cSource, cTmp, ",":U).
   DO WHILE  i NE 0 :
        
       /* make sure the match we found is the first part of the pair*/
        IF i MODULO 2 =  1 THEN  DO:              
              /* delete the first part of the pair */
             cTmp = DYNAMIC-FUNCTION ('deleteEntry':U IN TARGET-PROCEDURE, i,  cTmp, ",":U). 
              /* delete the 2nd part of the pair but it has the same index
                 now because of the previous delete */
             cTmp = DYNAMIC-FUNCTION ('deleteEntry':U IN TARGET-PROCEDURE, i,  cTmp, ",":U).
             
        END. /* end if modulo*/

  i = LOOKUP(cSource, cTmp, ",":U).
  END. /* end do while*/  
  IF cTmp NE cMapping THEN
    {set ObjectMapping cTmp}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateData Procedure 
PROCEDURE updateData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT         PARAMETER pcUpdateColumnNames AS CHARACTER  NO-UNDO.
 DEFINE INPUT         PARAMETER pcOldValues   AS CHARACTER  NO-UNDO.
 DEFINE INPUT-OUTPUT  PARAMETER pcNewValues   AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT        PARAMETER pcError       AS CHARACTER  NO-UNDO.

 RUN processOpenCall IN TARGET-PROCEDURE 
                    ('UPDATE':U, 
                      pcUpdateColumnNames,  
                      pcOldValues,  
                      INPUT-OUTPUT pcNewValues,
                      OUTPUT pcError).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:  Republishes any updateState event messages received from a
            Data-Target, to get them e.g. to Navigation Panel / Toolbar. 
   Params:  INPUT pcState AS CHARACTER   
    Notes:  For Visual objects the updateState is both a DataSourceEvent 
            and DataTargetEvent. We set the CurrentUpdateSource if the 
            publisher is an outside UpdateSoruce so the UpdateSource/DataTarget 
            can use this to recognize that it receives an updateState that it 
            self originated. 
 Note date: 2002/02/08             
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pcState AS CHARACTER  NO-UNDO.
   
   DEFINE VARIABLE cMapping          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE lInProcess        AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE cContained        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cObjects          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iObject           AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hObject           AS HANDLE     NO-UNDO.
   DEFINE VARIABLE cTargets          AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cEvents           AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cUpdateSources    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cTargetSRCEvents  AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cUnmapped         AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iMapping          AS INTEGER    NO-UNDO.
   DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
   DEFINE VARIABLE hMaster           AS HANDLE     NO-UNDO.

   {get ContainedDataObjects cContained}.
   {get ObjectMapping cMapping}.

   /* If the event did NOT come from one of our ContainedDataObjects, 
      we have reason to believe that it came from the outside */
   IF NOT CAN-DO(cContained,STRING(SOURCE-PROCEDURE)) THEN
   DO:
     /* When running updateState in SDOS, we will receive the same events from 
        them, which in again will be run in objects that may send it back 
        to the SBO in the course of republishing the event. We don't want the 
        SBO to react to these intermediate messages, so we set a flag on the 
        way in and turn it off when the event has been dealt with */    
     {get UpdateStateInProcess lInProcess}.

     IF lInProcess THEN 
       RETURN. 

     /* Get all internal objects linked to this */ 
     cObjects = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                 STRING(SOURCE-PROCEDURE), 
                                 cMapping, 
                                 TRUE,  /* return entry *after* */  
                                 ",":U).

     {set UpdateStateInProcess YES}.
     
     /* If the SOURCE is DataTarget that also subscribes, set the 
        currentupdatesource so it can avoid republishing */ 
     {get UpdateSource cUpdateSources}.
     IF CAN-DO(cUpdateSources,STRING(SOURCE-PROCEDURE)) THEN
       {set CurrentUpdateSource SOURCE-PROCEDURE}.
     DO iObject = 1 TO NUM-ENTRIES(cObjects):
       hObject = WIDGET-HANDLE(ENTRY(iObject, cObjects)).
       
       ghTargetProcedure = TARGET-PROCEDURE.
       RUN updateState IN hObject (pcState) NO-ERROR.
       ghTargetProcedure = ?.

     END. /* END DO iObject */
     {set CurrentUpdateSource ?}.
     {set UpdateStateInProcess NO}.
   END. /* not can-do(contained,source) */
   ELSE DO: /* from the inside sending out */
     /* if we're processing the master SDO AND the SBO has a DataSource */
     /* of its own, then notify the SBO DataSource by running 'updateState' */
     /* (Issuezilla 4419) */
     {get MasterDataObject hMaster}.
     IF hMaster = SOURCE-PROCEDURE THEN
     DO:
       {get DataSource hDataSource}.
       IF VALID-HANDLE(hDataSource) THEN
       DO:
         ghTargetProcedure = TARGET-PROCEDURE.
         RUN updateState IN hDataSource (pcState) NO-ERROR.
         ghTargetProcedure = ?.
       END.
     END.

     cObjects = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE,
                                 STRING(SOURCE-PROCEDURE), 
                                 cMapping, 
                                 FALSE,  /* return entry *before* */  
                                 ",":U).
     /* We check if data targets has subscribed. 
        Currently browsers do and viewers don't.  */
     {get DataTarget cTargets}.
     DO iObject = 1 TO NUM-ENTRIES(cObjects):
       ASSIGN
         hObject = WIDGET-HANDLE(ENTRY(iObject, cObjects))
         cEvents = ?.
       
       IF CAN-DO(cTargets,STRING(hObject)) THEN
         {get DataSourceEvents cEvents hObject}.
       
       IF CAN-DO(cEvents,'updateState':U) OR cEvents = ? THEN
       DO:
         ghTargetProcedure = TARGET-PROCEDURE.
         RUN updateState IN hObject (pcState) NO-ERROR.
         ghTargetProcedure = ?.
       END. /* can-do(cEvents,'updatestate') or cEvents = ? */
     END. /* DO iObject = 1 to  */
   END.  /* outgoing events */
   
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addQueryWhere Procedure 
FUNCTION addQueryWhere RETURNS LOGICAL
  ( pcWhere  AS CHARACTER, 
    pcObject AS CHARACTER, 
    pcAndOr  AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this where-clause function, which simply passes
            the parameters on to the SDO named in the pcObject argument.
   Params:  pcWhere AS CHAR (as for query.p function addQueyrWhere),
            pcBuffer AS CHAR (must be an SDO ObjectName),
            pcAndOr AS CHAR as for query.p fn)
    Notes:  Currently the pcObject argument must be specified.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hObject AS HANDLE NO-UNDO.

  hObject = DYNAMIC-FUNCTION('dataObjectHandle':U IN TARGET-PROCEDURE, pcObject).
  IF VALID-HANDLE(hObject) THEN
      RETURN DYNAMIC-FUNCTION('addQueryWhere':U IN hObject,
                              pcWhere, '':U, pcAndOr).
  ELSE RETURN FALSE.   /* If Object wasn't a known SDO Object Name */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-addRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addRow Procedure 
FUNCTION addRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: SBO version of this function, which passes the column list on to the
           contained DataObject which manages that data.
           Returns a chr(1) separated list of RowIdent(s) (separated with 
           semicolon for each object) and values corresponding to the passed 
           list.  
   Params: pcViewColList AS CHARACTER
           - List of columns qualifed with ObjectName or unqualified. 
    Notes: ALL or NONE columns must be qualified! 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTargetNames         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExpandedTargetNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTarget              AS CHARACTER  NO-UNDO.
  
  /* NOTE: AT least temporarily, we may need to get this value to get at
     the real calling object. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE}.
  
  IF NOT VALID-HANDLE(hRequester) THEN
    hRequester = SOURCE-PROCEDURE.
   
  {get UpdateTargetNames cTargetNames hRequester}.  

  /* go thru the UpdateTarget list as the visual client reports them */
  DO iCount = 1 TO NUM-ENTRIES(cTargetNames):
    ASSIGN
      cTarget = ENTRY(iCount, cTargetNames)
      hTarget = {fnarg DataObjectHandle cTarget}.

    /* if the Update Target is already in our expanded list, skip it */
    IF LOOKUP(cTarget, cExpandedTargetNames) > 0 THEN
      NEXT.
    ELSE
      /* otherwise get to the top of the 1-to-1 chain... */
      REPEAT WHILE {fn getUpdateFromSource hTarget}:
        hTarget = {fn getDataSource hTarget}.
      END.

    /* ...then get any 1-to-1 siblings of this UpdateTarget (multi-level)*/
    cExpandedTargetNames = cExpandedTargetNames + 
                           (IF cExpandedTargetNames = "" THEN "" ELSE ",") +
                           getUpdateSiblings (hTarget).
  END.

  RETURN DYNAMIC-FUNCTION('newDataObjectRow':U IN TARGET-PROCEDURE,
                          'add':U,
                           cExpandedTargetNames,
                           pcViewColList).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-appendContainedObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION appendContainedObjects Procedure 
FUNCTION appendContainedObjects RETURNS LOGICAL PRIVATE
  ( INPUT-OUTPUT pcObjects AS CHARACTER, INPUT phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  internal function to build the list of ContainedObjects
             in top-down Data-link order.
    Notes:  private function
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iTarget  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTargets AS CHARACTER  NO-UNDO.

  pcObjects = pcObjects + (IF pcObjects = "":U THEN "":U ELSE ",":U) +
      STRING(phObject).
  {get DataTarget cTargets phObject}.
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
      appendContainedObjects(pcObjects,      /* recurse as needed */
                             WIDGET-HANDLE(ENTRY(iTarget, cTargets))).
  END.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyContextFromServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyContextFromServer Procedure 
FUNCTION applyContextFromServer RETURNS LOGICAL
  ( pcContext AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Apply context returned from server after a server call
    Notes: 
       Typical usage:    
           cContext = obtainContextForServer()
           run <statelesscall>.p (object,
                                  input-output cContext). 
           applyContextFromServer(cContext)               
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContainedObjects AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iObject           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cQueryString      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hObject           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAsHasStarted     AS LOGICAL    NO-UNDO.
  
  {get AsHasStarted lAsHasStarted}.
 
  /* We have a problem.... 
     All SDOs except the upper one in a particular serverSendContained* 
     call is joined on server and the returned queryWhere will include 
     ForeignFields, which we don't know the position if. So if the queryString
     is blank we first check if queryWhere has been set and copy it to 
     the QueryString. 
     A non-blank QueryString will be used in query manipulation and we avoid 
     duplication of those ForeignFields. 
     (This is likely to be improved in the future.....) */     
  
  {get ContainedDataObjects cContainedObjects}.
  DO iObject = 2 TO NUM-ENTRIES(cContainedObjects):
    hObject      = WIDGET-HANDLE(ENTRY(iObject,cContainedObjects)).
    {get QueryString cQueryString hObject}.
    IF cQueryString = '':U THEN
    DO:
        /* QueryWhere should normally be ? at this stage, but it might
           have been set from an external call */
        {get QueryWhere cQueryString hObject}.
        IF cQueryString <> ? AND cQueryString <> '':U THEN
        DO:
         {set QueryString cQueryString hObject}.
        END.
    END. /* QueryString = '' */
  END. /* Do iObject = 1 to num-entries(cContainedObjects) */      
  
  DYNAMIC-FUNC('assignContainedProperties':U IN TARGET-PROCEDURE,
                                pcContext,
                               /* Replace */
                               'QueryWhere,QueryContext,OpenQuery,BaseQuery':U ).
  
  /* If queryStyring was not set from QueryWhere before the context was applied
     then we must set it from the baeQuery that was returned from server */  
  {get ContainedDataObjects cContainedObjects}.
  DO iObject = 2 TO NUM-ENTRIES(cContainedObjects):
    hObject      = WIDGET-HANDLE(ENTRY(iObject,cContainedObjects)).
    {get QueryString cQueryString hObject}.
    IF cQueryString = '':U THEN
    DO:
      {get BaseQuery cQueryString hObject}.
      {set QueryString cQueryString hObject}.
    END. /* QueryString = '' */
  END. /* Do iObject = 1 to num-entries(cContainedObjects) */      
  
  {set AsHasStarted TRUE}.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignCurrentMappedObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignCurrentMappedObject Procedure 
FUNCTION assignCurrentMappedObject RETURNS LOGICAL
  ( phRequester  AS HANDLE, 
    pcObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Identifies the "current" contained Data Object for purposes of 
            Navigation or other access by the caller.
   Params:  phRequester AS HANDLE, pcObjectName AS CHARACTER
    Notes:  This function maps the caller to the specified DataObject using the
            ObjectMapping property.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hObject  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cMapping AS CHAR      NO-UNDO.
  DEFINE VARIABLE iObject  AS INT       NO-UNDO.
  DEFINE VARIABLE cTargets AS CHARACTER NO-UNDO.

  {get ObjectMapping cMapping}.
  hObject = {fnarg dataObjectHandle pcObjectName}.
  IF VALID-HANDLE (hObject) THEN
  DO:
      iObject = LOOKUP(STRING(phRequester), cMapping).
      IF iObject NE 0 THEN       /* Change the mapping if the source is there */
          ENTRY(iObject + 1, cMapping) = STRING(hObject).
      ELSE 
      DO:
        /* if requester is an unmapped DataTarget then call the procedure that 
           does the ObjectMapping and updates required properties in target*/  
        {get DataTarget cTargets}.
         IF CAN-DO(cTargets,STRING(phRequester)) THEN
           RUN addDataTarget IN TARGET-PROCEDURE (phRequester).
      END.                      
      RETURN TRUE.
  END.      /* END DO IF VALID-HANDLE */
  ELSE RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignQuerySelection Procedure 
FUNCTION assignQuerySelection RETURNS LOGICAL
  ( pcColumns AS CHARACTER, pcValues AS CHARACTER, pcOperators AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this where-clause function, which separates the
            Columns by SDO and passes columns, values, and operators on to
            the appropriate SDO(s).
   Params:  pcColumns AS CHAR, pcValues AS CHAR, pcOperators AS CHAR --
            all as for the query.p assignQuerySelection function
    Notes:  All columns must be qualified by their SDO Objectname as TableName;
            this will be replaced with RowObject when the columns are passed
            on to the SDO.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iColumn      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cCols        AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cVals        AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cOps         AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cObjectNames AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cColumn      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iName        AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cString      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lSuccess     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE      NO-UNDO.

  {get DataObjectNames cObjectNames}.
  DO iColumn = 1 TO NUM-ENTRIES(cObjectNames):
      /* Initialize these to hold the cols, values, and ops for each SDO. 
         Use a delimiter of CHR(2) between groups for each SDO. */
      cCols = cCols + (IF iColumn = 1 THEN "":U ELSE CHR(2)).
  END.            /* END DO iColumn -- initialization of delimiters */
  cVals = cCols.
  /* If the request specified an operator per column, then initialize
     accordingly; otherwise just store the one entry passed in to us. */
  IF NUM-ENTRIES (pcOperators) > 1 THEN
      cOps = cCols.
  ELSE cOps = pcOperators.

  /* Now go through all the columns passed and divide them up (along with
     the corresponding values and, if specified, operators) by ObjectName. */
  DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
      cColumn = ENTRY(iColumn, pcColumns).
      IF NUM-ENTRIES(cColumn, ".":U) NE 2 THEN
          RETURN FALSE.           /* Must be qualified by ObjectName */
      iName = LOOKUP(ENTRY(1, cColumn, ".":U), cObjectNames).
      IF iName = 0 THEN
          RETURN FALSE.
      /* First add the column to the right list, qualified as "RowObject" */
      ASSIGN cString = ENTRY(iName, cCols, CHR(2))
             cString = cString + (IF cString = "":U THEN "":U ELSE ",":U) +
                 "RowObject.":U + ENTRY(2, cColumn, ".":U)
             ENTRY(iName, cCols, CHR(2)) = cString
             /* Now add the corresponding value to its list. */
             cString = ENTRY(iName, cVals, CHR(2))
             cString = cString + (IF cString = "":U THEN "":U ELSE CHR(1)) +
                 ENTRY(iColumn, pcValues, CHR(1))
             ENTRY(iName, cVals, CHR(2)) = cString.
       /* Finally put the operator in its list, unless there's only one
          (or none) for the whole list). */
       IF NUM-ENTRIES(pcOperators) > 1 THEN
           ASSIGN cString = ENTRY(iName, cOps, CHR(2))
                  cString = cString + (IF cString = "":U THEN "":U ELSE ",":U) +
                      ENTRY(iColumn, pcOperators)
                  ENTRY(iName, cOps, CHR(2)) = cString.           
  END.         /* END DO iColumn -- divide up columns per SDO. */

  DO iName = 1 TO NUM-ENTRIES(cObjectNames):
      cColumn = ENTRY(iName, cCols, CHR(2)).
      IF cColumn NE "":U THEN
      DO:
          ASSIGN hObject = DYNAMIC-FUNCTION('dataObjectHandle':U 
                                            IN TARGET-PROCEDURE, 
                                     ENTRY(iName, cObjectNames))
                 lSuccess = DYNAMIC-FUNCTION('assignQuerySelection':U IN
                                hObject,
                                INPUT ENTRY(iName, cCols, CHR(2)),
                                INPUT ENTRY(iName, cVals, CHR(2)),
                                INPUT IF NUM-ENTRIES(pcOperators) <= 1 THEN
                                    pcOperators ELSE 
                                        ENTRY(iName, cOps, CHR(2))).
                 IF NOT lSuccess THEN
                     RETURN FALSE.
      END.          /* END DO if cColumns not "" */
  END.              /* END DO iName */

  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cancelRow Procedure 
FUNCTION cancelRow RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this function, which passes the request
            on to the contained DataObject which manages that data.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iEntry       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hTarget      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTargetNames AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTargetName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAutoCommit  AS LOGICAL    NO-UNDO.
  
  {get TargetProcedure hRequester SOURCE-PROCEDURE}.
  
  /* NOTE: AT least temporarily, we may need to get this value to get at
     the real calling object. */
  IF NOT VALID-HANDLE(hRequester) THEN
    hRequester = SOURCE-PROCEDURE.
  
  /* The UpdatTargetNames property is set in the caller and identifies the 
     intended target for the add. The user may specify it to solve cases 
     where fieldname recognition is not sufficient to find the correct target. 
     If not defined by the user it is updated in updateObjectMapping. */
  {get UpdateTargetNames cTargetNames hRequester}.  
  
  {get AutoCommit lAutoCommit}.
  IF lAutoCommit THEN
  DO iEntry = 1 TO NUM-ENTRIES(cTargetNames):
    ASSIGN
      cTargetName = ENTRY(iEntry,cTargetNames) 
      hTarget     = {fnarg DataObjectHandle cTargetName}.

    IF VALID-HANDLE(hTarget) THEN
      {set RowObjectState 'NoUpdates':U hTarget}.
  END.

  /* NOte that we currently only support one  Target */
  DO iEntry = 1 TO NUM-ENTRIES(cTargetNames):
    ASSIGN
      cTargetName = ENTRY(iEntry,cTargetNames) 
      hTarget     = {fnarg DataObjectHandle cTargetName}.

    IF VALID-HANDLE(hTarget) THEN
      {fn cancelRow hTarget}.

  END. /* do iEntry = 1 to  */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canNavigate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canNavigate Procedure 
FUNCTION canNavigate RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Check if this object or its children has any updates.   
           This SBO version of the function turns around and returns 
           canNavigate from the SDO to which the caller is mapped.
           Otherwise it publishes isUpdatePending to its targets
    Notes: This returns true if we can navigate while isUpdatePending is the 
           opposite and returns true if update is pending. 
          (The real reason: It's easier to have default false for i-o params)   
         - See data.p for details.   
----------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping     AS CHAR    NO-UNDO.
  DEFINE VARIABLE iObject      AS INT     NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRequester   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lCanNavigate AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lUpdate      AS LOGICAL NO-UNDO.

  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.   
  IF NOT VALID-HANDLE(hRequester) THEN
    hRequester = SOURCE-PROCEDURE.

  {get ObjectMapping cMapping}.
  
  iObject = LOOKUP(STRING(hRequester), cMapping).
  
  IF iObject = 0 THEN
    {get MasterDataObject hObject} NO-ERROR.
  
  ELSE 
    hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
  
  lCanNavigate = {fn canNavigate hObject} NO-ERROR.
  
  RETURN IF lCanNavigate = FALSE THEN FALSE ELSE TRUE.
              
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnColumnLabel Procedure 
FUNCTION columnColumnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Column Label by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'ColumnLabel':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its data-type by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'DataType':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDbColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDbColumn Procedure 
FUNCTION columnDbColumn RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its DB column name by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'DbColumn':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnExtent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnExtent Procedure 
FUNCTION columnExtent RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Extent by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'Extent':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Format by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'Format':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its help string by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'Help':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its initial value by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'Initial':U, TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Label by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty (pcColumn, 'Label':U, TARGET-PROCEDURE).  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnMandatory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnMandatory Procedure 
FUNCTION columnMandatory RETURNS LOGICAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Mandatory setting by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMandatory AS CHARACTER    NO-UNDO.
  /* This fn does the work. */

  cMandatory = columnProperty (pcColumn, 'Mandatory':U, TARGET-PROCEDURE).  
  IF cMandatory = "YES":U OR cMandatory = "TRUE" THEN
      RETURN TRUE.
  ELSE RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnModified Procedure 
FUNCTION columnModified RETURNS LOGICAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Modified setting by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cModified AS CHARACTER    NO-UNDO.
  /* This fn does the work. */

  cModified = columnProperty (pcColumn, 'Modified':U, TARGET-PROCEDURE).  
  IF cModified = "YES":U OR cModified = "TRUE" THEN
      RETURN TRUE.
  ELSE RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnObjectHandle Procedure 
FUNCTION columnObjectHandle RETURNS HANDLE
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Takes an unqualified SDO column name and returns the procedure
           handle of the first SDO in this SBO that has that column name.
   Params: pcColumn AS CHARACTER 
    Notes: Column Name requests for SBOs should normally be qualified by
           their SDO ObjectName. This function is called is there is no
           qualifier to return the handle of the SDO, used by other functions. 
------------------------------------------------------------------------------*/

 DEFINE VARIABLE cColumns    AS CHAR   NO-UNDO.
 DEFINE VARIABLE iDO         AS INT    NO-UNDO.
 DEFINE VARIABLE cObjects    AS CHAR   NO-UNDO.

 {get ContainedDataColumns cColumns}.
 {get ContainedDataObjects cObjects}.
 DO iDO = 1 TO NUM-ENTRIES(cColumns, ";":U):  /* Extract each SDO list. */
     IF LOOKUP(pcColumn, ENTRY(iDO, cColumns, ";")) NE 0 THEN
         RETURN WIDGET-HANDLE(ENTRY(iDO, cObjects)).
 END.         /* END DO iDO */
 RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnPrivateData Procedure 
FUNCTION columnPrivateData RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its PRIVATE-DATA by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'PrivateData':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnProperty Procedure 
FUNCTION columnProperty RETURNS CHARACTER PRIVATE
  ( pcColumn AS CHARACTER, pcProperty AS CHARACTER, phTarget AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  General purpose function used internally to identify the
            SDO in which one of the column<property> functions should be
            run and to run it and return the value.
            Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its property value by passing the
            request along to the appropriate Data Object. If the column name
            is not qualified by the SDO ObjectName, the first matching column
            name is used to identify which SDO to pass the request along to.
            
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName;
            pcProperty AS CHARACTER -- the property name to retrieve;
            phTarget AS HANDLE -- Target procedure handle
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cColumn AS CHAR   NO-UNDO.
  DEFINE VARIABLE hObject AS HANDLE NO-UNDO.
  DEFINE VARIABLE cObject AS CHAR   NO-UNDO.

  IF NUM-ENTRIES(pcColumn, ".":U) = 2 THEN   /* Use ObjectName qualifier */
      ASSIGN cColumn = ENTRY(2, pcColumn, ".":U)
             cObject = ENTRY(1, pcColumn, ".":U)
             hObject = DYNAMIC-FUNCTION ('dataObjectHandle':U IN phTarget, 
                                         cObject).
  ELSE 
      ASSIGN cColumn = pcColumn             /* Use the unqualified name */
             hObject = DYNAMIC-FUNCTION ('columnObjectHandle':U IN phTarget,
                                          cColumn).
  IF VALID-HANDLE(hObject) THEN
      RETURN DYNAMIC-FUNCTION('column':U + pcProperty IN hObject, cColumn).
  ELSE RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnQuerySelection Procedure 
FUNCTION columnQuerySelection RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its QuerySelection by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'QuerySelection':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its ReadOnly setting by passing the
            request along to the appropriate Data Object.  
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
    Notes:  The SDO columnDataType option of permitting a name qualified by
            database table name is not supported.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReadOnly AS CHARACTER    NO-UNDO.
  /* This fn does the work. */

  cReadOnly = columnProperty (pcColumn, 'ReadOnly':U, TARGET-PROCEDURE).  
  IF cReadOnly = "YES":U OR cReadOnly = "TRUE" THEN
      RETURN TRUE.
  ELSE RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its String-Value by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'StringValue':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Table name by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'Table':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValExp Procedure 
FUNCTION columnValExp RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Validation Expression by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'ValExp':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its ValMsg by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'ValMsg':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValue Procedure 
FUNCTION columnValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Value by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN columnProperty(pcColumn, 'Value':U, TARGET-PROCEDURE).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a column name, either unqualified or qualified by
            the SDO ObjectName, and returns its Width by passing the
            request along to the appropriate Data Object. 
   Params:  pcColumn AS CHARACTER -- RowObject column name, optionally
            qualified by SDO ObjectName.
------------------------------------------------------------------------------*/
  /* This fn does the work. */
  RETURN DECIMAL(columnProperty(pcColumn, 'Width':U, TARGET-PROCEDURE)).   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
    (pcColumns AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:  SBO version of colValues to locate requested columns in contained
            Data Objects and assemble a list of their values.
   Params:  pcColumns AS CHARACTER -- comma-separated list of requested cols.
            - All qualified with objectname
            - One objectname qualified column will direct the call 
              to that SDO. 
            - unqualifed columns will use the value of the first column 
              encountered. (no ambiguity check)                
            The 'Rowident' will be a ; separated list of RowIdents 
            for all contained SDOs, also if only one SDO was encountered.
            The entry for SDOs for which no fields are requested will be blank.
            if pcColumns is blank then ALL SDOs rowids will be returned.
            For calls where one or more 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cColValues            AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDONames              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContainedDataColumns AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContainedDataObjects AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cColumn               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iCol                  AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iDO                   AS INTEGER    NO-UNDO.
 DEFINE VARIABLE hDO                   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cValue                AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lColFound             AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cColumnNames          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectName           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRowids               AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hRowObject            AS HANDLE     NO-UNDO.

 {get DataObjectNames cDONames}. 
 {get ContainedDataObjects cContainedDataObjects}.  /* List of contained Data Objects */
 
 /* We return a ; separated list of rowids as the first entry,
    we leave the entries blank if no fields were requested from the object
    but if no fields were requested at all we return all , */
 cRowids = FILL(';':U,NUM-ENTRIES(cDONames) - 1).
 
 IF pcColumns = '':U THEN
 DO: 
   DO iDO = 1 TO NUM-ENTRIES(cContainedDataObjects):
     hDO  = WIDGET-HANDLE(ENTRY(iDO,cContainedDataObjects)).
     IF NOT VALID-HANDLE(hDO) THEN
       RETURN ?.     /* Haven't been initialized yet. */
     {get RowObject hRowObject hDO}.
     ASSIGN
       ENTRY(iDO,cRowids,';':U)  = IF hRowObject:ROWID <> ? 
                                   THEN STRING(hRowObject:ROWID)
                                   ELSE '?':U.  
   END.
   RETURN cRowids + CHR(1).
 END. /* no columns requested */

 /* One qualified column qualifies all */
 IF INDEX(pcColumns,".":U) > 0 THEN
 DO:
   /* Check if we can resolve all columns in one SDO */
   DO iDO = 1 TO NUM-ENTRIES(cDONames) :
     /* replace ',object.' with ',' to see if all columns are for one object.
        left-trim because we add ',' to the columns to replace the first entry */
     ASSIGN
       cObjectName  = ENTRY(iDO,cDONames)
       cColumnNames = LEFT-TRIM(REPLACE(',':U + pcColumns,',':U + cObjectName + '.',',':U),',':U).
     IF INDEX(cColumnNames,'.':U) = 0 THEN
     DO:
       hDO  = {fnarg dataObjectHandle cObjectName}.       
       /* Haven't been initialized yet  */
       IF NOT VALID-HANDLE(hDO) THEN
         RETURN ?.    

       ASSIGN
         cColValues = {fnarg colValues cColumnNames hDo}
         /* Put the rowid part of the returned colvalues in the rowid list*/ 
         ENTRY(iDO,cRowids,';':U)  = ENTRY(1,cColValues) 
         /* then replace this list with the rowid part */
         ENTRY(1,cColValues,CHR(1)) = cRowids. 
       RETURN cColValues. /* We have all we need <------------------------- */
     END.  /* if index(cColumnnames,'.') = 0 */   
   END.  /* do iDO = 1 to num-entries(cDO) */
   
   ASSIGN 
      cObjectName = '':U
      hDO         = ?. 

   /* If we get here we did not return with data from one dataObject above */
   DO iCol = 1 TO NUM-ENTRIES(pcColumns):
     ASSIGN
       cColumn     = ENTRY(iCol,pcColumns).
     /* All columns must be qualified. We might probably get here if not 
        initialized if the logic above failed (?) */ 
     IF NUM-ENTRIES(cColumn,'.':U) <> 2 THEN
       RETURN ?.
     
     /* We don't need to keep regetting the SDO handle. */
     IF cObjectName NE ENTRY(1, cColumn, ".":U) THEN 
     DO:
       ASSIGN cObjectName = ENTRY(1, cColumn, ".":U)
              hDO         = {fnarg dataObjectHandle cObjectName}
              iDo         = LOOKUP(cObjectName,cDONames).
       
             /* Haven't been initialized  */
       IF NOT VALID-HANDLE(hDO) THEN
         RETURN ?.    

       /* if this is the first time this object was encountered get the ROWID */
       IF ENTRY(iDO,cRowids,';':U) = '':U THEN
       DO:
         {get RowObject hRowObject hDO}.
         ENTRY(iDO,cRowids,';':U) = IF hRowObject:ROWID <> ? 
                                    THEN STRING(hRowObject:ROWID)
                                    ELSE '?':U.
       END. /* first object encounter */
     END. /* new objectname */
     ASSIGN 
       cValue     = DYNAMIC-FUNCTION('columnValue':U IN hDO,ENTRY(2,cColumn,'.':U))
       cColValues = cColValues + CHR(1) + IF cValue = ? THEN "?":U 
                                          ELSE cValue.
   END. /* icol = 1 to num-entries */
 END. /* one or more columns qualified */  
 ELSE DO: /* no qualified columns */
   {get ContainedDataColumns cContainedDataColumns}. 
    
   DO iCol = 1 TO NUM-ENTRIES(pcColumns):
     ASSIGN 
       cColumn    = ENTRY(iCol,pcColumns)
       lColFound  = FALSE.
     DO iDO = 1 TO NUM-ENTRIES(cContainedDataColumns,';':U):
       IF CAN-DO(ENTRY(iDO,cContainedDataColumns,';':U),cColumn) THEN 
       DO:
         hDO        = WIDGET-HANDLE(ENTRY(iDO,cContainedDataObjects)).
         
          /* Haven't been initialized yet or not available  */
         IF NOT VALID-HANDLE(hDO) THEN
            RETURN ?.    

         ASSIGN
           cValue     = DYNAMIC-FUNCTION('columnValue':U IN hDO,cColumn)
           cColValues = cColValues + CHR(1) + IF cValue = ? THEN "?":U 
                                              ELSE cValue
                                          
           lColFound  = TRUE.
         /* if this is the first time this object was requested get the ROWID  */
         IF ENTRY(iDO,cRowids,';':U) = '':U THEN
         DO:
           {get RowObject hRowObject hDO}.
           ENTRY(iDO,cRowids,';':U) = IF hRowObject:ROWID <> ? 
                                      THEN STRING(hRowObject:ROWID)
                                      ELSE '?':U.
         END. /* first object encounter */
         LEAVE. /* iDo containedDataObject loop  */
       END.
     END. /* do iDo */
     IF NOT lColFound THEN RETURN ?.
   END. /* do icol 1 to num- pccolumns */
 END. 
 /* cColValues is prepended with chr(1) already */
 RETURN cRowids + cColValues.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION copyRow Procedure 
FUNCTION copyRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: SBO version of this function, which passes the column list on to the
           contained DataObject which manages that data.
           Returns a chr(1) separated list of RowIdent(s) (separated with 
           semicolon for each object) and values corresponding to the passed 
           list.  
   Params: pcViewColList AS CHARACTER
           - List of columns qualifed with ObjectName or unqualified. 
    Notes: ALL or NONE columns must be qualified! 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTargetNames AS CHARACTER  NO-UNDO.
  
  /* NOTE: AT least temporarily, we may need to get this value to get at
     the real calling object. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE}.
  
  IF NOT VALID-HANDLE(hRequester) THEN
    hRequester = SOURCE-PROCEDURE.
   
  {get UpdateTargetNames cTargetNames hRequester}.  
  RETURN DYNAMIC-FUNCTION('newDataObjectRow':U IN TARGET-PROCEDURE,
                          'copy':U,
                           cTargetNames,
                           pcViewColList).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-currentMappedObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION currentMappedObject Procedure 
FUNCTION currentMappedObject RETURNS CHARACTER
  (  phRequester AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the object name which is currently mapped to this caller.
   Params:  input phRequester AS HANDLE
    Notes:  The value is derived from the ObjectMapping property in the SDO.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping    AS CHAR   NO-UNDO.
  DEFINE VARIABLE iObject     AS INT    NO-UNDO.
  DEFINE VARIABLE hObject     AS HANDLE NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHAR   NO-UNDO.

  {get ObjectMapping cMapping}.
  iObject = LOOKUP(STRING(phRequester), cMapping).
  
  IF iObject > 0 THEN DO:
      hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
      {get ObjectName cObjectName hObject} NO-ERROR.
      RETURN cObjectName.
  END.         /* END DO IF SOurce Object found in list. */
  ELSE RETURN ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataContainerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dataContainerHandle Procedure 
FUNCTION dataContainerHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: The DataContainer handle is an appserver aware container that can 
           handle data requests and also is the container of this object. 
           This can be a standard container or an sbo. This function also 
           encapsulates the required checks of this object's AppServer properties
           and only returns the handle if the current or permanent state allows 
           it to be part of a stateless request handled by another object. 
    Notes: It is rather likely that the DataContainer role and client container
           role will be in separate objects in the future.      
         - Currently duplicated in data.p.  
         - Used in openQuery and fetchContainedRows 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cASDivision      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hSource          AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lDataContainer   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lSBO             AS LOGICAL    NO-UNDO.

 {get ContainerSource hSource}.
 IF VALID-HANDLE(hSource) THEN
 DO:
   /* The DataContainer flag identifies an Appserver Container */
   {get DataContainer lDataContainer hSource}.
   {get QueryObject   lSBO hSource}. 
   IF lDataContainer AND NOT lSBO THEN
   DO:
     /* Check AppServer properties to see if the object has no current or future 
        server bindings and is using a stateless operating mode.*/    
     IF {fn hasNoServerBinding} THEN
       RETURN hSource.
   END.
   /* An SBO has AsDivision = 'client'. If the SDO is inside an SBO its data 
      requests are always managed by the SBO, so the Appserver properties do 
      not need to be checked and may not even apply */
   ELSE DO: 
     {get ASDivision cASDivision hSource} NO-ERROR.
     IF (cASDivision = 'Client':U) THEN 
       RETURN hSource.
   END.
 END.
 
 RETURN ?. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataObjectHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dataObjectHandle Procedure 
FUNCTION dataObjectHandle RETURNS HANDLE
  ( pcObjectName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Given the ObjectName (logical name) of a contained SDO,
           returns the handle of that SDO. 
   Params: INPUT pcObjectName AS CHARACTER
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectNames AS CHAR   NO-UNDO.
  DEFINE VARIABLE cDataHandles AS CHAR   NO-UNDO.
  DEFINE VARIABLE iName        AS INT    NO-UNDO.

  {get DataObjectNames cObjectNames}.
  {get ContainedDataObjects cDataHandles}.
  iName = LOOKUP(pcObjectName, cObjectNames).
  IF iName NE 0 THEN
      RETURN WIDGET-HANDLE(ENTRY(iName, cDataHandles)).
  ELSE RETURN ?. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this function, which passes the rowident
            on to the contained DataObject which manages that data.
   Params:  pcRowIdent AS CHARACTER
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDO            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iDO2           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRowIdent      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowIdent2     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataObject    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataObject2   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAutoCommit    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuccess       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cObjectHandles AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowids        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hParent        AS HANDLE     NO-UNDO.
  
  {get ContainedDataObjects cObjectHandles}.
  
  /* Something is wrong, this is NOT allowed  */ 
  IF pcRowident = ? THEN RETURN FALSE. 

  /* Loop through to check if this is a delete of many ? and resort the list 
     so that we can delete the dependants first 
     Note: this is for support of One-to-One, not a cascade delete ..  */ 
  DO iDO = 1 TO NUM-ENTRIES(cObjectHandles) - 1: 
    cRowIdent = ENTRY(iDO,pcRowIdent,";":U). 
    /* we also sort unavailable rowident '?', probably not necessary, but   */
    IF cRowIdent <> '':U THEN
    DO:
      hDataObject = WIDGET-HANDLE(ENTRY(iDO,cObjectHandles)).     
      IF VALID-HANDLE(hDataObject) THEN
      DO:
        /* loop through all entries after this entry to check if we are 
           their datasource */  
        DO iDO2 = iDO + 1 TO NUM-ENTRIES(cObjectHandles):
          cRowIdent2 = ENTRY(iDO2,pcRowIdent,";":U).    
          IF cRowIdent2 <> '':U THEN
          DO:
            hDataObject2 = WIDGET-HANDLE(ENTRY(iDO2,cObjectHandles)).     
            IF VALID-HANDLE(hDataObject2) THEN
            DO:
              {get DataSource hParent hDataObject2}.
              /* if this object's DataSource is the object of the outer loop 
                 then swap them, so the child gets first in the list. */   
              IF hParent = hDataObject THEN
              DO:
                ASSIGN
                  ENTRY(iDO2,cObjectHandles)   = STRING(hDataObject)
                  ENTRY(iDO2,pcRowident,';':U) = cRowIdent
                  hDataObject = hDataObject2
                  cRowIdent  = cRowIdent2
                  ENTRY(iDO,cObjectHandles)   = STRING(hDataObject2)
                  ENTRY(iDO,pcRowident,';':U) = cRowIdent2.
              END. /* rowobject2's parent is rowobject */ 
            END. /* valid hROwObject2 */
            ELSE RETURN FALSE.
          END.  /* rowident2 is set */
        END.  /* do iDO2 = ido + 1 */ 
      END. /* valid(hRowObject) */
      ELSE RETURN FALSE.
    END. /* rowwident is set */ 
  END. /* do ido to num-entries(objects) - 1 */
  
  /* If AutoCommit commitTransaction will run dataavailable in targets 
     so just block outgoing while we delete */
  {get AutoCommit lAutoCommit}.

  IF lAutoCommit THEN 
    {set BlockDataAvailable TRUE}.
 
  /* Now loop through and delete */
  DO iDO = 1 TO NUM-ENTRIES(cObjectHandles): 
    ASSIGN
      cRowIdent   = ENTRY(iDO,pcRowIdent,";":U)    
      hDataObject = WIDGET-HANDLE(ENTRY(iDO,cObjectHandles)).
    
    IF cRowident <> '':U AND cRowident <> '?':U THEN
    DO:
      lSuccess  = DYNAMIC-FUNCTION('deleteRow':U IN hDataObject,cRowIdent).

      IF NOT lSuccess THEN
         RETURN FALSE.
    END.
  END. /* do ido to num-entries(objects) - 1 */
  
  
  /* We disabled outgoing dataAvailable messages while deleting if autocommit
     so set it back.  */    
  IF lAutoCommit THEN 
    {set BlockDataAvailable FALSE}.

  IF lSuccess = YES THEN
  DO:
    IF lAutoCommit THEN
    /* if there's no Commit-Source the changes will be committed now. */
    DO:
      RUN commitTransaction IN TARGET-PROCEDURE.
      RETURN RETURN-VALUE NE "ADM-ERROR":U.
    END.  /* END DO IF AutoCommit */
    ELSE {set RowObjectState 'RowUpdated':U}.
  END. /* do if lSuccess */
  ELSE RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterAvailable Procedure 
FUNCTION getFilterAvailable RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return whether a filter is available. 
    Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFilterAvailable  AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xpFilterAvailable 
  {get FilterAvailable lFilterAvailable}.
  &UNDEFINE xpFilterAvailable 
  
  RETURN lFilterAvailable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Needed by toolbar to provide the actual caller object handle.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghTargetProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateSiblings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateSiblings Procedure 
FUNCTION getUpdateSiblings RETURNS CHARACTER
  ( phDataObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Accepts the handle of an SDO and returns the ObjectNames of
            all 1-to-1 siblings
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDataTargetList   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDataTarget       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDataTarget       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSiblings         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount            AS INTEGER    NO-UNDO.

  ASSIGN
    cSiblings = {fn getObjectName phDataObject}
    cDataTargetList = {fn getDataTarget phDataObject}.

  DO iCount = 1 TO NUM-ENTRIES(cDataTargetList):
    ASSIGN
      cDataTarget = ENTRY(iCount, cDataTargetList)
      hDataTarget = WIDGET-HANDLE(cDataTarget).

    IF {fn getUpdateFromSource hDataTarget} THEN DO:
      cSiblings = cSiblings + "," + getUpdateSiblings (hDataTarget).
    END.
  END.

  RETURN cSiblings.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveAudit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasActiveAudit Procedure 
FUNCTION hasActiveAudit RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: SBO version of this property function, which checks the property 
           in the SDO to which the caller is mapped.
   Params: 
     Note: Requires a unique SDO mapping. If caller has no property that stores
           SDO name we assume the master.
           
           Currently used by the browser's hasActiveAudit.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDO        AS CHAR   NO-UNDO.
  DEFINE VARIABLE hObject     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRequester  AS HANDLE NO-UNDO.
  
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.  
  IF NOT VALID-HANDLE(hRequester) THEN
     hRequester = SOURCE-PROCEDURE.

  cSDO = ?.
  {get DataSourceNames cSDO hRequester} NO-ERROR.  
  
  IF cSDO = ? THEN
    {get NavigationTargetName cSDO hRequester} NO-ERROR.

  IF cSDO <> ? THEN
    hObject = {fnarg dataObjectHandle cSDO}.
  ELSE
    {get MasterDataObject hObject}. 

  IF VALID-HANDLE(hObject) THEN
    RETURN {fn hasActiveAudit hObject}.
  ELSE
    RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveComments) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasActiveComments Procedure 
FUNCTION hasActiveComments RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: SBO version of this property function, which checks the property 
           in the SDO to which the caller is mapped.
   Params: 
     Note: Requires a unique SDO mapping. If caller has no property that stores
           SDO name we assume the master.
           
           Currently used by the browser's hasActiveComments.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSDO        AS CHAR   NO-UNDO.
  DEFINE VARIABLE hObject     AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRequester  AS HANDLE NO-UNDO.
  
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.  
  IF NOT VALID-HANDLE(hRequester) THEN
     hRequester = SOURCE-PROCEDURE.

  cSDO = ?.
  {get DataSourceNames cSDO hRequester} NO-ERROR.  
  
  IF cSDO = ? THEN
    {get NavigationTargetName cSDO hRequester} NO-ERROR.

  IF cSDO <> ? THEN
    hObject = {fnarg dataObjectHandle cSDO}.
  ELSE
    {get MasterDataObject hObject}. 

  IF VALID-HANDLE(hObject) THEN
    RETURN {fn hasActiveComments hObject}.
  ELSE
    RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasActiveTargets Procedure 
FUNCTION hasActiveTargets RETURNS LOGICAL
  ( phHandle     AS HANDLE,
    plCheckchild AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Check if an SDO has external active (not hidden) targets  
    Notes: NOt tested: intended for use in linkState brokering   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataObjects       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTargets       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataSources       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cInactiveLinks     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hGaSource          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTargets           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHandle            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMapping           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNavSource         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hVisObject         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lHidden            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iMap               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObject            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lQueryObject       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cChildSDOs         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iChild             AS INTEGER    NO-UNDO.
  {get ObjectMapping cMapping}.

    cHandle = DYNAMIC-FUNCTION('mappedEntry':U IN TARGET-PROCEDURE, 
                  INPUT STRING(phHandle),
                  INPUT cMapping,
                  INPUT FALSE,       /* Get entries before this */
                  INPUT ",":U).      /* delimiter */  
    
    IF cHandle = '':U THEN
       RETURN FALSE.

    {get NavigationSource cNavSource}. 
    {get DataTarget cDataTargets}.
    {get DataSource cDataSources}.
       /* Check the objects that are mapped to this */
    DO iMap = 1 TO NUM-ENTRIES(cHandle):
      cObject = ENTRY(iMap,cHandle).
      IF NOT CAN-DO(cNavSource,cObject) THEN
      DO:
        hObject = WIDGET-HANDLE(cObject).
        IF CAN-DO(cDataTargets,cObject) THEN
        DO:
          {get QueryObject lQueryObject hObject}.        
          IF lQueryObject THEN
          DO:
            {get inactiveLinks cInactiveLinks hObject}.
            IF NOT CAN-DO(cInactiveLinks,'DataSource':U) THEN
               RETURN TRUE.
          END.
          ELSE DO:
            {get GroupAssignSource hGaSOurce hObject}.
            IF NOT VALID-HANDLE(hGaSource) THEN
            DO:
             {get GroupAssignHidden lHidden hObject}.
             IF NOT lHidden THEN
               RETURN TRUE.
            END.
          END.
        END.        
      END.
    END.
    {get DataTargets cChildSDOs hObject}.
    DO iChild = 1 TO NUM-ENTRIES(cChildSDOs):
      cObject = ENTRY(iChild,cHandle).
      hObject = WIDGET-HANDLE(cObject).
      IF {fnarg hasActiveTargets hObject} THEN
        RETURN TRUE.
    END.

    RETURN FALSE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasForeignKeyChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasForeignKeyChanged Procedure 
FUNCTION hasForeignKeyChanged RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the dataSource Foreignfields are different 
           from the current ForeignValues  
    Notes: DataAvailable has a 'RESET' mode that indicates that the query only 
           should be opened if necessary. This function is an imporetant part of 
           that logic. If it returns TRUE the query need to be reopened.  
        -  Uncommitted values are currently not considered to be a change, so 
           the DataSource's before-image values is checked if 
           RowObjectState = 'ROwUpdated'.
Note date: 2002/02/01            
-----------------------------------------------------------------------------*/
DEFINE VARIABLE cForeignFields  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCurrentValues  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cParentValues   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSourceFields   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iField          AS INTEGER    NO-UNDO.
DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDataSource     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cRowObjectState AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRowObjUpd      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRowObject      AS HANDLE     NO-UNDO.
DEFINE VARIABLE lNew            AS LOGICAL    NO-UNDO.

 {get ForeignFields cForeignFields}.
 {get ForeignValues cCurrentValues}.  
 {get DataSource    hDataSource}.
 
 IF NOT VALID-HANDLE(hDataSource) THEN
    RETURN FALSE.

 DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
   cSourceFields =  cSourceFields 
                    + (IF iField = 1 THEN "":U ELSE ",":U)                 
                     /* 2nd of pair is source RowObject fld */ 
                    +  ENTRY(iField + 1, cForeignFields).
 END.

 /* If the DataSource has uncommitted changes, check the before image of the 
    data source (This is admittedly somewhat dirty, but we do not want an API 
    yet...) 
    The intention here is to ensure that this function returns true
    if the parent really is pointing to a different record, but returns 
    false if we still are on the original parent, disregarding changed 
    keyvalues, we also want to disregard uncommitted new records */
 {get RowObjectState cRowObjectState hDataSource}. 
 IF cRowObjectState = 'RowUpdated':U THEN
 DO:
   /* New uncommitted does not constitute a change, but would fail the check 
      below */ 
   {get NewRow lNew}.
   IF lNew THEN
      RETURN FALSE.
   
   {get RowObject hRowObject hDataSource}.
   {get RowObjUpd hRowObjUpd hDataSource}.
   /* find the corresponding rowObjUpd -- (really synchronize the buffers) 
      Check the before image values and RETURN this finding. 
     if no RowObjUpd record is available then the current parent has not 
     changed and we will use the general logic below   */
   IF DYNAMIC-FUNCTION('findRowObjUpd':U IN hDataSource,
                          hRowObject, hRowObjUpd) THEN
   DO:
     DO iField = 1 TO NUM-ENTRIES(cSourceFields):
       hField = hRowObjUpd:BUFFER-FIELD(ENTRY(iField,cSourceFields)). 
       cParentValues = cParentValues + ',':U + hField:BUFFER-VALUE.
     END.
     cParentValues = LEFT-TRIM(cParentValues,',':U). 
      /* Return immediately */
     RETURN cParentValues <> cCurrentValues.
   END.
 END.

 ASSIGN
   cParentValues  = {fnarg colValues cSourceFields hDataSource} NO-ERROR.
   /* Throw away the RowIdent entry returned by colValues*/
   ENTRY(1,cParentValues,CHR(1)) = '':U.
   /* Remove the chr(1).. DON'T TRIM it may cause a problem if the first 
      value(s) in the list is blank */ 
   cParentValues  = SUBSTR(cParentValues,2).
 
 RETURN cParentValues <> cCurrentValues.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDataObjectOrdering Procedure 
FUNCTION initDataObjectOrdering RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Adjust the "DataOrdering" and "UpdateTables" properties for SBOs
            that contain dynamic SDOs.
    Notes:  This version of the function is called from 'initializeObject' 
            to accomodate the late RowObjUpd table creation of dynamic SDOs
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cOrdering      AS CHARACTER  NO-UNDO INIT "":U.
 DEFINE VARIABLE iCount         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iEntry         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cTableList     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hROU           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cDOList        AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hDO            AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
  
  {get ContainedDataObjects cDOList}.

  DO iCount = 1 TO NUM-ENTRIES(cDOList):
    ASSIGN
      hDO = WIDGET-HANDLE(ENTRY(iCount, cDOList))
      cObjectName = {fn getObjectName hDO}
      cOrdering = cOrdering + (IF cOrdering = "" THEN "" ELSE ",") +
                  STRING(iCount)
      /* A valid RowObjUpd table may not exist yet (ie passed as external  
         or not created yet), so insert a placeholder  which will be replaced  
         with the actual table handle when it's known */
      cTableList = cTableList + (IF cTableList = "" THEN "" ELSE ",") +
                   cObjectName. /* placeholder */

    IF VALID-HANDLE(hDO) THEN 
    DO:
      {get RowObjUpdTable hROU hDO}.
      IF VALID-HANDLE(hROU) THEN 
      DO:
        iEntry = LOOKUP(cObjectName, cTableList).
        IF iEntry > 0 THEN
          ENTRY(iEntry, cTableList) = STRING(hROU).
      END.
    END.
  END.

  {set UpdateTables cTableList}.

  RETURN cOrdering.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-IsColumnListQualified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION IsColumnListQualified Procedure 
FUNCTION IsColumnListQualified RETURNS LOGICAL
  ( pcColumnNames AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.

 /* At least the first column MUST be qualified */
 IF num-entries(ENTRY(1, pcColumnNames), '.':U) <= 1 THEN 
     RETURN FALSE.

 /* Either ALL columns must be individually qualified with the SDO name or */
 /* NONE (except the first one, of course) */
 iCount = NUM-ENTRIES(pcColumnNames, '.':U).
 IF iCount > 2                  /* more than one cols are qualified ...*/
    AND iCount <> NUM-ENTRIES(pcColumnNames) + 1 /* ... but not ALL */
   THEN RETURN FALSE.

 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newDataObjectRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newDataObjectRow Procedure 
FUNCTION newDataObjectRow RETURNS CHARACTER
  ( pcMode        AS CHARACTER,
    pcTargetNames AS CHARACTER,
    pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Set one or more the SDOs in New (copy or add) mode.  
  Purpose: Returns a chr(1) separated list of RowIdent(s) (separated with 
           semicolon for each object) and values corresponding to the passed 
           list.  
   Params:  pcObjectNames 
                      - List of object names to set in add/copy mode  
            pcViewColList 
                      - List of columns qualifed with ObjectName or unqualified.
            pcMode    = Add / Copy                 
   Notes:  Columns must match the objects and be qualified with the correct object 
           name if they are qualified.
           Called from addRow and copyRow.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iEntry       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowids      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cColumn      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColumn      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cValue       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lError       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFunction    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOne2One     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hQuery       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRow         AS HANDLE     NO-UNDO.

  IF NOT CAN-DO('Add,Copy':U,pcMode)  THEN
  DO:
    MESSAGE  "Function 'newDataObjectRow()' called with invalid mode: '" pcMode "'."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN ?.
  END.
  
  cFunction = pcMode + 'Row':U. 
  
 /* We add in the SBOs object order, this also enablkes us to return the rowident 
    in submitRow order */
  {get DataObjectNames cObjectNames}.

  /* Check if operating in a One-to-Zero situation. If so, reject... for now */
  DO iEntry = 1 TO NUM-ENTRIES(cObjectNames):
    cObjectName = ENTRY(iEntry,cObjectNames).
    
    /* Is this an updateTarget  */
    IF CAN-DO(pcTargetNames,cObjectName) THEN
    DO:      
      hTarget  = {fnarg DataObjectHandle cObjectName}.        
      IF VALID-HANDLE(hTarget) THEN
      DO:
        {get RowObject hRow hTarget}.
        IF NOT hRow:AVAILABLE THEN         /* no RowObject record... */
        DO:
          {get DataHandle hQuery hTarget}.
          IF hQuery:IS-OPEN THEN           /* ... and the query is open */
          DO:
            {get UpdateFromSource lOne2One hTarget}. /* check for 1to1 */
            IF lOne2One THEN DO:
              RUN addMessage IN TARGET-PROCEDURE ("No Record Available. Table IO operations not supported on One-to-Zero relations.",
                                                  ?,{fn getTables hTarget}).
              RETURN ?. /* ERROR */
            END.
          END.
        END.
      END.
    END.
  END.

  cRowids = FILL(';':U,NUM-ENTRIES(cObjectNames) - 1).
  DO iEntry = 1 TO NUM-ENTRIES(cObjectNames):
    ASSIGN
      cObjectName = ENTRY(iEntry,cObjectNames).
    
    /* Is this an updateTarget  */
    IF CAN-DO(pcTargetNames,cObjectName) THEN
    DO:      
    
      hTarget  = {fnarg DataObjectHandle cObjectName}.      
      
      IF NOT VALID-HANDLE(hTarget) THEN
      DO:
        lError = TRUE.
        LEAVE. /* leave the loop */ 
      END.

      /* If only one target and all the requested fields belongs to one object */   
      IF NUM-ENTRIES(pcTargetNames) = 1 THEN
      DO:
         /* Strip the SDO "tablename" qualifier because SDO addRow isn't
            expecting it. Make sure we don't replace a partial field name
            so replace ',<ObjectName.>' with ','. 
            This is about 4 to 10 times faster than a loop...  */ 
        IF INDEX(pcViewColList,".":U) > 0  THEN
          pcViewColList = LEFT-TRIM(REPLACE(',':U + pcViewColList,
                                   /* Add comma to first entry so it is replaced */
                                           ',':U + cObjectName + '.':U,
                                           ','),
                                    ',':U). /* Trim off the first comma again */
        ASSIGN
          cValueList    = DYNAMIC-FUNC(cFunction IN hTarget, pcViewColList)
                     /* Put the rowid part of the returned colvalues in the rowid list*/ 
          ENTRY(iEntry,cRowids,';':U)  = ENTRY(1,cValueList) 
         /* then replace this list with the rowid part */
          ENTRY(1,cValueList,CHR(1)) = cRowids. 
          
        RETURN cValueList. /* We have all we need <---------------- */
      END. /* One target */
      ELSE DO: 
          /* We block dataAvailable while adding */
          {set BlockDataAvailable TRUE}. 
          /* Block queryposition while adding */
          {set BlockQueryPosition TRUE}. 

          ASSIGN  
           cRowids      = DYNAMIC-FUNCTION(cFunction IN hTarget,'':U) 
           cValueList   = cValueList 
                          + (IF iEntry = 1 THEN "":U ELSE ";":U) 
                          + ENTRY(1,cRowids).
      END.
    END. /* Target found in entry( Sources )*/
    ELSE             
      cValueList  = cValueList 
                  + (IF iEntry = 1 THEN "":U ELSE ";":U) 
                  + '?':U.    
  END. /* Do iEntry loop through DataObjectNames */
    
  /* Unblock dataAvailable again adding */
  {set BlockDataAvailable FALSE}. 
  /* Unblock queryPosition  */
  {set BlockQueryPosition FALSE}. 
  IF lError THEN RETURN ?.
  
  /* All columns are qualifed if more than one Source, retrieve the value 
     from it. We only get down here if more than one target ann all of them were
     valid.   */
  DO iColumn = 1 TO NUM-ENTRIES(pcViewColList):
    ASSIGN cColumn     = ENTRY(iColumn,pcViewColList)
           cObjectName = ENTRY(1,cColumn,'.':U)
           cColumn     = ENTRY(2,cColumn,'.':U)
           hTarget     = {fnarg DataObjectHandle cObjectName}
           cValue      = {fnarg columnValue cColumn hTarget}
           cValueList  = cValueList + CHR(1)
                        + (IF cValue <> ? THEN cValue ELSE '?':U).
  END. /* do iColumn = 1 to */
  
  /* We need to ensure that potential GroupAssigntargets also get the new record
     so we cannot just run in requester. We cannot publish from SDOs either here
     because then add mode will be lost in datatargets if more than one is in addmode */
  PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ('DIFFERENT':U).

  RETURN cValueList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainContextForClient) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION obtainContextForClient Procedure 
FUNCTION obtainContextForClient RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Obtain context properties to return to the client after or as part 
           of a server request.   
    Notes: See containr.p 
         - Overridden because:
           - a data request also can be save/commit which is identified with 
             RowObjUpdTable:has-records.
           - Does not currently use Deep in containedProperties 
             (this does not really matter since an SBO does not have other
              containers.) 
Note date: 2002/02/12                
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lFirst          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cPropRequest    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iSDO            AS INTEGER    NO-UNDO.
    
  /* This is passed from the client to identify the first call */
  {get ServerFirstCall lFirst}. 
  IF lFirst THEN
  DO:
    /* ServerFirstCall need to be false if state-aware 
       (We also return it to the client as a handshake that the first call has 
        completed) */
    {set ServerFirstCall FALSE}. 
    /* Property from this SBO instance */
    cPropRequest = 'THIS;ServerOperatingMode,ServerFirstCall':U 
                 + ';':U 
                 + /* Properties from SDOs */
                    'SmartDataObject;OpenQuery,DBNames,IndexInformation,KeyFields,KeyTableID,EntityFields':U.
    
  END. /* First */
  
  cPropRequest = 
     (IF lFirst THEN cPropRequest + ',':U ELSE '':U)
      + 'FirstResultRow,LastResultRow,FirstRowNum,LastRowNum,QueryWhere,QueryRowident,ForeignValues,PositionForClient':U.
           
  RETURN DYNAMIC-FUNCTION('containedProperties':U IN TARGET-PROCEDURE,
         cPropRequest, 
         NO). 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  This is just a wrapper for fetchContainedData, to allow the
            familiar SDO calling pattern to be used.
   Params:  <none>
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hDataContainer AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lok            AS LOGICAL    NO-UNDO.
 
 /* can we use a data container */ 
 hDataContainer = {fn dataContainerHandle}.
 
 IF VALID-HANDLE(hDataContainer) THEN
 DO:
   {get ObjectName cObjectName}.
   RUN fetchContainedData IN hDataContainer (cObjectName).
   lok = RETURN-VALUE <> 'adm-error':U.
 END.
 ELSE DO:
   {set BindScope 'data':U}.
   RUN fetchContainedData IN TARGET-PROCEDURE (?).
   lok = RETURN-VALUE <> 'adm-error':U.
   /* Just in case nothing happened make sure the bindscope is blank */ 
   {set BindScope '':U}. 
 END.

 RETURN lok.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeQuerySelection Procedure 
FUNCTION removeQuerySelection RETURNS LOGICAL
  ( pcColumns AS CHARACTER, 
    pcOperators AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this where-clause function, which separates the
            Columns by SDO and passes columns and operators on to
            the appropriate SDO(s).
   Params:  pcColumns   AS CHAR,
            pcOperators AS CHAR 
            -- both as for the query.p removeQuerySelection function
    Notes:  All columns must be qualified by their SDO Objectname as TableName;
            this will be replaced with RowObject when the columns are passed
            on to the SDO.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iColumn      AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cCols        AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cOps         AS CHARACTER   NO-UNDO INIT "":U.
  DEFINE VARIABLE cObjectNames AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cColumn      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iName        AS INTEGER     NO-UNDO.
  DEFINE VARIABLE cString      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE lSuccess     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE      NO-UNDO.

  {get DataObjectNames cObjectNames}.
  DO iColumn = 1 TO NUM-ENTRIES(cObjectNames):
      /* Initialize these to hold the cols, values, and ops for each SDO. 
         Use a delimiter of CHR(2) between groups for each SDO. */
      cCols = cCols + (IF iColumn = 1 THEN "":U ELSE CHR(2)).
  END.            /* END DO iColumn -- initialization of delimiters */
  /* If the request specified an operator per column, then initialize
     accordingly; otherwise just store the one entry passed in to us. */
  IF NUM-ENTRIES (pcOperators) > 1 THEN
      cOps = cCols.
  ELSE cOps = pcOperators.

  /* Now go through all the columns passed and divide them up  
     by ObjectName. */
  DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
      cColumn = ENTRY(iColumn, pcColumns).
      IF NUM-ENTRIES(cColumn, ".":U) NE 2 THEN
          RETURN FALSE.           /* Must be qualified by ObjectName */
      iName = LOOKUP(ENTRY(1, cColumn, ".":U), cObjectNames).
      IF iName = 0 THEN
          RETURN FALSE.
      /* First add the column to the right list, qualified as "RowObject" */
      ASSIGN cString = ENTRY(iName, cCols, CHR(2))
             cString = cString + (IF cString = "":U THEN "":U ELSE ",":U) +
                 "RowObject.":U + ENTRY(2, cColumn, ".":U)
             ENTRY(iName, cCols, CHR(2)) = cString.
       /* Now put the operator in its list, unless there's only one
          (or none) for the whole list). */
       IF NUM-ENTRIES(pcOperators) > 1 THEN
         ASSIGN cString = ENTRY(iName, cOps, CHR(2))
                cString = cString + (IF cString = "":U THEN "":U ELSE ",":U) 
                          + ENTRY(iColumn, pcOperators)
                ENTRY(iName, cOps, CHR(2)) = cString.           
  END.  /* END DO iColumn -- divide up columns per SDO. */

  DO iName = 1 TO NUM-ENTRIES(cObjectNames):
     cColumn = ENTRY(iName, cCols, CHR(2)).
     IF cColumn NE "":U THEN
     DO:
        ASSIGN hObject = DYNAMIC-FUNCTION('dataObjectHandle':U
                                          IN TARGET-PROCEDURE, 
                                          ENTRY(iName, cObjectNames))
               lSuccess = DYNAMIC-FUNCTION('removeQuerySelection':U IN
                                hObject,
                                INPUT ENTRY(iName, cCols, CHR(2)),
                                INPUT IF NUM-ENTRIES(pcOperators) <= 1 
                                      THEN pcOperators 
                                      ELSE ENTRY(iName, cOps, CHR(2))).
        IF NOT lSuccess THEN
          RETURN FALSE.
      END.          /* END DO if cColumns not "" */
  END.              /* END DO iName */

  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION repositionRowObject Procedure 
FUNCTION repositionRowObject RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this function, which passes the rowident
            on to the contained DataObject which manages that data.
   Params:  pcRowIdent AS CHARACTER
            Semi colon separated with one entry for each ContainedDataObject.
            The visual object's getRowIdent returns this correct.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDO            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRowIdent      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataObject    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectHandles AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRowid         AS CHARACTER  NO-UNDO.
  
  {get ContainedDataObjects cObjectHandles}.
  
  /* Loop through to check if this is a delete of many ? and resort the list 
     so that we can delete children first */ 
  DO iDO = 1 TO NUM-ENTRIES(cObjectHandles): 
    cRowIdent = ENTRY(iDO,pcRowIdent,";":U). 
    /* we also sort unavailable rowident '?', probably not necessary, but   */
    IF cRowIdent <> '':U AND cRowIdent <> '?':U THEN
    DO:
      hDataObject = WIDGET-HANDLE(ENTRY(iDO,cObjectHandles)).     
      IF VALID-HANDLE(hDataObject) THEN
      DO:
        IF NOT {fnarg repositionRowObject cRowIdent hdataObject} THEN
          RETURN FALSE.
      END. /* valid(hRowObject) */
    END. /* RowIdent is set */ 
  END. /* do i to num-entries(objects) - 1 */
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetQuery Procedure 
FUNCTION resetQuery RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Resets the Query for all Contained SDOs, or if the pcObject
            parameter is specified, for that one SDO, to its original state
   Params:  pcObject AS CHARACTER -- SDO ObjectName
    Notes:  This function is here because setQueryWhere is not supported for
            SBOs, and running setQueryWhere('') would be the way to do it
            otherwise.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContained   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iObject      AS INTEGER    NO-UNDO.
  
  IF pcObject = "":U OR pcObject = ? THEN
  DO:
    {get ContainedDataObjects cContained}.
    DO iObject = 1 TO NUM-ENTRIES(cContained):
       hObject = WIDGET-HANDLE(ENTRY(iObject, cContained)).
       DYNAMIC-FUNCTION('setQueryWhere':U IN hObject, '':U).
    END. /* DO iObject */
  END. /* DO if pcObject not specified. */
  ELSE DO:
    hObject = DYNAMIC-FUNCTION('dataObjectHandle':U IN TARGET-PROCEDURE,
                                pcObject).
    IF VALID-HANDLE(hObject) THEN
       DYNAMIC-FUNCTION('setQueryWhere':U IN hObject, '':U).
    ELSE RETURN FALSE.
  END.  /* END ELSE DO IF pcObject specified. */

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetRow Procedure 
FUNCTION resetRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this function, which passes the rowident
            on to the contained DataObject which manages that data.
   Params:  pcRowIdent AS CHARACTER
            Semi colon separated with one entry for each ContainedDataObject.
            The visual object's getRowIdent returns this correct.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iDO            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRowIdent      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataObject    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectHandles AS CHARACTER  NO-UNDO.
  
  {get ContainedDataObjects cObjectHandles}.
  
  /* Loop through to check if this is a delete of many ? and resort the list 
     so that we can delete children first */ 
  DO iDO = 1 TO NUM-ENTRIES(cObjectHandles):
    ASSIGN
      cRowIdent = ENTRY(iDO,pcRowIdent,";":U)
      cRowIdent = IF cRowident = '?':U THEN ? ELSE cRowident. 
    /* we also sort unavailable rowident '?', probably not necessary, but   */
    IF cRowIdent <> '':U THEN
    DO:
      hDataObject = WIDGET-HANDLE(ENTRY(iDO,cObjectHandles)).     
      IF VALID-HANDLE(hDataObject) THEN
        {fnarg resetRow cRowIdent hdataObject}.
    END. /* RowIdent is set */ 
  END. /* do i to num-entries(objects) - 1 */
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION submitRow Procedure 
FUNCTION submitRow RETURNS LOGICAL
  ( pcRowIdent  AS CHARACTER, 
    pcValueList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Accepts a list of changed values for a row and passes them
               on to the SDOs from which they came.
  Parameters:
    INPUT pcRowIdent  - "key" with RowObject rowid to update, plus a list of 
                        the ROWID(s) of the db record(s) the RowObject is 
                        derived from.
    INPUT pcValueList - CHR(1) delimited list of alternating column names 
                        and values to be assigned.             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iSDO               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hSDO               AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lSuccess           AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cValueList         AS CHARACTER NO-UNDO
      EXTENT {&MaxContainedDataObjects}.
  DEFINE VARIABLE iCol               AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cColumn            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectName        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lAutoCommit        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cRowIdent          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectNames       AS CHARACTER NO-UNDO.
  
  {get DataObjectNames cObjectNames}.
  /* If trim(';') removes all then we have only ONE rowid */ 
  IF NUM-ENTRIES(TRIM(pcRowIdent,';':U),';':U) = 1 THEN
  DO:
    /* If one target and the columns are qualified, remove the qualifier.*/
    IF NUM-ENTRIES(ENTRY(1, pcValueList, CHR(1)), ".":U) = 2 THEN
    DO iCol = 1 TO NUM-ENTRIES(pcValueList, CHR(1)) BY 2:
       ASSIGN cColumn = ENTRY(iCol, pcValueList, CHR(1))
              cColumn = ENTRY(2, cColumn, ".":U)
              ENTRY(iCol, pcValueList, CHR(1)) = cColumn.
    END.         /* END DO iCOL - remove qualifiers. */
  END. /* num-entries(cTargetNames) = 1 */
  
  /* Else if the values came from more than one SDO, we need to build up a 
     separate update list for each SDO, and pass that as the ValueList 
     parameter, along with the corresponding entry in the list of temp-table 
     rowids in RowIdent. */  
  ELSE 
  DO iCol = 1 TO NUM-ENTRIES(pcValueList,CHR(1)) BY 2:
    cColumn = ENTRY(iCol, pcValueList, CHR(1)).
    /* Column names are qualified so use that to find SDO. */
    ASSIGN cObjectName = ENTRY(1, cColumn, ".":U)
           iSDO        = LOOKUP(cObjectName,cObjectNames)
           cColumn     = ENTRY(2, cColumn, ".":U) NO-ERROR. 

    IF iSDO > 0 THEN
     /* Found a match. Add the name/value pair to the list for that SDO. */
      cValueList[iSDO] = cValueList[iSDO] 
                       + (IF cValueList[iSDO] NE "":U THEN CHR(1) ELSE "":U)
                       + cColumn 
                       + CHR(1) 
                       + ENTRY(iCol + 1, pcValueList,CHR(1)).

    ELSE DO:
      DYNAMIC-FUNCTION('showMessage':U IN TARGET-PROCEDURE,
         "Unable to update column ":U + "'":U 
          + cObjectName + ".":U + cColumn + "'.":U + CHR(10) +
         "Object '" + cObjectName + "' is either not available or not updatable").
      RETURN FALSE.
    END. /* else do (SDO not found), */
  END. /* else do (more than one target) */
  
  {get AutoCommit lAutoCommit}.

  /* if autocommit commitTransaction will run dataavailable in targets 
     so just block outgoing */
  /* setting 'BlockDataAvailable=TRUE' here is probably not needed since all */
  /* child SDOs have 'Autocommit=FALSE', so no 'commitTransaction' will happen there */
  IF lAutoCommit THEN 
    {set BlockDataAvailable TRUE}.
  /* Now loop through all the Objects and update when we find the target(s)
     We do this in objectnames order so we can submit foreignfields  */ 
  DO iSDO = 1 TO NUM-ENTRIES(pcRowident,';':U):
    cRowIdent = ENTRY(iSDO,pcRowIdent,";":U).
    IF cRowIdent <> '':U THEN
    DO:
      ASSIGN
        cObjectName = ENTRY(iSDO,cObjectNames)
        hSDO = {fnarg DataObjectHandle cObjectName}.
      
      IF NOT VALID-HANDLE(hSDO) THEN
      DO:
          IF lAutoCommit = YES THEN
            {set BlockDataAvailable FALSE}.
          RETURN FALSE.
      END.

      /* If one target the data are still in the input parameter 
         (qualifiers were removed further up)*/
      IF NUM-ENTRIES(TRIM(pcRowIdent,';':U),';':U) = 1 THEN
      DO:
        lSuccess = DYNAMIC-FUNCTION('submitRow':U IN hSDO,
                                   cRowIdent, 
                                   pcValueList).
        LEAVE. /* no need to loop any more */
      END.
      ELSE DO:
        /* Multiple targets */
        IF cRowIdent <> '?':U THEN
          lSuccess  = DYNAMIC-FUNCTION('submitRow':U IN hSDO,
                                        cRowIdent,
                                        cValueList[iSDO]).              
        IF lAutoCommit = YES THEN
          {set BlockDataAvailable FALSE}.

        IF NOT lSuccess THEN
          RETURN FALSE.
      END. /* else do (multiple targets) */
    END.  /* can-do(cTargetNames,cObjectName) */
  END. /* do iSDO  */
  
  /* We disabled outgoing messages while updating if autocommit so set 
     it back */ 
  IF lAutoCommit = YES THEN
    {set BlockDataAvailable FALSE}.

  IF NOT lSuccess THEN
    RETURN FALSE.

  IF lAutoCommit = YES THEN
  /* if there's no Commit-Source the changes will be committed now. */
  DO:
    RUN commitTransaction IN TARGET-PROCEDURE.
    RETURN RETURN-VALUE NE "ADM-ERROR":U.
  END.                    /* END DO IF AutoCOmmit */
  /* else signal Commit panel and others that there are uncommitted changes. */
  ELSE 
     {set RowObjectState 'RowUpdated':U}.  
  
 

  RETURN lSuccess.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
