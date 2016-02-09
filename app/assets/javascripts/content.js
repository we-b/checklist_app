//チェック完了or未チェックありを判断
$(function(){
  $('#check_button').on('click', function(){
     var totalNum = $("#check_content :input").length;
     var checkedNum = $("#check_content :checked").length;
    if(checkedNum === totalNum){
      alert('チェック完了です！ お疲れ様でした。');
    }else{
      if(!confirm('チェックに漏れがあります。 完了してしまってもよろしいですか？')){
        return false;
      };
    }
  });
});
