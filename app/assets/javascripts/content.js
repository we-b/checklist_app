"use strict"

//チェック完了or未チェックありを判断
$(function(){
  $('#check_button').on('click', function(){
    let checked = $('input[id="text"]:checked').length;
    let contents = $('input[id="text"]').length;
    if(checked === contents){
      alert('チェック完了です！ お疲れ様でした。');
    }else{
      if(!confirm('チェックに漏れがあります。 完了してしまってもよろしいですか？')){
        return false;
      };
    }
  });
});
