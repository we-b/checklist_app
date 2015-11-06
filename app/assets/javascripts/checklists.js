// チェック頻度選択欄の表示・非表示
$(document).ready(function(){
  $("#wday").css("display", "none");
  $("#date").css("display", "none");
  $('[id=checklist_frequency]').change(function(){
    var val = $('[id=checklist_frequency]').val();
    if(val === 'wday'){
      $("#wday").css("display", "block");
      $("#date").css("display", "none");
    }
    else if(val === 'date'){
      $("#date").css("display", "block");
      $("#wday").css("display", "none");
    }
    else{
      $("#date").css("display", "none");
      $("#wday").css("display", "none");
    }
  });
});

// チェックリスト登録画面で、リスト項目の入力行追加
$(document).ready(function(){
  $('.contents_area').on('click', '.add_button', function(){
    $('.content_field:last').append('<div class="col-xs-8 content_input"><input class="form-control" placeholder="追加したいチェック項目を入力してください" type="text" name="text[content][][text]" id="text_content__text"></div><div class="col-xs-2 button_area"><input class="btn btn-default remove_button" type="button" value="削除"></div>');
  });
});


//  チェックリスト登録画面で、リスト項目の入力行削除
$(document).ready(function(){
  $('.contents_area').on('click', '.remove_button', function(){
    var count = $('.remove_button').length;
    if(count === 1){
      alert('入力欄が１行のため、削除出来ません。');
    }else{
      var index = Number($('.remove_button').index(this));
    $('.content_input').eq(index).remove();
    $('.button_area').eq(index).remove();
    };
  });
});

//本日未チェック分のリスト枠を赤くする
$(function(){
  var img = $('.panel-body div img')
  for(i=0; i<img.length; i++){
    var checkimg = img.eq(i)
    if(checkimg.attr('id') == 'not_done'){
      var panel = checkimg.parents('div[class="panel panel-default"]');
      panel.css('border', '3px double red');
    };
  };
});
