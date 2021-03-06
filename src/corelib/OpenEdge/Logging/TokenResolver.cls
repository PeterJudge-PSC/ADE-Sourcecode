/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : TokenResolver
    Purpose     : Resolves certain known token names into useful values
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 16 13:02:52 EST 2016
    Notes       : * Token substitutions are allowed for file names
                    the token format is ${<token>}, where
                    token = group "." arg
                    groups = session | env | guid | t[ime] | web | ver[sion]
                             cp | req[uest] | name
                   
                    If a token cannot be resovled, or resolves to a value of
                    ? (unknown) then the token name is used.  
                  
                  * Group args for SESSION
                    - any readable attribute on the session handle may be used
                   
                  * Group args for ENV
                    - any env var available via OE-GETENV() may be used
                    
                  * Group args for VERSION
                    - Correlates to the SESSION:LOCAL-VERSION-INFO 
                    - MAJOR, MINOR, MAINT
                    
                  * Group args for GUID
                    - a default-format GUID is used
                  
                  * Group args for T (T= time).
                    - Values are taken from the time at which the file name is being built.
                    - The args are based on http://en.cppreference.com/w/c/chrono/strftime
                    TODAY: An ISO-DATE formated DATE value is used
                    NOW  : An ISO-DATE formated datetime-tz value is used
                    YYYY : The current year, incl century
                    YY   : The current year, sans century
                    BB   : The full month name (from the MONTH_LONG property)
                    B    : The shortened month name (from the MONTH_SHORT property)
                    MM   : The integer month value, with leading 0 if needed
                    M    : The integer month value with no leading 0
                    DD   : The integer day value, with leading 0 if needed
                    D    : The integer month value, with no leading 0 
                    HH   : The hour value, in 24-hour clock format (ie 18 for 6pm)
                    H    : The hour value, in 12-hour clock format (ie 6 for 6pm)
                    MMM  : The minute value, with leading 0
                    SS   : The second value, with leading 0
                    SSS  : The millisecond value, with leading 0
                    Z    : The timezone (based on the current session), with leading +/-
                    PP   : The AM/PM indicator, as AM or PM
                    P    : The AM/PM indicator, as A or P
                    AA   : The full day of the week, from the WEEKDAY_LONG property
                    A    : The short day of the week, from the WEEKDAY_SHORT property
                    W    : The integer day of the week
                    
                 * Group args for REQ (request).
                   Will return ? if we're not in a request (ie startup event procs). Values
                   are taken from the session:current-request-info
                   TPT      : The adapter type (transport) for this request
                   CCID     : The client context id
                   ID       : The current request id 
                   SESSION  : The current session id
                   THREAD   : (PASOE) the current thread id 
                 
                 * Group args for WEB
                    WEBAPP
                    SVC
                    any other cgi value
                    
                 * Group args for CP (client principal)
                   credential-arg "." db-name
                   credential-arg 
                       The current user will be used (from the request info or the security-policy)
                       UID    : The current user id
                       QUID   : The qualified user id (user@domain) 
                       DOMAIN : The domain name of the current user
                   db-name
                        An optional logical db name from which to extract the CP. If none is set, use the security-policy
                   
                 * Group args for NAME
                   tokenArg = format-expression "." logger-name
                   - logger-name : a named-hierarchy dotted-name
                                           
                   - named-hierarchy
                          something like OpenEdge.Net.DataObject.DataObjectHandler (a logger name) will become
                          O.N.D.DataObjectHandler       (default or .1K)
                          o.n.d.DataObjectHandler       (.1L) 
                          OE.N.DO.DataObjectHandler     (.1C) 
                          OE.N.DO.DOH                   (.0C) 
                          
                   - format-expression
                        keep-expr case-expr
                        keep-expr:
                            number of significant entries to keep (from right)
                            0   : All entries will be trimmed (ie zero kept) 
                            1   : Only the last/only will be keep whole (default)
                            2..n: The number of entries (from the right) to keep 
                        case-expr
                            U   : trimmed elements are upper-cased
                            L   : trimmed elements are lower-cased
                            K   : trimmed elements are left alone (default)
                            C   : trimmed elements are Camel-cased (caps only written) 
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Core.TimeStamp.
using OpenEdge.Security.Principal.
using OpenEdge.Logging.TokenResolverEventArgs.
using OpenEdge.Logging.TokenResolver.
using OpenEdge.Core.String.

