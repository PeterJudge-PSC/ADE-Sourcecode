/*************************************************************/
/* Copyright (c) 2011,2013 by progress Software Corporation. */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : Query for partitions of a single TenantGroup 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Apr 2011
    Notes       : 
  ----------------------------------------------------------------------*/

 
routine-level on error undo, throw.
using OpenEdge.DataAdmin.Binding.ContextTree.
using OpenEdge.DataAdmin.Binding.IContextTree.
using OpenEdge.DataAdmin.Binding.IDataAdminContext.
using OpenEdge.DataAdmin.Binding.IPartitionContext.
using OpenEdge.DataAdmin.Binding.IRow.
using OpenEdge.DataAdmin.Binding.PartitionContext.
using OpenEdge.DataAdmin.Binding.Query.IPartitionQuery.
using OpenEdge.DataAdmin.Binding.Query.PartitionQuery.
using OpenEdge.DataAdmin.Binding.TenantGroupContext.
using OpenEdge.DataAdmin.DataAdminService.
using OpenEdge.DataAdmin.Error.IllegalOperationError.
using OpenEdge.DataAdmin.Error.UnsupportedOperationError.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Message.FetchRequest.
using OpenEdge.DataAdmin.Message.IFetchRequest.
using Progress.Lang.*.

class OpenEdge.DataAdmin.Binding.Query.TenantGroupPartitionQuery inherits PartitionQuery implements IPartitionQuery,IPartitionContext: 
	/*------------------------------------------------------------------------------
			Purpose: Used for a collection of sequence values under a sequence
			 		 indexed/mapped by tenant															  
			Notes:  																	  
	------------------------------------------------------------------------------*/
	define private variable PartitionContext as PartitionContext no-undo.
	define private variable mNew as logical no-undo.
    define protected property DefaultAllocation as char get. set.
    define protected property DefaultDataArea as char get. set.
    define protected property DefaultIndexArea as char get. set.
    define protected property DefaultLobArea as char get. set.
    define protected property TableName as char get. set.
     
    /** Parent context (Model) may change so don't store this */   
	define private property TenantGroupContext as TenantGroupContext no-undo
	     get():
	         return  cast(Model:GetChild("tenantGroups"),TenantGroupContext).
         end.
	  
	 
