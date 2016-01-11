&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame
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

Procedure:    adetran/pm/_extract.w
Author:       R. Ryan
Created:      2/95
Updated:      7/97 SLK Bug# 97-04-30-022 Cannot find file if . used
Purpose:      Dialog box for creating a string-XREF file then load that
              file into XL_STRING_INFO and XL_INSTANCE tables
Background:   The extract routine allows the project manager to extract
              strings from the procedures in the XL_Procedure table then
              load those strings into project tables.  Some choices:

                1. The load phase can be skipped and just the extract made
                    - Normally, all procedures in XL_Procedure will be used
                    - 'Marked' procedures mean that some procedures have
                      been identified by the 'Scan' routine in the procedures
                      tab as XL_Procedure.NeedsExtracting.  Typically, scanned
                      procedures are procedures that have a newer file date in the
                      file header and/or procedures that have been added.
                    - The compiler's string XREF outputs all strings that do not
                      have the string attribute ":U" or null string "".
                2. The extract phase can be skipped and just a load from
                   an existing xref file can be made (assuming the xref file
                   is string around).

                     - The load phase implies filtering the xref against
                       the include/exclude filters that are stored in
                       XL_SelectedFilters (include) and XL_CustomFilter
                       (exclude).

Notes:        This is a complex procedure that reads the string-xref file, then
              does the following:

               It then looks at the combination of string and string attributes
                   and decides if this is:

                     a. a new string (if so, it builds a XL_STRING_INFO records and
                        a corresponding XL_INSTANCE record)
                     b. an existing string but a new instance (if so, it builds a
                        new XL_INSTANCE record).
                     c. an existing string and an update to an existing instance.

Procedures:   Key procedures include:

                 IncludeThis      as a record is being read, it looks at the
                                  XL_SelectedFilters table, and prepares to loads those
                                  records which match.  But first, it looks at...
                 ExcludeThis      as a record is being read, and it has already passed
                                  the 'IncludeThis' test, the XL_CustomFilter table
                                  is read.  If a match is made, that record is rejected,
                                  otherwise it is loaded.
*/




{adetran/pm/tranhelp.i}
define output parameter pOKPressed as logical no-undo.
define input-output parameter pXREFFileName as char no-undo.
define input-output parameter pXREFType as char no-undo.
define input-output parameter pDeleteXREF as logical no-undo.

define shared var _MainWindow as widget-handle no-undo.
define shared var _hMeter as handle no-undo.
define shared var _hTrans as handle no-undo.
define shared var CurrentMode as integer no-undo.
define shared var StopProcessing as logical no-undo.
define shared var ProjectDB as char no-undo.
define shared var _ExtractWarnings as logical no-undo.

/* Temporary files generated by _sort.w and _order.w.                */
/* If these are blank then the regular OpenQuery internal procedures */
/* are run, otherwise these will be run                              */
DEFINE SHARED VARIABLE TmpFl_PM_Ss          AS CHARACTER                NO-UNDO.
{adetran/pm/vsubset.i &NEW=" " &SHARED="SHARED"}
/* NOTE that the BUFFERs and QUERY are defined as NEW SHARED
 * because they are defined as SHARED in common/_sort.w
 */
DEFINE NEW SHARED BUFFER ThisSubsetList         FOR bSubsetList.
DEFINE NEW SHARED QUERY  ThisSubsetList         FOR ThisSubsetList SCROLLING.

define stream XREFStream.

define var ThisMessage as char no-undo.
define var ErrorStatus as logical no-undo.
define var InputLine as char extent 9.
define var FoundIt as logical no-undo.
define var NextInstance as integer no-undo.
define var NextString as integer no-undo.
define var TimeDateStamp as decimal no-undo.
define var FileSize as int.
define var TotalStrings as int.
define var IncludedStrings as int.
define var Result as logical no-undo.
define var i as integer no-undo.

