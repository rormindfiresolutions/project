/* Not allowing a button to perform different action on subsequent clicks */
function clickAndDisable(link) {
    // disable subsequent clicks
    link.onclick = function(event) {
       event.preventDefault();
    }
  };   