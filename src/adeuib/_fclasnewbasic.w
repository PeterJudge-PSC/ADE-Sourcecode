&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS fFrameWin 
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
/*------------------------------------------------------------------------

  File:        fclassnewbasic.w

  Description: from cntnrfrm.w - ADM2 SmartFrame Tpl

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Notes:       Handles interface and logic to create a new ADM Class
               An ADM class is made of:
               5 + 1 standard files
               6 custom files
               This SmartFrame is the main procedure handling data entry
               code generation
               There is 2 main internal procedures invoked from _clasnew.w
               screenValidation : checks data entered
               generateFiles    : calls subroutines to generate all the files
               
               Custom links:
               fclassnewbasic.w -- Names            --> fclassnewcustom.w
               
  Created:     05/1999             
  Modified:    06/02/99 xbonnamy - full path for .dat files
               06/03/99 xbonnamy - Use standard dialog for file 
                                   generation status
               06/03/99 xbonnamy - check in any case for custom directory
                                   creation
               06/24/99 xbonnamy - verify/update paths management
               11/08/99 tomn     - We no longer force the class name (and
                                   generated file names) to be lowercase
               11/08/99 tomn     - Check for fully qualified "from template"
                                   file name and do not attempt to prepend
                                   DLC path onto it
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

/* Don't uncomment that - It has to be commented to avoid files opened
   to be parented to this SmartFrame */
/*CREATE WIDGET-POOL.*/

/* ***************************  Definitions  ************************** */
 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
  DEFINE VARIABLE glNameChanged     AS LOGICAL      NO-UNDO.    /* Indicates whether a class name is entered or not */

  DEFINE VARIABLE gcFileList        AS CHARACTER    NO-UNDO.    /* Handles of fields representing a file c.f. {&FILE-VALIDATION-LIST} */
  DEFINE VARIABLE gcPathList        AS CHARACTER    NO-UNDO.    /* Handles of fields representing a path c.f. {&PATH-VALIDATION-LIST} */  
  
  DEFINE VARIABLE gcDeriveMeth      AS CHARACTER    NO-UNDO.    /* Method library derived from */    
  DEFINE VARIABLE gcDeriveProp      AS CHARACTER    NO-UNDO.    /* Property file derived from */    
  DEFINE VARIABLE gcDeriveSrc       AS CHARACTER    NO-UNDO.    /* Path source derived from */

  DEFINE VARIABLE gcClassType       AS CHARACTER    NO-UNDO     /* Class type generated by this tool */
    INITIAL "User-Defined":U.
  DEFINE VARIABLE gcCustomDir       AS CHARACTER    NO-UNDO     /* Name of the custom directory */
    INITIAL "custom":U.  

  DEFINE VARIABLE gcDosSrc          AS CHARACTER    NO-UNDO.    /* Dos Source path */      
  DEFINE VARIABLE gcDosRun          AS CHARACTER    NO-UNDO.    /* Dos Rcode path */
  DEFINE VARIABLE gcDosTpl          AS CHARACTER    NO-UNDO.    /* Dos Template Path */
  DEFINE VARIABLE gcDosSrcCst       AS CHARACTER    NO-UNDO.    /* Dos Custom Source Path */  
  DEFINE VARIABLE gcDosRunCst       AS CHARACTER    NO-UNDO.    /* Dos Custom Rcode Path */
    
  DEFINE VARIABLE gcUnixSrc         AS CHARACTER    NO-UNDO.    /* Unix Source path */      
  DEFINE VARIABLE gcUnixRun         AS CHARACTER    NO-UNDO.    /* Unix Rcode path */
  DEFINE VARIABLE gcUnixTpl         AS CHARACTER    NO-UNDO.    /* Unix Template Path */  
  DEFINE VARIABLE gcUnixSrcCst      AS CHARACTER    NO-UNDO.    /* Unix custom Source Path */   
  DEFINE VARIABLE gcUnixRunCst      AS CHARACTER    NO-UNDO.    /* Unix custom Rcode Path */  

/* Variables to define standard files                                   */
  DEFINE VARIABLE gcStdFiles        AS CHARACTER    NO-UNDO     /* List of file names */
    EXTENT 6.
  DEFINE VARIABLE gcStdTypes        AS CHARACTER    NO-UNDO    /* List of file types */  
    EXTENT 6 INITIAL ["Class definition":U,
                      "Method library":U,
                      "Property file":U,
                      "Super procedure":U,
                      "Prototype file":U,
                      "Template file":U].
  DEFINE VARIABLE gcStdTpl          AS CHARACTER    NO-UNDO     /* List of Templates*/     
    EXTENT 6 INITIAL ["src/adm2/template/tplclass.dat":U,
                      "src/adm2/template/tplmethod.dat":U,
                      "src/adm2/template/tplproperty.dat":U,
                      "src/adm2/template/tplsuper.dat":U,
                      "src/adm2/template/tplprototype.dat":U,
                      "":U].
  /* There is a separate variable for template because template can be generated from a template
     we provide or any template file */                    
  DEFINE VARIABLE gcTplForTpl       AS CHARACTER    NO-UNDO    /* Dat template file for template */
    INITIAL "src/adm2/template/tpltemplate.dat".                      
  DEFINE VARIABLE gcStdExt          AS CHARACTER    NO-UNDO    /* List of extensions */
    EXTENT 6 INITIAL [".cld":U,
                      ".i":U,
                      ".i":U,
                      ".p":U,
                      ".i":U,
                      ".w":U].    
  DEFINE VARIABLE gcStdSuffix       AS CHARACTER    NO-UNDO    /* List of suffixes */
    EXTENT 6 INITIAL ["":U,
                      "":U,
                      "prop":U,
                      "":U,
                      "prto":U,
                      "":U].
                     
/* Variables to define custom files                                   */                        
  DEFINE VARIABLE gcCustomMeth         AS CHARACTER    NO-UNDO.   
  DEFINE VARIABLE gcCustomProp         AS CHARACTER    NO-UNDO. 
  DEFINE VARIABLE gcCustomSuper        AS CHARACTER    NO-UNDO. 
  DEFINE VARIABLE gcCustomPrto         AS CHARACTER    NO-UNDO. 
  DEFINE VARIABLE gcCustomExcl         AS CHARACTER    NO-UNDO. 
  DEFINE VARIABLE gcCustomDefs         AS CHARACTER    NO-UNDO.           

  DEFINE VARIABLE gcCustomFiles        AS CHARACTER    NO-UNDO     /* List of files */
    EXTENT 6.

  DEFINE VARIABLE gcCustomTypes        AS CHARACTER    NO-UNDO    /* List of types */  
    EXTENT 6 INITIAL ["Custom method library":U,
                      "Custom property file":U,
                      "Custom super procedure":U,
                      "Custom prototype file":U,
                      "Custom exclude definition":U,
                      "Custom instance definition":U].
  DEFINE VARIABLE gcCustomTpl          AS CHARACTER    NO-UNDO     /* List of Templates */     
    EXTENT 6 INITIAL ["src/adm2/template/tplcustommethod.dat":U,
                      "src/adm2/template/tplcustomproperty.dat":U,
                      "src/adm2/template/tplcustomsuper.dat":U,
                      "src/adm2/template/tplcustomprototype.dat":U,
                      "src/adm2/template/tplcustomexcl.dat":U,
                      "src/adm2/template/tplcustomdefs.dat":U].
  DEFINE VARIABLE gcCustomSuffix       AS CHARACTER    NO-UNDO    /* List of suffixes */
    EXTENT 6 INITIAL ["custom":U,
                      "custom":U,
                      "custom":U,
                      "custom":U,
                      "exclcustom":U,
                      "defscustom":U].    
      
    
  DEFINE VARIABLE glOpen            AS LOGICAL      NO-UNDO.    /* Open in the AppBuilder... */
  DEFINE VARIABLE glReplace         AS LOGICAL      NO-UNDO.    /* Replace if exist... */  
  
  DEFINE VARIABLE DOS-SLASH         AS CHARACTER    NO-UNDO     /* Backslash */
    INITIAL "~\":U.
  DEFINE VARIABLE UNIX-SLASH        AS CHARACTER    NO-UNDO     /* Forwardslash */
    INITIAL "/":U.
  DEFINE VARIABLE gcCldPath         AS CHARACTER    NO-UNDO     /* Path of .cld files */
    INITIAL "src\adm2":U.
    
  DEFINE VARIABLE gcDLC             AS CHARACTER    NO-UNDO.    /* DLC path */
  DEFINE VARIABLE gcUnixDLC         AS CHARACTER    NO-UNDO.    /* DLC path with UNIX slashes */
  DEFINE VARIABLE ghContainerDlg    AS HANDLE       NO-UNDO.    /* Handle of the container */
  DEFINE VARIABLE ghDialog          AS HANDLE       NO-UNDO.    /* Handle of the New ADM2 Class Dialog box */
  
  /* Editor Widget for file generation and other controls */
  
  DEFINE VARIABLE cEditor           AS CHARACTER    NO-UNDO
         VIEW-AS EDITOR SIZE 30 BY 10 LARGE.
  DEFINE FRAME frEditor
         cEditor
         WITH OVERLAY NO-LABELS.
  DEFINE VARIABLE hEditor           AS HANDLE       NO-UNDO.

  /* FRAME STATUS DIALOG */
  DEFINE VARIABLE cStatus1         AS CHARACTER    NO-UNDO
    FORMAT "x(50)":U.
  DEFINE VARIABLE cStatus2         AS CHARACTER    NO-UNDO
    FORMAT "x(50)":U.  
  
  DEFINE FRAME FrStatus
    SKIP(1)
    SPACE (4) cStatus1 VIEW-AS TEXT SPACE(4)
    SKIP
    SPACE (4) cStatus2 VIEW-AS TEXT SPACE(4)
    SKIP(1)
    WITH VIEW-AS DIALOG-BOX THREE-D NO-LABELS OVERLAY
         TITLE "File generation".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartFrame
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER FRAME

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cName cDef cSrc BtnBrowseSrc cRun ~
BtnBrowseRun cTpl BtnBrowseTpl cDerive BtnClass cMeth cProp cSuper cPrto ~
cTemplate cTemplateFrom BtnFileCopy lOpen 
&Scoped-Define DISPLAYED-OBJECTS cName cDef cSrc cRun cTpl cDerive cMeth ~
cProp cSuper cPrto cTemplate cTemplateFrom lOpen 

