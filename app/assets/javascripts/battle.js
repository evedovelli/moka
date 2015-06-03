
jQuery(function() {
  var data, optionsChart;
  data = $('#data_options').data('options');
  if (data) {
    return optionsChart = new Chart($("#canvas_options").get(0).getContext("2d")).Pie(data, {});
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

