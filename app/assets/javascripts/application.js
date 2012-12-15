// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.purr
//= require best_in_place
//= require best_in_place.purr
//= require bootstrap
//= require_tree .
//= require jquery_nested_form
//= require highcharts
//= require highcharts/modules/exporting



add = function(student, url) {
   $.getJSON(url,{"student":student}, function(resp){
    
    							// alert("heyyyy");
                                // handle the result
                                //document.getElementById("students['student']").hide();
                                //console.debug("heyyyyy thereee b2aaaaaaaaa");
                                //console.debug("students['student']");
                             
    
});
//alert("ffff");
	//document.getElementById("students["+student+"]").hide();
	a= "students["+student+"]"
	b= "studentsin_"+student
	document.getElementById(a).parentNode.parentNode.style.display="table-row"
	//document.getElementById(a).style.display = 'none';
	document.getElementById(b).parentNode.parentNode.style.display ="none";
    console.debug("heyyyyy thereee b2aaaaaaaaa"+student);
    console.debug("students["+student+"]");
};

remove = function(student, url) {
    $.getJSON(url,{"student":student}, function(resp){
    
    							// alert("heyyyy");
                                // handle the result
                                //document.getElementById("students['student']").hide();
                                //console.debug("heyyyyy thereee b2aaaaaaaaa");
                                //console.debug("students['student']");
                             
    
});
//alert("ffff");
	//document.getElementById("students["+student+"]").hide();
	a= "students["+student+"]"
	b= "studentsin_"+student
	document.getElementById(a).parentNode.parentNode.style.display="none"
	//document.getElementById(a).style.display = 'none';
	document.getElementById(b).parentNode.parentNode.style.display ="table-row";
	document.getElementById(b).checked=false   //uncheck the checkbox
	
    console.debug("heyyyyy thereee b2aaaaaaaaa"+student);
    console.debug("students["+student+"]");
};