/*	constructor public TenantGroupPartitionQuery (pparent as PartitionContext, pGroupName as char,pReq as IRequestInfo):*/
/*		super (pparent,"tenantGroups",pGroupName,pReq).	                                                                   */
/*	    PartitionContext = pparent.                                                                                     */
/*	end constructor.                                                                                                    */
/*                                                                                                                     */
    constructor public TenantGroupPartitionQuery (pModel as PartitionContext, pParent as IRow,pReq as IRequestInfo):
        super (pModel,pParent,pReq).     
        if pparent:Created then
        do:
            assign
                TableName         = pParent:FieldValue("TableName")
                DefaultAllocation = pParent:FieldValue("DefaultAllocation")
                DefaultDataArea   = pParent:FieldValue("DefaultDataAreaName") 
                DefaultIndexArea  = pParent:FieldValue("DefaultIndexAreaName") 
                DefaultLobArea    = pParent:FieldValue("DefaultLobAreaName"). 
            if TableName = "" then
                undo, throw new IllegalOperationError("Request for partitions for new TenantGroup with no Table.").   
            mNew = true.
        end.
        PartitionContext = pModel.
    end constructor.
    
     /** this is a hack - the fields are not used to query, but to assign default 
        data on fill  */
    method private char GetNewQuery():   
        return "for each ttpartition where ttPartition.TableName = " + quoter(TableName)
                                  + "  and ttTenantGroup.DefaultAllocation = "  + quoter(DefaultAllocation)
                                  + "  and ttTenantGroup.DefaultDataArea = "  + quoter(DefaultDataArea)
                                  + "  and ttTenantGroup.DefaultIndexArea = "  + quoter(DefaultIndexArea)
                                  + "  and ttTenantGroup.DefaultLobArea = "   + quoter(DefaultLobArea) .
    
    end method.
    
    method public override IFetchRequest GetQueryRequest():   
        if mNew then 
            return GetNewRequest().
        else 
            return super:GetQueryRequest().   
    end method.
    
    method public IFetchRequest GetNewRequest():   
        define variable msg as IFetchRequest no-undo.
        msg = new FetchRequest(Name,Id,DatasetHandle,yes).
        msg:SetTableRequestType("ttPartition","NEW").
        msg:SetTableQuery("ttPartition",GetNewQuery()).
        return msg.
    end method.
    
    method public override logical CanFind(pname as character):
        undo, throw new UnsupportedOperationError("TenantGroupPartitionQuery CanFind with single key").
    end.    
     
    method public override logical Find(pname as character):
        undo, throw new UnsupportedOperationError("TenantGroupPartitionQuery Find with single key").
    end.    
  
    method public override void ExportLastSaved(pcfile as char). 
        define variable hBuffer as handle no-undo.
        if valid-handle(LastSavedDataset) then
        do:
            hbuffer = LastSavedDataset:get-buffer-handle(TableHandle:Name) . 
            hbuffer:buffer-field ("SchemaName"):serialize-hidden = true.
            hbuffer:buffer-field ("SequenceName"):serialize-hidden = true.
            hbuffer:buffer-field ("Url"):serialize-hidden = true.         
            if valid-handle(hBuffer) then 
                hBuffer:write-json ("File",pcFile,yes).    
        end.
    end method.  
    
    method public override logical FindTable(pctable as char):
        return this-object:Find(pctable,"","",""). 
    end method.
    
    method public override logical FindField(pctable as char, pcfield as char):
        return this-object:Find(pctable,pcfield,"",""). 
    end method.
     
    method public override logical FindIndex(pctable as char, pcIndex as char,pcCollection as char):
        return this-object:Find(pctable,"",pcIndex,pcCollection). 
    end method.
    
    method protected logical Find(pctable as char,pcField as char, pcIndex as char,pccollation as char):
        if PartitionContext:FindGroup(ParentValue,pctable,pcField,pcIndex,pccollation) then
        do:
            return SynchWithModel(PartitionContext). 
        end.
        else return false.    
    end method.
    
    method public logical CanFindTable(pctable as char):
        return this-object:CanFind(pctable,"","",""). 
    end method.
    
    method public logical CanFindField(pctable as char,pcfield as char):
        return this-object:CanFind(pctable,pcfield,"",""). 
    end method.
    
    method public logical CanFindIndex(pctable as char, pcIndex as char,pccollection as char):
        return this-object:CanFind(pctable,"",pcIndex,pcCollection). 
    end method.
    
    method protected logical CanFind(pctable as char,pcField as char, pcIndex as char, pccollection as char):
        if PartitionContext:FindGroup(ParentValue,pctable,pcField,pcIndex,pcCollection) then
           return CanFindCurrentModel(PartitionContext).
    end method.
    
    method public override logical CanFindTenant(pcchar as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return false.
    end method.
    
    method public override logical CanFindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        if ParentValue = pcGroup then 
        do:
            if PartitionContext:FindGroup(ParentValue,pctable,pcField,pcIndex,pcCollection) then
               return CanFindCurrentModel(PartitionContext).
         end.
         return false.
    end method.
    
    method public override logical CanFindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return false.  
    end method.
    
    method public override logical FindTenant(pcchar as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return false.
    end method.
    
    method public override logical FindGroup(pcGroup as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        if ParentValue = pcGroup then 
        do:
            if PartitionContext:FindGroup(ParentValue,pctable,pcField,pcIndex,pcCollection) then
                return SynchWithModel(PartitionContext).
        end.
        return false.  
    end method.
    
    method public override logical FindPolicyDetail(pcDetail as char,pctable as char,pcField as char, pcIndex as char, pccollection as char):
        return false.  
    end method.  
    
    method public override logical Allocate():        
        define variable rid as rowid no-undo.
        define variable lTrack as logical no-undo.
        define variable lok as logical no-undo.
        define variable hBuffer as handle no-undo.
        lTrack = TableHandle:tracking-changes.
        TableHandle:tracking-changes = true. 
        hBuffer = QueryHandle:get-buffer-handle (1).
        rid = hBuffer:rowid.
        QueryHandle:get-first ().
        do while hBuffer:avail: 
            if hBuffer::AllocationState = "Delayed" then
            do:
                hBuffer::AllocationState = "Allocated".
                lok = true.
            end. 
            QueryHandle:get-next ().
        end.
        return lok.
        finally:
            TableHandle:tracking-changes = lTrack.          
            if rid <> ? then
                QueryHandle:reposition-to-rowid(rid). 
        end finally.       
       
    end method.
    /**********
    method public logical Deallocate(): 
        define variable rid as rowid no-undo.
        define variable lTrack as logical no-undo.
        define variable lok as logical no-undo.
        define variable hbuffer as handle no-undo.
        lTrack = TableHandle:tracking-changes.
        TableHandle:tracking-changes = true. 
        hBuffer = QueryHandle:get-buffer-handle (1).
        rid = hBuffer:rowid.
        QueryHandle:get-first ().
        do while hBuffer:avail: 
            if hBuffer::AllocationState = "Allocated"  
            and hBuffer::ObjectType = "Table" then
            do:
                hBuffer::AllocationState = "None".
                lok = true.
              
            end. 
            QueryHandle:get-next ().
        end.
        return lok.
        finally:
            TableHandle:tracking-changes = lTrack.          
            if rid <> ? then
                QueryHandle:reposition-to-rowid(rid). 
        end finally.       
              
    end method. 
    **********/
    
     /* 
    method public override character ColumnSource(pcColumn as char):
        define variable cField  as character no-undo.
        define variable cBuffer as character no-undo.
        
        define variable cMsg as character no-undo. 
        /*
        if num-entries(pcColumn,".") > 1 then
        do:
            cBuffer = entry(1,pcColumn,".").
            cField  = entry(2,pcColumn,".").
            if cBuffer = "tenant" then
            do:
                return Tenantcontext:ColumnSource(cField).
            end.    
        end.
        */
        return super:ColumnSource(pcColumn).
    end method.
    */
         
end class.