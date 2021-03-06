/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : FormDataBodyRequestFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : - Supports String as an input type, since 11.5.1 has a bug where
                    the only way to send form data is via a String.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.FormDataBodyWriter inherits MessageWriter: 
        
    constructor public FormDataBodyWriter():
        super(get-class(ByteBucket)).
    end constructor.
    
    method override public void Open():
        /* If nothing's passed in, use a bucket of our own. 
           Don't do this in the constructor as a micro-optimisation (yes, I know) */
        if not valid-object(this-object:Entity) then
            assign this-object:Entity = ByteBucket:Instance().
        
        super:Open().
    end method.
    
    method override public int64 Write(input pcData as longchar):
        Assert:NotNull(pcData).
        
        cast(this-object:Entity, ByteBucket):PutString(pcData).
        
        return length(pcData, 'raw':u).
    end method.
    
    method override public int64 Write(input poData as Object):
        define variable iBytesWritten as int64 no-undo.
        define variable oIterator as IIterator no-undo.
        define variable cDelimiter as character no-undo.
        define variable oEntry as MapEntry no-undo.
        define variable cFormString as character no-undo.
        
        Assert:NotNull(poData).
        
        if poData:GetClass():IsA(get-class(String)) then
            assign iBytesWritten = this-object:Write(cast(poData, String):Value).
        else
        if poData:GetClass():IsA(get-class(IStringStringMap)) then
        do:
            assign cDelimiter   = '':u
                   oIterator    = cast(poData, IStringStringMap):EntrySet:Iterator()
                   iBytesWritten = cast(this-object:Entity, ByteBucket):Size.
    
            do while oIterator:HasNext():
                assign oEntry        = cast(oIterator:Next(), MapEntry)
                       cFormString   = cDelimiter + substitute('&1=&2':u, oEntry:Key:ToString(), oEntry:Value:ToString())
                       cDelimiter    = '&':u
                       .
                cast(this-object:Entity, ByteBucket):PutString(cFormString).
            end.
            
            assign iBytesWritten = (cast(this-object:Entity, ByteBucket):Size - iBytesWritten).
        end.
        else                 
            return error new AppError(
                        substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                        , 0).
        
        return iBytesWritten.
    end method.
    
end class.