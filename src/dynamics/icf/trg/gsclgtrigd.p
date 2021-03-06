/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR DELETE OF gsc_language .

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   gsc_language           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE gsc_language
&SCOPED-DEFINE TRIGGER_FLA gsclg
&SCOPED-DEFINE TRIGGER_OBJ language_obj


DEFINE BUFFER lb_table FOR gsc_language.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR gsc_language.     /* Used for lock upgrades */

DEFINE BUFFER o_gsc_language FOR gsc_language.

/* Standard top of DELETE trigger code */
{af/sup/aftrigtopd.i}

  




/* Generated by ICF ERwin Template */
/* gsc_language has gsm_translated_menu_item ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST gsm_translated_menu_item WHERE
    gsm_translated_menu_item.language_obj = gsc_language.language_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "gsc_language|gsm_translated_menu_item":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.



/* Generated by ICF ERwin Template */
/* gsc_language is the source language of gsm_translated_menu_item ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST gsm_translated_menu_item WHERE
    gsm_translated_menu_item.source_language_obj = gsc_language.language_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "gsc_language|gsm_translated_menu_item":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.



/* Generated by ICF ERwin Template */
/* gsc_language is the source language of gsm_menu_item ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST gsm_menu_item WHERE
    gsm_menu_item.source_language_obj = gsc_language.language_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "gsc_language|gsm_menu_item":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.



/* Generated by ICF ERwin Template */
/* gsc_language is source language of gsm_translation ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST gsm_translation WHERE
    gsm_translation.source_language_obj = gsc_language.language_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "gsc_language|gsm_translation":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.



/* Generated by ICF ERwin Template */
/* gsc_language has gsc_error ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST gsc_error WHERE
    gsc_error.language_obj = gsc_language.language_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "gsc_language|gsc_error":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.



/* Generated by ICF ERwin Template */
/* gsc_language has gsm_help ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST gsm_help WHERE
    gsm_help.language_obj = gsc_language.language_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "gsc_language|gsm_help":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.



/* Generated by ICF ERwin Template */
/* gsc_language has gsm_translation ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST gsm_translation WHERE
    gsm_translation.language_obj = gsc_language.language_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "gsc_language|gsm_translation":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.



/* Generated by ICF ERwin Template */
/* gsc_language  gsm_user ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST gsm_user WHERE
    gsm_user.language_obj = gsc_language.language_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "gsc_language|gsm_user":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.



/* Generated by ICF ERwin Template */
/* gsc_language  gsc_language_text ON PARENT DELETE RESTRICT */
IF CAN-FIND(FIRST gsc_language_text WHERE
    gsc_language_text.language_obj = gsc_language.language_obj) THEN
    DO:
      /* Cannot delete parent because child exists! */
      ASSIGN lv-error = YES lv-errgrp = "AF ":U lv-errnum = 101 lv-include = "gsc_language|gsc_language_text":U.
      RUN error-message (lv-errgrp, lv-errnum, lv-include).
    END.












/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'gsclg':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "DELETE":U, INPUT "gsclg":U, INPUT BUFFER gsc_language:HANDLE, INPUT BUFFER o_gsc_language:HANDLE).

/* Standard bottom of DELETE trigger code */
{af/sup/aftrigendd.i}


/* Place any specific DELETE trigger customisations here */
