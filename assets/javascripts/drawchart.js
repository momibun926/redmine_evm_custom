function drawChart(dataToChart, placeholder, nowdate){ 
    var data = dataToChart;
    var chartOptions = {
            credits:{
                enabled: false
            },
            chart:{
                renderTo: placeholder,
                type: 'spline',
                zoomType: 'x'
            },
            title:{
                text: "",
                align: "left"
            },
            xAxis:{
                type: 'datetime',
                dateTimeLabelFormats:{
                    month: '%e. %b',
                    year: '%b'
                },
                plotLines: [{
                    color: '#FFAAAA',
                    width: 1,
                    value: nowdate,
                    label: {
                        text: 'Project is here',
                        verticalAlign: 'bottom',
                        textAlign: 'right',
                        y: -10
                    }
                }]
            },          
            yAxis:{
                min: 0,
                minorGridLineWidth: 0,
                minorTickInterval: 'auto',
                minorTickLength: 10,
                minorTickWidth: 1,
                plotLines:[{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip:{
                valueDecimals: 2, 
                crosshairs: true,
                shared: true
            },
            plotOptions:{
                spline: {
                    lineWidth: 2,
                    states: {
                        hover: {
                            lineWidth: 3
                        }
                    },
                    marker: {
                        enabled: false
                    }
                }
            },
            legend:{
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0,
                itemDistance: 50
            },
            series:[
                {
                    name: 'PV',
                    color: '#0f75bc',
                    data: data.planned_value
                },
                {
                    name: 'AC', 
                    color: '#fcb040',
                    data: data.actual_cost
                },
                {
                    name: 'EV', 
                    color: '#8cc63f',
                    data: data.earned_value
                },
                {
                    name: 'BAC', 
                    dashStyle: 'dash',
                    lineWidth: 1,
                    data: data.bac_top_line
                },
                {
                    name: 'EAC', 
                    dashStyle: 'dash',
                    lineWidth: 1,
                    data: data.eac_top_line
                },
                {
                    name: 'AC Forecast',
                    color: '#fcb040', 
                    dashStyle: 'dot',
                    data: data.actual_cost_forecast
                },
                {
                    name: 'EV Forecast', 
                    color: '#8cc63f',
                    dashStyle: 'dot',
                    data: data.earned_value_forecast
                }
            ]
      };
      var lg1 = new Highcharts.Chart(chartOptions);

}
