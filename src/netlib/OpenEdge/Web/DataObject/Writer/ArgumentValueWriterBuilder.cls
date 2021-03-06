/************************************************
Copyright (c)  2016 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ArgumentValueWriterBuilder 
    Purpose     : Builds a argument value writer for a given type (like a ILongcharHolder)
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Web.DataObject.OperationArgument.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using OpenEdge.Web.DataObject.Writer.DefaultArgumentValueWriterBuilder.
using Progress.Lang.Object.

class OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder inherits ConfigBuilder
            abstract:
    
    /* (mandatory) The argument type to which we want to write */
    define public property ArgumentType as class Progress.Lang.Class no-undo get. private set.
    
    /** Each concrete builder will implement this differently */
    define abstract public property Writer as ArgumentValueWriter no-undo get. 

    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(ArgumentValueWriterBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry(get-class(ArgumentValueWriterBuilder)).
                oRegistry:Put(get-class(ArgumentValueWriterBuilder):TypeName,
                              get-class(DefaultArgumentValueWriterBuilder)).
                assign ArgumentValueWriterBuilder:Registry = oRegistry.
            end.
            return ArgumentValueWriterBuilder:Registry.
        end get.
        private set.
        
    /** Returns an argument value writer for a argument
        
        @param  OperationArgument The operation for which to build the writer
        @return ArgumentValueWriterBuilder The entity writer builder to use  */
    method static public ArgumentValueWriterBuilder Build(input poArg as OperationArgument):
        Assert:NotNull(poArg, 'Operation argument').
        
        return ArgumentValueWriterBuilder:Build(poArg:ArgumentType).
    end method.
    
    /** Returns an argument value writer for a argument type
        
        @param  OperationArgument The operation for which to build the writer
        @return ArgumentValueWriterBuilder The entity writer builder to use  */
    method static public ArgumentValueWriterBuilder Build(input poArgType as class Progress.Lang.Class):
        define variable oBuilderType as Progress.Lang.Class no-undo.
        define variable oBuilder as ArgumentValueWriterBuilder no-undo.
        
        Assert:NotNull(poArgType, 'Argument type').
        
        assign oBuilderType = ArgumentValueWriterBuilder:Registry:Get(get-class(ArgumentValueWriterBuilder):TypeName).
        Assert:IsType(oBuilderType, get-class(ArgumentValueWriterBuilder)).
        
        oBuilder = dynamic-new string(oBuilderType:TypeName) (poArgType).
        
        if type-of(oBuilder, ISupportInitialize) then
            cast(oBuilder, ISupportInitialize):Initialize().
        
        return oBuilder.
    end method.

    /* Constructor */
    constructor public ArgumentValueWriterBuilder (input poArgType as class Progress.Lang.Class):
        Assert:NotNull(poArgType, 'Argument type').
        assign this-object:ArgumentType = poArgType.
    end method.
    
    /** Specifies the Entity object to use for the message body   
        
        @param  ByteBucket The bucket to use
        @return ArgumentValueWriterBuilder The writer used */
    method public ArgumentValueWriterBuilder WriteTo(input poValue as Object):
        Assert:NotNull(poValue, 'Argument value').
        
        SetOption('arg':u,     poValue).
        SetOption('argType':u, poValue:GetClass():TypeName).
    
        return this-object.
    end method.

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  character The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Option(input pcName as character,
                                                    input pcValue as character):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, pcValue).
        
        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  character The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Logger(input poLogger as ILogWriter):
        
        Assert:NotNull(poLogger, 'Log writer').
        SetOption(get-class(ILogWriter):TypeName, poLogger).
        
        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  Object The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Option(input pcName as character,
                                                    input poValue as Object):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, poValue).
        
        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  int64 The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Option(input pcName as character,
                                                    input piValue as int64):
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, piValue).

        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  decimal The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Option(input pcName as character,
                                                    input pdValue as decimal):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, pdValue).

        return this-object.
    end method.                                                     

    /** Adds or overwrites an option for the client library.
        
        @param  character The name of the option
        @param  logical The value of the option (can be anything)
        @return ArgumentValueWriterBuilder This builder object. */
    method public ArgumentValueWriterBuilder Option(input pcName as character,
                                                    input plValue as logical):
        
        Assert:NotNullOrEmpty(pcName, 'Option name').
        SetOption(pcName, plValue).

        return this-object.
    end method.

    /** Returns a value writer from a particular registry
        
        @param Progress.Lang.Class The current argument type for which we are trying to find a writer
        @param BuilderRegistry The registry in which to look 
        @return Progress.Lang.Class The type of the writer. It's the caller's responsibility to invoke and use the writer */
    method abstract protected class Progress.Lang.Class GetWriter(input poArgType as class Progress.Lang.Class,
                                                                  input poRegistry as BuilderRegistry).

end class.