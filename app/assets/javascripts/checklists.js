// チェック頻度選択欄の表示・非表示
$(function(){
  $("#wday").css("display", "none");
  $("#date").css("display", "none");
  $('[id=checklist_frequency]').change(function(){
    var val = $('[id=checklist_frequency]').val();
    if(val === 'wday'){
      $("#wday").css("display", "block");
      $("#date").css("display", "none");
    }else if(val === 'date'){
      $("#date").css("display", "block");
      $("#wday").css("display", "none");
    }else{
      $("#date").css("display", "none");
      $("#wday").css("display", "none");
    };
  });
});

// 編集画面でのチェック頻度選択欄の表示・非表示
$(function(){
  var frequency = $('select[id="checklist_frequency"] option:selected').val();
  if(frequency == 'wday'){
    $('#wday_edit').css('display', 'block');
    $('#date_edit').css('display', 'none');
  }else if(frequency == 'date'){
    $('#wday_edit').css('display', 'none');
    $('#date_edit').css('display', 'block');
  }else{
    $('#wday_edit').css('display', 'none');
    $('#date_edit').css('display', 'none');
  };
  $('select[id="checklist_frequency"]').on('change', function(){
    var val = $('[id=checklist_frequency]').val();
    if(val === 'wday'){
      $("#wday_edit").css("display", "block");
      $("#date_edit").css("display", "none");
    }
    else if(val === 'date'){
      $("#date_edit").css("display", "block");
      $("#wday_edit").css("display", "none");
    }
    else{
      $("#date_edit").css("display", "none");
      $("#wday_edit").css("display", "none");
    };
  });
});

// チェックリスト登録画面で、リスト項目の入力行追加
$(function(){
  $('.contents_area').on('click', '.add_button', function(){
    $('.content_field:last').append('<div class="col-xs-8 content_input"><input class="form-control" placeholder="追加したいチェック項目を入力してください" type="text" name="text[content][][text]" id="text_content__text"></div><div class="col-xs-2 button_area"><input class="btn btn-default remove_button" type="button" value="削除"></div>');
  });
});

//チェックリスト登録画面で、リスト項目の入力行削除
$(function(){
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
    var checkimg = img.eq(i);
    if(checkimg.attr('id') == 'not_done'){
      var panel = checkimg.parents('div[class="panel panel-default"]');
      panel.css('border', '3px double red');
    };
  };
});

// リスト削除の確認
$(function(){
  $('#list_delete_button').on('click', function(){
    if(!confirm('このリストを削除します。よろしいですか？')){
      return false;
    };
  });
});

//既にチェック済みだったらチェックリストにチェックをいれて、戻るボタンを表示
$(function(){
  var alerttext = $('div.alert').text();
  if(alerttext == '本日チェック済みです。 お疲れ様でした' || alerttext == '本日チェックする必要はございません'){
    $('input[type="checkbox"]').prop("checked",true);
    $('#check_button').replaceWith('<a href="/", type="button", class="btn btn-success">トップに戻る</a>');
  };
});
