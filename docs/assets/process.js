$(document).ready(function(){
    var e, c = true;
    $(".erb").click(function (){
        if(e == false){
            $(this).attr("value","");
            e = true;
        }else{
            $(this).attr("value","");
            e = false;
        }
    });
     $(".cut").click(function (){
        if(c == false){
            $(this).attr("value","");
            c = true;
        }else{
            $(this).attr("value","");
            c = false;
        }
    });
    $(".xhr").click(function (){
        var x = $(".type").val();
        var erb = $(".erb").val();
        var cut = $(".cut").val();
         x = x.replace(/#/g,"$$$");
         x = x.replace(/;/g,"%%%");
         var xhr = new XMLHttpRequest();
            x = encodeURI(x);
               xhr.open("GET", "http://localhost:1776/try/?q="+x+"&erb="+erb+"&cut="+cut);
            xhr.setRequestHeader("Content-Type", "text/plain");
            xhr.onreadystatechange = function () {
                if(this.readyState == 4){
                    if(this.responseText != null){
                        var doc = xhr.responseText;
                        $(".lies").html(doc);
                    }else{
                        console.log("No response found");
                    }
                }
            };
            xhr.send();
    });
});