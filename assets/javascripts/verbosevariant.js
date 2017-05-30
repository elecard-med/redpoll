$(document).ready(function(){
  $(".more-info").click(function(){
    $(this).next().toggle();
  });
  $(".close-verbose").click(function(){
    $(this).closest(".verbose-variant").toggle();
  });
});
