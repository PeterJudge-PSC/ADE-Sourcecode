/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/

TRIGGER PROCEDURE FOR WRITE OF ryc_attribute OLD BUFFER o_ryc_attribute.

/* Created automatically using ERwin ICF Trigger template db/af/erw/afercustrg.i
   Do not change manually. Customisations to triggers should be placed in separate
   include files pulled into the trigger. ICF auto generates write trigger custom
   include files. Delete or create customisation include files need to be created
   manually. Be sure to put the hook in ERwin directly so as not to have you changes
   overwritten.
   User defined Macro (UDP) Summary (case sensitive)
   ryc_attribute           Expands to full table name, e.g. gsm_user
   %TableFLA            Expands to table unique code, e.g. gsmus
   %TableObj            If blank or not defined expands to table_obj with no prefix (framework standard)
                        If defined, uses this field as the object field
                        If set to "none" then indicates table does not have an object field
   XYZ                  Do not define so we can compare against an empty string

   See docs for explanation of replication macros 
*/   

&SCOPED-DEFINE TRIGGER_TABLE ryc_attribute
&SCOPED-DEFINE TRIGGER_FLA rycat
&SCOPED-DEFINE TRIGGER_OBJ attribute_obj


DEFINE BUFFER lb_table FOR ryc_attribute.      /* Used for recursive relationships */
DEFINE BUFFER lb1_table FOR ryc_attribute.     /* Used for lock upgrades */



/* Standard top of WRITE trigger code */
{af/sup/aftrigtopw.i}

/* properform fields if enabled for table */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'rycat':U
              AND gsc_entity_mnemonic.auto_properform_strings = YES) THEN
  RUN af/app/afpropfrmp.p (INPUT BUFFER ryc_attribute:HANDLE).
  



/* Generated by ICF ERwin Template */
/* ryc_attribute_group has ryc_attribute ON CHILD UPDATE SET NULL */
IF NEW ryc_attribute OR  ryc_attribute.attribute_group_obj <> o_ryc_attribute.attribute_group_obj  THEN
  DO:
    IF NOT(CAN-FIND(FIRST ryc_attribute_group WHERE
        ryc_attribute.attribute_group_obj = ryc_attribute_group.attribute_group_obj)) THEN DO:
        
        ASSIGN ryc_attribute.attribute_group_obj = 0 .
    END.
    
    
  END.








IF NOT NEW ryc_attribute AND ryc_attribute.{&TRIGGER_OBJ} <> o_ryc_attribute.{&TRIGGER_OBJ} THEN
    DO:
        ASSIGN lv-error = YES lv-errgrp = "AF":U lv-errnum = 13 lv-include = "table object number":U.
        RUN error-message (lv-errgrp,lv-errnum,lv-include).
    END.

/* Customisations to WRITE trigger */
{icf/trg/rycattrigw.i}



/* Update Audit Log */
IF CAN-FIND(FIRST gsc_entity_mnemonic
            WHERE gsc_entity_mnemonic.entity_mnemonic = 'rycat':U
              AND gsc_entity_mnemonic.auditing_enabled = YES) THEN
  RUN af/app/afauditlgp.p (INPUT "WRITE":U, INPUT "rycat":U, INPUT BUFFER ryc_attribute:HANDLE, INPUT BUFFER o_ryc_attribute:HANDLE).

/* Standard bottom of WRITE trigger code */
{af/sup/aftrigendw.i}



