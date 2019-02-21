$(document).ready(function(){
    $("#theme").click(function (){
        $(".pop-menu").toggleClass("active");
        $(this).toggleClass("fa-close fa-bars");
    });
    $(".pop-menu li a").click(function(){
        var tg = $(this).attr("data-target");
        if (tg == "#one"){
            $("#two").removeClass("active");
        }else{
            $("#one").removeClass("active");
        }
        $(tg).toggleClass("active");
    })
    $(".table").hide();
    $(".tagged").click(function (){
        $(".table").slideToggle(600);
    })
});