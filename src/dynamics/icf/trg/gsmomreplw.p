/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*               PSC                                                  *
*                                                                    *
*********************************************************************/
TRIGGER PROCEDURE FOR REPLICATION-WRITE OF gsm_object_menu_structure OLD BUFFER lb_old.

{af/sup/afreplicat.i  &TABLE-NAME   = "gsm_object_menu_structure"
                      &TABLE-FLA    = "gsmom"
                      &TABLE-PK     = "object_obj,
                                       menu_structure_obj,
                                       instance_attribute_obj"
                      &OLD-BUFFER   = "lb_old"
                      &ACTION       = "WRITE"
                      
                      
                      &VERSION-DATA = "YES"
}