DEFINE VARIABLE cOrigTitle       AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ShortHeight      AS DECIMAL                        NO-UNDO.
DEFINE VARIABLE FullHeight       AS DECIMAL                        NO-UNDO.
DEFINE VARIABLE OptionState      AS LOGICAL INITIAL TRUE           NO-UNDO.
DEFINE VARIABLE hSubset          AS HANDLE                         NO-UNDO.

DEFINE VARIABLE lCase         AS LOGICAL            NO-UNDO.
DEFINE VARIABLE cLine         AS CHARACTER          NO-UNDO CASE-SENSITIVE.
DEFINE VARIABLE cFilt         AS CHARACTER          NO-UNDO CASE-SENSITIVE.

&SCOPED-DEFINE XREF-VER 4.0

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnOK XREFFileName BtnFile BtnCancel ~
XREFType BtnHelp BtnOptions LoadAfterExtract pUseFilters DeleteXREF ~
XREFLabel LoadLabel RECT-1 RECT-2
&Scoped-Define DISPLAYED-OBJECTS XREFFileName XREFType LoadAfterExtract ~
pUseFilters DeleteXREF XREFLabel LoadLabel

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY DEFAULT
     LABEL "Cancel":L
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnFile
     LABEL "&Files...":L
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnHelp
     LABEL "&Help":L
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOK AUTO-GO
     LABEL "OK":L
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOptions
     LABEL "&Options >>":L
     SIZE 15 BY 1.14.

DEFINE VARIABLE LoadLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Load Options"
      VIEW-AS TEXT
     SIZE 13.6 BY .67 NO-UNDO.

DEFINE VARIABLE XREFFileName AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE XREFLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Extract Options"
      VIEW-AS TEXT
     SIZE 16.6 BY .67 NO-UNDO.

DEFINE VARIABLE XREFType AS CHARACTER
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS
          "Extract Phrases from &All Procedures", "A":U,
"Extract Phrases from &Marked Procedures", "M":U
     SIZE 69 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 73 BY 3.67.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 72 BY 3.33.

DEFINE VARIABLE DeleteXREF AS LOGICAL INITIAL no
     LABEL "&Delete XREF When Load Complete":L
     VIEW-AS TOGGLE-BOX
     SIZE 63 BY .67 NO-UNDO.

DEFINE VARIABLE LoadAfterExtract AS LOGICAL INITIAL no
     LABEL "&Load immediately after Extract":L
     VIEW-AS TOGGLE-BOX
     SIZE 67 BY .67 NO-UNDO.

DEFINE VARIABLE pUseFilters AS LOGICAL INITIAL yes
     LABEL "&Use Filters":L
     VIEW-AS TOGGLE-BOX
     SIZE 63 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BtnOK AT ROW 1.48 COL 76
     XREFFileName AT ROW 2.19 COL 5 NO-LABEL
     BtnFile AT ROW 2.19 COL 58
     BtnCancel AT ROW 2.76 COL 76
     XREFType AT ROW 3.38 COL 5 NO-LABEL
     BtnHelp AT ROW 4.05 COL 76
     BtnOptions AT ROW 5.29 COL 76
     LoadAfterExtract AT ROW 7.19 COL 5
     pUseFilters AT ROW 8.38 COL 8
     DeleteXREF AT ROW 9.1 COL 8
     XREFLabel AT ROW 1.24 COL 4.4 NO-LABEL
     LoadLabel AT ROW 6.48 COL 4.4 NO-LABEL
     RECT-1 AT ROW 1.48 COL 2
     RECT-2 AT ROW 6.71 COL 2
     SPACE(22.19) SKIP(0.24)
    WITH VIEW-AS DIALOG-BOX
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         FONT 4
         TITLE "Extract"
         ROW 2 COLUMN 3
         DEFAULT-BUTTON BtnOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN LoadLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN XREFFileName IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN XREFLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Extract */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFile Dialog-Frame
