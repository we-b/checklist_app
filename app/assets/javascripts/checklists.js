"use strict"

function check_wday (wday, date) {
  wday.css('display', 'block');
  date.css('display', 'none');
};

function check_date(wday, date) {
  wday.css('display', 'none');
  date.css('display', 'block');
};

function check_everyday(wday, date) {
  wday.css('display', 'none');
  date.css('display', 'none');
};

// チェック頻度選択欄の表示・非表示
$(function(){
  let $date = $("#date");
  let $wday = $("#wday");
  check_everyday($wday, $date);
  $('[id=checklist_frequency]').change(function(){
    let val = $(this).val();
    if(val === 'wday'){
      check_wday($wday, $date);
    }else if(val === 'date'){
      check_date($wday, $date);
    }else{
      check_everyday($wday, $date);
    };
  });

  // 編集画面でのチェック頻度選択欄の表示・非表示
  let $selectedItem = $('select[id="checklist_frequency"] option:selected')
  let $frequencyList = $('[id="checklist_frequency"]')
  let $frequency = $selectedItem.val();
  let $wdayEdit = $('#wday_edit');
  let $dateEdit = $('#date_edit');
  if($frequency == 'wday'){
    check_wday($wdayEdit, $dateEdit)
  }else if($frequency == 'date'){
    check_date($wdayEdit, $dateEdit)
  }else{
    check_everyday($wdayEdit, $dateEdit)
  };
  $frequencyList.on('change', function(){
    let val = $frequencyList.val();
    if(val === 'wday'){
      check_wday($wdayEdit, $dateEdit)
    }
    else if(val === 'date'){
      check_date($wdayEdit, $dateEdit)
    }
    else{
      check_everyday($wdayEdit, $dateEdit)
    };
  });

  // チェックリスト登録画面で、リスト項目の入力行追加
  let list_count = $('.content_input').length;
  $('.contents_area').on('click', '.add_button', function(){
    $('.content_field:last').append('<div class="col-xs-8 content_input"><input class="form-control" placeholder="追加したいチェック項目を入力してください" type="text" name="checklist[contents_attributes][' + list_count + '][text]" id="checklist_contents_attributes_' + list_count + '_text"></div><div class="col-xs-2 button_area"><input class="btn btn-default remove_button" type="button" value="削除"></div>'
    );
    list_count ++
  });

  //チェックリスト登録画面で、リスト項目の入力行削除
  $('.contents_area').on('click', '.remove_button', function(){
    let count = $('.remove_button').length;
    if(count === 1){
      alert('入力欄が１行のため、削除出来ません。');
    }else{
      let index = Number($('.remove_button').index(this));
    $('.content_input').eq(index).remove();
    $('.button_area').eq(index).remove();
    };
  });


  //本日未チェック分のリスト枠を赤くする
  let img = $('.panel-body div img')
  for(let i = 0; i < img.length; i++){
    let checkimg = img.eq(i);
    if(checkimg.attr('id') == 'not_done'){
      let panel = checkimg.parents('div[class="panel panel-default"]');
      panel.css('border', '3px double red');
    };
  };

  // リスト削除の確認
  $('#list_delete_button').on('click', function(){
    if(!confirm('このリストを削除します。よろしいですか？')){
      return false;
    };
  });

  //既にチェック済みだったらチェックリストにチェックをいれて、戻るボタンを表示
  let alertText = $('div.alert').text();
  if(alertText == '本日チェック済みです。 お疲れ様でした' || alertText == '本日チェックする必要はございません'){
    $('input[type="checkbox"]').prop("checked",true);
    $('#check_button').replaceWith('<a href="/", type="button", class="btn btn-success">トップに戻る</a>');
  };
});
