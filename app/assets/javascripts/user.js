/**********************************************************/
/* Show unfollow button when mouse over follow button     */
/**********************************************************/

showsUnfollowButton = function() {
  $("a.btn-unfollow").hover(
    function () {
      $(this).addClass("btn-danger");
      $(this).removeClass("btn-success");
    },
    function () {
      $(this).addClass("btn-success");
      $(this).removeClass("btn-danger");
    }
  );
}

jQuery(showsUnfollowButton);


/**********************************************************/
/* Image upload preview                                   */
/**********************************************************/

configurePictureForm = function() {
  $('.upload_picture').hide();
  $('.delete_picture').hide();
  $('.picture_preview').hide();
}

closeOverlayUserForm = function() {
  $('#close-user-form').click(function() {
    $('#user_form').css("display","none");
  });
}

jQuery(previewImageClick);
jQuery(deletePhoto);
jQuery(configurePictureForm);

closeOverlayLoginForm = function() {
  $('.close-login-form').click(function() {
    $('#login-box').css("display","none");
  });
}