ON CHOOSE OF BtnFile IN FRAME Dialog-Frame /* Files... */
DO:
  define var OKPressed as logical no-undo.

  SYSTEM-DIALOG GET-FILE XREFFileName
     TITLE      "XREF Files"
     FILTERS    "XREF (*.xrf)" "*.xrf":u,
                "All Files (*.*)"       "*.*":u
     USE-FILENAME
     UPDATE OKpressed.

  IF OKpressed = TRUE THEN
    XREFFileName:screen-value = XREFFileName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Dialog-Frame
ON CHOOSE OF BtnHelp IN FRAME Dialog-Frame /* Help */
OR help of frame {&frame-name} do:
  run adecomm/_adehelp.p ("tran":u,"context":u,{&extract_dialog_box}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK Dialog-Frame
ON CHOOSE OF BtnOK IN FRAME Dialog-Frame /* OK */
DO:
  DEFINE VAR err-num    AS INTEGER                   NO-UNDO.
  define var Justify    as integer INITIAL 0         NO-UNDO.
  define var NumProcs   as INTEGER                   NO-UNDO.
  define var PctTaken   as decimal format ">>9.9%":u NO-UNDO.
  DEFINE VAR real-err   AS LOGICAL                   NO-UNDO.
  DEFINE VAR subst-line AS CHARACTER                 NO-UNDO.
  define var ThisFile   as char                      NO-UNDO.
  define var ThisProc   as char                      NO-UNDO.

  IF VALID-HANDLE(hSubset) THEN
  DO:
     IF lSubset THEN
     DO:
        /* Set to FALSE all NeedsExtracting */
        FOR EACH bFileList WHERE bFileList.Project = ProjectDB
                             AND bFileList.OrigNeedsExtracting:
           FIND FIRST xlatedb.XL_Procedure
             WHERE xlatedb.XL_Procedure.Directory = bFilelist.Directory
               AND xlatedb.XL_Procedure.FileName  = bFilelist.FileName
             EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE xlatedb.XL_Procedure THEN
             ASSIGN xlatedb.XL_Procedure.NeedsExtracting = FALSE.
        END.

        FOR EACH ThisSubsetList WHERE ThisSubsetList.Project = ProjectDB
                                  AND ThisSubsetList.Active  = TRUE NO-LOCK:
           IF ThisSubsetList.FileName = cAllFiles THEN
           DO:
              FOR EACH xlatedb.XL_Procedure WHERE
                 xlatedb.XL_Procedure.Directory = ThisSubsetList.Directory
              EXCLUSIVE-LOCK:
                 xlatedb.XL_Procedure.NeedsExtracting = TRUE.
              END.
           END.
           ELSE /* All Files */
           DO:
              FIND FIRST xlatedb.XL_Procedure WHERE
                     xlatedb.XL_Procedure.FileName  = ThisSubsetList.FileName
                 AND xlatedb.XL_Procedure.Directory = ThisSubsetList.Directory
              EXCLUSIVE-LOCK NO-ERROR.
              IF AVAILABLE xlatedb.XL_Procedure THEN
                 xlatedb.XL_Procedure.NeedsExtracting = TRUE.
           END. /* Single file */
         END. /* For each ThisSubsetList */
     END.
  END.

  if XREFFileName:screen-value = "" then do:

     ThisMessage = "You must enter a XREF filename.".
     run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage).
     apply "entry":u to XREFFileName.
     return no-apply.
  end.

  /*
  ** Ok, there must a filename.  Is it valid?
  */
  apply "leave":u to XREFFileName in frame {&frame-name}.

  /*
  ** warn the user about the need to connect to databases
  */
  ASSIGN ThisMessage = "Note: Before continuing, you must be connected to all " +
                       "databases which your application uses. Continue?"
         ErrorStatus = yes.
  run adecomm/_s-alert.p (input-output ErrorStatus, "q":u,"yes-no":u, ThisMessage).

  if not ErrorStatus then return no-apply.

  /* Used to check filters */
  IF LoadAfterExtract:CHECKED AND pUseFilters:CHECKED THEN
  DO:
      {adetran/pm/ckfilter.i}
  END.

  /*
  ** All the checks are done, ready to extract
  */
  assign
    pOKPressed          = true
    XREFFileName        = XREFFileName:screen-value
    pXREFFileName       = XREFFileName
    pXREFType           = XREFType:screen-value.

  /*
  ** Extract
  */
  find first xlatedb.XL_Project no-lock no-error.
  assign NumProcs       = xlatedb.XL_Project.NumberOfProcedures
         StopProcessing = false
         sAppDir        = xlatedb.XL_Project.ApplDirectory.

  file-info:filename = XREFFileName.
  if file-info:full-pathname <> ? then
    os-delete value(file-info:full-pathname) no-error.
  frame {&frame-name}:hidden = true.
  run Realize in _hMeter ("Extracting...").
  i = 0.

  for each xlatedb.XL_Procedure exclusive-lock where
    xlatedb.XL_Procedure.FileName <> ? and
      (if pXREFType = "M":u or lsubset then
        xlatedb.XL_Procedure.NeedsExtracting
      else true):

    process events.
    if StopProcessing then do:
      run HideMe in _hMeter.
      return.
    end.

    i = i + 1.
    ThisFile = IF xlatedb.XL_Procedure.Directory = ".":U THEN "":U
               ELSE xlatedb.XL_Procedure.Directory.
    run adecomm/_osfmush.p
        (input  ThisFile, input xlatedb.XL_Procedure.FileName,
         output ThisFile).
    file-info:filename = ThisFile.

    if file-info:full-pathname = ? or file-info:full-pathname = "" then do:

      IF (NOT _ExtractWarnings) AND
         (NOT LoadAfterExtract:CHECKED) THEN
      DO:
         ThisMessage = ThisFile +
            "^Cannot find this file. Do you want to delete it from the list of procedures?".
         run adecomm/_s-alert.p (input-output ErrorStatus, "q*":u,"yes-no-cancel":u, ThisMessage).
         if ErrorStatus then delete xlatedb.XL_Procedure.
         ELSE IF ErrorStatus = ? THEN
         DO:
           RUN HideMe in _hMeter.
           RETURN.
         END.
      END. /* NOT extractWarnings */
      ELSE
      DO:
           RUN HideMe in _hMeter.
           RETURN.
      END. /* extract Warnings suppressed */
    end.
    else do:
      run SetBar in _hMeter (NumProcs, MAX(0, i - 1), ThisFile).
      xlatedb.XL_Procedure.NeedsExtracting = false.
      compile value(ThisFile) string-xref value(XREFFileName) append NO-ERROR.
      if compiler:error
         AND (NOT _ExtractWarnings)
         AND (NOT LoadAfterExtract:CHECKED) then do:

        ASSIGN real-err = FALSE.
        DO err-num = 1 TO ERROR-STATUS:num-messages:
          IF ERROR-STATUS:GET-NUMBER(err-num) NE 2884 AND
             ERROR-STATUS:GET-NUMBER(err-num) NE 4345 AND
             ERROR-STATUS:GET-NUMBER(err-num) NE 6430
             THEN real-err = TRUE.
        END.
        IF NOT real-err THEN NEXT.  /* Skip error processing for warnings 2884,4345 and 643and 0*/
        RUN adecomm/_errmsgs.p (INPUT ACTIVE-WINDOW, INPUT compiler:file-name, INPUT "$$":U ).
        assign ThisMessage = ThisFile + "^^Could not be compiled successfully which may " +
                             "result in an incomplete extract. Continue?"
               ErrorStatus = false.
        run adecomm/_s-alert.p (input-output ErrorStatus, "q*":u,"ok-cancel":u, ThisMessage).
        if ErrorStatus = ? then do:
          run HideMe in _hMeter.
          return.
        end.
      end. /* If compiler:error */
    end.
  end.  /* for each loop */
  run HideMe in _hMeter.

  if i = 0 then do:
    ThisMessage = "No marked procedures were found.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u,"ok":u, ThisMessage).
    frame {&frame-name}:hidden = false.
    return no-apply.
  end.

  IF (NOT _ExtractWarnings)
     AND (NOT LoadAfterExtract:CHECKED) THEN
  MESSAGE "Extracted strings are in the file:  " + XREFFileName VIEW-AS ALERT-BOX INFORMATION.

  IF LoadAfterExtract:CHECKED THEN
  RUN LoadStr (INPUT XREFFileName:SCREEN-VALUE,
               INPUT pUseFilters:CHECKED,
               INPUT DeleteXREF:CHECKED).
  IF VALID-HANDLE(hSubset) THEN
  APPLY "CLOSE":U TO hSubset.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOptions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOptions Dialog-Frame
