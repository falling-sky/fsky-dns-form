var files = [ "v6ns","domain","v6ns1"];
var variables = [ "domain","ns","hostmaster","4","6","1280","serial" ];


function update_serial() {
 // Borrowed from http://stackoverflow.com/questions/1531093/how-to-get-current-date-in-javascript
 // http://stackoverflow.com/users/525895/samuel-meddows
 var today = new Date();
 var dd = today.getDate();
 var mm = today.getMonth()+1; //January is 0!
 var yyyy = today.getFullYear();
 
 if(dd<10) {
     dd='0'+dd
 } 
     
 if(mm<10) {
   mm='0'+mm
 } 
 $("#form_serial").val(   yyyy + mm + dd );        

}

function update_templates() {
  try {
    update_serial();
  } catch (err) {
  }

  for (i=0; i < files.length; i++) {
    file = files[i];
    template = templates[file];
    
    
    for (j=0; j < variables.length; j++) {
        variable = variables[j];
        find = "#form_" + variable;
        found = $(find).val();
        if (found.length > 0) {
          re = new RegExp('[$]argv[{]' + variable + '[}]','gi');
          template = template.replace(re,found);
        }
    }
    divid = '#code_' + file;
    jQuery(divid).text(template);
  }
}

function set_handlers() {
    for (j=0; j < variables.length; j++) {
        variable = variables[j];
        find = "#form_" + variable;
        $(find).change(update_templates)
        $(find).blur(update_templates)
    }
}


$( document ).ready(function() {
     // Your code here.
     set_handlers();
     update_templates();
});
      