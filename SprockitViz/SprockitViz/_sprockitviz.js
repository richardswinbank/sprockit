/*
 * _sprockitviz.js
 * Copyright (c) 2019 Richard Swinbank (richard@richardswinbank.net)
 * http://richardswinbank.net/
 *
 * JavaScript functions to drive sprocktviz client-side app.
 */

// fire reload event even if we've arrived on the page via the browser's back button
if(performance.navigation.type == 2)
   location.reload(true);

// setContent() is called on load (in JavaScript, bottom of this file)
function setContent() {
  // read node list 
  var nodes = getNodes();

  // get selected node
  var node = getUrlParameter("node");
  if (node === null || node.length == 0)
    node = nodes[0]; // default to first in list if none selected

  // set title & diagram 
  document.getElementById("title").innerHTML = node + "&nbsp;&nbsp;&nbsp;";
  var obj = document.getElementById("diagram");
  obj.outerHTML = obj.outerHTML.replace(/data="(.+?)"/, 'data="' + node + '.svg' + '"');

  // set up autocomplete
  setupAutoComplete(document.getElementById("myInput"), nodes);
};

// getUrlParameter() parses a URL parameter out of a GET-style URL, client-side.
// From https://davidwalsh.name/query-string-javascript.
function getUrlParameter(name) {
  name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
  var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
  var results = regex.exec(location.search);
  return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
};

// setupAutoComplete() sets up auto-complete style searching for Sprockit nodes.
// Tidied up from https://www.w3schools.com/howto/howto_js_autocomplete.asp.
function setupAutoComplete(inp, arr) { // inp = input text field element, arr = array of values to search

  var selectedItemIndex;

  /*
   * add input listener to text field; revises auto-complete dropdown in response to typing
   */ 
  inp.addEventListener(
    "input"
  , function (e) { // function to be executed whenever text field input occurs

      closeAllLists();  // close any open auto-complete list
      var val = this.value;
      if (!val) { return false; }
      selectedItemIndex = -1;

      // create div element to comtain auto-complete list items
      var list = document.createElement("div");
      list.setAttribute("id", this.id + "autocomplete-list");
      list.setAttribute("class", "autocomplete-items");    
      this.parentNode.appendChild(list);  // append the div element as a child of the autocomplete container

      // add items to the auto-complete list by checking array elements and adding matches
      for (let i = 0; i < arr.length; i++) {
        if (arr[i].toUpperCase().includes(val.toUpperCase())) {  // add a list item if the array element contains the text in the input box

          // create a div element containing the matched text 
          var listItem = document.createElement("div");
          var off = arr[i].toUpperCase().indexOf(val.toUpperCase());
          listItem.innerHTML = arr[i].substr(0, off);
          listItem.innerHTML += "<strong>" + arr[i].substr(off, val.length) + "</strong>";  // display matched text in bold
          listItem.innerHTML += arr[i].substr(off + val.length);
          listItem.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";  // input field containing the value of the array element

          // add a click listener to the div element
          listItem.addEventListener(
            "click"
          , function (e) {  // function to be executed when the div is clicked
              inp.value = this.getElementsByTagName("input")[0].value;  // set input field value
              closeAllLists();  // close any open auto-complete list
              document.getElementById("sprockitNodeSelector").submit();  // submit the form
            }
          );

          // add the list item div to the list
          list.appendChild(listItem);
        }
      }
    }
  );

  /*
   * add keydown listener to text field; changes selected list item with up/down cursor keys, submits form with ENTER
   */
  inp.addEventListener(
    "keydown"
  , function (e) {  // function to be executed whenever a key is pressed in the input field
      // get list items
      var x = document.getElementById(this.id + "autocomplete-list");
      if (x) x = x.getElementsByTagName("div");

      if (e.keyCode == 40) {  // DOWN cursor key pressed
        // highlight next element down in list
        selectedItemIndex++;  
        highlightListItem(x);
      } else if (e.keyCode == 38) {  // UP cursor key pressed
        // highlight next element up in list
        selectedItemIndex--;
        highlightListItem(x);
      } else if (e.keyCode == 13) {  // ENTER key pressed
        e.preventDefault();  // don't submit the form directly...
        if (selectedItemIndex > -1 && x)
          x[selectedItemIndex].click();  // ...instead, simulate click on selected element (causing its own click listener to submit the form)
      }
    }
  );

  // helper function to highlight a list item (by adding "autocomplete-active" to its class list for highlighting by CSS)
  function highlightListItem(x) {
    if (!x) return false;

    // remove the "active" class from all items
    for (let i = 0; i < x.length; i++)
      x[i].classList.remove("autocomplete-active");

    // add class "autocomplete-active" to element at selectedItemIndex
    if (selectedItemIndex >= x.length) selectedItemIndex = 0;
    if (selectedItemIndex < 0) selectedItemIndex = (x.length - 1);
    x[selectedItemIndex].classList.add("autocomplete-active");
  }

  // helper function to close all autocomplete lists in the document, except the one passed as an argument
  function closeAllLists(keepOpen) {
    var x = document.getElementsByClassName("autocomplete-items");
    for (let i = 0; i < x.length; i++) {
      if (keepOpen != x[i] && keepOpen != inp) {
        x[i].parentNode.removeChild(x[i]);
      }
    }
  }

  /*
   * add click listener to document; dismisses auto-complete list when user clicks elsewhere on page
   */ 
  document.addEventListener(
    "click"
  , function (e) {
      closeAllLists(e.target);
    }
  );
}

// call setContent() when the window has loaded
window.onload = setContent;
