//  File:         rylogic.js
//  Description:  Implements Client Logic API

function Logic(e){
  with(this){
  }
}

Logic.prototype.assignFocusedWidget=function(fld){
  // Sets focus to a widget
  return action(this.setWidgetPrefix(fld)+'.focus');
}

Logic.prototype.assignWidgetValue=function(fld,val){
  // Sets a field's screen value
//  alert('[rylogic.js] assignwidgetvalue');
  return action(this.setWidgetPrefix(fld)+'.setinput|'+val);
}

Logic.prototype.assignWidgetValueList=function(flds,vals){
  /* Sets screen value for a field list.  If any assignments fail because the 
     widget is not found, FALSE is returned after list processing completes.
  */
//  alert('[rylogic.js] assignwidgetvaluelist');
  var f=flds.split(',');
  var v=vals.split('|');
  var artn=true, rtn=true;
  var val;
  if(f.length!=v.length && v.length>1) return false;
  for (var i=0;i<f.length;i++){
    val=(v.length==1?v[0]:v[i]);
    artn=action(this.setWidgetPrefix(f[i])+'.setinput|'+val);
    rtn=rtn&&artn;
  }
  return rtn;
}

Logic.prototype.blankWidget=function(flds){
  /* Blanks the screen value for a list of fields.  This does nothing to 
     objects where a blank screen value does not make sense, such as radio 
     sets, toggle boxes and selection lists. */
//  alert('[rylogic.js] blankwidget');
  var f=flds.split(','); // create field list array
  for (var i=0;i<f.length;i++){
    action(this.setWidgetPrefix(f[i])+'.setinput|');
  }
  return true;
}

Logic.prototype.disableRadioButton=function(fld,num){
  /* Returns FALSE if a widget is not a radio-set, if a widget is not found, 
     or if the button number is invalid. */
  // TBD: needs to access ryapph.js code to decipher field name
  // TBD: return FALSE for non radio-set widget
  if(!num||num<1) return false;        // item number is invalid
  var hdl=this.widgetHandle(fld);
  if(hdl.type!='radio') return false;  // widget is not a radio-set
//  apph.action('tool.'+hdl.id+'.disable');
/*
  e.disabled=true;  This won't work in Netscape
  e.className=(e.className).split(' ')[0]+' disable';
  alert(e.className);
*/
  return true;
}

Logic.prototype.disableWidget=function(flds){
  // Returns FALSE if any field in the list is not found.
  var f=flds.split(','); // create field list array
  var artn=true, rtn=true;
  for (var i=0;i<f.length;i++){
//    alert('[rylogic.js] disablewidget\n'+this.setWidgetPrefix(f[i])+'.disable');
    artn=action(this.setWidgetPrefix(f[i])+'.disable');
    rtn=rtn&&artn;
  }
  return rtn;
}

Logic.prototype.enableRadioButton=function(fld,num){
//  alert('[rylogic.js] enableradiobutton');
  if(num<1) return false;
  // TBD: needs to access ryapph.js code to decipher field name
  var e=app.document.getElementsByName(fld)[num-1];
  if(!e) return false;
  e.disabled=false;
  e.className=(e.className).split(' ')[0]+' enable';
//  alert(e.className);
  return true;
}

Logic.prototype.enableWidget=function(flds){
  // Returns FALSE if any field in the list is not found.
//  alert('[rylogic.js] enablewidget');
  var f=flds.split(','); // create field list array
  var artn=true, rtn=true;
  for (var i=0;i<f.length;i++){
    artn=action(this.setWidgetPrefix(f[i])+'.enable');
    rtn=rtn&&artn;
  }
  return rtn;
}

Logic.prototype.formattedWidgetValue=function(fld){
  // Returns a widget's formatted screen value
//  alert('[rylogic.js] formattedwidgetvalue');
  return action(this.setWidgetPrefix(fld)+'.getinput');
}

Logic.prototype.formattedWidgetValueList=function(flds,dlm){
  /* Returns delimited list of formatted screen values, dlm delimited.
     If a field or its value is unknown, a '?' placeholder is returned. */
//  alert('[rylogic.js] formattedwidgetvaluelist');
  if(dlm==null||dlm==undefined) dlm='|'; // default to pipe
  var f=flds.split(','); // create field list array
  var lst='', val;
  for (var i=0;i<f.length;i++){
    if(i>0) lst+=dlm;
    val=action(this.setWidgetPrefix(f[i])+'.get');
    if(!val) val='?';
     lst+=val;
  }
  return lst;
}

Logic.prototype.hideWidget=function(flds){
  // Returns FALSE if any field in the list is not found.
//  alert('[rylogic.js] hidewidget');
  var f=flds.split(','); // create field list array
  var artn=true, rtn=true;
  for (var i=0;i<f.length;i++){
    artn=action(this.setWidgetPrefix(f[i])+'.hide');
    rtn=rtn&&artn;
  }
  return rtn;
}

Logic.prototype.highlightWidget=function(flds,typ){
  var f=flds.split(',');
  for (var i=0;i<f.length;i++){
    var hdl=this.widgetHandle(f[i]);
    if(!hdl) continue;
    
    switch (typ) {
      case 'err':
        hdl.className='error';
      case 'info':
        hdl.className='information';
      case 'warn':
        hdl.className='warning';
      default:
        hdl.className='field';
    }
  }
  return false;
}