ON CHOOSE OF BtnOptions IN FRAME Dialog-Frame /* Options >> */
DO:
   IF OptionState THEN
   DO:
      run adecomm/_setcurs.p("wait":U).

      /* Set the Option state and display the full dialog */
      FRAME {&FRAME-NAME}:HEIGHT = FullHeight.
      ASSIGN
         RECT-2:HIDDEN               = FALSE
         LoadLabel:HIDDEN            = FALSE
         LoadAfterExtract:HIDDEN     = FALSE
         pUseFilters:HIDDEN          = FALSE
         DeleteXREF:HIDDEN           = FALSE
         pUseFilters:SENSITIVE       = LoadAfterExtract:CHECKED
         DeleteXREF:SENSITIVE        = LoadAfterExtract:CHECKED
         OptionState                 = NOT OptionState
         BtnOptions:LABEL            = "<< &Options".

      DISPLAY LoadLabel WITH FRAME Dialog-Frame.
      RUN VALUE("adetran/pm/_subset.w") PERSISTENT SET hSubset
               (  INPUT FRAME Dialog-Frame:HANDLE
                , INPUT THIS-PROCEDURE
                ).

      run adecomm/_setcurs.p("":U).

      APPLY "ENTRY":U TO LoadAfterExtract.
   END. /* OptionState */
   ELSE
   DO:
      ASSIGN
         RECT-2:HIDDEN               = TRUE
         LoadLabel:HIDDEN            = TRUE
         LoadAfterExtract:HIDDEN     = TRUE
         pUseFilters:HIDDEN          = TRUE
         DeleteXREF:HIDDEN           = TRUE
         OptionState                 = NOT OptionState
         BtnOptions:LABEL            = "&Options >>".
      RUN shrinkDialog.
      APPLY "ENTRY":U TO XREFFileName.
   END. /* NOT OptionState */
