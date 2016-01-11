<?xml version="1.0" encoding="utf-8" ?>
<dataset Transactions="5"><dataset_header DisableRI="yes" DatasetObj="1007600190.08" DateFormat="mdy" FullHeader="yes" SCMManaged="no" YearOffset="1950" DatasetCode="GSMCA" NumericFormat="AMERICAN" NumericDecimal="." OriginatingSite="90" NumericSeparator=","><deploy_dataset_obj>1007600190.08</deploy_dataset_obj>
<dataset_code>GSMCA</dataset_code>
<dataset_description>gsm_category - Categories</dataset_description>
<disable_ri>yes</disable_ri>
<source_code_data>no</source_code_data>
<deploy_full_data>yes</deploy_full_data>
<xml_generation_procedure></xml_generation_procedure>
<default_ado_filename></default_ado_filename>
<deploy_additions_only>no</deploy_additions_only>
<enable_data_versioning>yes</enable_data_versioning>
<deletion_dataset>yes</deletion_dataset>
<dataset_entity><dataset_entity_obj>1007600191.08</dataset_entity_obj>
<deploy_dataset_obj>1007600190.08</deploy_dataset_obj>
<entity_sequence>1</entity_sequence>
<entity_mnemonic>GSMCA</entity_mnemonic>
<primary_entity>yes</primary_entity>
<join_entity_mnemonic></join_entity_mnemonic>
<join_field_list>category_obj</join_field_list>
<filter_where_clause></filter_where_clause>
<delete_related_records>yes</delete_related_records>
<overwrite_records>yes</overwrite_records>
<keep_own_site_data>no</keep_own_site_data>
<use_relationship>no</use_relationship>
<relationship_obj>0</relationship_obj>
<deletion_action></deletion_action>
<entity_mnemonic_description>gsm_category</entity_mnemonic_description>
<entity_dbname>ICFDB</entity_dbname>
</dataset_entity>
<table_definition><name>gsm_category</name>
<dbname>icfdb</dbname>
<index-1>XAK1gsm_category,1,0,0,related_entity_mnemonic,0,category_type,0,category_group,0,category_subgroup,0</index-1>
<index-2>XIE1gsm_category,0,0,0,category_label,0</index-2>
<index-3>XIE2gsm_category,0,0,0,category_description,0</index-3>
<index-4>XIE3gsm_category,0,0,0,related_entity_mnemonic,0,category_type,0,category_group,0,category_group_seq,0</index-4>
<index-5>XIE4gsm_category,0,0,0,related_entity_mnemonic,0,category_subgroup,0</index-5>
<index-6>XIE5gsm_category,0,0,0,related_entity_mnemonic,0,owning_entity_mnemonic,0,category_type,0,category_group,0,category_subgroup,0</index-6>
<index-7>XPKgsm_category,1,1,0,category_obj,0</index-7>
<field><name>category_obj</name>
<data-type>decimal</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;9.999999999</format>
<initial>                  0.000000000</initial>
<label>Category Obj</label>
<column-label>Category Obj</column-label>
</field>
<field><name>related_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Related Entity Mnemonic</label>
<column-label>Related Entity Mnemonic</column-label>
</field>
<field><name>category_type</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Category Type</label>
<column-label>Category Type</column-label>
</field>
<field><name>category_group</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Category Group</label>
<column-label>Category Group</column-label>
</field>
<field><name>category_subgroup</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(3)</format>
<initial></initial>
<label>Category Subgroup</label>
<column-label>Category Subgroup</column-label>
</field>
<field><name>category_group_seq</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;9</format>
<initial>      0</initial>
<label>Category Group Seq.</label>
<column-label>Category Group Seq.</column-label>
</field>
<field><name>category_label</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(28)</format>
<initial></initial>
<label>Category Label</label>
<column-label>Category Label</column-label>
</field>
<field><name>category_description</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(35)</format>
<initial></initial>
<label>Category Description</label>
<column-label>Category Description</column-label>
</field>
<field><name>owning_entity_mnemonic</name>
<data-type>character</data-type>
<extent>0</extent>
<format>X(8)</format>
<initial></initial>
<label>Owning Entity Mnemonic</label>
<column-label>Owning Entity Mnemonic</column-label>
</field>
<field><name>system_owned</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>System Owned</label>
<column-label>System Owned</column-label>
</field>
<field><name>validation_min_length</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;9</format>
<initial>        0</initial>
<label>Validation Min. Length</label>
<column-label>Validation Min. Length</column-label>
</field>
<field><name>validation_max_length</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;&gt;&gt;&gt;&gt;&gt;9</format>
<initial>        0</initial>
<label>Validation Max. Length</label>
<column-label>Validation Max. Length</column-label>
</field>
<field><name>view_as_columns</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;&gt;9</format>
<initial>   0</initial>
<label>View as Columns</label>
<column-label>View as Columns</column-label>
</field>
<field><name>view_as_rows</name>
<data-type>integer</data-type>
<extent>0</extent>
<format>-&gt;9</format>
<initial>  0</initial>
<label>View as Rows</label>
<column-label>View as Rows</column-label>
</field>
<field><name>category_mandatory</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>NO </initial>
<label>Category Mandatory</label>
<column-label>Category Mandatory</column-label>
</field>
<field><name>category_active</name>
<data-type>logical</data-type>
<extent>0</extent>
<format>YES/NO</format>
<initial>YES</initial>
<label>Category Active</label>
<column-label>Category Active</column-label>
</field>
</table_definition>
</dataset_header>
<dataset_records><dataset_transaction TransactionNo="1" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_category"><category_obj>827</category_obj>
<related_entity_mnemonic>GSMCM</related_entity_mnemonic>
<category_type>NOT</category_type>
<category_group>NOT</category_group>
<category_subgroup>NOT</category_subgroup>
<category_group_seq>0</category_group_seq>
<category_label>Notes</category_label>
<category_description>Notes</category_description>
<owning_entity_mnemonic>GSMCM</owning_entity_mnemonic>
<system_owned>no</system_owned>
<validation_min_length>0</validation_min_length>
<validation_max_length>0</validation_max_length>
<view_as_columns>0</view_as_columns>
<view_as_rows>0</view_as_rows>
<category_mandatory>no</category_mandatory>
<category_active>no</category_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="2" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_category"><category_obj>246566</category_obj>
<related_entity_mnemonic>GSMCM</related_entity_mnemonic>
<category_type>NOT</category_type>
<category_group>ALL</category_group>
<category_subgroup>NOT</category_subgroup>
<category_group_seq>0</category_group_seq>
<category_label>Notes</category_label>
<category_description>Notes</category_description>
<owning_entity_mnemonic></owning_entity_mnemonic>
<system_owned>no</system_owned>
<validation_min_length>0</validation_min_length>
<validation_max_length>0</validation_max_length>
<view_as_columns>0</view_as_columns>
<view_as_rows>0</view_as_rows>
<category_mandatory>no</category_mandatory>
<category_active>no</category_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="3" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_category"><category_obj>2122116</category_obj>
<related_entity_mnemonic>GSMST</related_entity_mnemonic>
<category_type>STS</category_type>
<category_group>HST</category_group>
<category_subgroup>COD</category_subgroup>
<category_group_seq>0</category_group_seq>
<category_label>Status History</category_label>
<category_description>Status History</category_description>
<owning_entity_mnemonic></owning_entity_mnemonic>
<system_owned>no</system_owned>
<validation_min_length>0</validation_min_length>
<validation_max_length>0</validation_max_length>
<view_as_columns>0</view_as_columns>
<view_as_rows>0</view_as_rows>
<category_mandatory>no</category_mandatory>
<category_active>yes</category_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="4" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_category"><category_obj>2292438</category_obj>
<related_entity_mnemonic>GSMST</related_entity_mnemonic>
<category_type>STS</category_type>
<category_group>HST</category_group>
<category_subgroup>TRN</category_subgroup>
<category_group_seq>0</category_group_seq>
<category_label>Status History Account Trans</category_label>
<category_description>Status History Account Transaction</category_description>
<owning_entity_mnemonic></owning_entity_mnemonic>
<system_owned>no</system_owned>
<validation_min_length>0</validation_min_length>
<validation_max_length>0</validation_max_length>
<view_as_columns>0</view_as_columns>
<view_as_rows>0</view_as_rows>
<category_mandatory>no</category_mandatory>
<category_active>yes</category_active>
</contained_record>
</dataset_transaction>
<dataset_transaction TransactionNo="5" TransactionType="DATA"><contained_record DB="icfdb" Table="gsm_category"><category_obj>1005081017.28</category_obj>
<related_entity_mnemonic>GSMMM</related_entity_mnemonic>
<category_type>IMG</category_type>
<category_group>TRE</category_group>
<category_subgroup>ANY</category_subgroup>
<category_group_seq>0</category_group_seq>
<category_label>Tree View Images</category_label>
<category_description>Tree View Images</category_description>
<owning_entity_mnemonic></owning_entity_mnemonic>
<system_owned>yes</system_owned>
<validation_min_length>0</validation_min_length>
<validation_max_length>0</validation_max_length>
<view_as_columns>0</view_as_columns>
<view_as_rows>0</view_as_rows>
<category_mandatory>no</category_mandatory>
<category_active>yes</category_active>
</contained_record>
</dataset_transaction>
</dataset_records>
</dataset>