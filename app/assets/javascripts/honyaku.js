/*global $*/
$(document).ready(function(){
    
    $(".honyaku_start").click(function() {
        $("#honyaku_startpage").fadeOut();

        $("#honyaku_test").delay(800).fadeIn();
/*
        $("#honyaku_test").fadeIn(800, function(){

            var $container = $('.masonry-parent');
            $container.imagesLoaded( function() {
              $container.masonry({
                itemSelector : '.run-masonry'
              });
            });
        });*/
    });
    
    $(".honyaku_submit").click(function() {
        $("#honyaku_submit").fadeOut();

//        $("#honyaku_submit").fadeOut(100, function(){
//        });

    });
});


