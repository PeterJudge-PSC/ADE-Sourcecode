&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" vTableWin _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" vTableWin _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE RowObject
       {"af/obj2/gsmsyfullo.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS vTableWin 
/* Copyright (C) 2005,2007 by Progress Software Corporation. All rights
   reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*---------------------------------------------------------------------------------
  File: gsmsyviewv.w

  Description:  Session Type Property

  Purpose:      Session Type Property Static SmartDataViewer

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000035   UserRef:    posse
                Date:   17/04/2001  Author:     Tammy St Pierre

  Update Notes: Created from Template rysttviewv.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

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

&scop object-name       gsmsyviewv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataViewer yes

{af/sup2/afglobals.i}
{af/sup2/afttcombo.i}

DEFINE VARIABLE gcForeignField  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSessionType   AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "af/obj2/gsmsyfullo.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.property_value 
&Scoped-define ENABLED-TABLES RowObject
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-Define ENABLED-OBJECTS toChangeServiceType rctPhysicalService ~
fiLblPhysicalService 
&Scoped-Define DISPLAYED-FIELDS RowObject.property_value 
&Scoped-define DISPLAYED-TABLES RowObject
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-Define DISPLAYED-OBJECTS toChangeServiceType fiLblPhysicalService ~
fiPropertyValueLabel 

/* Custom List Definitions                                              */
/* ADM-ASSIGN-FIELDS,List-2,List-3,List-4,List-5,List-6                 */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowHandle vTableWin 
FUNCTION getWindowHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_gscspdynlookup AS HANDLE NO-UNDO.
DEFINE VARIABLE h_gsmsedynlookup AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiLblPhysicalService AS CHARACTER FORMAT "X(256)":U INITIAL " Property details" 
      VIEW-AS TEXT 
     SIZE 15.8 BY .62 NO-UNDO.

DEFINE VARIABLE fiPropertyValueLabel AS CHARACTER FORMAT "X(35)":U INITIAL "Property value:" 
      VIEW-AS TEXT 
     SIZE 14.8 BY .62 NO-UNDO.

DEFINE RECTANGLE rctPhysicalService
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83.6 BY 5.67.

DEFINE VARIABLE toChangeServiceType AS LOGICAL INITIAL no 
     LABEL "Change Session type of this Property" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.4 BY .81 TOOLTIP "Note: Treeview will rebuild on successful change of Session Type after save" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     toChangeServiceType AT ROW 1.1 COL 25
     RowObject.property_value AT ROW 5.05 COL 25 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 56 BY 4
     fiLblPhysicalService AT ROW 3.29 COL 4.8 COLON-ALIGNED NO-LABEL
     fiPropertyValueLabel AT ROW 5.19 COL 8.2 COLON-ALIGNED NO-LABEL
     rctPhysicalService AT ROW 3.62 COL 5.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY USE-DICT-EXPS 
         SIDE-LABELS NO-UNDERLINE THREE-D NO-AUTO-VALIDATE 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataViewer
   Data Source: "af/obj2/gsmsyfullo.w"
   Allow: Basic,DB-Fields,Smart
   Container Links: Data-Target,Update-Source,TableIO-Target,GroupAssign-Source,GroupAssign-Target
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {af/obj2/gsmsyfullo.i}
      END-FIELDS.
   END-TABLES.
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
  CREATE WINDOW vTableWin ASSIGN
         HEIGHT             = 8.29
         WIDTH              = 88.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB vTableWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW vTableWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiPropertyValueLabel IN FRAME frMain
   NO-ENABLE                                                            */
ASSIGN 
       fiPropertyValueLabel:PRIVATE-DATA IN FRAME frMain     = 
                "Property value:".

/* SETTINGS FOR EDITOR RowObject.property_value IN FRAME frMain
   EXP-LABEL                                                            */
ASSIGN 
       RowObject.property_value:RETURN-INSERTED IN FRAME frMain  = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME toChangeServiceType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toChangeServiceType vTableWin
ON VALUE-CHANGED OF toChangeServiceType IN FRAME frMain /* Change Session type of this Property */
DO:
  ASSIGN toChangeServiceType.
  
  IF toChangeServiceType:CHECKED THEN
    RUN enableField IN h_gsmsedynlookup.
  ELSE
    RUN disableField IN h_gsmsedynlookup.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK vTableWin 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord vTableWin 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  RUN SUPER.

  RUN setFieldSensitivity.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects vTableWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsm_session_type.session_type_codeKeyFieldgsm_session_type.session_type_objFieldLabelSession typeFieldTooltipEnter Session Type or Press F4 for Session Type LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(20)DisplayDatatypecharacterBaseQueryStringFOR EACH gsm_session_type NO-LOCK
                     BY gsm_session_type.session_type_codeQueryTablesgsm_session_typeBrowseFieldsgsm_session_type.session_type_code,gsm_session_type.session_type_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(20)|X(35)RowsToBatch200BrowseTitleLookup Session TypesViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListgsm_session_type.session_type_code^yesQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamesession_type_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gsmsedynlookup ).
       RUN repositionObject IN h_gsmsedynlookup ( 2.00 , 25.00 ) NO-ERROR.
       RUN resizeObject IN h_gsmsedynlookup ( 1.00 , 60.80 ) NO-ERROR.

       RUN constructObject (
             INPUT  'adm2/dynlookup.w':U ,
             INPUT  FRAME frMain:HANDLE ,
             INPUT  'DisplayedFieldgsc_session_property.session_property_nameKeyFieldgsc_session_property.session_property_objFieldLabelProperty nameFieldTooltipEnter Session Property or Press F4 for Session Property LookupKeyFormat->>>>>>>>>>>>>>>>>9.999999999KeyDatatypedecimalDisplayFormatX(70)DisplayDatatypecharacterBaseQueryStringFOR EACH gsc_session_property NO-LOCK
                     BY gsc_session_property.session_property_nameQueryTablesgsc_session_propertyBrowseFieldsgsc_session_property.session_property_name,gsc_session_property.session_property_descriptionBrowseFieldDataTypescharacter,characterBrowseFieldFormatsX(70)|X(70)RowsToBatch200BrowseTitleLookup Session PropertiesViewerLinkedFieldsLinkedFieldDataTypesLinkedFieldFormatsViewerLinkedWidgetsColumnLabelsColumnFormatSDFFileNameSDFTemplateLookupImageadeicon/select.bmpParentFieldParentFilterQueryMaintenanceObjectMaintenanceSDOCustomSuperProcPhysicalTableNamesTempTablesQueryBuilderJoinCodeQueryBuilderOptionListNO-LOCKQueryBuilderOrderListgsc_session_property.session_property_name^yesQueryBuilderTableOptionListNO-LOCKQueryBuilderTuneOptionsQueryBuilderWhereClausesPopupOnAmbiguousyesPopupOnUniqueAmbiguousnoPopupOnNotAvailnoBlankOnNotAvailnoMappedFieldsUseCacheyesSuperProcedureDataSourceNameFieldNamesession_property_objDisplayFieldyesEnableFieldyesLocalFieldnoHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_gscspdynlookup ).
       RUN repositionObject IN h_gscspdynlookup ( 3.91 , 25.00 ) NO-ERROR.
       RUN resizeObject IN h_gscspdynlookup ( 1.00 , 60.80 ) NO-ERROR.

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_gsmsedynlookup ,
             toChangeServiceType:HANDLE IN FRAME frMain , 'AFTER':U ).
       RUN adjustTabOrder ( h_gscspdynlookup ,
             h_gsmsedynlookup , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord vTableWin 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN setFieldSensitivity.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord vTableWin 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN setFieldSensitivity.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable vTableWin 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcRelative).

  /* Code placed here will execute AFTER standard behavior.    */
  IF VALID-HANDLE(h_gsmsedynlookup) THEN
    gcSessionType = {fn getSavedScreenValue h_gsmsedynlookup}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI vTableWin  _DEFAULT-DISABLE
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields vTableWin 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF gcForeignField <> "":U THEN
    RUN setFieldSensitivity.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject vTableWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE hDataSource AS HANDLE   NO-UNDO.

  {get DataSource    hDataSource}.
  {get ForeignFields gcForeignField hDataSource}.

  IF NUM-ENTRIES(gcForeignField) > 1 THEN
    gcForeignField = ENTRY(2, gcForeignField).
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord vTableWin 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  RUN setFieldSensitivity.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFieldSensitivity vTableWin 
PROCEDURE setFieldSensitivity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cViewerMode   AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF {fn getObjectMode} = "Modify":U THEN
      IF LOOKUP({fn getNewRecord}, "Add,Copy,Yes":U) <> 0 THEN
        cViewerMode = "Add":U.
      ELSE
        cViewerMode = "Modify":U.

    CASE cViewerMode:
      WHEN "Modify":U THEN
      DO:
        IF gcForeignField = "session_type_obj":U THEN
        DO:
          ASSIGN
              toChangeServiceType:SENSITIVE = TRUE
              toChangeServiceType:CHECKED   = FALSE.

          RUN disableField IN h_gsmsedynlookup.
        END.
        ELSE
        DO:
          ASSIGN
              toChangeServiceType:SENSITIVE = FALSE
              toChangeServiceType:CHECKED   = FALSE.

          RUN disableField IN h_gscspdynlookup.
        END.
      END.

      WHEN "Add":U THEN
      DO:
        ASSIGN
            toChangeServiceType:SENSITIVE = FALSE
            toChangeServiceType:CHECKED   = FALSE.
        
        IF gcForeignField = "session_type_obj":U THEN
          RUN disableField IN h_gsmsedynlookup.
        ELSE
          RUN disableField IN h_gscspdynlookup.
      END.
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateMode vTableWin 
PROCEDURE updateMode :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcMode AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcMode).

  /* Code placed here will execute AFTER standard behavior.    */
  RUN setFieldSensitivity.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord vTableWin 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE cSessionType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNewRecord    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFilterViewer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainer    AS HANDLE     NO-UNDO.

  ASSIGN
      cSessionType = gcSessionType
      lNewRecord   = LOOKUP({fn getNewRecord}, "Add,Copy,Yes":U) <> 0.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  IF RETURN-VALUE <> "":U THEN
    RETURN.

  RUN setFieldSensitivity.

  {get WindowHandle hContainer}.

  IF VALID-HANDLE(hContainer) THEN
    hFilterViewer = {fnarg linkHandles 'TreeFilter-Source':U hContainer}.

  IF NOT VALID-HANDLE(hFilterViewer) THEN
    RETURN.

  IF NOT lNewRecord AND cSessionType <> {fn getSavedScreenValue h_gsmsedynlookup} THEN
  DO:
    cSessionType = {fn getSavedScreenValue h_gsmsedynlookup}.

    {fnarg refreshTree "cSessionType, FALSE" hFilterViewer}.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowHandle vTableWin 
FUNCTION getWindowHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hWindow AS HANDLE     NO-UNDO.

  {get ContainerSource hWindow}.

  DO WHILE VALID-HANDLE(hWindow) AND {fn getObjectType hWindow} <> "SmartWindow":U:
    {get ContainerSource hWindow hWindow}.
  END.

  RETURN hWindow.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

