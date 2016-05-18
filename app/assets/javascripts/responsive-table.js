/* Responsiveness of html table on adjustment of different heights and widths as per view */
$(window).on('load resize', function () {
  if ($(this).width() < 640) {
    $('table tfoot').hide();
  } else {
    $('table tfoot').show();
  }  
});