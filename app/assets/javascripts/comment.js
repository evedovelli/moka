autoExpand = function(selector) {
  $(selector).each(function () {
    this.setAttribute('style', 'height:' + (this.scrollHeight) + 'px;overflow-y:hidden;');
  }).on('input', function () {
    this.style.height = 'auto';
    this.style.height = (this.scrollHeight) + 'px';
  });
}

newComment = function(selector) {
  $(selector).find(".new-comment").focus(function() {
    $(this).closest(".option-outer-box").find(".btn-comments").click();
  });
}

function newComments () {
  $( ".new-comment" ).focus(function() {
    $(this).closest(".option-outer-box").find(".btn-comments").click();
  });
}

jQuery(newComments);
