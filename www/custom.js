function messageTimeOut() {
    $(".correct-mask, .wrong-mask").click(function(){
        $(".correct-mask, .wrong-mask").fadeOut(300);});
}
function loadImg() {
    el = $(".idol-img");
    for (i = 0; i < el.length; i++) {
        $(el[i]).attr("src", $("#src_" + $(el[i]).attr("id")).attr("src"));
    }
}
