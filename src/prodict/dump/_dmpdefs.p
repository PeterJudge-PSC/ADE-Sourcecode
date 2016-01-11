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
/* _dmpdefs.p - Dump Data Definitions for *all* DBTYPEs */
/*

history:
    D. McMann   09/19/02    Change SQL-WIDTH to MAX-WIDTH
    D. McMann   08/14/02    Removed "UPDATE DATABASE ?" for all tables - On-line schema support
    D. McMann   08/08/02    Eliminated any sequences whose name begins "$" - Peer Direct
    D. McMann   00/08/17    Added _db-recid to StorageObject find 20000815029
    D. McMann   00/05/26    Changed check for shadow column for only ORACLE
    D. McMann   00/03/08    Added check for default indices for SQL tables
    D. McMann   99/03/25    Added check for phantom field so index-field is not blank
    Mario B     99/03/15    Conditionalized dump of _Field._Field-rpos using 
                            user_env[26]
    D. McMann   99/01/27    Added logic to dump _field._Width when not ?
    D. McMann   98/04/28    Added support for Oracle version 7 or 8
                            default to 7 if not in _db-misc1[3]
    D. McMann   98/04/22    Quoted Area Names
    D. McMann   98/03/31    Added logic to dump _field-rpos
    D. McMann   98/03/26    Added logic to dump Area name
    hutegger    94/05/04    special cases for old codepage-names:
                                ISO-Latin-1   =now=>  ISO8859-1
                                ISO 8859-1    =now=>  ISO8859-1
                                Codepage 850  =now=>  IBM850
*/

DEFINE INPUT  PARAMETER pi_method  AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pi_recid   AS RECID     NO-UNDO.
DEFINE INPUT  PARAMETER pi_DmpRpos AS CHARACTER NO-UNDO.

DEFINE VARIABLE v_ispro AS LOGICAL NO-UNDO.
DEFINE VARIABLE byte1   AS INTEGER NO-UNDO.
DEFINE VARIABLE byte2   AS INTEGER NO-UNDO.
DEFINE VARIABLE odbtyp  AS CHARACTER NO-UNDO. /* list of ODBC-types */
DEFINE VARIABLE vers    AS CHAR    NO-UNDO.

DEFINE SHARED STREAM ddl.

assign
  odbtyp      = {adecomm/ds_type.i
                  &direction = "ODBC"
                  &from-type = "odbtyp"
                  }.
                  