Logic.prototype.locateWidget=function(fld){
  // Returns widget handle
//  alert('[rylogic.js] locatewidget');
  return action(this.setWidgetPrefix(fld)+'.handle');
}

Logic.prototype.resetWidgetValue=function(flds){
  /* Resets the object screen value to its original data source value.  If a 
     field is not found, FALSE is returned after list processing completes. */
//  alert('[rylogic.js] resetwidgetvalue');
  var f=flds.split(',');
  var old;
  var rtn=true;
  for (var i=0;i<f.length;i++){
    old=action(this.setWidgetPrefix(f[i])+'.getdata');
    if(!old) rtn=false;
    else action(this.setWidgetPrefix(f[i])+'.setinput|'+old);
  }
  return rtn;
}

Logic.prototype.setWidgetPrefix=function(fld){
  /* Determine if 'widget' or 'tool' needs to be prefixed to field name.  
     For internal use only. */
  var f=fld.split('.');
  if(f.length==1) return 'tool.'+fld;
  for(var i=0;i<f.length;i++){
    if(f[i]=='browse'||f[i]=='tool'||f[i]=='viewer'||f[i]=='widget') return fld;
  }
  return 'widget.'+fld;
}

Logic.prototype.toggleWidget=function(flds){
  /* Supports logical text input, non-SDO checkbox (see ryapph.js).  If any
     assignment fails, FALSE is returned after list processing completes. */
//  alert('[rylogic.js] togglewidget');
  var f=flds.split(',');
  var rtn=true, val;
  for (var i=0;i<f.length;i++){
    val=action(this.setWidgetPrefix(f[i])+'.switch');
    if(!val) rtn=false;
  }
  return rtn;
}

Logic.prototype.viewWidget=function(flds){
  // Returns FALSE if any field in the list is not found.
//  alert('[rylogic.js] viewwidget');
  var f=flds.split(','); // create field list array
  var artn=true, rtn=true;
  for (var i=0;i<f.length;i++){
    artn=action(this.setWidgetPrefix(f[i])+'.show');
    rtn=rtn&&artn;
  }
  return rtn;
}

Logic.prototype.widgetHandle=function(fld){
  // Returns widget handle or handle array if the object is a radio-set
//  alert('[rylogic.js] widgethandle\n'+action(this.setWidgetPrefix(fld)+'.handle').id);
  return action(this.setWidgetPrefix(fld)+'.handle');
}

Logic.prototype.widgetIsBlank=function(flds){
//  alert('[rylogic.js] widgetisblank');
  var f=flds.split(','); // create field list array
  var artn=true, rtn=false;
  for (var i=0;i<f.length;i++){
    artn=(action(this.setWidgetPrefix(f[i])+'.getinput')=='');
    rtn=rtn||artn;
  }
  return rtn;
}

Logic.prototype.widgetIsModified=function(flds){
  /* Returns TRUE if the screen value for any field in the list is different
     from its underlying data value.*/
//  alert('[rylogic.js] widgetismodified');
  var f=flds.split(',');  // create field list array
  var artn=true, rtn=false;
  for (var i=0;i<f.length;i++){
    artn=(action(this.setWidgetPrefix(f[i])+'.getinput')!=action(this.setWidgetPrefix(f[i])+'.getdata'));
    rtn=rtn||artn;
  }
  return rtn;
}

Logic.prototype.widgetIsTrue=function(fld){
  /* Returns TRUE if the value of a logical object is TRUE, otherwise FALSE.
     Returns null if the field is not found, if the value is unknown, or if 
     the widget is not a logical field.
     Supports logical text input with yes/no values. */
  // TBD: need support for checkboxes
  var wtyp=this.widgetHandle(fld).type;
  var dtyp=action(this.setWidgetPrefix(fld)+'.gettype');
  if(!dtyp||dtyp!='log') return null;
//  alert('[rylogic.js] widgetistrue\ndtyp='+dtyp+'\nwtyp='+wtyp);
  return (action(this.setWidgetPrefix(fld)+'.getinput').toLowerCase()=='yes');
}

Logic.prototype.widgetValue=function(fld){
  /* Returns a widget's unformatted input value.  Supports date, decimal, and
     integer datatypes. */
  var val=action(this.setWidgetPrefix(fld)+'.get');
  var typ=action(this.setWidgetPrefix(fld)+'.gettype');
//  alert('[rylogic.js] widgetValue\nval='+val+'\ntyp='+typ);
  return window.strip(val,typ);
}

Logic.prototype.widgetValueList=function(flds,dlm){
  /* Returns unformatted list of values.  Supports date, decimal, and integer
     datatypes. */
  var f=flds.split(','); // create field list array
  if(dlm==null||dlm==undefined) dlm='|';
  var lst='';
  var fld, typ, val; 
  for (var i=0;i<f.length;i++){
    if(i>0) lst+='|';
    val=action(this.setWidgetPrefix(f[i])+'.get');
    typ=action(this.setWidgetPrefix(f[i])+'.gettype');
    lst+=window.strip(val,typ);
  }
//  alert('[rylogic.js] widgetvaluelist\n'+lst);
  return lst;
}

logic=new Logic();
