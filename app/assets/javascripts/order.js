$(function () {
  $('#datetimepicker1').datetimepicker({});

  $('#order-search-date').click(function (evt) {
    var date = $('#datetimepicker1').data().date
    if (typeof date !== 'undefined') {
      d = new Date(date)
      dest_date = d.getFullYear().toString() + '-' + (d.getMonth() + 1).toString() + '-' + d.getDate().toString()
      new_url = $(evt.currentTarget).attr('href') + '?select_date=' + dest_date
      window.location.href = new_url;
    }
    else {
      alert("Please select date")
    }
    return false;
  });
});
