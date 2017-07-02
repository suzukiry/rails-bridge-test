/*global $*/
$(document).ready(function() {
//$( document ).ready(function() { // 6,32 5,38 2,34

        console.log(".circliful is called");

    $("#test-circle1").circliful({
       animation: 1,
        animationStep: 5,
        foregroundBorderWidth: 15,
        backgroundBorderWidth: 15,
        percent: 38,
        textSize: 28,
        textStyle: 'font-size: 12px;',
        textColor: '#666',
        multiPercentage: 1,
        percentages: [10, 20, 30]
    });

});