IF pi_method BEGINS "d" OR pi_method BEGINS "a" THEN DO: /* auto-conn records */
  /* Only output auto-connect records if current db is */
  /* Progress.  The auto-conn records themselves have a */
  /* name other than ?.  Or if given the Id of a */
  /* specific _Db record, then dump that */
  FIND _Db WHERE RECID(_Db) = pi_recid NO-LOCK.
  v_ispro = (_Db._Db-name = ?).
  FOR EACH _Db
    WHERE (v_ispro AND _Db._Db-type = "PROGRESS" AND _Db._Db-name <> ?)
      OR  (NOT v_ispro AND RECID(_Db) = pi_recid) NO-LOCK
    BY _Db._Db-name:
    PUT STREAM ddl UNFORMATTED
      "ADD DATABASE """ _Db._Db-name """ "
      "TYPE " _Db._Db-type " " SKIP.
    IF _Db._Db-addr <> ? AND _Db._Db-addr <> '' THEN DO:
      PUT STREAM ddl CONTROL "  DBNAME ".
      EXPORT STREAM ddl _Db._Db-addr.
    END.
    IF _Db._Db-comm <> ? AND _Db._Db-comm <> '' THEN DO:
      PUT STREAM ddl CONTROL "  PARAMS ".
      EXPORT STREAM ddl _Db._Db-comm.
    END.
    IF (_Db._Db-misc1[1] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  DB-MISC11 " _Db._Db-misc1[1] SKIP.
    IF (_Db._Db-misc1[2] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  DB-MISC12 " _Db._Db-misc1[2] SKIP.
      
    IF (_Db._Db-misc1[3] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  DB-MISC13 " _Db._Db-misc1[3] SKIP.
    ELSE IF _Db._Db-misc1[3] = ? AND _DB._DB-type = "ORACLE" THEN
      PUT STREAM ddl UNFORMATTED "  DB-MISC13 7  " SKIP.
      
    IF (_Db._Db-misc1[4] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  DB-MISC14 " _Db._Db-misc1[4] SKIP.
    IF (_Db._Db-misc1[5] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  DB-MISC15 " _Db._Db-misc1[5] SKIP.
    IF (_Db._Db-misc1[6] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  DB-MISC16 " _Db._Db-misc1[6] SKIP.
    IF (_Db._Db-misc1[7] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  DB-MISC17 " _Db._Db-misc1[7] SKIP.
    IF (_Db._Db-misc1[8] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  DB-MISC18 " _Db._Db-misc1[8] SKIP.
    IF _Db._Db-misc2[1] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  DRIVER-NAME ".
      EXPORT STREAM ddl _Db._Db-misc2[1].
    END.
    IF _Db._Db-misc2[2] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  DRIVER-VERS ".
      EXPORT STREAM ddl _Db._Db-misc2[2].
    END.
    IF _Db._Db-misc2[3] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  ESCAPE-CHAR ".
      EXPORT STREAM ddl _Db._Db-misc2[3].
    END.
    IF _Db._Db-misc2[4] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  DRIVER-CHARS ".
      EXPORT STREAM ddl _Db._Db-misc2[4].
    END.
    IF _Db._Db-misc2[5] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  DBMS-VERSION ".
      EXPORT STREAM ddl _Db._Db-misc2[5].
    END.
    IF _Db._Db-misc2[6] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  DSRVR-VERSION ".
      EXPORT STREAM ddl _Db._Db-misc2[6].
    END.
    IF _Db._Db-misc2[7] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  PROGRESS-VERSION ".
      EXPORT STREAM ddl _Db._Db-misc2[7].
    END.
    IF _Db._Db-misc2[8] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  DSRVR-MISC ".
      EXPORT STREAM ddl _Db._Db-misc2[8].
    END.
    PUT STREAM ddl CONTROL "  CODEPAGE-NAME ".
    CASE _Db._Db-xl-name: /* special cases for old codepage-names */
     WHEN "ISO-Latin-1"                         /* # 94-04-28-015 */
          THEN EXPORT STREAM ddl "ISO8859-1".
     WHEN "ISO 8859-1"  
          THEN EXPORT STREAM ddl "ISO8859-1".
     WHEN "Codepage 850"  
          THEN EXPORT STREAM ddl "IBM850".
     OTHERWISE EXPORT STREAM ddl _Db._Db-xl-name.
     END CASE. 
    PUT STREAM ddl UNFORMATTED SKIP(1).
  END.
END.


/* If the user wants the collation-stuff he gets it in _tran.df. */

IF pi_method BEGINS "c" THEN DO: /* collation and conversion tables */
  FIND _Db WHERE RECID(_Db) = pi_recid NO-LOCK.
  PUT STREAM ddl UNFORMATTED "UPDATE DATABASE """ _Db._Db-name """" SKIP.
  /* _Db-collate[5] is used to store the version #.  e.g., 2.0 would be
     stored as 2 bytes, 0x0200.  We only started storing the # starting
     at 2.0, so if it's not there, the version is 1.0.
  */
  ASSIGN
    byte1 = GETBYTE(_Db._Db-collate[5], 1) 
    byte2 = GETBYTE(_Db._Db-collate[5], 2).
  IF byte1 <> ? AND byte1 > 0 THEN 
    vers = STRING(byte1) + "." + STRING(byte2) + "-16".
  ELSE
    vers = "1.0-16".
  PUT STREAM ddl UNFORMATTED "  COLLATION-TRANSLATION-VERSION " vers SKIP.
  PUT STREAM ddl CONTROL "  COLLATION-NAME ".
  EXPORT STREAM ddl _Db._Db-coll-name.
  PUT STREAM ddl CONTROL "  CODEPAGE-NAME ".
  EXPORT STREAM ddl _Db._Db-xl-name.
  PUT STREAM ddl CONTROL "  INTERNAL-EXTERNAL-TRAN-TABLE ".
    PUT STREAM ddl UNFORMATTED SKIP(1).
    RUN prodict/dump/_dmp_raw.p (_Db._Db-xlate[1]).
  PUT STREAM ddl CONTROL "  EXTERNAL-INTERNAL-TRAN-TABLE ".
    PUT STREAM ddl UNFORMATTED SKIP(1).
    RUN prodict/dump/_dmp_raw.p (_Db._Db-xlate[2]).
  PUT STREAM ddl CONTROL "  CASE-INSENSITIVE-SORT ".
    PUT STREAM ddl UNFORMATTED SKIP(1).
    RUN prodict/dump/_dmp_raw.p (_Db._Db-collate[1]).
  PUT STREAM ddl CONTROL "  CASE-SENSITIVE-SORT ".
    PUT STREAM ddl UNFORMATTED SKIP(1).
    RUN prodict/dump/_dmp_raw.p (_Db._Db-collate[2]).
  PUT STREAM ddl CONTROL "  UPPERCASE-MAP ".
    PUT STREAM ddl UNFORMATTED SKIP(1).
    RUN prodict/dump/_dmp_raw.p (_Db._Db-collate[3]).
  PUT STREAM ddl CONTROL "  LOWERCASE-MAP ".
    PUT STREAM ddl UNFORMATTED SKIP(1).
    RUN prodict/dump/_dmp_raw.p (_Db._Db-collate[4]).
  PUT STREAM ddl UNFORMATTED SKIP(1).
END.

ELSE

IF pi_method BEGINS "s" THEN DO: /*-------------------------*/ /* sequences */
  FIND _Db WHERE RECID(_Db) = pi_recid NO-LOCK.
  FOR EACH _Sequence OF _Db WHERE NOT _Sequence._Seq-name BEGINS "$" NO-LOCK BY _Seq-Num:
    PUT STREAM ddl UNFORMATTED "ADD SEQUENCE """ _Sequence._Seq-Name """" SKIP.
    PUT STREAM ddl UNFORMATTED "  INITIAL " _Sequence._Seq-Init SKIP.
    PUT STREAM ddl UNFORMATTED "  INCREMENT " _Sequence._Seq-Incr SKIP.
    PUT STREAM ddl CONTROL "  CYCLE-ON-LIMIT ".
    EXPORT STREAM ddl _Sequence._Cycle-Ok.
    IF _Sequence._Seq-Min <> ? THEN
      PUT STREAM ddl UNFORMATTED "  MIN-VAL " _Sequence._Seq-Min SKIP.
    IF _Sequence._Seq-Max <> ? THEN
      PUT STREAM ddl UNFORMATTED "  MAX-VAL " _Sequence._Seq-Max SKIP.
    IF _Sequence._Seq-Misc[1] <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-NAME " _Sequence._Seq-Misc[1] SKIP.
    IF _Sequence._Seq-Misc[2] <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-OWNER " _Sequence._Seq-Misc[2] SKIP.
    IF _Sequence._Seq-Misc[3] <> ? THEN
      PUT STREAM ddl UNFORMATTED "  SEQ-MISC3 " _Sequence._Seq-Misc[3] SKIP.
    IF _Sequence._Seq-Misc[4] <> ? THEN
      PUT STREAM ddl UNFORMATTED "  SEQ-MISC4 " _Sequence._Seq-Misc[4] SKIP.
    IF _Sequence._Seq-Misc[5] <> ? THEN
      PUT STREAM ddl UNFORMATTED "  SEQ-MISC5 " _Sequence._Seq-Misc[5] SKIP.
    IF _Sequence._Seq-Misc[6] <> ? THEN
      PUT STREAM ddl UNFORMATTED "  SEQ-MISC6 " _Sequence._Seq-Misc[6] SKIP.
    IF _Sequence._Seq-Misc[7] <> ? THEN
      PUT STREAM ddl UNFORMATTED "  SEQ-MISC7 " _Sequence._Seq-Misc[7] SKIP.
    IF _Sequence._Seq-Misc[8] <> ? THEN
      PUT STREAM ddl UNFORMATTED "  SEQ-MISC8 " _Sequence._Seq-Misc[8] SKIP.

    PUT STREAM ddl UNFORMATTED SKIP(1).
  END.
END.

ELSE

IF pi_method BEGINS "t" THEN DO: /*----------------------*/ /* table_record */
  FIND _File WHERE RECID(_File) = pi_recid NO-LOCK NO-ERROR.
  IF NOT AVAILABLE _File THEN DO:
    FIND _Field WHERE RECID(_Field) = pi_recid NO-LOCK NO-ERROR.
    IF AVAILABLE _Field THEN FIND _File OF _Field.
  END.
  IF NOT AVAILABLE _File THEN DO:
    FIND _Index WHERE RECID(_Index) = pi_recid NO-LOCK NO-ERROR.
    IF AVAILABLE _Index THEN FIND _File OF _Index.
  END.
  FIND _Db OF _File NO-LOCK.
  IF RECID(_File) = pi_recid THEN DO:
    FIND FIRST _StorageObject
      WHERE _StorageObject._Db-recid = RECID(_Db)
        AND _StorageObject._Object-Number = _File._File-Number 
        AND _StorageObject._Object-type = 1 NO-LOCK NO-ERROR.
    PUT STREAM ddl UNFORMATTED "ADD TABLE """ _File._File-name """".
    IF _File._Db-lang > 0 THEN
      PUT STREAM ddl UNFORMATTED SKIP "  TYPE SQL" SKIP.
    ELSE IF _Db._Db-type <> "PROGRESS"
      THEN PUT STREAM ddl UNFORMATTED "  TYPE " _Db._Db-type SKIP.
      ELSE PUT STREAM ddl UNFORMATTED skip.
    IF AVAILABLE _StorageObject
     THEN DO:
       FIND _Area WHERE _Area._Area-number = _StorageObject._Area NO-LOCK.
       PUT STREAM ddl UNFORMATTED "  AREA """ _Area._Area-name """" SKIP.
     END.  
     ELSE DO:
       FIND _Area WHERE _Area._Area-number = 6 NO-LOCK.
       PUT STREAM ddl UNFORMATTED "  AREA """ _Area._Area-name """" SKIP.
     END.  
    IF _File._Can-Create <> '*' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-CREATE ".
      EXPORT STREAM ddl _File._Can-Create.
    END.
    IF _File._Can-Delete <> '*' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-DELETE ".
      EXPORT STREAM ddl _File._Can-Delete.
    END.
    IF _File._Can-Read <> '*' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-READ ".
      EXPORT STREAM ddl _File._Can-Read.
    END.
    IF _File._Can-Write <> '*' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-WRITE ".
      EXPORT STREAM ddl _File._Can-Write.
    END.
    IF _File._Can-Dump <> '*' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-DUMP ".
      EXPORT STREAM ddl _File._Can-Dump.
    END.
    IF _File._Can-Load <> '*' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-LOAD ".
      EXPORT STREAM ddl _File._Can-Load.
    END.
    IF _File._File-Label <> ? AND _File._File-Label <> '' THEN DO:
      PUT STREAM ddl CONTROL "  LABEL ".
      EXPORT STREAM ddl _File._File-Label.
    END.
    IF _File._File-Label-SA <> ? AND _File._File-Label-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  LABEL-SA ".
      EXPORT STREAM ddl _File._File-Label-SA.
    END.
    IF _File._Desc <> ? AND _File._Desc <> '' THEN DO:
      PUT STREAM ddl CONTROL "  DESCRIPTION ".
      EXPORT STREAM ddl _File._Desc.
    END.
    IF _File._Valexp <> ? AND _File._Valexp <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALEXP ".
      EXPORT STREAM ddl _File._Valexp.
    END.
    IF _File._Valmsg <> ? AND _File._Valmsg <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALMSG ".
      EXPORT STREAM ddl _File._Valmsg.
    END.
    IF _File._Valmsg-SA <> ? AND _File._Valmsg-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALMSG-SA ".
      EXPORT STREAM ddl _File._Valmsg-SA.
    END.
    IF _File._Frozen THEN
      PUT STREAM ddl UNFORMATTED "  FROZEN" SKIP.
    IF _File._Hidden THEN
      PUT STREAM ddl UNFORMATTED "  HIDDEN" SKIP.
    IF _File._Dump-name <> ? THEN DO:
      PUT STREAM ddl CONTROL "  DUMP-NAME ".
      EXPORT STREAM ddl _File._Dump-name.
    END.
    IF _File._For-Flag <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-FLAGS " _File._For-Flag SKIP.
    IF _File._For-Format <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FOREIGN-FORMAT ".
      EXPORT STREAM ddl _File._For-Format.
    END.
    IF _File._For-Cnt1 <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-GLOBAL " _File._For-Cnt1 SKIP.
    IF _File._For-Id <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-ID " _File._For-Id SKIP.
    IF _File._For-Cnt2 <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-LOCAL " _File._For-Cnt2 SKIP.
    IF _File._For-Info <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FOREIGN-MARK ".
      EXPORT STREAM ddl _File._For-Info.
    END.
    IF _File._For-Name <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FOREIGN-NAME ".
      EXPORT STREAM ddl _File._For-Name.
    END.
    IF _File._For-Number <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-NUMBER " _File._For-Number SKIP.
    IF _File._For-Owner <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FOREIGN-OWNER ".
      EXPORT STREAM ddl _File._For-Owner.
    END.
    IF _File._For-Size <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-SIZE " _File._For-Size SKIP.
    IF _File._For-Type <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FOREIGN-TYPE ".
      EXPORT STREAM ddl _File._For-Type.
    END.
    IF _File._Fil-misc1[1] <> ? THEN DO:
      IF CAN-DO("ORACLE,SYBASE," + odbtyp,_Db._Db-type)
        THEN PUT STREAM ddl UNFORMATTED "  PROGRESS-RECID " _File._Fil-misc1[1] SKIP.
        ELSE PUT STREAM ddl UNFORMATTED "  FILE-MISC11 "    _File._Fil-misc1[1] SKIP.
    END.
    IF _File._Fil-misc1[2] <> ? THEN DO:
      IF CAN-DO("RMS",_Db._Db-type)
        THEN DO:
          PUT STREAM ddl CONTROL "  FOREIGN-SPAN ".
          EXPORT STREAM ddl (IF _File._Fil-misc1[2] = 1 THEN 'yes' ELSE 'no').
        END.
        ELSE PUT STREAM ddl UNFORMATTED "  FILE-MISC12 "    _File._Fil-misc1[2] SKIP.
    END.
    IF _File._Fil-misc1[3] <> ? THEN DO:
      IF CAN-DO(odbtyp,_Db._Db-type)
        THEN PUT STREAM ddl UNFORMATTED "  INDEX-FREE-FLD " _File._Fil-misc1[3] SKIP.
        ELSE PUT STREAM ddl UNFORMATTED "  FILE-MISC13 "    _File._Fil-misc1[3] SKIP.
    END.
    IF (_File._Fil-misc1[4] <> ?) THEN DO:
      IF CAN-DO("ORACLE",_Db._Db-type)
        THEN PUT STREAM ddl UNFORMATTED "  RECID-COL-NO " _File._Fil-misc1[4] SKIP.
        ELSE PUT STREAM ddl UNFORMATTED "  FILE-MISC14 "  _File._Fil-misc1[4] SKIP.
    END.
    IF (_File._Fil-misc1[5] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  FILE-MISC15 " _File._Fil-misc1[5] SKIP.
    IF (_File._Fil-misc1[6] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  FILE-MISC16 " _File._Fil-misc1[6] SKIP.
    IF (_File._Fil-misc1[7] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  FILE-MISC17 " _File._Fil-misc1[7] SKIP.
    IF (_File._Fil-misc1[8] <> ?) THEN
      PUT STREAM ddl UNFORMATTED "  FILE-MISC18 " _File._Fil-misc1[8] SKIP.
    IF _File._Fil-misc2[1] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  QUALIFIER ".
      EXPORT STREAM ddl  _File._Fil-misc2[1].
    END.
    IF _File._Fil-misc2[2] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  HIDDEN-FLDS ".
      EXPORT STREAM ddl  _File._Fil-misc2[2].
    END.
    IF _File._Fil-misc2[3] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  RECID-FLD-NAME ".
      EXPORT STREAM ddl  _File._Fil-misc2[3].
    END.
    IF _File._Fil-misc2[4] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FLD-NAMES-LIST ".
      EXPORT STREAM ddl  _File._Fil-misc2[4].
    END.
    IF _File._Fil-misc2[5] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FILE-MISC25 ".
      EXPORT STREAM ddl  _File._Fil-misc2[5].
    END.
    IF _File._Fil-misc2[6] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FILE-MISC26 ".
      EXPORT STREAM ddl  _File._Fil-misc2[6].
    END.
    IF _File._Fil-misc2[7] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FILE-MISC27 ".
      EXPORT STREAM ddl  _File._Fil-misc2[7].
    END.
    IF _File._Fil-misc2[8] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  DB-LINK-NAME ".
      EXPORT STREAM ddl  _File._Fil-misc2[8].
    END.
    FOR EACH _File-trig OF _File NO-LOCK BY _Event:
      PUT STREAM ddl UNFORMATTED
        "  TABLE-TRIGGER """ _File-Trig._Event """ "
        (IF _File-Trig._Override THEN 'OVERRIDE' ELSE 'NO-OVERRIDE') " "
        "PROCEDURE """ _File-Trig._Proc-Name """ "
        "CRC """ _File-Trig._Trig-CRC """ " SKIP.
    END.
    PUT STREAM ddl UNFORMATTED SKIP(1).
  END.
  FOR EACH _Field OF _File NO-LOCK BY _Field-rpos:
    IF RECID(_File) <> pi_recid AND RECID(_Field) <> pi_recid THEN NEXT.
    PUT STREAM ddl UNFORMATTED
      "ADD FIELD """ _Field._Field-name """ "
      "OF """ _File._File-name """ "
      "AS " _Field._Data-type " " SKIP.
    IF _Field._Desc <> ? AND _Field._Desc <> '' THEN DO:
      PUT STREAM ddl CONTROL "  DESCRIPTION ".
      EXPORT STREAM ddl _Field._Desc.
    END.
    PUT STREAM ddl CONTROL "  FORMAT ".
    EXPORT STREAM ddl _Field._Format.
    IF _Field._Format-SA <> ? AND _Field._Format-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  FORMAT-SA ".
      EXPORT STREAM ddl _Field._Format-SA.
    END.
    PUT STREAM ddl CONTROL "  INITIAL ".
    EXPORT STREAM ddl _Field._Initial.
    IF _Field._Initial-SA <> ? AND _Field._Initial-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  INITIAL-SA ".
      EXPORT STREAM ddl _Field._Initial-SA.
    END.
    IF _Field._Label <> ? THEN DO:
      PUT STREAM ddl CONTROL "  LABEL ".
      EXPORT STREAM ddl _Field._Label.
    END.
    IF _Field._Label-SA <> ? AND _Field._Label-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  LABEL-SA ".
      EXPORT STREAM ddl _Field._Label-SA.
    END.
    IF pi_DmpRpos = "y" THEN DO:
       PUT STREAM ddl CONTROL "  POSITION ".
       EXPORT STREAM ddl _Field._Field-rpos. 
    END.   
    IF _Field._Width <> ? THEN DO: 
      PUT STREAM ddl CONTROL "  MAX-WIDTH ".
      EXPORT STREAM ddl _Field._Width.  
    END.
    IF _Field._View-As <> ? THEN DO:
      PUT STREAM ddl CONTROL "  VIEW-AS ".
      EXPORT STREAM ddl _Field._View-As.
    END.
    IF _Field._Col-label <> ? THEN DO:
      PUT STREAM ddl CONTROL "  COLUMN-LABEL ".
      EXPORT STREAM ddl _Field._Col-label.
    END.
    IF _Field._Col-label-SA <> ? AND _Field._Col-label-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  COLUMN-LABEL-SA ".
      EXPORT STREAM ddl _Field._Col-label-SA.
    END.
    IF _Field._Can-Read <> '*' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-READ ".
      EXPORT STREAM ddl _Field._Can-Read.
    END.
    IF _Field._Can-Write <> '*' THEN DO:
      PUT STREAM ddl CONTROL "  CAN-WRITE ".
      EXPORT STREAM ddl _Field._Can-Write.
    END.
    IF _Field._Valexp <> ? AND _Field._Valexp <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALEXP ".
      EXPORT STREAM ddl _Field._Valexp.
    END.
    IF _Field._Valmsg <> ? AND _Field._Valmsg <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALMSG ".
      EXPORT STREAM ddl _Field._Valmsg.
    END.
    IF _Field._Valmsg-SA <> ? AND _Field._Valmsg-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  VALMSG-SA ".
      EXPORT STREAM ddl _Field._Valmsg-SA.
    END.
    IF _Field._Help <> ? AND _Field._Help <> '' THEN DO:
      PUT STREAM ddl CONTROL "  HELP ".
      EXPORT STREAM ddl _Field._Help.
    END.
    IF _Field._Help-SA <> ? AND _Field._Help-SA <> '' THEN DO:
      PUT STREAM ddl CONTROL "  HELP-SA ".
      EXPORT STREAM ddl _Field._Help-SA.
    END.
    IF _Field._Extent > 0 THEN
      PUT STREAM ddl UNFORMATTED "  EXTENT " _Field._Extent SKIP.
    IF _Field._Decimals <> ? AND _Field._dtype = 5 THEN
      PUT STREAM ddl UNFORMATTED "  DECIMALS " _Field._Decimals SKIP.
    IF _Field._Decimals <> ? AND _Field._dtype = 1 THEN
      PUT STREAM ddl UNFORMATTED "  LENGTH " _Field._Decimals SKIP.
    PUT STREAM ddl UNFORMATTED "  ORDER " _Field._Order SKIP.
    IF _Field._Mandatory THEN
      PUT STREAM ddl UNFORMATTED "  MANDATORY" SKIP.
    IF _Field._Fld-case THEN
      PUT STREAM ddl UNFORMATTED "  CASE-SENSITIVE" SKIP.
    IF _Field._Fld-stoff <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-POS " _Field._Fld-stoff SKIP.
    IF _Field._Fld-stlen <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-SIZE " _Field._Fld-stlen SKIP.
    IF _Field._Fld-stdtype = 38 AND _Db._Db-type = 'RMS' THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-BITS " _Field._Decimals SKIP.
    IF _Field._For-Itype <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-CODE " _Field._For-Itype SKIP.
    IF _Field._For-Id <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-ID " _Field._For-Id SKIP.
    IF _Field._For-Name <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FOREIGN-NAME ".
      EXPORT STREAM ddl _Field._For-Name.
    END.
    IF _Field._For-Retrieve <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FOREIGN-RETRIEVE ".
      EXPORT STREAM ddl _Field._For-Retrieve.
    END.
    IF _Field._For-Scale <> ? AND _Field._For-Scale <> 0 THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-SCALE " _Field._For-Scale SKIP.
    IF _Field._For-Spacing <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-SPACING " _Field._For-Spacing SKIP.
    IF _Field._For-Type <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FOREIGN-TYPE ".
      EXPORT STREAM ddl _Field._For-Type.
    END.
    IF _Field._For-xpos <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-XPOS " _Field._For-xpos SKIP.
    IF _Field._For-Separator <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FOREIGN-SEP ".
      EXPORT STREAM ddl _Field._For-Separator.
    END.
    IF _Field._For-Allocated <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-ALLOCATED " _Field._For-Allocated SKIP.
    IF _Field._For-Maxsize <> ? THEN
      PUT STREAM ddl UNFORMATTED "  FOREIGN-MAXIMUM " _Field._For-Maxsize SKIP.
    IF _Field._Fld-misc1[1] <> ? THEN DO:
      IF CAN-DO("ORACLE," + odbtyp,_Db._Db-type) 
        THEN PUT STREAM ddl CONTROL "  DSRVR-PRECISION ".
        ELSE PUT STREAM ddl CONTROL "  FIELD-MISC11 ".
      EXPORT STREAM ddl _Field._Fld-misc1[1].
    END.
    IF _Field._Fld-misc1[2] <> ? THEN DO:
      IF CAN-DO(odbtyp,_Db._Db-type) 
        THEN PUT STREAM ddl CONTROL "  DSRVR-SCALE ".
        ELSE PUT STREAM ddl CONTROL "  FIELD-MISC12 ".
      EXPORT STREAM ddl _Field._Fld-misc1[2].
    END.
    IF _Field._Fld-misc1[3] <> ? THEN DO:
      IF CAN-DO(odbtyp,_Db._Db-type)
        THEN PUT STREAM ddl CONTROL "  DSRVR-LENGTH ".
        ELSE PUT STREAM ddl CONTROL "  FIELD-MISC13 ".
      EXPORT STREAM ddl _Field._Fld-misc1[3].
    END.
    IF _Field._Fld-misc1[4] <> ? THEN DO:
      IF CAN-DO(odbtyp,_Db._Db-type)
        THEN PUT STREAM ddl CONTROL "  DSRVR-FLDMISC ".
        ELSE PUT STREAM ddl CONTROL "  FIELD-MISC14 ".
      EXPORT STREAM ddl _Field._Fld-misc1[4].
    END.
    IF _Field._Fld-misc1[5] <> ? THEN DO:
      IF CAN-DO(odbtyp,_Db._Db-type)
        THEN PUT STREAM ddl CONTROL "  DSRVR-SHADOW ".
        ELSE PUT STREAM ddl CONTROL "  FIELD-MISC15 ".
      EXPORT STREAM ddl _Field._Fld-misc1[5].
    END.
    IF _Field._Fld-misc1[6] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FIELD-MISC16 ".
      EXPORT STREAM ddl _Field._Fld-misc1[6].
    END.
    IF _Field._Fld-misc1[7] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FIELD-MISC17 ".
      EXPORT STREAM ddl _Field._Fld-misc1[7].
    END.
    IF _Field._Fld-misc1[8] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FIELD-MISC18 ".
      EXPORT STREAM ddl _Field._Fld-misc1[8].
    END.
    IF _Field._Fld-misc2[1] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FIELD-MISC21 ".
      EXPORT STREAM ddl _Field._Fld-misc2[1].
    END.
    IF _Field._Fld-misc2[2] <> ? THEN DO:
      IF _db._Db-type = "ORACLE" THEN     
        PUT STREAM ddl CONTROL "  SHADOW-COL ".
      ELSE PUT STREAM ddl CONTROL "  FIELD-MISC22 ".
      EXPORT STREAM ddl _Field._Fld-misc2[2].
    END.
    IF _Field._Fld-misc2[3] <> ? THEN DO:
      IF CAN-DO("ORACLE,SYBASE," + odbtyp,_Db._Db-type)
        THEN PUT STREAM ddl CONTROL "  QUOTED-NAME ".
        ELSE PUT STREAM ddl CONTROL "  FIELD-MISC23 ".
      EXPORT STREAM ddl _Field._Fld-misc2[3].
    END.
    IF _Field._Fld-misc2[4] <> ? THEN DO:
      IF CAN-DO("ORACLE,SYBASE," + odbtyp,_Db._Db-type)
        THEN PUT STREAM ddl CONTROL "  MISC-PROPERTIES ".
        ELSE PUT STREAM ddl CONTROL "  FIELD-MISC24 ".
      EXPORT STREAM ddl _Field._Fld-misc2[4].
    END.
    IF _Field._Fld-misc2[5] <> ? THEN DO:
      IF _Db._Db-type = "ODBC"
        THEN PUT STREAM ddl CONTROL "  SHADOW-NAME ".
        ELSE PUT STREAM ddl CONTROL "  FIELD-MISC25 ".
      EXPORT STREAM ddl _Field._Fld-misc2[5].
    END.
    IF _Field._Fld-misc2[6] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FIELD-MISC26 ".
      EXPORT STREAM ddl _Field._Fld-misc2[6].
    END.
    IF _Field._Fld-misc2[7] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FIELD-MISC27 ".
      EXPORT STREAM ddl _Field._Fld-misc2[7].
    END.
    IF _Field._Fld-misc2[8] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FIELD-MISC28 ".
      EXPORT STREAM ddl _Field._Fld-misc2[8].
    END.
    FOR EACH _Field-trig OF _Field NO-LOCK BY _Event:
      PUT STREAM ddl UNFORMATTED
        "  FIELD-TRIGGER """ _Field-Trig._Event """ "
        (IF _Field-Trig._Override THEN 'OVERRIDE' ELSE 'NO-OVERRIDE') " "
        "PROCEDURE """ _Field-Trig._Proc-Name """ "
        "CRC """ _Field-Trig._Trig-CRC """ " SKIP.
    END.
    PUT STREAM ddl UNFORMATTED SKIP(1).
  END.

  FOR EACH _Index
    OF _File WHERE NOT _File._dft-pk OR 
       _File._Prime-Index <> RECID(_Index) NO-LOCK
    BY STRING(_File._Prime-Index = RECID(_Index),"1/2") + _Index-name:
    IF RECID(_File) <> pi_recid AND RECID(_Index) <> pi_recid THEN NEXT.
    IF _Index-name = "sql-default" THEN NEXT.
    FIND FIRST _StorageObject
      WHERE _StorageObject._Db-recid = _File._Db-recid
        AND _StorageObject._Object-Number = _Index._Idx-num 
        AND _StorageObject._Object-type = 2 NO-LOCK NO-ERROR.
    PUT STREAM ddl UNFORMATTED
      "ADD INDEX """ _Index._Index-Name """ "
      "ON """ _File._File-name """ " SKIP.
    IF AVAILABLE _StorageObject THEN DO:
      FIND _Area WHERE _Area._Area-number = _StorageObject._Area NO-LOCK.
      PUT STREAM ddl UNFORMATTED "  AREA """ _Area._Area-name """" SKIP.
    END.  
    ELSE DO:
      FIND _Area WHERE _Area._Area-number = 6 NO-LOCK.
      PUT STREAM ddl UNFORMATTED "  AREA """ _Area._Area-name """" SKIP.
    END.  
    IF _Index._Unique THEN
      PUT STREAM ddl UNFORMATTED "  UNIQUE" SKIP.
    IF NOT _Index._Active THEN
      PUT STREAM ddl UNFORMATTED "  INACTIVE" SKIP.
    IF _File._Prime-index = RECID(_Index) THEN
      PUT STREAM ddl UNFORMATTED "  PRIMARY" SKIP.
    IF _Index._Wordidx = 1 THEN
      PUT STREAM ddl UNFORMATTED "  WORD" SKIP.
    IF _Index._Desc <> ? AND _Index._Desc <> '' THEN DO:
      PUT STREAM ddl CONTROL "  DESCRIPTION ".
      EXPORT STREAM ddl _Index._Desc.
    END.
    IF _Index._Idx-num <> ? AND _Db._Db-type <> 'PROGRESS' THEN
      PUT STREAM ddl UNFORMATTED "  INDEX-NUM " _Index._Idx-num SKIP.
    IF _Index._For-Name <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FOREIGN-NAME ".
      EXPORT STREAM ddl _Index._For-Name.
    END.
    IF _Index._For-Type <> ? THEN DO:
      PUT STREAM ddl CONTROL "  FOREIGN-TYPE ".
      EXPORT STREAM ddl _Index._For-Type.
    END.
    IF _Index._I-misc2[1] <> ? THEN DO:
      PUT STREAM ddl CONTROL "  RECID-INDEX ".
      EXPORT STREAM ddl _Index._I-misc2[1].
    END.
    FOR EACH _Index-field OF _Index NO-LOCK,
      _Field OF _Index-field NO-LOCK
      BY _Index-field._Index-seq:     
      IF AVAILABLE _Field AND (_Field._Field-name <> "" AND _Field._Field-name <> ?) THEN
        PUT STREAM ddl UNFORMATTED
          "  INDEX-FIELD """ _Field._Field-Name """ "
          (IF _Index-field._Ascending THEN "ASCENDING " ELSE "")
          (IF NOT _Index-field._Ascending THEN "DESCENDING " ELSE "")
          (IF _Index-field._Abbreviate THEN "ABBREVIATED " ELSE "")
          (IF _Index-field._Unsorted THEN "UNSORTED " ELSE "") SKIP.
    END.
    PUT STREAM ddl UNFORMATTED SKIP(1).
  END.
END.

RETURN.







