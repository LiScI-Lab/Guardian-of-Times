function copyToken() {
  /* Get the text field */
  var copyText = document.getElementById("tokenField");

  /* Select the text field */
  copyText.select();
  copyText.setSelectionRange(0, 99999); /*For mobile devices*/

  /* Copy the text inside the text field */
  var status = document.execCommand("copy");

  /* Alert the copied text */
  alert("Copied to Clipboard: " + copyText.value);
  console.log("Copy status: " + status);
}