class OpenEdge.Logging.TokenResolver:
    
    /* Event published after a token is resolved by this resolver. Allows a listener to override the value */
    define static public event TokenResolved signature void (input pSender as Progress.Lang.Object,
                                                            input pArgs as TokenResolverEventArgs). 
    
    // Long/full names of the month, for use with ${t.BB} tokens
    define static public property MONTH_LONG as character extent 12 no-undo
            initial ['January','February','March','April','May','June','July','August','September','October','November','December']
            get.
            set.
    // Short names of the month, for use with ${t.B} tokens
    define static public property MONTH_SHORT as character extent 12 no-undo
            initial ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
            get.
            set.
    
    // Long names of the week days, for use with ${t.AA} tokens
    define static public property WEEKDAY_LONG as character extent 7 no-undo
            initial ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']
            get.
            set.
    
    // Long names of the week days, for use with ${t.A} tokens
    define static public property WEEKDAY_SHORT as character extent 7 no-undo
            initial ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
            get.
            set.
    
    define static private variable mInstanceRoot as character no-undo.
    
    /* Resolves a NAME-based token arg, based on the type/logger name given
       
       @param character  The token argument for ${NAME.*} tokens
       @param character  The (type) name to resolve
       @return character The resolved string  */
    method static public character ResolveName(input pTokenArg  as character,
                                               input pName as character):
        define variable tokenValue as character no-undo.
        define variable numKeep as integer no-undo.
        define variable numChars as integer no-undo.
        define variable charLoop as integer no-undo.
        define variable numEntries as integer no-undo.
        define variable entryLoop as integer no-undo.
        define variable singleEntry as character no-undo.
        define variable sensitiveChar as character no-undo case-sensitive.
        define variable charAsc as integer no-undo.
        define variable delim as character no-undo.
        
        if pName eq ? then
            return ?.
        
        assign numEntries = num-entries (pName, '.':u)
               delim      = '':u
               tokenValue = '':u
               .
        
        if pTokenArg eq '':u then
            assign pTokenArg = '1K':u.
        
        assign numKeep = ?
               numKeep = integer(substring(pTokenArg, 1, 1)) 
               no-error.
        if numKeep eq ? then
            assign numKeep = 1.
        
        do entryLoop = 1 to numEntries:
            assign singleEntry = entry(entryLoop, pName, '.':u).
            
            if entryLoop gt numEntries - numKeep then
                assign tokenValue = tokenValue
                                  + delim
                                  + singleEntry.
            else
            case substring(pTokenArg, 2, 1):
                when 'U':u then     //Upper
                    assign tokenValue = tokenValue
                                      + delim
                                      + caps(substring(singleEntry, 1, 1)).
                
                when 'L':u then     //Lower
                    assign tokenValue = tokenValue
                                      + delim
                                      + lc(substring(singleEntry, 1, 1)).
                
                when 'C':u then     //camelCase
                do:                                
                    /* Loop through entire input string */
                    assign numChars   = length(singleEntry)
                           tokenValue = tokenValue
                                      + delim
                                      + substring(singleEntry, 1, 1)
                                      .
                    do charLoop = 2 to numChars:
                        assign sensitiveChar = substring(singleEntry, charLoop, 1).
                        if sensitiveChar eq caps(sensitiveChar) then
                            assign tokenValue = tokenValue + sensitiveChar.
                    end.
                end.    // CamelCase
                
                otherwise           // Keep
                    assign tokenValue = tokenValue
                                      + delim
                                      + substring(singleEntry, 1, 1).
            end case.
            assign delim = '.':u.
        end.                                                   

        return tokenValue.
    end method.

    /* Resolves a time-based token arg, based on the timestamp given
       
       @param character   The token argument for ${T.*} tokens
       @param datetime-tz The timestamp to use to resolve the token
       @return character  The resolved string */
    method static public character ResolveTime(input pTokenArg  as character,
                                               input pTimestamp as datetime-tz):
        return ResolveTime(pTokenArg,
                           MONTH_LONG, MONTH_SHORT,
                           WEEKDAY_LONG, WEEKDAY_SHORT,
                           pTimestamp).                                                   
    end method.
    
    /* Resolves a time-based token arg, based on the timestamp given
       
       @param character     The token argument for ${T.*} tokens
       @param character[12] The long-form month names (ie January)
       @param character[12] The short-form month names (ie Jan)
       @param character[7]  The long-form weekday names (ie Thursday)
       @param character[7]  The short-form weekday names (ie Thurs)
       @param datetime-tz   The timestamp to use to resolve the token
       @return character    The resolved string */
    method static public character ResolveTime(input pTokenArg  as character,
                                               input pMonthLong as character extent 12,
                                               input pMonthShort as character extent 12,
                                               input pWeekdayLong as character extent 7,
                                               input pWeekdayShort as character extent 7,
                                               input pTimestamp as datetime-tz ):
        define variable tokenValue as character no-undo.
        define variable formatString as character no-undo.
        define variable timeValue as integer no-undo.
        
        if pTimestamp eq ? then
            return ?.
        
        assign formatString = '99':u
               tokenValue   = ?.
        
        if length(pTokenArg) eq 1 then
            assign formatString = '>9':u.
        
        case pTokenArg:
            // predefined 
            when 'now':u then
                assign tokenValue = iso-date(pTimestamp).
            
            when 'today':u then
                assign tokenValue = iso-date(date(pTimestamp)).
            // years
            when 'YYYY':u then
                assign tokenValue = string(year(pTimestamp), '9999':u).
            when 'YY':u then
                assign tokenValue = string(year(pTimestamp) mod 100, '99':u).
            
            // Months
            when 'B':u then 
                assign tokenValue = pMonthShort[month(pTimestamp)].
            when 'BB':u then
                assign tokenValue = pMonthLong[month(pTimestamp)].
                
            // Months (M and MM)
            when 'M':u or
            when 'MM':u then
                assign tokenValue = string(month(pTimestamp), formatString).
            
            // Days
            when 'D':u or   
            when 'DD':u then
                assign tokenValue = string(day(pTimestamp), formatString).
            
            // Hours
            when 'H':u or   
            when 'HH':u then
                assign tokenValue = string(interval(pTimestamp, date(pTimestamp), 'hour':u),
                                         formatString).
            // Minutes
            when 'MMM':u then
                    assign tokenValue = string(interval(pTimestamp, date(pTimestamp), 'minutes':u) 
                                               - 60  * interval(pTimestamp, date(pTimestamp), 'hours':u),
                                               '99':u). 
            
            // Seconds
            when 'SS':u then
                    assign tokenValue = string(interval(pTimestamp, date(pTimestamp), 'seconds':u) 
                                               - 60  * interval(pTimestamp, date(pTimestamp), 'minutes':u),
                                               '99':u). 
            // Milliseconds
            when 'SSS':u then
                    assign tokenValue = string(interval(pTimestamp, date(pTimestamp), 'milliseconds':u) 
                                               - 1000 * interval(pTimestamp, date(pTimestamp), 'seconds':u),
                                               '999':u). 
            
            // Timezone
            when 'Z':u then
                assign tokenValue = string(timezone(pTimestamp), '+999':u).
            
            // Weekday
            when 'A':u then 
                assign tokenValue = pWeekdayShort[weekday(pTimestamp)].
            when 'AA':u then
                assign tokenValue = pWeekdayLong[weekday(pTimestamp)].
            when 'W':u then 
                assign tokenValue = string(weekday(pTimestamp)).
            
            // AM/PM
            when 'P':u or
            when 'PP':u then
            do:
                assign timeValue = interval(pTimestamp, date(pTimestamp), 'hour':u).
                if timeValue ge 12 then                        
                    assign tokenValue = 'PM':u.
                else
                    assign tokenValue = 'AM'.
                // A -> A or P; AA -> AM or PM    
                assign tokenValue = substring(tokenValue, 1, length(pTokenArg)).
            end.
        end.
        
        return tokenValue.
    end method.
    
    /* Resolves a CP-based token arg, based on the client-principal.
        
       It is the CALLER's responsibility to clean up the C-P object represented by this handle
       
       @param character The token argument for ${CP.*} tokens
       @param handle     A user represented by a client-principal 
       @return character The resolved string  */
    method static public character ResolveUser(input pTokenArg as character,
                                               input pUser as handle):
        define variable tokenValue as character no-undo.
        
        if not valid-handle(pUser) then
            return ?.
        
        if not pUser:type eq 'Client-Principal':u then
            return ?. 
        
        assign tokenValue = ?.
        
        case pTokenArg:
            when 'uid':u then
                assign tokenValue = pUser:user-id. 
            when 'quid':u then
                assign tokenValue = pUser:qualified-user-id.
            when 'domain':u then
                assign tokenValue = pUser:domain-name.
        end case.
        
        return tokenValue.
    end method.
    
    /* Resolves any tokens in the file name into appropriate values
       
       @param character The source string
       @return character The resolved string */
    method static public character Resolve(input pcBaseString as character):
        define variable resolvedName as character no-undo.
        define variable startPos as integer no-undo.
        define variable endPos as integer no-undo.
        define variable token as character no-undo.
        define variable dynCall as handle no-undo.
        define variable logicalDb as character no-undo.
        define variable currentTime as datetime-tz no-undo.
        define variable formatString as character no-undo.
        define variable currentUser as handle no-undo.
        define variable tokenEventArgs as TokenResolverEventArgs no-undo.
        define variable dotPos as integer no-undo.
        
        if pcBaseString eq ? then
            return '':u.
        
        assign startPos = index(pcBaseString, '$':u).
        if startPos eq 0 then
            return pcBaseString.
        
        assign /* use a variable to fix the time used in the filename. if we use now or time, we may flip 
                  to the next (milli)second during the execution of this loop */
               currentTime    = now
               .
        do while startPos gt 0:
            assign endPos     = index(pcBaseString, '~}':u)
                   token      = substring(pcBaseString, startPos, endPos - startPos + 1)
                   token      = trim(token, '$':u + StringConstant:CURLY_OPEN)
                   token      = trim(token, StringConstant:CURLY_CLOSE)
                   
                   // TokenValue is set to ? in the ctor
                   tokenEventArgs = new TokenResolverEventArgs(token)
                   .
            case tokenEventArgs:TokenGroup:
                when 'session':u then
                do:
                    // we can get the rest dynamically.
                    if not valid-handle(dynCall) then
                        create call dynCall.
                    else
                        dynCall:clear().
                    
                    assign dynCall:call-type = get-attr-call-type
                           dynCall:call-name = tokenEventArgs:TokenArg
                           dynCall:in-handle = session:handle
                           .                              
                    dynCall:invoke no-error.
                    assign tokenEventArgs:TokenValue = substitute('&1':u, dynCall:return-value). 
                end.   // session
                
                when 't':u or
                when 'time':u then
                    assign tokenEventArgs:SourceValue = new TimeStamp(currentTime)
                           tokenEventArgs:TokenValue  = ResolveTime(tokenEventArgs:TokenArg, currentTime).
                
                when 'guid' then
                    assign tokenEventArgs:TokenValue = guid.
                
                when 'env':u then
                do:
                    case tokenEventArgs:TokenArg:
                        when 'CATALINA_BASE':u then
                        do:
                            if mInstanceRoot eq '':u then
                                assign tokenEventArgs:TokenValue = os-getenv(tokenEventArgs:TokenArg)
                                       mInstanceRoot             = tokenEventArgs:TokenValue.
                            else
                                assign tokenEventArgs:TokenValue = mInstanceRoot. 
                        end.
                        otherwise
                            assign tokenEventArgs:TokenValue = os-getenv(tokenEventArgs:TokenArg).
                    end case.
                end.    //env
                
                when 'version':u or
                when 'ver':u then
                case tokenEventArgs:TokenArg:
                    when 'major':u then
                        assign tokenEventArgs:TokenValue = session:local-version-info:OEMajorVersion.
                    when 'minor':u then
                        assign tokenEventArgs:TokenValue = session:local-version-info:OEMinorVersion.
                    when 'maint':u then
                        assign tokenEventArgs:TokenValue = session:local-version-info:OEMaintVersion.
                end.    // version
                
                when 'request':u or
                when 'req':u then
                case tokenEventArgs:TokenArg:
                    when 'tpt':u then
                        assign tokenEventArgs:TokenValue = string(session:current-request-info:AdapterType). 
                   when 'ccid':u then
                        assign tokenEventArgs:TokenValue = session:current-request-info:ClientContextId.
                    when 'id':u then
                        assign tokenEventArgs:TokenValue = session:current-request-info:RequestId.
                    when 'session':u then
                        assign tokenEventArgs:TokenValue = string(session:current-request-info:SessionId).
                    when 'thread':u then
                        assign tokenEventArgs:TokenValue = string(session:current-request-info:ThreadId).
                end case.
                
                when 'web':u then
                case session:client-type:
                    when 'WEBSPEED':u or
                    when 'MULTI-SESSION-AGENT':u then
                    case tokenEventArgs:TokenArg:
                        when 'webapp':u then
                            assign tokenEventArgs:TokenValue = web-context:get-cgi-value('env':u, 'CONTEXT_PATH':u).
                        
                        when 'tpt':u then
                            assign tokenEventArgs:TokenValue = web-context:get-cgi-value('env':u, 'SERVLET_PATH':u).
                        
                        otherwise
                            assign tokenEventArgs:TokenValue = web-context:get-cgi-value('env':u, caps(tokenEventArgs:TokenArg)).
                    end case.   // tokenEventArgs:TokenArg 
                end case.  // web
                
                when 'cp':u then
                do:
                    if num-entries(tokenEventArgs:TokenArg, '.':u) gt 1 then
                    do:
                        assign logicalDb = entry(2, tokenEventArgs:TokenArg, '.':u).
                        if     valid-handle(currentUser) 
                           and lookup(logicalDb, currentUser:db-list) eq 0 then
                            delete object currentUser no-error.
                        
                        if not valid-handle(currentUser) then
                            assign currentUser = get-db-client(logicalDb) no-error.
                    end.
                    
                    if not valid-handle(currentUser) then
                        assign currentUser = security-policy:get-client().
                            
                    if valid-handle(currentUser) then
                        assign tokenEventArgs:SourceValue = new Principal(currentUser)
                               tokenEventArgs:TokenValue  = ResolveUser(tokenEventArgs:TokenArg, currentUser)
                               .
                end.    //cp
                
                when 'name':u then
                    //tokenArg = format-expression "." logger-name 
                    assign dotPos                     = index(tokenEventArgs:TokenArg, '.':u)
                           tokenEventArgs:SourceValue = new String(substring(tokenEventArgs:TokenArg, dotPos + 1))
                           tokenEventArgs:TokenValue  = ResolveName(substring(tokenEventArgs:TokenArg, 1, dotPos - 1),
                                                                    tokenEventArgs:SourceValue:ToString()).
            end case.   // token-group 
            
            // see if anyone wants to change this token, or handle tokens we don't know about
            TokenResolved:Publish(get-class(TokenResolver), tokenEventArgs).
            
            // null values aren't nice in the filesystem. use the original token instead             
            if tokenEventArgs:TokenValue eq ? then
                assign tokenEventArgs:TokenValue = token.
            
            assign resolvedName = resolvedName
                                // add the stuff before the ${
                                + substring(pcBaseString, 1, startPos - 1)
                                // add the replaced value
                                + tokenEventArgs:TokenValue
                    
                   // chop off the and everything preceeding the first } in the string
                   pcBaseString = substring(pcBaseString, endPos + 1)
                   // see if there's another token
                   startPos   = index(pcBaseString, '$':u)
                   .
        end.
        
        return resolvedName + pcBaseString.
        finally:
            if valid-object(currentUser) then
                delete object currentUser no-error.
            if valid-object(dynCall) then
                delete object dynCall no-error.
        end finally.
    end method.
    
end class.