/* Custom List Definitions                                              */
/* FILE-VALIDATION-LIST,PATH-VALIDATION-LIST,OBJECTS-TO-ENABLE,List-4,List-5,List-6 */
&Scoped-define FILE-VALIDATION-LIST cDef cDerive cMeth cProp cSuper cPrto ~
cTemplate cTemplateFrom 
&Scoped-define PATH-VALIDATION-LIST cSrc cRun cTpl 
&Scoped-define OBJECTS-TO-ENABLE cDef cSrc BtnBrowseSrc cRun BtnBrowseRun ~
cTpl BtnBrowseTpl cDerive BtnClass cMeth cProp cSuper cPrto cTemplate ~
cTemplateFrom BtnFileCopy lOpen 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD backToPage1 fFrameWin 
FUNCTION backToPage1 RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD correctExtension fFrameWin 
FUNCTION correctExtension RETURNS LOGICAL
  ( INPUT pcFile    AS CHARACTER, INPUT pcRightExtension AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createCustomNames fFrameWin 
FUNCTION createCustomNames RETURNS CHARACTER
  ( INPUT pcSuffix  AS CHAR, INPUT pcFileName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD directoryExist fFrameWin 
FUNCTION directoryExist RETURNS LOGICAL
  ( pcName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD errorGenerationMsg fFrameWin 
FUNCTION errorGenerationMsg RETURNS CHARACTER
  ( INPUT pcFileType AS CHAR, INPUT pcFile AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fileExist fFrameWin 
FUNCTION fileExist RETURNS LOGICAL
  ( pcName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isInDLC fFrameWin 
FUNCTION isInDLC RETURNS LOGICAL
  ( INPUT pcDir AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Prefix fFrameWin 
FUNCTION Prefix RETURNS CHARACTER
  ( INPUT pcFile AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareDosPath fFrameWin 
FUNCTION prepareDosPath RETURNS CHARACTER
  ( INPUT pcPath AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD RelativePath fFrameWin 
FUNCTION RelativePath RETURNS CHARACTER
  ( INPUT pcPath AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setReplace fFrameWin 
FUNCTION setReplace RETURNS LOGICAL
  ( INPUT plReplace AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD unixPath fFrameWin 
FUNCTION unixPath RETURNS CHARACTER
  ( INPUT pcDosPath AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnBrowseRun 
     LABEL "Browse..." 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE BUTTON BtnBrowseSrc 
     LABEL "Browse..." 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE BUTTON BtnBrowseTpl 
     LABEL "Browse..." 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE BUTTON BtnClass 
     LABEL "Class..." 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE BUTTON BtnFileCopy 
     LABEL "File..." 
     SIZE 12 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE cDef AS CHARACTER FORMAT "X(256)":U 
     LABEL "Class &Definition File" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cDerive AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Derive From Class" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cMeth AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Method Library" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cName AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Name" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cProp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Propert&y File" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cPrto AS CHARACTER FORMAT "X(256)":U 
     LABEL "Proto&type File" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cRun AS CHARACTER FORMAT "X(256)":U INITIAL ".~\adm2" 
     LABEL "&Rcode Directory" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cSrc AS CHARACTER FORMAT "X(256)":U INITIAL ".~\src~\adm2" 
     LABEL "&Source Directory" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cSuper AS CHARACTER FORMAT "X(256)":U 
     LABEL "S&uper Procedure" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cTemplate AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tem&plate" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cTemplateFrom AS CHARACTER FORMAT "X(256)":U 
     LABEL "Copy &From Template" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE cTpl AS CHARACTER FORMAT "X(256)":U INITIAL ".~\src~\adm2~\template" 
     LABEL "&Template Directory" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE lOpen AS LOGICAL INITIAL no 
     LABEL "Open files in the App&Builder once generated" 
     VIEW-AS TOGGLE-BOX
     SIZE 46 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     cName AT ROW 1 COL 19.8 COLON-ALIGNED
     cDef AT ROW 2.29 COL 19.8 COLON-ALIGNED
     cSrc AT ROW 3.57 COL 19.8 COLON-ALIGNED
     BtnBrowseSrc AT ROW 3.57 COL 56.6
     cRun AT ROW 4.57 COL 19.8 COLON-ALIGNED
     BtnBrowseRun AT ROW 4.57 COL 56.6
     cTpl AT ROW 5.57 COL 19.8 COLON-ALIGNED
     BtnBrowseTpl AT ROW 5.62 COL 56.6
     cDerive AT ROW 7 COL 19.8 COLON-ALIGNED
     BtnClass AT ROW 7 COL 56.6
     cMeth AT ROW 8.48 COL 19.8 COLON-ALIGNED
     cProp AT ROW 9.48 COL 19.8 COLON-ALIGNED
     cSuper AT ROW 10.52 COL 19.8 COLON-ALIGNED
     cPrto AT ROW 11.52 COL 19.8 COLON-ALIGNED
     cTemplate AT ROW 12.86 COL 19.8 COLON-ALIGNED
     cTemplateFrom AT ROW 13.86 COL 19.8 COLON-ALIGNED
     BtnFileCopy AT ROW 13.86 COL 56.6
     lOpen AT ROW 14.95 COL 2.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 68.2 BY 14.76.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartFrame
   Allow: Basic,Browse,DB-Fields,Query,Smart
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target
   Other Settings: PERSISTENT-ONLY
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
  CREATE WINDOW fFrameWin ASSIGN
         HEIGHT             = 14.76
         WIDTH              = 68.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB fFrameWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW fFrameWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fMain
   NOT-VISIBLE                                                          */
ASSIGN 
       FRAME fMain:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON BtnBrowseRun IN FRAME fMain
   3                                                                    */
/* SETTINGS FOR BUTTON BtnBrowseSrc IN FRAME fMain
   3                                                                    */
/* SETTINGS FOR BUTTON BtnBrowseTpl IN FRAME fMain
   3                                                                    */
/* SETTINGS FOR BUTTON BtnClass IN FRAME fMain
   3                                                                    */
/* SETTINGS FOR BUTTON BtnFileCopy IN FRAME fMain
   3                                                                    */
/* SETTINGS FOR FILL-IN cDef IN FRAME fMain
   1 3                                                                  */
/* SETTINGS FOR FILL-IN cDerive IN FRAME fMain
   1 3                                                                  */
/* SETTINGS FOR FILL-IN cMeth IN FRAME fMain
   1 3                                                                  */
/* SETTINGS FOR FILL-IN cProp IN FRAME fMain
   1 3                                                                  */
/* SETTINGS FOR FILL-IN cPrto IN FRAME fMain
   1 3                                                                  */
/* SETTINGS FOR FILL-IN cRun IN FRAME fMain
   2 3                                                                  */
/* SETTINGS FOR FILL-IN cSrc IN FRAME fMain
   2 3                                                                  */
/* SETTINGS FOR FILL-IN cSuper IN FRAME fMain
   1 3                                                                  */
/* SETTINGS FOR FILL-IN cTemplate IN FRAME fMain
   1 3                                                                  */
/* SETTINGS FOR FILL-IN cTemplateFrom IN FRAME fMain
   1 3                                                                  */
/* SETTINGS FOR FILL-IN cTpl IN FRAME fMain
   2 3                                                                  */
/* SETTINGS FOR TOGGLE-BOX lOpen IN FRAME fMain
   3                                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fMain
/* Query rebuild information for FRAME fMain
     _Options          = ""
     _Query            is NOT OPENED
*/  /* FRAME fMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BtnBrowseRun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnBrowseRun fFrameWin
ON CHOOSE OF BtnBrowseRun IN FRAME fMain /* Browse... */
DO:
    RUN browsePath (cRun:HANDLE).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnBrowseSrc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnBrowseSrc fFrameWin
ON CHOOSE OF BtnBrowseSrc IN FRAME fMain /* Browse... */
DO:
    RUN browsePath (cSrc:HANDLE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnBrowseTpl
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnBrowseTpl fFrameWin
ON CHOOSE OF BtnBrowseTpl IN FRAME fMain /* Browse... */
DO:
    RUN browsePath (cTpl:HANDLE).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnClass
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnClass fFrameWin
ON CHOOSE OF BtnClass IN FRAME fMain /* Class... */
DO:
  DEFINE VARIABLE lOk       AS LOGICAL    NO-UNDO.

  SYSTEM-DIALOG GET-FILE cDerive
    TITLE "Choose Class Definition" 
    FILTERS "Class Definition(*.cld)" "*.cld":U
    INITIAL-DIR gcCldPath
    MUST-EXIST
    UPDATE lOk IN WINDOW {&WINDOW-NAME}.
  
  IF lOk THEN DO: /* "Open" was chosen */
    /* If the file is in the PROPATH, make it a relative pathname */
    ASSIGN FILE-INFO:FILE-NAME  = cDerive
           cDerive              = FILE-INFO:FULL-PATHNAME
           . 

    RUN extractTemplateInfo.  /* Analyze the file to gather any necessary information */
    DISPLAY cDerive WITH FRAME {&FRAME-NAME}.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnFileCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFileCopy fFrameWin
ON CHOOSE OF BtnFileCopy IN FRAME fMain /* File... */
DO:
  DEFINE VARIABLE lOk       AS LOGICAL    NO-UNDO.

  SYSTEM-DIALOG GET-FILE cTemplateFrom
    TITLE "Choose Template File" 
    FILTERS "Template (*.w)" "*.w":U,
            "All files (*.*)" "*.*":U    
    MUST-EXIST
    UPDATE lOk IN WINDOW {&WINDOW-NAME}.
  
  IF lOk THEN DO: /* "Open" was chosen */
    /* If the file is in the PROPATH, make it a relative pathname */
    ASSIGN FILE-INFO:FILE-NAME        = cTemplateFrom
           cTemplateFrom              = FILE-INFO:FULL-PATHNAME
           . 
    DISPLAY cTemplateFrom WITH FRAME {&FRAME-NAME}.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDerive
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDerive fFrameWin
ON LEAVE OF cDerive IN FRAME fMain /* Derive From Class */
DO:
  ASSIGN {&SELF-NAME}.
  RUN extractTemplateInfo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cMeth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cMeth fFrameWin
ON LEAVE OF cMeth IN FRAME fMain /* Method Library */
, cProp, cPrto ,cSuper
DO:
  RUN makeCustomNames.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cName fFrameWin
ON VALUE-CHANGED OF cName IN FRAME fMain /* Name */
DO:
  IF SELF:SCREEN-VALUE NE "":U THEN
    RUN enableObjects.
  ELSE  
    RUN disableObjects.
  ASSIGN glNameChanged = SELF:SCREEN-VALUE NE "":U.  
  RUN makeNames.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lOpen fFrameWin
ON VALUE-CHANGED OF lOpen IN FRAME fMain /* Open files in the AppBuilder once generated */
DO:
  glOpen = SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK fFrameWin 


/* ***************************  Main Block  *************************** */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
   /* Now enable the interface  if in test mode - otherwise this happens when
      the object is explicitly initialized from its container. */
   RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE activateStatus fFrameWin 
PROCEDURE activateStatus :
/*------------------------------------------------------------------------------
  Purpose:     Activates the geneartion status dialog that list files 
               being generated.
               The dialog is moved in the screen to appear in the middle of
               the New ADM Class dialog.
               Without that the dialog is placed by default in the AppBuilder's
               window area 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrStatus     AS HANDLE   NO-UNDO.
  
  /* move the status dialog in the New ADM Class area */
  ASSIGN
    hFrStatus      = FRAME FrStatus:HANDLE
    hFrStatus:ROW  = ghDialog:ROW + INTEGER((ghDialog:HEIGHT - hFrStatus:HEIGHT) / 2)
    hFrStatus:COL  = ghDialog:COL + INTEGER((ghDialog:WIDTH - hFrStatus:WIDTH) / 2)
    .

  /* view it now */    
  VIEW FRAME FrStatus.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects fFrameWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE browsePath fFrameWin 
PROCEDURE browsePath :
/*------------------------------------------------------------------------------
  Purpose:     Call adeshar/_seldir.w to let the user choose a directory
  Parameters:  Field handle
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phField    AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE cOldPath  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cPath     AS CHARACTER    NO-UNDO.  
  
  ASSIGN cOldPath            = phField:SCREEN-VALUE
         cPath                = cOldPath
         .
  
  RUN adeshar/_seldir.w (INPUT-OUTPUT cPath).
  IF cPath NE cOldPath THEN /* Path has changed */
    phField:SCREEN-VALUE = DYNAMIC-FUNCTION('RelativePath':U, INPUT cPath).

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildFilesList fFrameWin 
PROCEDURE buildFilesList :
/*------------------------------------------------------------------------------
  Purpose:     Assign values to the 2 variables that store files we have to 
               generate.
               gcStdFiles stores standard files (displayed in Basic Folder)
               gcCustomFiles stores custom files (displayed in Custom Folder)               
  Parameters:  <none>
  Notes:       For template if a copy from template is referenced we change
               the name of the source file to copy from with the name entered
------------------------------------------------------------------------------*/

  /* List of standard files */
  ASSIGN
  
    gcStdFiles[1]       = gcDosSrc + cDef 
    gcStdFiles[2]       = gcDosSrc + cMeth
    gcStdFiles[3]       = gcDosSrc + cProp
    gcStdFiles[4]       = gcDosSrc + cSuper
    gcStdFiles[5]       = gcDosSrc + cPrto
    gcStdFiles[6]       = IF cTemplate NE "":U THEN (gcDosTpl + cTemplate)
                          ELSE "":U 

    /* If template copy from is referenced the original file we copy from
       is not the .dat file but the one referenced in cTemplateFrom field */
    gcStdTpl  [6]       = IF cTemplateFrom NE "":U THEN cTemplateFrom
                          ELSE gcTplForTpl

  /* List of custom files */  
    gcCustomFiles[1]    = gcDosSrcCst + gcCustomMeth
    gcCustomFiles[2]    = gcDosSrcCst + gcCustomProp
    gcCustomFiles[3]    = gcDosSrcCst + gcCustomSuper
    gcCustomFiles[4]    = gcDosSrcCst + gcCustomPrto
    gcCustomFiles[5]    = gcDosSrcCst + gcCustomExcl
    gcCustomFiles[6]    = gcDosSrcCst + gcCustomDefs
    .
     
  RETURN.         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPaths fFrameWin 
PROCEDURE buildPaths :
/*------------------------------------------------------------------------------
  Purpose:     Create path names
  Parameters:  <none>
  Notes:       Full dos path is for files validation and generation
               Relative unix path is used for reference in generated files
------------------------------------------------------------------------------*/
  
  ASSIGN
    /* source dir */
    cSrc                = DYNAMIC-FUNCTION('prepareDosPath':U, INPUT cSrc)
    FILE-INFO:FILE-NAME = cSrc
    gcDosSrc            = RIGHT-TRIM(FILE-INFO:FULL-PATHNAME, DOS-SLASH) + DOS-SLASH 
    gcUnixSrc           = DYNAMIC-FUNCTION('unixPath':U, INPUT FILE-INFO:FULL-PATHNAME)

    
    /* rcode dir */    
    cRun                = DYNAMIC-FUNCTION('prepareDosPath':U, INPUT cRun)
    FILE-INFO:FILE-NAME = cRun
    gcDosRun            = RIGHT-TRIM(FILE-INFO:FULL-PATHNAME, DOS-SLASH) + DOS-SLASH 
    gcUnixRun           = DYNAMIC-FUNCTION('unixPath':U, INPUT FILE-INFO:FULL-PATHNAME)

    /* custom dirs */
    gcDosSrcCst            = gcDosSrc  + gcCustomDir + DOS-SLASH
    gcUnixSrcCst           = gcUnixSrc + gcCustomDir + UNIX-SLASH
    gcDosRunCst            = gcDosRun  + gcCustomDir + DOS-SLASH
    gcUnixRunCst           = gcUnixRun + gcCustomDir + UNIX-SLASH

    /* template dir */
    /* Reset the template directory when there is no template file name referenced 
       We don't want to reference the template directory in the cld file if it's not used 
       In this case, template paths will be ? */    
    cTpl                = "" WHEN cTemplate EQ "":U 
    cTpl                = DYNAMIC-FUNCTION('prepareDosPath':U, INPUT cTpl)
    FILE-INFO:FILE-NAME = cTpl
    gcDosTpl            = RIGHT-TRIM(FILE-INFO:FULL-PATHNAME, DOS-SLASH) + DOS-SLASH 
    gcUnixTpl           = DYNAMIC-FUNCTION('unixPath':U, INPUT FILE-INFO:FULL-PATHNAME)
    
    /* for Unix paths, we try to make it relative, so remove './' that starts if needed */

    gcUnixSrc    = LEFT-TRIM(gcUnixSrc, "./":U)
    gcUnixRun    = LEFT-TRIM(gcUnixRun, "./":U)
    gcUnixTpl    = LEFT-TRIM(gcUnixTpl, "./":U)     
    gcUnixSrcCst = LEFT-TRIM(gcUnixSrcCst, "./":U)
    gcUnixRunCst = LEFT-TRIM(gcUnixRunCst, "./":U)    
    .    

  RETURN.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDir fFrameWin 
PROCEDURE createDir :
/*------------------------------------------------------------------------------
  Purpose:     Create directories on disk
  Parameters:  pcDirName : Source, Rcode, Template (actually, it's the field name)
               pcDir     : Directorty to create
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcDir      AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE cListDir      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cDirToCreate  AS CHARACTER    NO-UNDO.  
  DEFINE VARIABLE cDrive        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iStart        AS INTEGER      NO-UNDO INITIAL 1.
      
  ASSIGN 
    cListDir = REPLACE(pcDir, UNIX-SLASH, DOS-SLASH)
    cListDir = RIGHT-TRIM(cListDir, DOS-SLASH)
    .
    
  IF INDEX(cListDir, ":":U) EQ 2 THEN /* a drive is referenced */  
    ASSIGN
    cDrive = SUBSTRING(cListDir,1 , 2)
    iStart = 2
    cDirToCreate = cDrive
    .

  /* If a drive letter is referenced but a dos-slash is missing
     right after the drive. i.e d:temp */
  IF cDirToCreate NE "":U AND INDEX(cListDir, DOS-SLASH) NE 3 THEN DO:
    MESSAGE "Can not create" pcDir ".":U SKIP
            VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ERROR":U.
  END.
  
  DO iCount = iStart TO NUM-ENTRIES(cListDir, DOS-SLASH):
    ASSIGN
    cDirToCreate = cDirToCreate + (IF cDirToCreate NE "":U THEN DOS-SLASH ELSE "":U) + ENTRY(iCount, cListDir, DOS-SLASH).
    OS-CREATE-DIR VALUE (cDirToCreate).
    IF OS-ERROR NE 0 THEN DO:
      MESSAGE "Creation of" pcDir "failed." 
              VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ERROR":U.
    END.          
  END. /* DO iCount ... */
            
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deactivateStatus fFrameWin 
PROCEDURE deactivateStatus :
/*------------------------------------------------------------------------------
  Purpose:     Hides the generation status dialog
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  HIDE FRAME FrStatus.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableObjects fFrameWin 
PROCEDURE disableObjects :
/*------------------------------------------------------------------------------
  Purpose:     Disable objects of the interface if class name is filled
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION ('setToggleEnable':U IN ghContainerDlg, INPUT FALSE).  
  DISABLE {&OBJECTS-TO-ENABLE} WITH FRAME {&FRAME-NAME}.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI fFrameWin  _DEFAULT-DISABLE
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
  HIDE FRAME fMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableObjects fFrameWin 
PROCEDURE enableObjects :
/*------------------------------------------------------------------------------
  Purpose:     Enable objects of the interface if class name is filled
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION ('setToggleEnable':U IN ghContainerDlg, INPUT TRUE).  
  ENABLE {&OBJECTS-TO-ENABLE} WITH FRAME {&FRAME-NAME}.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI fFrameWin  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY cName cDef cSrc cRun cTpl cDerive cMeth cProp cSuper cPrto cTemplate 
          cTemplateFrom lOpen 
      WITH FRAME fMain.
  ENABLE cName cDef cSrc BtnBrowseSrc cRun BtnBrowseRun cTpl BtnBrowseTpl 
         cDerive BtnClass cMeth cProp cSuper cPrto cTemplate cTemplateFrom 
         BtnFileCopy lOpen 
      WITH FRAME fMain.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE extractTemplateInfo fFrameWin 
PROCEDURE extractTemplateInfo :
/*------------------------------------------------------------------------------
  Purpose:     Analyze class definition file (.cld) refrenced for Derive From
               and extract any template information
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iColPos   AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cLine     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cSearch   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cTemplate AS CHARACTER    NO-UNDO.  
  DEFINE VARIABLE cPathTpl  AS CHARACTER    NO-UNDO.  

  /* check if the file is valid */
  IF NOT DYNAMIC-FUNCTION('fileExist':U, INPUT cDerive) THEN RETURN.

  RUN changeCursor ('WAIT':U).
      
  INPUT FROM VALUE(cDerive) NO-ECHO.

  REPEAT:
    IMPORT UNFORMATTED cLine.
    ASSIGN cLine   = TRIM(cLine)
           iColPos = INDEX(cLine , ":":U)
           cSearch = SUBSTRING(cLine, 1, iColPos - 1)
           .
    CASE cSearch:       
        WHEN "Class TemplatePath":U THEN
            ASSIGN cPathTpl = LEFT-TRIM(SUBSTRING(cLine,iColPos + 1)).
        WHEN "Class Template":U THEN
            ASSIGN cTemplate = LEFT-TRIM(SUBSTRING(cLine,iColPos + 1)).            
    END CASE.
  END. /* repeat import */

  INPUT CLOSE.


  IF cTemplate NE "":U THEN  
  ASSIGN   
    cPathTpl                    = REPLACE(RIGHT-TRIM(cPathTpl, UNIX-SLASH), UNIX-SLASH, DOS-SLASH)
    cPathTpl                    = IF cPathTpl NE "":U THEN (cPathTpl + DOS-SLASH) ELSE cPathTpl
    cTemplate                   = cPathTpl + cTemplate
    cTemplateFrom:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cTemplate /* Display the value onto the screen */
    cTemplateFrom                                     = cTemplate /* Synchronize the variable buffer */
    .
  
  RUN changeCursor ('':U).
      
  RETURN.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genCustomFiles fFrameWin 
PROCEDURE genCustomFiles :
/*------------------------------------------------------------------------------
  Purpose:     Generate custom files (Custom Folder)
  Parameters:  <none>
  Notes:       See definition section for gcCustomXXX variable definition
------------------------------------------------------------------------------*/    
   DEFINE VARIABLE cFileType       AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE cReplace        AS CHARACTER    NO-UNDO.    
   DEFINE VARIABLE cFile           AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE cTemplate       AS CHARACTER    NO-UNDO. 
   DEFINE VARIABLE cErrorMsg       AS CHARACTER    NO-UNDO.       
   DEFINE VARIABLE iCount          AS INTEGER      NO-UNDO.
   DEFINE VARIABLE iCreated        AS INTEGER      NO-UNDO.
   DEFINE VARIABLE iUpdated        AS INTEGER      NO-UNDO.
   DEFINE VARIABLE lNewClass       AS LOGICAL      NO-UNDO.
    
   ASSIGN
     lNewClass = yes.

   /* Generates files if an error occured in this block return error to the calling program 
      The showError internal procedure when called display an error message and returns error */
   GENERATION-BLOCK:
   DO iCount = 1 TO 6 ON ERROR UNDO GENERATION-BLOCK, RETURN ERROR :
     ASSIGN 
        cFileType  = gcCustomTypes[iCount] 
        cTemplate  = gcCustomTpl[iCount]
        cFile      = gcCustomFiles[iCount]
        cErrorMsg  = DYNAMIC-FUNCTION('errorGenerationMsg':U, INPUT cFileType, INPUT cFile)        
        .
        
     /* If the file already exists */
     IF DYNAMIC-FUNCTION('fileExist':U, INPUT cFile) THEN
     DO:
       ASSIGN
         lNewClass = NO.
       IF NOT glReplace THEN
       DO:  /* Ask if they want to overwrite existing class file */
         MESSAGE "File" cFile "already exists" SKIP
                 "Do you want to replace it?" 
                 VIEW-AS ALERT-BOX QUESTION
                 BUTTONS YES-NO
                 UPDATE lAnswer AS LOGICAL.
         /* Restore the cursor shape to 'Wait' */        
         RUN changeCursor (INPUT 'WAIT':U).                               
         IF NOT lAnswer THEN NEXT GENERATION-BLOCK.
       END.  /* NOT glReplace */
       ASSIGN
         iUpdated = iUpdated + 1.
     END.   
     ELSE
       ASSIGN
         iCreated = iCreated + 1.

     /* display status of file being generated */   
     RUN generationStatus (INPUT "Generating " + cFileType, INPUT cFile).
     
     /* copy template to destination file */      
     OS-COPY 
        VALUE(gcUnixDLC + cTemplate) 
        VALUE(cFile).
        
     IF OS-ERROR NE 0 THEN
       RUN showError (INPUT cErrorMsg).

     /* Read the file in the editor */
     IF NOT hEditor:READ-FILE(cFile) THEN 
        RUN showError (INPUT cErrorMsg).        
        
     /* Generic substitutions */   
     IF NOT hEditor:REPLACE("<today>":U, STRING(TODAY,"99/99/9999":U), FIND-GLOBAL)     THEN 
        RUN showError (INPUT cErrorMsg). 
        
     /* Specific substitutions */        
     CASE cFileType :
        /* Custom Method */
        WHEN gcCustomTypes[1] THEN DO:
            IF NOT hEditor:REPLACE("<class-meth>":U, cMeth, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<custom-meth>":U, gcCustomMeth, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).            
            IF NOT hEditor:REPLACE("<class-run-custom>":U, gcUnixRunCst, FIND-GLOBAL)     THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<custom-super>":U, gcCustomSuper, FIND-GLOBAL)        THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src-custom>":U, gcUnixSrcCst, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).                
            IF NOT hEditor:REPLACE("<class-src>":U, gcUnixSrc, FIND-GLOBAL)                    THEN 
                RUN showError (INPUT cErrorMsg).
        END. /* Custom Method */

        /* Custom Property */
        WHEN  gcCustomTypes[2] THEN DO:
            IF NOT hEditor:REPLACE("<custom-prop>":U, gcCustomProp, FIND-GLOBAL)            THEN 
                RUN showError (INPUT cErrorMsg).                
            IF NOT hEditor:REPLACE("<custom-prto>":U, gcCustomPrto, FIND-GLOBAL)            THEN 
                RUN showError (INPUT cErrorMsg).            
            IF NOT hEditor:REPLACE("<class-prop>":U, cProp, FIND-GLOBAL)                    THEN 
                RUN showError (INPUT cErrorMsg).  
            IF NOT hEditor:REPLACE("<class-src-custom>":U, gcUnixSrcCst, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).                
            IF NOT hEditor:REPLACE("<class-src>":U, gcUnixSrc, FIND-GLOBAL)                    THEN 
                RUN showError (INPUT cErrorMsg).                
        END. /* Custom Property */

        /* Custom Super */
        WHEN gcCustomTypes[3] THEN DO:
            IF NOT hEditor:REPLACE("<class-prop>":U, cProp, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<custom-super>":U, gcCustomSuper, FIND-GLOBAL)        THEN 
                RUN showError (INPUT cErrorMsg). 
            IF NOT hEditor:REPLACE("<class-name>":U, cName, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src>":U, gcUnixSrc, FIND-GLOBAL)                    THEN 
                RUN showError (INPUT cErrorMsg).                                       
        END. /* Custom Super */

        /* Custom Prototype */
        WHEN gcCustomTypes[4] THEN DO:
            IF NOT hEditor:REPLACE("<custom-super>":U, gcCustomSuper, FIND-GLOBAL)        THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<custom-prto>":U, gcCustomPrto, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<time>":U,STRING(TIME,"HH:MM:SS":U),FIND-GLOBAL)      THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src-custom>":U, gcUnixSrcCst, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).                            
        END. /* Custom Prototype */

        /* Custom Exclude */
        WHEN gcCustomTypes[5] THEN DO:
            IF NOT hEditor:REPLACE("<custom-excl>":U, gcCustomExcl, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-super>":U, cSuper, FIND-GLOBAL)                THEN
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src-custom>":U, gcUnixSrcCst, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src>":U, gcUnixSrc, FIND-GLOBAL)                    THEN 
                RUN showError (INPUT cErrorMsg).                                
        END. /* Custom Exclude */

        /* Custom Defs */
        WHEN gcCustomTypes[6] THEN DO:
            IF NOT hEditor:REPLACE("<custom-defs>":U, gcCustomDefs, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-prop>":U, cProp, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src-custom>":U, gcUnixSrcCst, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src>":U, gcUnixSrc, FIND-GLOBAL)                    THEN 
                RUN showError (INPUT cErrorMsg).                                
        END. /* Custom Defs */

    END CASE.

    /* save the file */
    IF NOT hEditor:SAVE-FILE(cFile) THEN 
        RUN showError (INPUT cErrorMsg).
  END. /* DO iCount = 1 TO ... */
    
  RETURN STRING(iCreated) + CHR(4) + STRING(iUpdated) + CHR(4) + STRING(lNewClass).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateFiles fFrameWin 
PROCEDURE generateFiles :
/*------------------------------------------------------------------------------
  Purpose:     Main routine to generate standard, custom and template files
               and to compile super procedure
               Calls:
               genStandardFiles
               genCustomFiles
               genRcodeSuper
               
  Parameters:  <none>
  Notes:       Each internal procedure call here returns ERROR if the
               process fails
               Cursor shape is changed at the beginning of this procedure
               Any message statement should be aware to change the cursor
               shape when necessary.
               The block is retried if there is an error to set the lError flag
               and to be sure to change the cursor shape and to hide the status
               frame.
               The procedures genStandardFiles and genCustomFiles return a 
               string value via the RETURN-VALUE statement that consists of a
               CHR(4) delimited list of three values:
               
                 Entry  Data Type   Description
                 -----  ---------   ---------------------------------------
                     1    Integer   Number of new class files created.
                     2    Integer   Number of existing class files updated.
                     3    Logical   Is it a brand new class?
                     
               The procedure genRcodeSuper returns a string value via the
               RETURN-VALUE statement that contains a logical value indicating
               whether or not the rcode for the super procedure already 
               existed.
                              
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lError     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hDialog    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRetStatus AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCreated   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iUpdated   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cNewClass  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cMessage   AS CHARACTER NO-UNDO.

  /* activate generation status */
  RUN activateStatus.

  /* change cursor */
  RUN changeCursor ('WAIT':U).

  ASSIGN
    cRetStatus = "":U.
  
  GENERATION-BLOCK:
  DO ON ERROR UNDO GENERATION-BLOCK, RETRY GENERATION-BLOCK:
    /* If we retry the block mark the lError Logical to True */
    IF RETRY THEN DO:
      lError = TRUE.
      LEAVE GENERATION-BLOCK.
    END.
  
    /* Generate standard files */
    RUN genStandardFiles.
    ASSIGN
      cRetStatus = RETURN-VALUE
      iCreated   = INTEGER(ENTRY(1, cRetStatus, CHR(4)))
      iUpdated   = INTEGER(ENTRY(2, cRetStatus, CHR(4)))
      cNewClass  = TRIM(ENTRY(3, cRetStatus, CHR(4))).
  
    /* Generate custom files */
    RUN genCustomFiles.
    ASSIGN
      cRetStatus = RETURN-VALUE
      iCreated   = iCreated + INTEGER(ENTRY(1, cRetStatus, CHR(4)))
      iUpdated   = iUpdated + INTEGER(ENTRY(2, cRetStatus, CHR(4)))
      cNewClass  = IF CAN-DO("YES,TRUE":U, cNewClass) THEN
                     TRIM(ENTRY(3, cRetStatus, CHR(4)))
                   ELSE
                     cNewClass.

    IF (iCreated GT 0) OR (iUpdated GT 0) THEN
    DO:
      /* Compile standard super procedure */
      RUN genRcodeSuper.
      IF CAN-DO("YES,TRUE":U, TRIM(STRING(RETURN-VALUE))) THEN
        ASSIGN iUpdated = iUpdated + 1.
      ELSE
        ASSIGN iCreated = iCreated + 1.
    END.
  
  END. /* GENERATION-BLOCK */

  /* Restores original setting */
  PAUSE 0 BEFORE-HIDE.

  /* deactivate generation status */
  RUN deactivateStatus.
  
  /* restores cursor shape */
  RUN changeCursor ('':U).
  
  /* If an error occured, return "ERROR":U to the calling program */
  IF lError THEN RETURN "ERROR":U.
  
  IF CAN-DO("YES,TRUE":U, cNewClass) THEN
    /* Class was created */
    ASSIGN cMessage = "Class ":U + cName + " created:^^":U.
  ELSE IF (iUpdated GT 0) OR (iCreated GT 0) THEN
    /* Class was updated */
    ASSIGN cMessage = "Class ":U + cName + " updated:^^":U.
  ELSE
    /* No files were generated */
    ASSIGN cMessage = "Class ":U + cName + " unchanged.":U.

  IF iCreated EQ 1 THEN
    ASSIGN cMessage = cMessage + STRING(iCreated) + " file created^":U.
  ELSE IF iCreated GT 1 THEN
    ASSIGN cMessage = cMessage + STRING(iCreated) + " files created^":U.
  IF iUpdated EQ 1 THEN
    ASSIGN cMessage = cMessage + STRING(iUpdated) + " file updated":U.  
  ELSE IF iUpdated GT 1 THEN
    ASSIGN cMessage = cMessage + STRING(iUpdated) + " files updated":U.

  RUN adecomm/_s-alert.p (INPUT-OUTPUT lError, "i":U, "ok":U, cMessage).

  /* Open files in the AppBuilder when requested */
  IF glOpen THEN 
    RUN openFiles.
    
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generationStatus fFrameWin 
PROCEDURE generationStatus :
/*------------------------------------------------------------------------------
  Purpose:     Updates information displayed in the 'Status dialog'. The status
               dialog gives feedback to the user about the file generation 
               process
  Parameters:  pcStatus1, CHAR, first status line
               pcStatus2, CHAR, second status line
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcStatus1 AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcStatus2 AS CHARACTER NO-UNDO.
  
  DO WITH FRAME FrStatus:
    ASSIGN
      cStatus1:SCREEN-VALUE = pcStatus1
      cStatus2:SCREEN-VALUE = pcStatus2
      .
  END.  
  
  PAUSE 1 NO-MESSAGE.
      
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genRcodeSuper fFrameWin 
PROCEDURE genRcodeSuper :
/*------------------------------------------------------------------------------
  Purpose:     Compile standard super procedure and save the .r in the Rcode 
               directory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFile    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lExists  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iPos     AS INTEGER   NO-UNDO.
  
  RUN generationStatus (INPUT "Compiling " + gcStdTypes[4], INPUT gcStdFiles[4]).
  
  ASSIGN
    cFile   = gcStdFiles[4]
    iPos    = R-INDEX(cFile, "/":U)
    iPos    = IF iPos EQ 0 THEN R-INDEX(cFile, "~\":U) ELSE iPos
    cFile   = gcDosRun + SUBSTR(cFile, iPos + 1, -1)
    cFile   = SUBSTR(cFile, 1, R-INDEX(cFile, ".":U)) + "r":U
    lExists = DYNAMIC-FUNCTION('fileExist':U, INPUT cFile).

  COMPILE VALUE(gcStdFiles[4]) SAVE INTO VALUE (gcDosRun) NO-ERROR.
  IF COMPILER:ERROR THEN DO:
    MESSAGE "Compilation of super procedure failed." 
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN ERROR.    
  END.
  
  RETURN STRING(lExists).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genStandardFiles fFrameWin 
PROCEDURE genStandardFiles :
/*------------------------------------------------------------------------------
  Purpose:     Generate standard files (Basic Folder, except template)
  Parameters:  <none>
  Notes:       See definition section for gcStdXXX variable definition
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cFileType       AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE cReplace        AS CHARACTER    NO-UNDO.    
   DEFINE VARIABLE cFile           AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE cTplTag         AS CHARACTER    NO-UNDO.    
   DEFINE VARIABLE cErrorMsg       AS CHARACTER    NO-UNDO.    
   DEFINE VARIABLE iCount          AS INTEGER      NO-UNDO.
   DEFINE VARIABLE lError          AS LOGICAL      NO-UNDO.
   DEFINE VARIABLE iCreated        AS INTEGER      NO-UNDO.
   DEFINE VARIABLE iUpdated        AS INTEGER      NO-UNDO.
   DEFINE VARIABLE lNewClass       AS LOGICAL      NO-UNDO.
    
   DEFINE VARIABLE cCldSrc         AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE cCldRun         AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE cCldTpl         AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE cCldDef         AS CHARACTER    NO-UNDO.            
   DEFINE VARIABLE cCldDerive      AS CHARACTER    NO-UNDO.

   /* For definition file, paths are slightly different we want to remove
      the trailing UNIX-SLASH */
   ASSIGN
       cCldSrc     = RIGHT-TRIM(gcUnixSrc, UNIX-SLASH) 
       cCldRun     = RIGHT-TRIM(gcUnixRun, UNIX-SLASH)     
       cCldTpl     = RIGHT-TRIM(gcUnixTpl, UNIX-SLASH) 
       cCldDerive  = REPLACE(cDerive, DOS-SLASH, UNIX-SLASH)
       cCldDef     = gcDosSrc + cDef
       lNewClass   = YES
       iCreated    = 0
       iUpdated    = 0
       .

   /* Generates files if an error occured in this block return error to the calling program 
      The showError internal procedure when called display an error message and returns error */
   GENERATION-BLOCK:
   DO iCount = 1 TO 6 ON ERROR UNDO GENERATION-BLOCK, RETURN ERROR :
     ASSIGN 
        cFileType  = gcStdTypes[iCount] 
        cTplTag    = gcStdTpl[iCount]
        cFile      = gcStdFiles[iCount]
        cErrorMsg  = DYNAMIC-FUNCTION('errorGenerationMsg':U, INPUT cFileType, INPUT cFile) 
        .
        
     /* if file name is empty do nothing - should only be eventually template */   
     IF cFile = ""  THEN NEXT GENERATION-BLOCK.

     /* If the file already exists */
     IF DYNAMIC-FUNCTION('fileExist':U, INPUT cFile) THEN
     DO:
       ASSIGN
         lNewClass = NO.
       IF NOT glReplace THEN
       DO:  /* Ask if they want to overwrite existing class file */
         MESSAGE "File" cFile "already exists" SKIP
                 "Do you want to replace it?" 
                 VIEW-AS ALERT-BOX QUESTION
                 BUTTONS YES-NO
                 UPDATE lAnswer AS LOGICAL.
         /* Restore the cursor shape to 'Wait' */        
         RUN changeCursor (INPUT 'WAIT':U).                
         IF NOT lAnswer THEN NEXT GENERATION-BLOCK.        
       END.
       ASSIGN
         iUpdated = iUpdated + 1.
     END.
     ELSE
       ASSIGN
         iCreated = iCreated + 1.

     /* display status of file being generated */     
     RUN generationStatus (INPUT "Generating " + cFileType, INPUT cFile).

     /* copy template to destination file */      
     OS-COPY 
        VALUE(IF INDEX(cTplTag, ":":U) > 0 THEN cTplTag ELSE gcUnixDLC + cTplTag) 
        VALUE(cFile).
        
     /* if copy failed then display error, return error */        
     IF OS-ERROR NE 0 THEN
       RUN showError (INPUT cErrorMsg).

     /* Read the file in the editor */
     IF NOT hEditor:READ-FILE(cFile) THEN 
       RUN showError (INPUT cErrorMsg).        
     

     /* Specific substitutions */        
     CASE cFileType :
        /* Class definition */
        WHEN gcStdTypes[1] THEN DO:
            IF NOT hEditor:REPLACE("<today>":U, STRING(TODAY,"99/99/9999":U), FIND-GLOBAL) THEN 
               RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-name>":U, cName, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).     
            IF NOT hEditor:REPLACE("<class-def>":U, cCldDef, FIND-GLOBAL)                 THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-type>":U, gcClassType, FIND-GLOBAL)            THEN 
                RUN showError (INPUT cErrorMsg).            
            IF NOT hEditor:REPLACE("<class-derive>":U, cCldDerive, FIND-GLOBAL)           THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src>":U, cCldSrc, FIND-GLOBAL)                 THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-run>":U, cCldRun, FIND-GLOBAL)                 THEN 
                RUN showError (INPUT cErrorMsg). 
            IF NOT hEditor:REPLACE("<class-tpl>":U, cCldTpl, FIND-GLOBAL)                 THEN 
                RUN showError (INPUT cErrorMsg).                   
            IF NOT hEditor:REPLACE("<class-meth>":U, cMeth, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-prop>":U, cProp, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-super>":U, cSuper, FIND-GLOBAL)                THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-prto>":U, cPrto, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-template>":U, cTemplate, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<custom-meth>":U, gcCustomMeth, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<custom-prop>":U, gcCustomProp, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<custom-super>":U, gcCustomSuper, FIND-GLOBAL)        THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<custom-prto>":U, gcCustomPrto, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<custom-excl>":U, gcCustomExcl, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<custom-defs>":U, gcCustomDefs, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).

        END. /* Class Definition */

        /* Method library */
        WHEN  gcStdTypes[2] THEN DO:
            ASSIGN cReplace = IF cDerive NE "":U THEN "~{":U + gcDeriveMeth + "~}":U ELSE "":U.
            IF NOT hEditor:REPLACE("<today>":U, STRING(TODAY,"99/99/9999":U), FIND-GLOBAL) THEN 
               RUN showError (INPUT cErrorMsg).            
            IF NOT hEditor:REPLACE("<subclass-meth>":U, cReplace, FIND-GLOBAL)            THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-name>":U, cName, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src>":U, gcUnixSrc, FIND-GLOBAL)               THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-run>":U, gcUnixRun, FIND-GLOBAL)               THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-super>":U, cSuper, FIND-GLOBAL)                THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-meth>":U, cMeth, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).                
            IF NOT hEditor:REPLACE("<class-prop>":U, cProp, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).  
            IF NOT hEditor:REPLACE("<custom-meth>":U, gcCustomMeth, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src-custom>":U, gcUnixSrcCst, FIND-GLOBAL)     THEN 
                RUN showError (INPUT cErrorMsg).                                      
        END. /* Method Library */

        /* Property file */
        WHEN gcStdTypes[3] THEN DO:
            ASSIGN cReplace = IF cDerive NE "":U THEN "~{":U + gcDeriveProp + "~}":U ELSE "":U. 
            IF NOT hEditor:REPLACE("<today>":U, STRING(TODAY,"99/99/9999":U), FIND-GLOBAL) THEN 
               RUN showError (INPUT cErrorMsg).            
            IF NOT hEditor:REPLACE("<subclass-prop>":U, cReplace, FIND-GLOBAL)            THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src>":U, gcUnixSrc, FIND-GLOBAL)               THEN 
                RUN showError (INPUT cErrorMsg).                
            IF NOT hEditor:REPLACE("<class-prop>":U, cProp, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-prto>":U, cPrto, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<custom-prop>":U, gcCustomProp, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).            
            IF NOT hEditor:REPLACE("<custom-defs>":U, gcCustomDefs, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).            
            IF NOT hEditor:REPLACE("<class-src-custom>":U, gcUnixSrcCst, FIND-GLOBAL)     THEN 
                RUN showError (INPUT cErrorMsg).                
        END. /* Property File */
        
        /* Super procedure */
        WHEN gcStdTypes[4] THEN DO:
            IF NOT hEditor:REPLACE("<today>":U, STRING(TODAY,"99/99/9999":U), FIND-GLOBAL) THEN 
               RUN showError (INPUT cErrorMsg).        
            IF NOT hEditor:REPLACE("<class-super>":U, cSuper, FIND-GLOBAL)                THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src>":U, gcUnixSrc, FIND-GLOBAL)               THEN 
                RUN showError (INPUT cErrorMsg).                
            IF NOT hEditor:REPLACE("<class-name>":U, cName, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).            
            IF NOT hEditor:REPLACE("<class-prop>":U, cProp, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-run>":U, gcUnixRun, FIND-GLOBAL)               THEN 
                RUN showError (INPUT cErrorMsg).                           
            IF NOT hEditor:REPLACE("<custom-excl>":U, gcCustomExcl, FIND-GLOBAL)          THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src-custom>":U, gcUnixSrcCst, FIND-GLOBAL)     THEN 
                RUN showError (INPUT cErrorMsg).                            
        END. /* Super Procedure */

        /* Prototype file */
        WHEN gcStdTypes[5] THEN DO:
            IF NOT hEditor:REPLACE("<today>":U, STRING(TODAY,"99/99/9999":U), FIND-GLOBAL) THEN 
               RUN showError (INPUT cErrorMsg).        
            IF NOT hEditor:REPLACE("<class-prto>":U, cPrto, FIND-GLOBAL)                  THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<class-src>":U, gcUnixSrc, FIND-GLOBAL)               THEN 
                RUN showError (INPUT cErrorMsg).                
            IF NOT hEditor:REPLACE("<class-super>":U, cSuper, FIND-GLOBAL)                THEN 
                RUN showError (INPUT cErrorMsg).
            IF NOT hEditor:REPLACE("<time>":U,STRING(TIME,"HH:MM:SS":U),FIND-GLOBAL)      THEN 
                RUN showError (INPUT cErrorMsg).
        END. /* Prototype file */
        
        /* Template */
        WHEN gcStdTypes[6] THEN DO:        
          IF cFile NE "":U THEN /* sanity check */
            /* if template generation failed, it will return error */
            RUN genTemplateFile.
        END. /* Template */
       
     END CASE.

     /* save the file */
     IF NOT hEditor:SAVE-FILE(cFile) THEN 
       RUN showError (INPUT cErrorMsg).
       
   END. /* DO iCount = 1 TO ... */

   RETURN STRING(iCreated) + CHR(4) + STRING(iUpdated) + CHR(4) + STRING(lNewClass).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genTemplateFile fFrameWin 
PROCEDURE genTemplateFile :
/*------------------------------------------------------------------------------
  Purpose:    Generate a template file  
  Parameters:  <none>
  Notes:      There are 2 cases:
              Template from scratch
              Template by copying another one 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iStart    AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iEnd      AS INTEGER      NO-UNDO.  
  DEFINE VARIABLE cLib      AS CHARACTER    NO-UNDO. 
  DEFINE VARIABLE cErrorMsg       AS CHARACTER    NO-UNDO.  
  
   /* Generates template file
      if an error occured in these blocks return error to the calling program 
      The showError internal procedure when called display an error message and returns error */
  
  ASSIGN cErrorMsg = DYNAMIC-FUNCTION('errorGenerationMsg':U, INPUT gcStdTypes[6], INPUT gcStdFiles[6]).
        
  /* From scratch, using Simple SmartObject as a starting point */
  IF cTemplateFrom EQ "":U THEN 
  TEMPLATE-SCRATCH:
  DO ON ERROR UNDO TEMPLATE-SCRATCH, RETURN ERROR :
    /* method library referenced in the template */
    ASSIGN cLib = "~{":U + gcUnixSrc + cMeth + "~}":U.

     IF NOT hEditor:REPLACE("<class-meth>", cLib, FIND-GLOBAL)                  THEN 
       RUN showError (INPUT cErrorMsg).
     IF NOT hEditor:REPLACE("<today>", STRING(TODAY,"99/99/9999"), FIND-GLOBAL)  THEN 
       RUN showError (INPUT cErrorMsg).     
     IF NOT hEditor:REPLACE("<class-name>", cName, FIND-GLOBAL)                  THEN 
       RUN showError (INPUT cErrorMsg).    
  END. /* Template scratch */
  
  ELSE 
  TEMPLATE-COPY:
  DO ON ERROR UNDO TEMPLATE-COPY, RETURN ERROR : /* Copy from another template */
       
     
    /* look for the Inluded-Libraries section */
    IF NOT hEditor:SEARCH("/* ************************* Included-Libraries *********************** */":U,FIND-SELECT) THEN
      RUN showError (INPUT cErrorMsg).    
    istart = hEditor:SELECTION-START. 
  
    /* Look for the specified block right after it */
    IF NOT hEditor:SEARCH("/* _UIB-CODE-BLOCK-END */":U,FIND-SELECT) THEN
      RUN showError (INPUT cErrorMsg).    
    iend   = hEditor:SELECTION-START.  

    IF iStart = 0 OR iEnd = 0 THEN 
      RUN showError (INPUT cErrorMsg).    

    IF NOT hEditor:SET-SELECTION(istart, iend) THEN   /* Select entire text */
      RUN showError (INPUT cErrorMsg). 

    /* Replacement text */
    ASSIGN clib  = "/* ************************* Included-Libraries *********************** */":U + CHR(10) +
                   CHR(10) +
                   "~{" + gcUnixSrc + cMeth + "~}" +
                   CHR(10)
                   .
    /* Replace the selected text by the new one */                           
    IF NOT hEditor:REPLACE-SELECTION-TEXT(cLib) THEN
      RUN showError (INPUT cErrorMsg).    

    /* Save the file */      
    IF NOT hEditor:SAVE-FILE(gcStdFiles[6]) THEN
      RUN showError (INPUT cErrorMsg).      
  END. /* Case template is a copy from another one */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject fFrameWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Stores the handle of the 'hidden' editor widget */
  IF DYNAMIC-FUNCTION('getUIBMode':U) = "":U THEN DO:
    GET-KEY-VALUE SECTION "StartUp":U KEY "DLC":U VALUE gcDLC.
    ASSIGN 
      gcCldPath      = gcDLC + DOS-SLASH + gcCldPath
      /* If DLC is not set, just default to current directory */
      gcCldPath      = (IF gcCldPath = ? THEN "":U ELSE gcCldPath)
      gcUnixDLC      = REPLACE(gcDlc, DOS-SLASH, UNIX-SLASH) + UNIX-SLASH
      ghContainerDlg = DYNAMIC-FUNCTION('getContainerSource':U)
      ghDialog       = DYNAMIC-FUNCTION('getContainerHandle':U IN ghContainerDlg)
      hEditor        = cEditor:HANDLE IN FRAME frEditor
      .

  END.  /* Only at runtime */
  
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* Generate list handles for screen validation */
  IF DYNAMIC-FUNCTION('getUIBMode':U) = "":U THEN DO:
    RUN listHandles.
    RUN disableObjects.
  END.  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE listHandles fFrameWin 
PROCEDURE listHandles :
/*------------------------------------------------------------------------------
  Purpose:  Generate lists of handles for screen validation and file generation   
  Parameters:  <none>
  Notes:    {&FILE-VALIDATION-LIST} represents the list of fields associated
            to a file name
            {&PATH-VALIDATION-LIST} represents the list of fields associated
            to a path name            
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hObj  AS HANDLE NO-UNDO.
  
  ASSIGN
    hObj = FRAME {&FRAME-NAME}:CURRENT-ITERATION
    hObj = hObj:FIRST-CHILD
    .
    
  DO WHILE VALID-HANDLE(hObj):
    IF hObj:NAME NE ? THEN DO:
        IF LOOKUP(hObj:NAME, "{&FILE-VALIDATION-LIST}":U, " ":U) NE 0 THEN
          ASSIGN gcFileList = gcFileList + ",":U + STRING(hObj).
        IF  LOOKUP(hObj:NAME, "{&PATH-VALIDATION-LIST}":U, " ":U) NE 0 THEN
          ASSIGN gcPathList = gcPathList + ",":U + STRING(hObj).        
    END.    
    hObj = hObj:NEXT-SIBLING.    
  END.
  ASSIGN
    gcFileList      = LEFT-TRIM(gcFileList,",":U)
    gcPathList      = LEFT-TRIM(gcPathList,",":U)    
    .
      
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE makeCustomNames fFrameWin 
PROCEDURE makeCustomNames :
/*------------------------------------------------------------------------------
  Purpose:     Generate names for custom files and publishes these names
               to the custom SmartFrame.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN 
        gcCustomMeth        = IF cMeth:SCREEN-VALUE NE "":U  THEN 
                                DYNAMIC-FUNCTION('createCustomNames':U, INPUT gcCustomSuffix[1], INPUT cMeth:SCREEN-VALUE)
                              ELSE "":U
        gcCustomProp        = IF cProp:SCREEN-VALUE NE "":U  THEN 
                                DYNAMIC-FUNCTION('createCustomNames':U, INPUT gcCustomSuffix[2], INPUT cProp:SCREEN-VALUE)
                              ELSE "":U
        gcCustomSuper       = IF cSuper:SCREEN-VALUE NE "":U THEN 
                                DYNAMIC-FUNCTION('createCustomNames':U, INPUT gcCustomSuffix[3], INPUT cSuper:SCREEN-VALUE)
                              ELSE "":U
        gcCustomPrto        = IF cPrto:SCREEN-VALUE NE "":U  THEN 
                                DYNAMIC-FUNCTION('createCustomNames':U, INPUT gcCustomSuffix[4], INPUT cPrto:SCREEN-VALUE)
                              ELSE "":U
        gcCustomExcl        = IF cName:SCREEN-VALUE NE "":U  THEN 
                                DYNAMIC-FUNCTION('createCustomNames':U, INPUT gcCustomSuffix[5], INPUT (cName:SCREEN-VALUE + ".i":U))
                              ELSE "":U
        gcCustomDefs        = IF cName:SCREEN-VALUE NE "":U  THEN 
                                DYNAMIC-FUNCTION('createCustomNames':U, INPUT gcCustomSuffix[6], INPUT (cName:SCREEN-VALUE + ".i":U))
                              ELSE "":U
        .
  END. /* DO WITH FRAME ... */
  
  /* Publish names for the custom folder */
  PUBLISH 'Names':U 
        (gcCustomMeth, 
         gcCustomProp, 
         gcCustomSuper,
         gcCustomPrto, 
         gcCustomExcl,
         gcCustomDefs).

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE makeNames fFrameWin 
PROCEDURE makeNames :
/*------------------------------------------------------------------------------
  Purpose:     Generate names for standard files
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTruncName  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cBaseName   AS CHARACTER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN cBaseName = cName:SCREEN-VALUE.
    /* get the first 4 characters of the class to build 
       property and prototype files name */
    IF LENGTH(cBaseName,"CHARACTER":U) > 4 THEN 
        ASSIGN cTruncName = SUBSTRING(cBaseName,1,4,"CHARACTER":U).
    ELSE  
        ASSIGN cTruncName = cBaseName.
    /* Display build files names on the screen */
    ASSIGN 
        cDef:SCREEN-VALUE       = IF cBaseName EQ "":U  THEN "":U ELSE (cBaseName  + gcStdSuffix[1]  + gcStdExt[1])
        cMeth:SCREEN-VALUE      = IF cBaseName EQ "":U  THEN "":U ELSE (cBaseName  + gcStdSuffix[2]  + gcStdExt[2])
        cProp:SCREEN-VALUE      = IF cBaseName EQ "":U  THEN "":U ELSE (cTruncName + gcStdSuffix[3]  + gcStdExt[3])
        cSuper:SCREEN-VALUE     = IF cBaseName EQ "":U  THEN "":U ELSE (cBaseName  + gcStdSuffix[4]  + gcStdExt[4])
        cPrto:SCREEN-VALUE      = IF cBaseName EQ "":U  THEN "":U ELSE (cTruncName + gcStdSuffix[5]  + gcStdExt[5])
        cTemplate:SCREEN-VALUE  = IF cBaseName EQ "":U  THEN "":U ELSE (cBaseName  + gcStdSuffix[6]  + gcStdExt[6])
        .
  END. /* DO WITH FRAME ... */
  /* Create custom names */
  RUN makeCustomNames.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openFiles fFrameWin 
PROCEDURE openFiles :
/*------------------------------------------------------------------------------
  Purpose:     Opens files under AppBuilder if requested by the user
  Parameters:  <none>
  Notes:       As it's not intended to modify .cld file the .cdl file is not
               opened in the AppBuilder. Template is also not opened
------------------------------------------------------------------------------*/
  /* Open standard files in the AppBuilder only if requested 
     Note here that there is 6 entries in the gcStdFiles extent but we skip first
     and last as first is the cld file and the last the template file
  */   
  DEFINE VARIABLE iCount          AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cFile           AS CHARACTER    NO-UNDO.
  
  
  DO iCount = 2 TO 5 ON ERROR UNDO, RETURN NO-APPLY:
    ASSIGN 
       cFile      = gcStdFiles[iCount] 
       .
    /* sanity check */
    IF cFile EQ "":U THEN NEXT.
             
    RUN adeuib/_open-w.p 
       (INPUT cFile , 
        INPUT "":U , 
        INPUT "OPEN":U).

  END. /* DO iCount = 1 TO ... */
                   
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE screenValidation fFrameWin 
PROCEDURE screenValidation :
/*------------------------------------------------------------------------------
  Purpose:     Main procedure for screen validation
               Calls other internal procedures:
               validateDirectory
               buildPaths
               buildFilesList
               validate<field-name>
               validateIsCLD
               validateIsTemplate
               
  Parameters:  <none>
  Notes:       Each of the internal procedure called here serves to check if
               values entered are correct.
               They all are build the same way. If the validation fails they return
               a character string "ERROR":U or the message to display.
               If they return nothing, the validation is ok.
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hField          AS HANDLE       NO-UNDO.
   DEFINE VARIABLE iCount          AS INTEGER      NO-UNDO.
   DEFINE VARIABLE cMessage        AS CHARACTER    NO-UNDO.
 
   /* Assign screen values */     
   ASSIGN FRAME {&FRAME-NAME}
           cDef cDerive cMeth 
           cName cProp  cPrto  
           cSuper cTemplate 
           cTemplateFrom 
           cSrc cRun cTpl
           .
   /* A class name is mandatory */
   IF NOT glNameChanged THEN DO WITH FRAME {&FRAME-NAME}:
      DYNAMIC-FUNCTION('backToPage1':U).
      MESSAGE "A class name must be supplied." VIEW-AS ALERT-BOX INFORMATION.
      APPLY "ENTRY":U TO cName.
      RETURN "ERROR":U.        
   END.   

   /* First we need to check paths: Source, Rcode, Template         
      gcPathList is based on the value of {&PATH-VALIDATION-LIST} */
   DO iCount = 1 TO NUM-ENTRIES(gcPathList):        
     ASSIGN hField = WIDGET-HANDLE(ENTRY(iCount,gcPathList)).
     RUN validateDirectory (INPUT hField:NAME, INPUT hField:LABEL, INPUT hField:SCREEN-VALUE).
     IF RETURN-VALUE EQ "ERROR":U THEN DO:
      DYNAMIC-FUNCTION('backToPage1':U).     
      APPLY "ENTRY":U TO hField.
      RETURN "ERROR":U.
     END.
   END. /* DO iCount */

   /* Build path variables */           
   RUN buildPaths.   
   
   /* We need to build the file list now in order to be able
      to check if files exist in the validation process */
   RUN buildFilesList.  
   
   /* Create the necessary custom subdirectory under the source
      and the rcode directory if not already exist */
   IF NOT DYNAMIC-FUNCTION('directoryExist':U, gcDosSrcCst) THEN DO:
    RUN createDir (gcDosSrcCst).
    IF RETURN-VALUE EQ "ERROR":U THEN RETURN "ERROR":U.
   END.
   IF NOT DYNAMIC-FUNCTION('directoryExist':U, gcDosRunCst) THEN DO:
    RUN createDir (gcDosRunCst).
    IF RETURN-VALUE EQ "ERROR":U THEN RETURN "ERROR":U.
   END.
   
   /* Check files value entered - 
      gcFileList is based on the value of {&FILE-VALIDATION-LIST} 
      Each field to validate has a internal procedure defined : validate<field-name> */
   DO iCount = 1 TO NUM-ENTRIES(gcFileList):        
     ASSIGN hField = WIDGET-HANDLE(ENTRY(iCount,gcFileList)).
     RUN VALUE("validate":U + hField:NAME).
     /* There is an error */
     IF RETURN-VALUE NE "":U THEN DO:
      cMessage = RETURN-VALUE.
      DYNAMIC-FUNCTION('backToPage1':U).     
      MESSAGE cMessage VIEW-AS ALERT-BOX INFORMATION.
      APPLY "ENTRY":U TO hField.
      RETURN "ERROR":U.
     END.
   END. /* DO iCount */

   /* if class derived from entered, make sure we are able to analyze the .cld */
   IF cDerive NE "":U THEN DO:
     RUN validateIsCLD.
     IF RETURN-VALUE EQ "ERROR":U THEN DO:
       DYNAMIC-FUNCTION('backToPage1':U).     
       APPLY "ENTRY":U TO cDerive IN FRAME {&FRAME-NAME}.       
       RETURN "ERROR":U.
     END.  
   END. /* IF cDerive NE "":U ... */
   
   /* if copy from template entered, make sure the file is a template */
   IF cTemplateFrom NE "":U THEN DO:
     RUN validateIsTemplate.        
     IF RETURN-VALUE EQ "ERROR":U THEN DO:
       DYNAMIC-FUNCTION('backToPage1':U).     
       APPLY "ENTRY":U TO cTemplateFrom IN FRAME {&FRAME-NAME}.       
       RETURN "ERROR":U.
     END.     
   END. /* IF cTemplateFrom NE "":U ... */
   
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showError fFrameWin 
PROCEDURE showError :
/*------------------------------------------------------------------------------
  Purpose:     Display an error message and return error
               The calling block must handle the error
  Parameters:  pcError : formatted error message
               
  Notes:       RETURN ERROR must be handled in the calling block
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcError          AS CHARACTER    NO-UNDO.

  MESSAGE pcError 
         VIEW-AS ALERT-BOX INFORMATION.
        
  RETURN ERROR.        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE statusDisplay fFrameWin 
PROCEDURE statusDisplay :
/*------------------------------------------------------------------------------
  Purpose:    Display status of what is generated in FRAME FrStatus 
  Parameters: pcLine1 AS CHAR, first status line
              pcLine2 AS CHAR, second status line
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcLine1        AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER pcLine2        AS CHARACTER    NO-UNDO.

  DISPLAY
    pcLine1 @ cStatus1
    pcLine2 @ cStatus2
    WITH FRAME FrStatus.
  RETURN.  
          
  DO WITH FRAME FrStatus:
    ASSIGN
     cStatus1:SCREEN-VALUE = pcLine1
     cStatus2:SCREEN-VALUE = pcLine2
     .
  END.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatecDef fFrameWin 
PROCEDURE validatecDef :
/*------------------------------------------------------------------------------
  Purpose:     Checks the value of the class definition file
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cPrefix                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cBaseName                 AS CHARACTER    NO-UNDO.
    
  IF cDef = "":U THEN RETURN "A class definition file must be supplied.".
  ELSE
  IF DYNAMIC-FUNCTION('Prefix':U, INPUT cDef) NE "":U THEN RETURN "A class definition file does not have a path.".
  ELSE
  IF NOT DYNAMIC-FUNCTION('correctExtension':U, INPUT cDef, INPUT gcStdExt[1]) THEN
    RETURN "The extension for a class definition must be " + gcStdExt[1].
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatecDerive fFrameWin 
PROCEDURE validatecDerive :
/*------------------------------------------------------------------------------
  Purpose:     Checks the value of derive from class
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF cDerive NE "":U THEN DO:
    IF NOT DYNAMIC-FUNCTION('correctExtension':U, INPUT cDerive, INPUT ".cld":U) THEN 
      RETURN "The extension for a class definition file is .cld".
    ELSE
    IF NOT DYNAMIC-FUNCTION('fileExist':U, INPUT cDerive) THEN 
      RETURN "File " + cDerive + " can't be found.".
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatecMeth fFrameWin 
PROCEDURE validatecMeth :
/*------------------------------------------------------------------------------
  Purpose:     Checks the value of the method library
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF cMeth = "":U THEN RETURN "A method library file must be supplied.".    
  ELSE
  IF DYNAMIC-FUNCTION('Prefix':U, INPUT cMeth) NE "":U THEN RETURN "Method library name must not contain a path.".
  ELSE
  IF NOT DYNAMIC-FUNCTION('correctExtension':U, INPUT cMeth, INPUT gcStdExt[2]) THEN
    RETURN "The extension for a method library must be " + gcStdExt[2].

  RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatecName fFrameWin 
PROCEDURE validatecName :
/*------------------------------------------------------------------------------
  Purpose:     Checks the value of the class name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF cName  = "":U THEN RETURN "A class name must be supplied.".
  ELSE
  IF DYNAMIC-FUNCTION('Prefix':U, INPUT cName) NE "":U THEN RETURN "A class name not have a path.".
  ELSE
  IF NOT DYNAMIC-FUNCTION('correctExtension':U,INPUT cName,"") THEN RETURN "A class name doesn't have an extension".
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatecProp fFrameWin 
PROCEDURE validatecProp :
/*------------------------------------------------------------------------------
  Purpose:     Checks the value of the property file
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF cProp = "":U THEN RETURN "A property file must be supplied.".    
  ELSE
  IF DYNAMIC-FUNCTION('Prefix':U, INPUT cProp) NE "":U THEN RETURN "Property file name must not contain a path.".
  ELSE
  IF NOT DYNAMIC-FUNCTION('correctExtension':U, INPUT cProp, INPUT gcStdExt[3]) THEN
    RETURN "The extension for a property file must be " + gcStdExt[3].

  RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatecPrto fFrameWin 
PROCEDURE validatecPrto :
/*------------------------------------------------------------------------------
  Purpose:     Checks the value of the prototype file
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF cPrto = "":U THEN RETURN "A prototype file must be supplied.".    
  ELSE
  IF DYNAMIC-FUNCTION('Prefix':U, INPUT cPrto) NE "":U THEN RETURN "Prototype file name must not contain a path.".
  ELSE
  IF NOT DYNAMIC-FUNCTION('correctExtension':U, INPUT cPrto, INPUT gcStdExt[5]) THEN
    RETURN "The extension for a property file must be " + gcStdExt[5].

  RETURN. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatecSuper fFrameWin 
PROCEDURE validatecSuper :
/*------------------------------------------------------------------------------
  Purpose:     Checks the value of the super procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF cSuper = "":U THEN RETURN "A super procedure file must be supplied.".    
  ELSE
  IF DYNAMIC-FUNCTION('Prefix':U, INPUT cSuper) NE "":U THEN RETURN "Super procedure file name must not contain a path.".
  ELSE
  IF NOT DYNAMIC-FUNCTION('correctExtension':U, INPUT cSuper, INPUT gcStdExt[4]) THEN
    RETURN "The extension for a super procedure must be " + gcStdExt[4].

  RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatecTemplate fFrameWin 
PROCEDURE validatecTemplate :
/*------------------------------------------------------------------------------
  Purpose:     Checks the value of the template name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF cTemplate EQ "":U AND cTemplateFrom NE "":U THEN RETURN "A template name is required.".

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatecTemplateFrom fFrameWin 
PROCEDURE validatecTemplateFrom :
/*------------------------------------------------------------------------------
  Purpose:     Checks the value of Copy from template
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF cTemplateFrom NE "":U THEN DO:
    IF NOT DYNAMIC-FUNCTION('fileExist':U, INPUT cTemplateFrom) THEN RETURN "Template " + cTemplateFrom + " can't be found.".
  END.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDirectory fFrameWin 
PROCEDURE validateDirectory :
/*------------------------------------------------------------------------------
  Purpose:     Check if directory typed exists, if not ask the user if he wants
               to create it
  Parameters:  pcDirName AS CHAR, actually it's the name of corresponding fields
               pcDirLabel AS CHAR, label of the directory to check (by default
               its the label)
               pcDir AS CHAR, directory typed
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcDirName  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcDirLabel AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcDir      AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lAnswer   AS LOGICAL  NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE lExist    AS LOGICAL  NO-UNDO.
    
  /* If the label is passed it may contains '&', so removes it */
  ASSIGN pcDirLabel = REPLACE(pcDirLabel, "&":U, "":U).
  
  /* if template dir is blank and no template file is referenced, 
     we dont need to check the template directory */
  IF pcDirName = "cTpl":U AND pcDir = "":U AND cTemplate EQ "":U THEN RETURN.
  
  /* Directory value is blank */
  IF pcDir = "":U THEN  DO:
    MESSAGE "The" pcDirLabel "can not be left blank." 
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ERROR":U.    
  END.
  ELSE DO:
    lExist = DYNAMIC-FUNCTION('directoryExist':U, INPUT pcDir).
    /* If lExist EQ ?, we have found something that is not a directory */
    IF lExist EQ ? THEN DO:
      MESSAGE "Invalid directory." 
              VIEW-AS ALERT-BOX INFORMATION.
      RETURN "ERROR":U.        
    END.
    /* If the directory not already exists, create it */
    IF NOT lExist THEN DO:
      MESSAGE "The" LC(pcDirLabel) pcDir "doesn't exist" SKIP
              "Do you want to create it?"
              VIEW-AS ALERT-BOX QUESTION
              BUTTONS YES-NO
              UPDATE lAnswer.    
      IF NOT lAnswer THEN RETURN "ERROR":U.
      RUN createDir (INPUT pcDir).
      IF RETURN-VALUE = "ERROR":U THEN RETURN "ERROR":U.
    END. /* Not Exist */
    /* If they try to write in DLC, give a warning */
    ELSE IF DYNAMIC-FUNCTION('isInDLC':U, INPUT pcDir) THEN DO:
      ASSIGN lAnswer = TRUE.
      MESSAGE "Directory" pcDir "is a subdirectory of DLC" SKIP
              "You shouldn't install code in the DLC directory." SKIP
              "However, do you want to create this directory" SKIP
              "under your current directory?"
          VIEW-AS ALERT-BOX WARNING
          BUTTONS YES-NO UPDATE lAnswer.
      IF lAnswer THEN DO:    
        RUN createDir (INPUT pcDir).
        IF RETURN-VALUE = "ERROR":U THEN RETURN "ERROR":U.  
      END.
     END. /* Not exist but is in DLC */    
  END. /* ELSE */
   
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateIsCLD fFrameWin 
PROCEDURE validateIsCLD :
/*------------------------------------------------------------------------------
  Purpose:     Analyze class definition file (.cld) refrenced for Derive From..
  Parameters:  <none>
  Notes:       Read the file and check if values read: source-path, 
               method library, property and template (if refrenced) 
               are valid files
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iColPos   AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cLine     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cSearch   AS CHARACTER    NO-UNDO.

  /* Initialize values */
  ASSIGN
    gcDeriveSrc  = "":U
    gcDeriveMeth = "":U
    gcDeriveProp = "":U
    .    

  INPUT FROM VALUE(cDerive) NO-ECHO.

  REPEAT:
    IMPORT UNFORMATTED cLine.
    ASSIGN cLine   = TRIM(cLine)
           iColPos = INDEX(cLine , ":":U)
           cSearch = SUBSTRING(cLine, 1, iColPos - 1)
           .
    CASE cSearch:       
        WHEN "Class SourcePath":U THEN
            ASSIGN gcDeriveSrc = LEFT-TRIM(SUBSTRING(cLine,iColPos + 1)). 
        WHEN "Class Method":U THEN
            ASSIGN gcDeriveMeth = LEFT-TRIM(SUBSTRING(cLine,iColPos + 1)). 
        WHEN "Class Property":U THEN
            ASSIGN gcDeriveProp = LEFT-TRIM(SUBSTRING(cLine,iColPos + 1)).                     
    END CASE.
  END. /* repeat import */

  INPUT CLOSE.

  /* Standard necessary information */
  IF gcDeriveMeth = "":U OR gcDeriveProp = "":U THEN DO:
    MESSAGE "Class file" cDerive "can't be analyzed." VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ERROR":U.
  END.  
  
  /* Assign values */
  ASSIGN
    gcDeriveSrc                 = RIGHT-TRIM(gcDeriveSrc, UNIX-SLASH) /* sanity check */
    gcDeriveMeth                = (IF gcDeriveSrc NE "":U THEN (gcDeriveSrc + UNIX-SLASH) ELSE "":U) + gcDeriveMeth
    gcDeriveProp                = (IF gcDeriveSrc NE "":U THEN (gcDeriveSrc + UNIX-SLASH) ELSE "":U) + gcDeriveProp
    .
  /* Files refrenced in the .cld file may not exist or be found
     check it */
  IF NOT DYNAMIC-FUNCTION('fileExist':U, INPUT gcDeriveMeth) THEN DO:
    MESSAGE "The method library" gcDeriveMeth SKIP
            "referenced in" cDerive "can't be found."
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ERROR":U.        
  END.     
  IF NOT DYNAMIC-FUNCTION('fileExist':U, INPUT gcDeriveProp) THEN DO:
    MESSAGE "The property file" gcDeriveProp SKIP
            "referenced in" cDerive "can't be found."
            VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ERROR":U.        
  END.     
  
    
  RETURN.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateIsTemplate fFrameWin 
PROCEDURE validateIsTemplate :
/*------------------------------------------------------------------------------
  Purpose:    Open silently the file in a hidden Editor Widget and check
              if the file is a template.
  Parameters:  <none>
  Notes:      We look at the procedure settings section of the file and look 
              at the Template keyword in the 'Type:' definition :
  /* &ANALYZE-SUSPEND _PROCEDURE-SETTINGS
    /* Settings for THIS-PROCEDURE
       Type: SmartDataViewer Template
       Allow: Basic,DB-Fields
       Frames: 1
       Add Fields to: Neither
       Other Settings: PERSISTENT-ONLY COMPILE
     */

    /* This procedure should always be RUN PERSISTENT.  Report the error,  */
    /* then cleanup and return.                                            */
    IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
      MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN.
    END.

    &ANALYZE-RESUME _END-PROCEDURE-SETTINGS */
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iStart    AS INTEGER      NO-UNDO.
  DEFINE VARIABLE iEnd      AS INTEGER      NO-UNDO.  
  DEFINE VARIABLE cInfo     AS CHARACTER    NO-UNDO. 
  DEFINE VARIABLE cErrorMsg AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lError    AS LOGICAL      NO-UNDO INITIAL FALSE.
  
  ASSIGN cErrorMsg = "File " + cTemplateFrom + " can't be analyzed.".
  
  ANALYZE-TEMPLATE:
  DO ON ERROR UNDO ANALYZE-TEMPLATE, RETURN "ERROR":U :
    /* Read the file */
    IF NOT hEditor:READ-FILE(cTemplateFrom) THEN 
      RUN showError (cErrorMsg).
    
    /* Get the offset of the beginning text we are looking for */
    IF NOT hEditor:SEARCH("&ANALYZE-SUSPEND _PROCEDURE-SETTINGS":U,FIND-SELECT) THEN
      RUN showError (cErrorMsg).
    istart = hEditor:SELECTION-START. 
  
    /* Get the offset of the ending text we are looking for */  
    IF NOT hEditor:SEARCH("&ANALYZE-RESUME _END-PROCEDURE-SETTINGS":U,FIND-SELECT) THEN
      RUN showError (cErrorMsg).        
    iend   = hEditor:SELECTION-START.  
  
    /* if we haven't found what we are looking for then ... */
    IF iStart = 0 OR iEnd = 0 THEN 
      RUN showError (cErrorMsg).

    /* Select entire text */
    IF NOT hEditor:SET-SELECTION(istart, iend) THEN 
      RUN showError (cErrorMsg).

  END. /* ANALYZE-TEMPLATE */
  
  ASSIGN
    cInfo  = hEditor:SELECTION-TEXT
    cInfo  = REPLACE(cInfo,"Type:":U, CHR(1))
    cInfo  = REPLACE(cInfo,"Allow:":U, CHR(1))
    cInfo  = ENTRY(2,cInfo, CHR(1)) /* narrow the string, by extracting what is in between Type: and Allow: */ 
    .  
    
  /* Note that there is a blank between '*' and the Template keyword
     It's to differentiate between real templates and object names that
     may contain the Template keyword */  
  IF NOT cInfo MATCHES "* Template*":U THEN DO:
    MESSAGE "File" cTemplateFrom "is not a template." VIEW-AS ALERT-BOX INFORMATION.
    RETURN "ERROR":U.
  END.    

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION backToPage1 fFrameWin 
FUNCTION backToPage1 RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Force the SmartDialog to switch to the page where the SmartFrame is 
        
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPage     AS INTEGER NO-UNDO.
  
  /* get the page where the SmartFrame is */
  ASSIGN iPage = DYNAMIC-FUNCTION('getObjectPage':U).
  
  /* Ask the container to switch to that page */
  RUN selectPage IN ghContainerDlg (iPage).
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION correctExtension fFrameWin 
FUNCTION correctExtension RETURNS LOGICAL
  ( INPUT pcFile    AS CHARACTER, INPUT pcRightExtension AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Verifies that the extension of a file is correct
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cExtension AS CHARACTER    NO-UNDO.
      
  /* get file extension */
  RUN adecomm/_osfext.p (INPUT pcFile, OUTPUT cExtension).
  
  RETURN pcRightExtension = cExtension.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createCustomNames fFrameWin 
FUNCTION createCustomNames RETURNS CHARACTER
  ( INPUT pcSuffix  AS CHAR, INPUT pcFileName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Creates custom names. Extracts from the base name the name
            without the extension, adds the suffix and then adds the extension 
            back to the new name
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBase         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cExtension    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cName         AS CHARACTER    NO-UNDO.
  
  ASSIGN
    cBase      = TRIM(SUBSTRING (pcFileName, 1, INDEX (pcFileName , '.':U) - 1))
    cExtension = TRIM(SUBSTRING (pcFileName, INDEX (pcFileName , '.':U)))
    cName      = cBase + pcSuffix + cExtension
    .
      
  RETURN cName.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION directoryExist fFrameWin 
FUNCTION directoryExist RETURNS LOGICAL
  ( pcName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Verifies that a directory exists
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN
    FILE-INFO:FILE-NAME = pcName.
    
  /* Does the file exist ? */
  IF FILE-INFO:FULL-PATHNAME = ? THEN RETURN FALSE.
  
  /* Is it a D as expected */
  IF NOT FILE-INFO:FILE-TYPE BEGINS "D":U THEN RETURN ?.    
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION errorGenerationMsg fFrameWin 
FUNCTION errorGenerationMsg RETURNS CHARACTER
  ( INPUT pcFileType AS CHAR, INPUT pcFile AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Generates a standard generation error message with file type and 
            file name
    Notes:  
 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReturnMsg    AS CHARACTER    NO-UNDO.
  
  ASSIGN cReturnMsg = "Generation of " + pcFileType + " " + pcFile + " failed..." + 
                      CHR(10) + "Process interrupted".
                      
  RETURN cReturnMsg.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fileExist fFrameWin 
FUNCTION fileExist RETURNS LOGICAL
  ( pcName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Verifies that a file exists
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN
    FILE-INFO:FILE-NAME = pcName.
    
  /* Does the file exist ? */
  IF FILE-INFO:FULL-PATHNAME = ? THEN RETURN FALSE.

  /* Is it a F as expected */
  IF NOT FILE-INFO:FILE-TYPE BEGINS "F":U THEN RETURN FALSE.
    
  RETURN TRUE.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isInDLC fFrameWin 
FUNCTION isInDLC RETURNS LOGICAL
  ( INPUT pcDir AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Checks if the directory or subdirectory is in the DLC path 
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN
    FILE-INFO:FILE-NAME = pcDir.

  /* Is it a D or a F as expected */
  IF FILE-INFO:FULL-PATHNAME BEGINS gcDLC THEN RETURN TRUE.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Prefix fFrameWin 
FUNCTION Prefix RETURNS CHARACTER
  ( INPUT pcFile AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the prefix (path referenced) of a file
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPrefix       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cBaseName     AS CHARACTER    NO-UNDO.
    
  RUN adecomm/_osprefx.p (INPUT pcFile, OUTPUT cPrefix, OUTPUT cBaseName).

  RETURN cPrefix.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareDosPath fFrameWin 
FUNCTION prepareDosPath RETURNS CHARACTER
  ( INPUT pcPath AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Make a dos path, add or remove a DOS-SLASH at the end
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCorrectPath     AS CHARACTER    NO-UNDO.
  
  ASSIGN
    cCorrectPath = RIGHT-TRIM(pcPath)
    cCorrectPath = REPLACE(pcPath, UNIX-SLASH, DOS-SLASH)
    .
  /* They have entered a drive letter this way D:,
     add a dos-slash to avoid any confusion */  
  IF LENGTH(cCorrectPath,"CHARACTER":U) = 2 AND INDEX(cCorrectPath, ":":U) EQ 2 THEN 
    ASSIGN cCorrectPath = cCorrectPath + DOS-SLASH.
  
  RETURN cCorrectPath.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION RelativePath fFrameWin 
FUNCTION RelativePath RETURNS CHARACTER
  ( INPUT pcPath AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Make a path relative to the PROPATH
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cReturnPath   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cTmp          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER      NO-UNDO.
    
  ASSIGN
    FILE-INFO:FILE-NAME = pcPath
    pcPath              = FILE-INFO:FULL-PATHNAME
    cReturnPath         = pcPath
    .


  DO iEntry = 1 TO NUM-ENTRIES(PROPATH):
    ASSIGN
      cTmp = ENTRY(iEntry, PROPATH)
      FILE-INFO:FILE-NAME = cTmp
      .
      
    IF pcPath BEGINS FILE-INFO:FULL-PATHNAME THEN DO:
        cTmp = REPLACE(pcPath, FILE-INFO:FULL-PATHNAME, "":U).
        IF LENGTH(cTmp, "CHARACTER":U) < LENGTH(cReturnPath, "CHARACTER":U) THEN
            cReturnPath = cTmp.
    END. 
  END.

  ASSIGN
    cReturnPath  = LEFT-TRIM(cReturnPath, DOS-SLASH)
    .
    
  IF cReturnPath = "":U THEN
    cReturnPath = ".":U.
    
  RETURN cReturnPath.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setReplace fFrameWin 
FUNCTION setReplace RETURNS LOGICAL
  ( INPUT plReplace AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Set Open property which indicate whether or not files should be
            replaced during the generation process
    Notes:  Called from _clasnew.w
------------------------------------------------------------------------------*/
  glReplace = plReplace.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION unixPath fFrameWin 
FUNCTION unixPath RETURNS CHARACTER
  ( INPUT pcDosPath AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Make a unix relative path (to the PROPATH) based on a full dos path
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUnixPath     AS CHARACTER    NO-UNDO.
  
  ASSIGN
    cUnixPath = DYNAMIC-FUNCTION('RelativePath':U, INPUT pcDosPath)
    cUnixPath = RIGHT-TRIM(REPLACE(cUnixPath, DOS-SLASH, UNIX-SLASH), UNIX-SLASH)
    cUnixPath = cUnixPath + UNIX-SLASH
    .
  
  RETURN cUnixPath.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