END. /* CHOOSE OF BtnOptions */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME XREFType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL XREFType Dialog-Frame
ON VALUE-CHANGED OF XREFType IN FRAME Dialog-Frame /* Extract All/Marked */
DO:
/* *** NO!!! Once you establish a subset, it is independent of everthing...
   ASSIGN
      lSubset = IF XREFType:SCREEN-VALUE = "M":U THEN YES
                ELSE                                  NO.
***** */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME LoadAfterExtract
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LoadAfterExtract Dialog-Frame
ON VALUE-CHANGED OF LoadAfterExtract IN FRAME Dialog-Frame /* Load immediately after Extract */
DO:
   ASSIGN
      pUseFilters:SENSITIVE    = LoadAfterExtract:CHECKED
      DeleteXREF:SENSITIVE    = LoadAfterExtract:CHECKED.
   IF NOT LoadAfterExtract:CHECKED THEN
   ASSIGN
      pUseFilters:CHECKED      = TRUE
      DeleteXREF:CHECKED      = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME XREFFileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL XREFFileName Dialog-Frame
ON LEAVE OF XREFFileName IN FRAME Dialog-Frame
DO:
  if self:screen-value = "" then return.

  define var TestName as char no-undo.
  define var DirName as char no-undo.
  define var BaseName as char no-undo.
  run adecomm/_osprefx.p (XREFFileName:screen-value,output DirName, output BaseName).
  /* 11/96 Modified for long filenames */
  if length(BaseName,"RAW":u) > 255 then do:
    ThisMessage = XREFFileName:screen-value + "^This filename is not valid.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage).
    XREFFileName:auto-zap = true.
    apply "entry":u to XREFFileName in frame Dialog-frame.
    return no-apply.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN
ASSIGN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW
       CURRENT-WINDOW = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   /*
   ** provide a default XREF filename
   */
   assign
     THIS-PROCEDURE:PRIVATE-DATA     = "EXTRACT":U
     cOrigTitle                      = FRAME {&FRAME-NAME}:TITLE
     XrefLabel:screen-value          = "Extract Options"
     XrefLabel:width                 = font-table:get-text-width-chars (trim(XrefLabel:screen-value),4)
     XREFFileName:screen-value       = if pXREFFileName <> "" and pXREFFileName <> ? then pXREFFileName
                                       else ldbname("xlatedb":u) + ".xrf":u
     XREFType:screen-value           = pXrefType.

/* *** NO! Once you establish a subset, it is independent of everything...
  ASSIGN
      lSubset = IF XREFType:SCREEN-VALUE = "M":U THEN YES
                ELSE                                  NO.
****** */
  IF lSubset THEN RUN assignTitle.

  RUN Realize.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} focus XREFFileName.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIBe-CODE-BLOCK _PROCEDURE assignTitle DIALOG-1
PROCEDURE assignTitle :
   ASSIGN FRAME {&FRAME-NAME}:TITLE = IF lSubset THEN cOrigTitle + cSubset
                                      ELSE cOrigTitle.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIBe-CODE-BLOCK _PROCEDURE crUpdDirFileList DIALOG-1
PROCEDURE crUpdDirFileList :
   FOR EACH xlatedb.XL_Procedure BREAK BY xlatedb.XL_Procedure.Directory:
      IF FIRST-OF (xlatedb.XL_Procedure.Directory) THEN
      DO:
         FIND FIRST bSubsetList
            WHERE bSubsetList.Project   = ProjectDB
              AND bSubsetList.Directory = xlatedb.XL_Procedure.Directory
              AND bSubsetList.FileName  = cAllFiles
            NO-LOCK NO-ERROR.
         IF NOT AVAILABLE bSubsetList OR NOT bSubsetList.Active THEN
         DO:
            FIND FIRST bDirList
               WHERE bDirList.Project   = ProjectDB
                 AND bDirList.Directory = xlatedb.XL_Procedure.Directory
               NO-LOCK NO-ERROR.
            IF NOT AVAILABLE bDirList THEN
            DO:
               CREATE bDirList.
               ASSIGN bDirList.Project   = ProjectDB
                      bDirList.Directory = xlatedb.XL_Procedure.Directory.
            END.
            ASSIGN bDirList.Active = TRUE.
         END.
      END.

      FIND FIRST bFileList
         WHERE bFileList.Project   = ProjectDB
           AND bFileList.Directory = xlatedb.XL_Procedure.Directory
           AND bFileList.FileName  = xlatedb.XL_Procedure.FileName
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE bFileList THEN
      DO:
         CREATE bFileList.
         ASSIGN bFileList.Project   = ProjectDB
                bFileList.Directory = xlatedb.XL_Procedure.Directory
                bFileList.FileName  = xlatedb.XL_Procedure.FileName.
      END.
      /* If there is already an active subset listing for the individual file
       * or for the complete directory, then set the filename to not active */
      FIND FIRST bSubsetList
         WHERE bSubsetList.Project   = ProjectDB
           AND bSubsetList.Directory = bFileList.Directory
           AND bSubsetList.Active    = yes
           AND (bSubsetList.FileName = cAllFiles OR
                bsubsetList.FileName = xlatedb.XL_Procedure.FileName)
         NO-LOCK NO-ERROR.
      ASSIGN bFileList.Active = NOT AVAILABLE bSubsetList.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE crUpdSubsetList DIALOG-1
