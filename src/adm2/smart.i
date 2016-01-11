&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
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
    Library     : smart.i - NEW V9 version of top-level SmartObject include

    Modified    : May 22, 2000 -- Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .i file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  /* If smart.i has already been included, skip everything 
      (matching ENDIF is at the end of the file). */
&IF DEFINED(adm-smart) = 0 &THEN
  &GLOB adm-smart yes
  
  /* Define the preprocessor that identifies the basic "class" of the object;
     ADMClass will remain undefined here only if the object uses no sub-class
     include files. */
  &IF "{&ADMClass}":U = "":U &THEN
    &GLOB ADMClass smart
  &ENDIF

 DEFINE VARIABLE ghContainer    AS HANDLE NO-UNDO.  /* Window or Frame handle */

  /* If this object is of type "smart", i.e., uses no lower class include
     files, then include the property file here. Otherwise this will be
     done in the class include file of the base class of the object. */

&IF "{&ADMClass}":U = "smart":U &THEN
  {src/adm2/smrtprop.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 5.24
         WIDTH              = 52.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */
  DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iStart      AS INTEGER    NO-UNDO.

  RUN start-super-proc ("adm2/smart.p":U).
  
  /* Use the old adm definition */
  IF NOT {&ADM-PROPS-DEFINED} THEN
  DO:
    /* Now create the one record in this property temp-table, and store its
       handle in ADM-DATA. The CHR(1) delimiters are to set aside spots
       for UserProperties and UserLinks. */
    ghADMProps:TEMP-TABLE-PREPARE('ADMProps':U).
    ghADMPropsBuf = ghADMProps:DEFAULT-BUFFER-HANDLE.
    ghADMPropsBuf:BUFFER-CREATE().
    /* ... and save it. This ADM object is now open for business! */   
    THIS-PROCEDURE:ADM-DATA = STRING(ghADMPropsBuf) + CHR(1) + CHR(1).
    /* from this point  {&ADM-PROPS-DEFINED} is true for all cases */

    cObjectName =  '{&xcInstanceProperties}':U.
    {set InstanceProperties cObjectName}.

    /* Set the default object name to the simple procedure file name. */
    ASSIGN cObjectName = REPLACE(THIS-PROCEDURE:FILE-NAME, "~\":U, "~/":U)
           iStart = R-INDEX(cObjectName, "~/":U) + 1
           cObjectName = SUBSTR(cObjectName, iStart, 
                   R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U) - iStart).
    {set ObjectName cObjectName}.    
  END.
  
  ELSE DO:
    /* Set the properties that get their value from preprocessor initial values
       in smrtprop.i (This is temporary until all of this is moved to the 
       repository/ or handled by the repository manager)*/
        
    /* (we steal the objectname to avoid adding variables to instances) */    
    cObjectname = '{&ADM-SUPPORTED-LINKS}':U.
    {set SupportedLinks cObjectName}.
    cObjectName = '{&ADM-VERSION}':U.
    {set ObjectVersion cObjectName}.
    cObjectName =  '{&PROCEDURE-TYPE}':U.
    {set ObjectType cObjectName}.
    cObjectName = '{&ADM-CONTAINER}':U.
    {set ContainerType cObjectName}.
    cObjectName = '{&ADM-PROPERTY-DLG}':U.
    {set PropertyDialog cObjectName}.
    cObjectName =  '{&xcInstanceProperties}':U.
    {set InstanceProperties cObjectName}.

    /* probably not of any value? as this is for appbuilder adm-create */ 
    cObjectName =  '{&xcTranslatableProperties}':U.
    {set TranslatableProperties cObjectName}.

    &IF DEFINED (DB-AWARE) NE 0 &THEN
       {set DBAware {&DB-AWARE}}.
    &ELSE
       {set DBAware NO}. /* probably not necessary? as this is default */
    &ENDIF
    cObjectName =  '{&OBJECT-VERSION}':U.
    {set PhysicalVersion cObjectName}.
    cObjectName =  '{&OBJECT-NAME}':U.
    
    IF cObjectName > '':U  THEN
      {set PhysicalObjectName cObjectName}.
    ELSE 
      {set PhysicalObjectName THIS-PROCEDURE:FILE-NAME}.
  END. /* properties defined by repository manager */

&IF "{&ADM-CONTAINER}":U NE "":U &THEN
  &IF "{&ADM-CONTAINER}":U = "WINDOW":U &THEN
    ghContainer    =   {&WINDOW-NAME}.
  &ELSEIF "{&ADM-CONTAINER}":U = "VIRTUAL":U OR "{&FRAME-NAME}":U = "":U &THEN
    ghContainer    = ?. /* Container has no vis. */
  &ELSEIF "{&ADM-CONTAINER}":U = "FRAME":U OR 
    "{&ADM-CONTAINER}":U = "DIALOG-BOX":U 
  &THEN
    ghContainer = FRAME {&FRAME-NAME}:HANDLE. 
  &ENDIF
&ELSE
  &IF "{&FRAME-NAME}":U NE "":U &THEN
      ghContainer = FRAME {&FRAME-NAME}:HANDLE.
  &ENDIF
&ENDIF
  
  {set ContainerHandle ghContainer}.
 
 
  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/smartcustom.i}
  /* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-start-super-proc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE start-super-proc Method-Library 
PROCEDURE start-super-proc :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to start a super proc if it's not already running, 
               and to add it as a super proc in any case.
  Parameters:  Procedure name to make super.
  Notes:       NOTE: This presumes that we want only one copy of an ADM
               super procedure running per session, meaning that they are 
               stateless and "multi-threaded". This is intended to be the case
               for ours, but may not be true for all super procs.
            -  The LAST-SUPER-PROCEDURE-PROP preprocessor allows classes
               to specify a property of char or handle that stores
               super-procedures that need to be kept at the bottom of the list 
               (defined by data.i and sbo.i if they are extended by other classes)        
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcProcName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE        hProc      AS HANDLE     NO-UNDO.
  
  hProc = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hProc) AND hProc:FILE-NAME NE pcProcName:
    hProc = hProc:NEXT-SIBLING.
  END.
  IF NOT VALID-HANDLE(hProc) THEN
    RUN VALUE(pcProcName) PERSISTENT SET hProc.
  

     &IF '{&LAST-SUPER-PROCEDURE-PROP}':U <> '':U &THEN
  DEFINE VARIABLE cLast    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLast    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLast    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSupers  AS CHARACTE   NO-UNDO.
  DEFINE VARIABLE cRemoved AS CHARACTER  NO-UNDO.
  
  cLast = DYNAMIC-FUNCTION('get' + '{&LAST-SUPER-PROCEDURE-PROP}':U) NO-ERROR.
  IF cLast > '':U THEN
  DO:
    cSupers = THIS-PROCEDURE:SUPER-PROCEDURES. 
    DO iLast = 1 TO NUM-ENTRIES(cLast):
      hLast = WIDGET-HANDLE(ENTRY(iLast,cLast)). 
      IF VALID-HANDLE(hLast) AND LOOKUP(STRING(hLast),cSupers) > 0 THEN
      DO:
        THIS-PROCEDURE:REMOVE-SUPER-PROCEDURE(hLast).
        cRemoved = cRemoved 
                   + (IF cRemoved = '':u THEN '':U ELSE ',':U)
                   +  STRING(hLast). 
      END.
    END.
  END.
     &ENDIF

  THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hProc, SEARCH-TARGET).
     
     &IF '{&LAST-SUPER-PROCEDURE-PROP}':U <> '':U &THEN
  IF cRemoved > '':U THEN
  DO:
    DO iLast = NUM-ENTRIES(cRemoved) TO 1:
      hLast = WIDGET-HANDLE(ENTRY(iLast,cRemoved)). 
      IF VALID-HANDLE(hLast) THEN
        THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hLast, SEARCH-TARGET).
    END.
  END.
     &ENDIF
  
  RETURN.
  
END PROCEDURE.

/* Note: This ENDIF matches the adm-smart definition at the top of file.
   Do not delete it and if another procedure or function is defined which
   occurs later in the file, move it to the end of that. */
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

