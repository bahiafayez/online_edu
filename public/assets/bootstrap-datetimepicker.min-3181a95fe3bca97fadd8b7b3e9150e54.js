/**
 * @license
 * =========================================================
 * bootstrap-datetimepicker.js 
 * http://www.eyecon.ro/bootstrap-datepicker
 * =========================================================
 * Copyright 2012 Stefan Petre
 *
 * Contributions:
 *  - Andrew Rowls
 *  - Thiago de Arruda
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =========================================================
 */
(function(e){function l(e){return e.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g,"\\$&")}function c(e,t,n){return t<e.length?e:Array(t-e.length+1).join(n||" ")+e}function h(e,t,n,r){return t&&n?'<div class="bootstrap-datetimepicker-widget dropdown-menu"><ul><li class="collapse in"><div class="datepicker">'+d.template+"</div>"+"</li>"+'<li class="picker-switch"><a class="accordion-toggle"><i class="'+e+'"></i></a></li>'+'<li class="collapse">'+'<div class="timepicker">'+v.getTemplate(r)+"</div>"+"</li>"+"</ul>"+"</div>":n?'<div class="bootstrap-datetimepicker-widget dropdown-menu"><div class="timepicker">'+v.getTemplate(r)+"</div>"+"</div>":'<div class="bootstrap-datetimepicker-widget dropdown-menu"><div class="datepicker">'+d.template+"</div>"+"</div>"}function p(){return new Date(Date.UTC.apply(Date,arguments))}var t=window.orientation!=undefined,n=function(e,t){this.id=r++,this.init(e,t)};n.prototype={constructor:n,init:function(t,n){var r;if(!n.pickTime&&!n.pickDate)throw new Error("Must choose at least one picker");this.options=n,this.$element=e(t),this.language=n.language in i?n.language:"en",this.pickDate=n.pickDate,this.pickTime=n.pickTime,this.isInput=this.$element.is("input"),this.component=!1;if(this.$element.is(".input-append")||this.$element.is(".input-prepend"))this.component=this.$element.find(".add-on");this.format=n.format,this.format||(this.isInput?this.format=this.$element.data("format"):this.format=this.$element.find("input").data("format"),this.format||(this.format="MM/dd/yyyy")),this._compileFormat(),this.component&&(r=this.component.find("i")),this.pickTime&&(r&&r.length&&(this.timeIcon=r.data("time-icon")),this.timeIcon||(this.timeIcon="icon-time"),r.addClass(this.timeIcon)),this.pickDate&&(r&&r.length&&(this.dateIcon=r.data("date-icon")),this.dateIcon||(this.dateIcon="icon-calendar"),r.removeClass(this.timeIcon),r.addClass(this.dateIcon)),this.widget=e(h(this.timeIcon,n.pickDate,n.pickTime,n.pick12HourFormat)).appendTo("body"),this.minViewMode=n.minViewMode||this.$element.data("date-minviewmode")||0;if(typeof this.minViewMode=="string")switch(this.minViewMode){case"months":this.minViewMode=1;break;case"years":this.minViewMode=2;break;default:this.minViewMode=0}this.viewMode=n.viewMode||this.$element.data("date-viewmode")||0;if(typeof this.viewMode=="string")switch(this.viewMode){case"months":this.viewMode=1;break;case"years":this.viewMode=2;break;default:this.viewMode=0}this.startViewMode=this.viewMode,this.weekStart=n.weekStart||this.$element.data("date-weekstart")||0,this.weekEnd=this.weekStart===0?6:this.weekStart-1,this.fillDow(),this.fillMonths(),this.fillHours(),this.fillMinutes(),this.fillSeconds(),this.update(),this.showMode(),this._attachDatePickerEvents()},show:function(e){this.widget.show(),this.height=this.component?this.component.outerHeight():this.$element.outerHeight(),this.place(),this.$element.trigger({type:"show",date:this._date}),this._attachDatePickerGlobalEvents(),e&&(e.stopPropagation(),e.preventDefault())},hide:function(){var e=this.widget.find(".collapse");for(var t=0;t<e.length;t++){var n=e.eq(t).data("collapse");if(n&&n.transitioning)return}this.widget.hide(),this.viewMode=this.startViewMode,this.showMode(),this.set(),this.$element.trigger({type:"hide",date:this._date}),this._detachDatePickerGlobalEvents()},set:function(){var e="";this._unset||(e=this.formatDate(this._date));if(!this.isInput){if(this.component){var t=this.$element.find("input");t.val(e),this._resetMaskPos(t)}this.$element.data("date",e)}else this.$element.val(e),this._resetMaskPos(this.$element)},setValue:function(e){e?this._unset=!1:this._unset=!0,typeof e=="string"?this._date=this.parseDate(e):this._date=new Date(e),this.set(),this.viewDate=p(this._date.getUTCFullYear(),this._date.getUTCMonth(),1,0,0,0,0),this.fillDate(),this.fillTime()},getDate:function(){return this._unset?null:new Date(this._date.valueOf())},setDate:function(e){e?this.setValue(e.valueOf()):this.setValue(null)},getLocalDate:function(){if(this._unset)return null;var e=this._date;return new Date(e.getUTCFullYear(),e.getUTCMonth(),e.getUTCDate(),e.getUTCHours(),e.getUTCMinutes(),e.getUTCSeconds(),e.getUTCMilliseconds())},setLocalDate:function(e){e?this.setValue(Date.UTC(e.getFullYear(),e.getMonth(),e.getDate(),e.getHours(),e.getMinutes(),e.getSeconds(),e.getMilliseconds())):this.setValue(null)},place:function(){var e=this.component?this.component.offset():this.$element.offset();this.widget.css({top:e.top+this.height,left:e.left})},notifyChange:function(){this.$element.trigger({type:"changeDate",date:this.getDate(),localDate:this.getLocalDate()})},update:function(e){var t=e;if(!t){this.isInput?t=this.$element.val():t=this.$element.find("input").val();if(!t){var n=new Date;this._date=p(n.getFullYear(),n.getMonth(),n.getDate(),n.getHours(),n.getMinutes(),n.getSeconds(),n.getMilliseconds())}else this._date=this.parseDate(t)}this.viewDate=p(this._date.getUTCFullYear(),this._date.getUTCMonth(),1,0,0,0,0),this.fillDate(),this.fillTime()},fillDow:function(){var e=this.weekStart,t="<tr>";while(e<this.weekStart+7)t+='<th class="dow">'+i[this.language].daysMin[e++%7]+"</th>";t+="</tr>",this.widget.find(".datepicker-days thead").append(t)},fillMonths:function(){var e="",t=0;while(t<12)e+='<span class="month">'+i[this.language].monthsShort[t++]+"</span>";this.widget.find(".datepicker-months td").append(e)},fillDate:function(){var e=this.viewDate.getUTCFullYear(),t=this.viewDate.getUTCMonth(),n=p(this._date.getUTCFullYear(),this._date.getUTCMonth(),this._date.getUTCDate(),0,0,0,0);this.widget.find(".datepicker-days th:eq(1)").text(i[this.language].months[t]+" "+e);var r=p(e,t-1,28,0,0,0,0),s=d.getDaysInMonth(r.getUTCFullYear(),r.getUTCMonth());r.setUTCDate(s),r.setUTCDate(s-(r.getUTCDay()-this.weekStart+7)%7);var o=new Date(r.valueOf());o.setUTCDate(o.getUTCDate()+42),o=o.valueOf();var u=[],a;while(r.valueOf()<o){r.getUTCDay()===this.weekStart&&u.push("<tr>"),a="";if(r.getUTCFullYear()<e||r.getUTCFullYear()==e&&r.getUTCMonth()<t)a+=" old";else if(r.getUTCFullYear()>e||r.getUTCFullYear()==e&&r.getUTCMonth()>t)a+=" new";r.valueOf()===n.valueOf()&&(a+=" active"),u.push('<td class="day'+a+'">'+r.getUTCDate()+"</td>"),r.getUTCDay()===this.weekEnd&&u.push("</tr>"),r.setUTCDate(r.getUTCDate()+1)}this.widget.find(".datepicker-days tbody").empty().append(u.join(""));var f=this._date.getUTCFullYear(),l=this.widget.find(".datepicker-months").find("th:eq(1)").text(e).end().find("span").removeClass("active");f===e&&l.eq(this._date.getUTCMonth()).addClass("active"),u="",e=parseInt(e/10,10)*10;var c=this.widget.find(".datepicker-years").find("th:eq(1)").text(e+"-"+(e+9)).end().find("td");e-=1;for(var h=-1;h<11;h++)u+='<span class="year'+(h===-1||h===10?" old":"")+(f===e?" active":"")+'">'+e+"</span>",e+=1;c.html(u)},fillHours:function(){var e=this.widget.find(".timepicker .timepicker-hours table");e.parent().hide();var t="";if(this.options.pick12HourFormat){var n=1;for(var r=0;r<3;r+=1){t+="<tr>";for(var i=0;i<4;i+=1){var s=n.toString();t+='<td class="hour">'+c(s,2,"0")+"</td>",n++}t+="</tr>"}}else{var n=0;for(var r=0;r<6;r+=1){t+="<tr>";for(var i=0;i<4;i+=1){var s=n.toString();t+='<td class="hour">'+c(s,2,"0")+"</td>",n++}t+="</tr>"}}e.html(t)},fillMinutes:function(){var e=this.widget.find(".timepicker .timepicker-minutes table");e.parent().hide();var t="",n=0;for(var r=0;r<5;r++){t+="<tr>";for(var i=0;i<4;i+=1){var s=n.toString();t+='<td class="minute">'+c(s,2,"0")+"</td>",n+=3}t+="</tr>"}e.html(t)},fillSeconds:function(){var e=this.widget.find(".timepicker .timepicker-seconds table");e.parent().hide();var t="",n=0;for(var r=0;r<5;r++){t+="<tr>";for(var i=0;i<4;i+=1){var s=n.toString();t+='<td class="second">'+c(s,2,"0")+"</td>",n+=3}t+="</tr>"}e.html(t)},fillTime:function(){if(!this._date)return;var e=this.widget.find(".timepicker span[data-time-component]"),t=e.closest("table"),n=this.options.pick12HourFormat,r=this._date.getUTCHours(),i="AM";n&&(r>=12&&(i="PM"),r===0?r=12:r!=12&&(r%=12),this.widget.find(".timepicker [data-action=togglePeriod]").text(i)),r=c(r.toString(),2,"0");var s=c(this._date.getUTCMinutes().toString(),2,"0"),o=c(this._date.getUTCSeconds().toString(),2,"0");e.filter("[data-time-component=hours]").text(r),e.filter("[data-time-component=minutes]").text(s),e.filter("[data-time-component=seconds]").text(o)},click:function(t){t.stopPropagation(),t.preventDefault();var n=e(t.target).closest("span, td, th");if(n.length===1)switch(n[0].nodeName.toLowerCase()){case"th":switch(n[0].className){case"switch":this.showMode(1);break;case"prev":case"next":var r=this.viewDate,i=d.modes[this.viewMode].navFnc,s=d.modes[this.viewMode].navStep;n[0].className==="prev"&&(s*=-1),r["set"+i](r["get"+i]()+s),this.fillDate(),this.set()}break;case"span":if(n.is(".month")){var o=n.parent().find("span").index(n);this.viewDate.setUTCMonth(o)}else{var u=parseInt(n.text(),10)||0;this.viewDate.setUTCFullYear(u)}this.viewMode!==0&&(this._date=p(this.viewDate.getUTCFullYear(),this.viewDate.getUTCMonth(),this.viewDate.getUTCDate(),this._date.getUTCHours(),this._date.getUTCMinutes(),this._date.getUTCSeconds(),this._date.getUTCMilliseconds()),this.notifyChange()),this.showMode(-1),this.fillDate(),this.set();break;case"td":if(n.is(".day")){var a=parseInt(n.text(),10)||1,o=this.viewDate.getUTCMonth(),u=this.viewDate.getUTCFullYear();n.is(".old")?o===0?(o=11,u-=1):o-=1:n.is(".new")&&(o==11?(o=0,u+=1):o+=1),this._date=p(u,o,a,this._date.getUTCHours(),this._date.getUTCMinutes(),this._date.getUTCSeconds(),this._date.getUTCMilliseconds()),this.viewDate=p(u,o,Math.min(28,a),0,0,0,0),this.fillDate(),this.set(),this.notifyChange()}}},actions:{incrementHours:function(e){this._date.setUTCHours(this._date.getUTCHours()+1)},incrementMinutes:function(e){this._date.setUTCMinutes(this._date.getUTCMinutes()+1)},incrementSeconds:function(e){this._date.setUTCSeconds(this._date.getUTCSeconds()+1)},decrementHours:function(e){this._date.setUTCHours(this._date.getUTCHours()-1)},decrementMinutes:function(e){this._date.setUTCMinutes(this._date.getUTCMinutes()-1)},decrementSeconds:function(e){this._date.setUTCSeconds(this._date.getUTCSeconds()-1)},togglePeriod:function(e){var t=this._date.getUTCHours();t>=12?t-=12:t+=12,this._date.setUTCHours(t)},showPicker:function(){this.widget.find(".timepicker > div:not(.timepicker-picker)").hide(),this.widget.find(".timepicker .timepicker-picker").show()},showHours:function(){this.widget.find(".timepicker .timepicker-picker").hide(),this.widget.find(".timepicker .timepicker-hours").show()},showMinutes:function(){this.widget.find(".timepicker .timepicker-picker").hide(),this.widget.find(".timepicker .timepicker-minutes").show()},showSeconds:function(){this.widget.find(".timepicker .timepicker-picker").hide(),this.widget.find(".timepicker .timepicker-seconds").show()},selectHour:function(t){var n=e(t.target),r=parseInt(n.text(),10);if(this.options.pick12HourFormat){var i=this._date.getUTCHours();i>=12?r!=12&&(r=(r+12)%24):r===12?r=0:r%=12}this._date.setUTCHours(r),this.actions.showPicker.call(this)},selectMinute:function(t){var n=e(t.target),r=parseInt(n.text(),10);this._date.setUTCMinutes(r),this.actions.showPicker.call(this)},selectSecond:function(t){var n=e(t.target),r=parseInt(n.text(),10);this._date.setUTCSeconds(r),this.actions.showPicker.call(this)}},doAction:function(t){t.stopPropagation(),t.preventDefault(),this._date||(this._date=p(1970,0,0,0,0,0,0));var n=e(t.currentTarget).data("action"),r=this.actions[n].apply(this,arguments);return this.set(),this.fillTime(),this.notifyChange(),r},stopEvent:function(e){e.stopPropagation(),e.preventDefault()},keydown:function(t){var n=this,r=t.which,i=e(t.target);(r==8||r==46)&&setTimeout(function(){n._resetMaskPos(i)})},keypress:function(t){var n=t.which;if(n==8||n==46)return;var r=e(t.target),i=String.fromCharCode(n),s=r.val()||"";s+=i;var o=this._mask[this._maskPos];if(!o)return!1;if(o.end!=s.length)return;if(!o.pattern.test(s.slice(o.start))){s=s.slice(0,s.length-1);while((o=this._mask[this._maskPos])&&o.character)s+=o.character,this._maskPos++;return s+=i,o.end!=s.length?(r.val(s),!1):o.pattern.test(s.slice(o.start))?(r.val(s),this._maskPos++,!1):(r.val(s.slice(0,o.start)),!1)}this._maskPos++},change:function(t){var n=e(t.target),r=n.val();this._formatPattern.test(r)?(this.update(),this.setValue(this._date.getTime()),this.notifyChange(),this.set()):r&&r.trim()?(this.setValue(this._date.getTime()),this._date?this.set():n.val("")):this._date&&(this.setValue(null),this.notifyChange()),this._resetMaskPos(n)},showMode:function(e){e&&(this.viewMode=Math.max(this.minViewMode,Math.min(2,this.viewMode+e))),this.widget.find(".datepicker > div").hide().filter(".datepicker-"+d.modes[this.viewMode].clsName).show()},destroy:function(){this._detachDatePickerEvents(),this._detachDatePickerGlobalEvents(),this.widget.remove(),this.$element.removeData("datetimepicker"),this.component.removeData("datetimepicker")},formatDate:function(e){return this.format.replace(f,function(t){var n,r,i,o=t.length;t==="ms"&&(o=1),r=s[t].property;if(r==="Hours12")i=e.getUTCHours(),i===0?i=12:i!==12&&(i%=12);else{if(r==="Period12")return e.getUTCHours()>=12?"PM":"AM";n="get"+r,i=e[n]()}return n==="getUTCMonth"&&(i+=1),n==="getUTCYear"&&(i=i+1900-2e3),c(i.toString(),o,"0")})},parseDate:function(e){var t,n,r,i,s,o={};if(!(t=this._formatPattern.exec(e)))return null;for(n=1;n<t.length;n++){r=this._propertiesByIndex[n];if(!r)continue;s=t[n],/^\d+$/.test(s)&&(s=parseInt(s,10)),o[r]=s}return this._finishParsingDate(o)},_resetMaskPos:function(e){var t=e.val();for(var n=0;n<this._mask.length;n++){if(this._mask[n].end>t.length){this._maskPos=n;break}if(this._mask[n].end===t.length){this._maskPos=n+1;break}}},_finishParsingDate:function(e){var t,n,r,i,s,o,u;return t=e.UTCFullYear,e.UTCYear&&(t=2e3+e.UTCYear),t||(t=1970),e.UTCMonth?n=e.UTCMonth-1:n=0,r=e.UTCDate||1,i=e.UTCHours||0,s=e.UTCMinutes||0,o=e.UTCSeconds||0,u=e.UTCMilliseconds||0,e.Hours12&&(i=e.Hours12),e.Period12&&(/pm/i.test(e.Period12)?i!=12&&(i=(i+12)%24):i%=12),p(t,n,r,i,s,o,u)},_compileFormat:function(){var e,t,n=[],r=[],i=this.format,o={},u=0,f=0;while(e=a.exec(i))t=e[0],t in s?(u++,o[u]=s[t].property,n.push("\\s*"+s[t].getPattern(this)+"\\s*"),r.push({pattern:new RegExp(s[t].getPattern(this)),property:s[t].property,start:f,end:f+=t.length})):(n.push(l(t)),r.push({pattern:new RegExp(l(t)),character:t,start:f,end:++f})),i=i.slice(t.length);this._mask=r,this._maskPos=0,this._formatPattern=new RegExp("^\\s*"+n.join("")+"\\s*$"),this._propertiesByIndex=o},_attachDatePickerEvents:function(){var t=this;this.widget.on("click",".datepicker *",e.proxy(this.click,this)),this.widget.on("click","[data-action]",e.proxy(this.doAction,this)),this.widget.on("mousedown",e.proxy(this.stopEvent,this)),this.pickDate&&this.pickTime&&this.widget.on("click.togglePicker",".accordion-toggle",function(n){n.stopPropagation();var r=e(this),i=r.closest("ul"),s=i.find(".collapse.in"),o=i.find(".collapse:not(.in)");if(s&&s.length){var u=s.data("collapse");if(u&&u.transitioning)return;s.collapse("hide"),o.collapse("show"),r.find("i").toggleClass(t.timeIcon+" "+t.dateIcon),t.$element.find(".add-on i").toggleClass(t.timeIcon+" "+t.dateIcon)}}),this.isInput?(this.$element.on({focus:e.proxy(this.show,this),change:e.proxy(this.change,this)}),this.options.maskInput&&this.$element.on({keydown:e.proxy(this.keydown,this),keypress:e.proxy(this.keypress,this)})):(this.$element.on({change:e.proxy(this.change,this)},"input"),this.options.maskInput&&this.$element.on({keydown:e.proxy(this.keydown,this),keypress:e.proxy(this.keypress,this)},"input"),this.component?this.component.on("click",e.proxy(this.show,this)):this.$element.on("click",e.proxy(this.show,this)))},_attachDatePickerGlobalEvents:function(){e(window).on("resize.datetimepicker"+this.id,e.proxy(this.place,this)),this.isInput||e(document).on("mousedown.datetimepicker"+this.id,e.proxy(this.hide,this))},_detachDatePickerEvents:function(){this.widget.off("click",".datepicker *",this.click),this.widget.off("click","[data-action]"),this.widget.off("mousedown",this.stopEvent),this.pickDate&&this.pickTime&&this.widget.off("click.togglePicker"),this.isInput?(this.$element.off({focus:this.show,change:this.change}),this.options.maskInput&&this.$element.off({keydown:this.keydown,keypress:this.keypress})):(this.$element.off({change:this.change},"input"),this.options.maskInput&&this.$element.off({keydown:this.keydown,keypress:this.keypress},"input"),this.component?this.component.off("click",this.show):this.$element.off("click",this.show))},_detachDatePickerGlobalEvents:function(){e(window).off("resize.datetimepicker"+this.id),this.isInput||e(document).off("mousedown.datetimepicker"+this.id)}},e.fn.datetimepicker=function(t,r){return this.each(function(){var i=e(this),s=i.data("datetimepicker"),o=typeof t=="object"&&t;s||i.data("datetimepicker",s=new n(this,e.extend({},e.fn.datetimepicker.defaults,o))),typeof t=="string"&&s[t](r)})},e.fn.datetimepicker.defaults={maskInput:!0,pickDate:!0,pickTime:!0,pick12HourFormat:!1},e.fn.datetimepicker.Constructor=n;var r=0,i=e.fn.datetimepicker.dates={en:{days:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],daysShort:["Sun","Mon","Tue","Wed","Thu","Fri","Sat","Sun"],daysMin:["Su","Mo","Tu","We","Th","Fr","Sa","Su"],months:["January","February","March","April","May","June","July","August","September","October","November","December"],monthsShort:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]}},s={dd:{property:"UTCDate",getPattern:function(){return"(0?[1-9]|[1-2][0-9]|3[0-1])\\b"}},MM:{property:"UTCMonth",getPattern:function(){return"(0?[1-9]|1[0-2])\\b"}},yy:{property:"UTCYear",getPattern:function(){return"(\\d{2})\\b"}},yyyy:{property:"UTCFullYear",getPattern:function(){return"(\\d{4})\\b"}},hh:{property:"UTCHours",getPattern:function(){return"(0?[0-9]|1[0-9]|2[0-3])\\b"}},mm:{property:"UTCMinutes",getPattern:function(){return"(0?[0-9]|[1-5][0-9])\\b"}},ss:{property:"UTCSeconds",getPattern:function(){return"(0?[0-9]|[1-5][0-9])\\b"}},ms:{property:"UTCMilliseconds",getPattern:function(){return"([0-9]{1,3})\\b"}},HH:{property:"Hours12",getPattern:function(){return"(0?[1-9]|1[0-2])\\b"}},PP:{property:"Period12",getPattern:function(){return"(AM|PM|am|pm|Am|aM|Pm|pM)\\b"}}},o=[];for(var u in s)o.push(u);o[o.length-1]+="\\b",o.push(".");var a=new RegExp(o.join("\\b|"));o.pop();var f=new RegExp(o.join("\\b|"),"g"),d={modes:[{clsName:"days",navFnc:"UTCMonth",navStep:1},{clsName:"months",navFnc:"UTCFullYear",navStep:1},{clsName:"years",navFnc:"UTCFullYear",navStep:10}],isLeapYear:function(e){return e%4===0&&e%100!==0||e%400===0},getDaysInMonth:function(e,t){return[31,d.isLeapYear(e)?29:28,31,30,31,30,31,31,30,31,30,31][t]},headTemplate:'<thead><tr><th class="prev">&lsaquo;</th><th colspan="5" class="switch"></th><th class="next">&rsaquo;</th></tr></thead>',contTemplate:'<tbody><tr><td colspan="7"></td></tr></tbody>'};d.template='<div class="datepicker-days"><table class="table-condensed">'+d.headTemplate+"<tbody></tbody>"+"</table>"+"</div>"+'<div class="datepicker-months">'+'<table class="table-condensed">'+d.headTemplate+d.contTemplate+"</table>"+"</div>"+'<div class="datepicker-years">'+'<table class="table-condensed">'+d.headTemplate+d.contTemplate+"</table>"+"</div>";var v={hourTemplate:'<span data-action="showHours" data-time-component="hours" class="timepicker-hour"></span>',minuteTemplate:'<span data-action="showMinutes" data-time-component="minutes" class="timepicker-minute"></span>',secondTemplate:'<span data-action="showSeconds" data-time-component="seconds" class="timepicker-second"></span>'};v.getTemplate=function(e){return'<div class="timepicker-picker"><table class="table-condensed"'+(e?' data-hour-format="12"':"")+">"+"<tr>"+'<td><a href="#" class="btn" data-action="incrementHours"><i class="icon-chevron-up"></i></a></td>'+'<td class="separator"></td>'+'<td><a href="#" class="btn" data-action="incrementMinutes"><i class="icon-chevron-up"></i></a></td>'+'<td class="separator"></td>'+'<td><a href="#" class="btn" data-action="incrementSeconds"><i class="icon-chevron-up"></i></a></td>'+(e?'<td class="separator"></td>':"")+"</tr>"+"<tr>"+"<td>"+v.hourTemplate+"</td> "+'<td class="separator">:</td>'+"<td>"+v.minuteTemplate+"</td> "+'<td class="separator">:</td>'+"<td>"+v.secondTemplate+"</td>"+(e?'<td class="separator"></td><td><button type="button" class="btn btn-primary" data-action="togglePeriod"></button></td>':"")+"</tr>"+"<tr>"+'<td><a href="#" class="btn" data-action="decrementHours"><i class="icon-chevron-down"></i></a></td>'+'<td class="separator"></td>'+'<td><a href="#" class="btn" data-action="decrementMinutes"><i class="icon-chevron-down"></i></a></td>'+'<td class="separator"></td>'+'<td><a href="#" class="btn" data-action="decrementSeconds"><i class="icon-chevron-down"></i></a></td>'+(e?'<td class="separator"></td>':"")+"</tr>"+"</table>"+"</div>"+'<div class="timepicker-hours" data-action="selectHour">'+'<table class="table-condensed">'+"</table>"+"</div>"+'<div class="timepicker-minutes" data-action="selectMinute">'+'<table class="table-condensed">'+"</table>"+"</div>"+'<div class="timepicker-seconds" data-action="selectSecond">'+'<table class="table-condensed">'+"</table>"+"</div>"}})(window.jQuery);