PROCEDURE crUpdSubsetList :
 /* ***********
  * No need to do this. The subset list should initially be empty;
  * The user maintains the subset list manually during the session.
  * When the session ends, the current subset list is stored in the
  * database.  When the project database is reopened, we populate
  * the subset list temp-table with the saved values.  (tomn 10/99)

  IF NOT CAN-FIND(FIRST ThisSubsetList
                  WHERE ThisSubsetList.Project = ProjectDB) THEN
  DO:
    FOR EACH xlatedb.XL_Procedure:
      FIND FIRST ThisSubsetList
        WHERE ThisSubsetList.Project   = ProjectDB
          AND ThisSubsetList.Directory = xlatedb.XL_Procedure.Directory
          AND ThisSubsetList.FileName  = xlatedb.XL_Procedure.FileName
         NO-LOCK NO-ERROR.
       IF NOT AVAILABLE ThisSubsetList THEN
       DO:
          CREATE ThisSubsetList.
          ASSIGN ThisSubsetList.Project   = ProjectDB
                 ThisSubsetList.Directory = xlatedb.XL_Procedure.Directory
                 ThisSubsetList.FileName  = xlatedb.XL_Procedure.FileName.
       END.
       ASSIGN ThisSubsetList.Active = TRUE.
    END.
  END.
*********** */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enlargeDialog Dialog-Frame
PROCEDURE enlargeDialog :
DEFINE INPUT PARAMETER  p-iExtraHeight    AS INTEGER        NO-UNDO.
   DEFINE INPUT PARAMETER  p-iExtraWidth     AS INTEGER        NO-UNDO.
   DEFINE OUTPUT PARAMETER p-iRow            AS INTEGER        NO-UNDO.
   DEFINE OUTPUT PARAMETER p-iColumn         AS INTEGER        NO-UNDO.

   /* Since the subset frame will be a child to procedure's frame,
    *    p-iRow should be
    *    p-iColumn should be 1
    */
   ASSIGN
      p-iRow                       = FRAME Dialog-Frame:HEIGHT-CHARS - 0.1
      p-iColumn                    = 1
      FRAME Dialog-Frame:HEIGHT-CHARS  = FRAME Dialog-Frame:HEIGHT-CHARS +
                                     p-iExtraHeight + .5
      FRAME Dialog-Frame:WIDTH-CHARS   = 1 +
         MAX(FRAME Dialog-Frame:WIDTH-CHARS, p-iExtraWidth).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize Dialog-Frame
PROCEDURE Realize :
ASSIGN ShortHeight = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS.

enable
    XREFFileName
    BtnFile
    XREFType
    BtnOK
    BtnCancel
    BtnHelp
    BtnOptions
    RECT-2
    LoadLabel
    LoadAfterExtract
    pUseFilters
    DeleteXREF
  with frame {&frame-name}.

  ASSIGN FullHeight = FRAME {&FRAME-NAME}:HEIGHT.

  ASSIGN
         RECT-2:HIDDEN               = TRUE
         LoadLabel:HIDDEN            = TRUE
         LoadAfterExtract:HIDDEN     = TRUE
         pUseFilters:HIDDEN           = TRUE
         pUseFilters:CHECKED          = TRUE
         DeleteXREF:HIDDEN           = TRUE
         OptionState                 = TRUE
         BtnOptions:LABEL            = "&Options >>"
         FRAME {&FRAME-NAME}:HEIGHT  = BtnOptions:ROW + BtnOptions:HEIGHT + 0.6.

  ASSIGN FRAME {&FRAME-NAME}:HIDDEN = FALSE.
  ASSIGN ShortHeight = FRAME {&FRAME-NAME}:HEIGHT.
  run adecomm/_setcurs.p ("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE shrinkDialog Dialog-Frame
PROCEDURE shrinkDialog :
   IF VALID-HANDLE(hSubset) THEN
   RUN disable_UI IN hSubset.  /* This will delete the persistent proc instance */
   ASSIGN FRAME Dialog-Frame:HEIGHT-CHARS    = ShortHeight.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{adetran/pm/loadstr.i}