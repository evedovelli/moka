
jQuery(function() {
  var data, stuffsChart;
  data = $('#data_stuffs').data('stuffs');
  if (data) {
    return stuffsChart = new Chart($("#canvas_stuffs").get(0).getContext("2d")).Pie(data, {});
  }
});

jQuery(function() {
  var data, hoursChart;
  data = $('#data_hours').data('hours');
  if (data) {
    return hoursChart = new Chart($("#canvas_hours").get(0).getContext("2d")).Bar(data, {
      responsive: true,
      maintainAspectRatio: true,
      scaleGridLineColor : "rgba(0,0,0,.1)",
      barValueSpacing : 3,
    });
  }
});

