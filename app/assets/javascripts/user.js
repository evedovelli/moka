
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

