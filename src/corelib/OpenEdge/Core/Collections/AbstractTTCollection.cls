/************************************************
Copyright (c)  2013-2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------------
    File        : AbstractTTCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Dec 16 22:41:40 EST 2007
    Notes       : This is an ABL specific abstraction that uses only dynamic 
                  constructs to access temp-tables and buffers in order to 
                  allow it to be reused by subclasses that have different 
                  temp-tables.  
                - The most important behavioral encapsulation/reuse provided by 
                  this is the management of the size().               
------------------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.Iterator.
using Progress.Lang.Object.
 
 
class OpenEdge.Core.Collections.AbstractTTCollection abstract serializable 
        implements ICollection: 

   /*---------------------------------------------------------------------------
    Purpose: Abstract collection class                                                                
    Notes:   All temp-table operations are dynamic
             Subclasses should define internal temp-table and pass the 
             handle to super the constructor. They must override 
             findBufferUseObject (see below) and could also override other 
             methods with static code for performance.                   
    --------------------------------------------------------------------------*/
    define private variable mhTempTable     as handle no-undo. 
    define private variable mhDefaultBuffer as handle no-undo.      
    define private variable mhField         as handle no-undo. 

    define public property Size as integer no-undo get. private set.
    
    constructor public AbstractTTCollection():
        /* default public ctor for Serialization only */
    end constructor.
        
    /* pass Collection  */ 
    constructor protected AbstractTTCollection (poCol as ICollection,phtt as handle,pcField as char):
        this-object(phtt,pcField).
        poCol:ToTable(output table-handle phtt).
        Size = poCol:Size.  
    end constructor.
    
    /* pass temp-table handle and name of object field */ 
    constructor protected AbstractTTCollection ( phtt as handle, pcField as char ):
        this-object(phtt,phtt:default-buffer-handle:buffer-field(pcField)).
    end constructor.

    /* pass temp-table handle and object field */ 
    constructor protected AbstractTTCollection (phtt as handle, hField as handle ):
        super ().
        assign
            mhTempTable     = phtt
            mhDefaultBuffer = phtt:default-buffer-handle
            mhField         = hField.
    end constructor.
     
    method public logical Add( newObject as Object):
        if valid-object(newObject) then
        do:
            mhDefaultBuffer:buffer-create().
            assign
                mhField:buffer-value = newObject  
                Size = Size + 1.    
            mhDefaultBuffer:buffer-release().
            return true.
        end.
        return false.
    end method.
    
    method public logical AddArray(objectArray as Object extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(objectArray).
        do iLoop = 1 to iMax:
            this-object:Add(objectArray[iLoop]).
        end.
        
        return true.
    end method.
    
    method public logical AddAll(newCollection as ICollection):
        define variable iterator as IIterator no-undo.
        if newCollection:getClass():Equals(getClass()) then
        do:
            newCollection:ToTable(output table-handle mhTempTable append).
            Size = Size + newCollection:Size.
        end.
        else do:
            iterator = newCollection:iterator(). 
            do while iterator:hasNext():
                this-object:Add(iterator:Next()).
            end.                                       
        end.    
        return true. 
    end method.
    
    method public void Clear(  ):
        mhTempTable:default-buffer-handle:empty-temp-table.
        assign this-object:Size = 0.        
    end method.
    
    method public logical Contains( checkObject as Object ):
        FindBufferUseObject(checkObject).
        return (mhDefaultBuffer:available).
    end method.
    
    method public logical ContainsAll(input poCollection as ICollection):
        define variable lContains as logical no-undo.
        define variable oIterator as IIterator.
        define variable oCheckObject as Object no-undo.
        
        /* if both are empty collections then true */        
        lContains = poCollection:IsEmpty() and this-object:IsEmpty().
        
        /* if the passed in collection is larger than this collection,
           this cannot be true. */
        if poCollection:size lt this-object:size then
            return false.
        
        /* one or both collections has data */
        if not lContains then
        do:
            oIterator = poCollection:Iterator().
        
            do while oIterator:HasNext():
                oCheckObject = oIterator:Next().
                lContains = this-object:Contains(oCheckObject).
                if not lContains then
                    leave.
            end.
        end.
        
        return lContains.
    end method.
    
    /* Returns a new IIterator over the collection. */
    method public IIterator Iterator( ):    
        return new Iterator(this-object,mhTempTable,mhField:name).
    end method.
     
    method public logical IsEmpty(  ):
        return not (mhTempTable:has-records).
    end method.

    method public void ToTable( output table-handle tt ):
        tt = mhTempTable.
    end method.
    
    method public logical Remove( oldObject as Object ):
        FindBufferUseObject(oldObject).
        if mhDefaultBuffer:avail then
        do:
            mhDefaultBuffer:buffer-delete(). 
            Size = Size - 1.
            return true.
        end.    
        return false.
    end method.
    
    method public logical RemoveAll(collection as ICollection):
        define variable iterator as IIterator. 
        define variable oRemove  as Object. 
        define variable lAny as logical no-undo.        
        iterator = collection:iterator().
        do while iterator:HasNext():
            oRemove = iterator:Next().
            do while Remove(oRemove):
                lAny = true.
            end.
        end.
        return lAny.
    end method.
    
    method public logical RetainAll(oCol as ICollection):
        define variable iterator as IIterator no-undo.
        define variable oChild as Object no-undo.  
        define variable lAny as logical no-undo.        
        iterator = Iterator().
        do while iterator:HasNext():
            oChild = iterator:Next().
            if not oCol:Contains(oChild) then 
            do:
                do while Remove(oChild):
                    lAny = true.
                end.
            end.     
        end.                                     
        return lAny.     
    end method.
    
    /* ToArray should not be used with large collections
       If there is too much data the ABL will throw:  
       Attempt to update data exceeding 32000. (12371) */
    method public Object extent ToArray():
        define variable i as integer no-undo.
        define variable oObjArray as Object extent no-undo.
        define variable iterator as IIterator no-undo.   
         
        if Size eq 0 then
            return oObjArray.
        
        extent(oObjarray) = Size.
        iterator = Iterator(). 
        do while iterator:hasNext():
           i = i + 1.
           oObjArray[i] = iterator:Next().  
        end.                                     
        return oObjArray.
    end method.
    
    /* override this in subclass - used by remove   */      
    method abstract protected void FindBufferUseObject (obj as Object).
    
    /* Deep clone. or rather deep enough since we don't know what the elements' Clone()
       operations do, so this may end up being a memberwise clone */
    method override public Object Clone():
        define variable oClone as ICollection no-undo.
        
        oClone = cast(this-object:GetClass():New(), ICollection).
        CloneElements(oClone).
        
        return oClone.        
    end method.
    
    method protected void CloneElements(input poClone as ICollection):
        define variable oIterator as IIterator no-undo. 

        oIterator = this-object:Iterator().
        do while oIterator:HasNext():
           poClone:Add(oIterator:Next():Clone()).
        end.
    end method.
    
end class.
