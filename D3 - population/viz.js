
function displayData() {
    var series1 = [];
    var series2 = [];

    var year;
    d3.json("1850.json", function(data) {
        console.log(data);
        console.log(data.length);
        console.log(data[0]);

        for(var i = data[0].values.length - 1; i >= 0; i--) {
            series1.push({
                x:data[0].values[i].age, y:data[0].values[i].people
            });
        }
        for(var i = data[1].values.length - 1; i >= 0; i--) {
            series2.push({
                x:data[1].values[i].age, y:data[1].values[i].people
            });
        }
        var output = [
            {
                key: "Males",
                values: series1
            },
            {
                key: "Females",
                values:series2
            }
        ];
        console.log(output);
        renderChart(output);
    });
}

function renderChart(data) {
    nv.addGraph(function() {
        var chart = nv.models.multiBarHorizontalChart()
        .showLegend(false)
        .showControls(false)
        .stacked(true)
        .margin({top: 40, right: 40, bottom: 40, left: 40})
        ;

        chart.yAxis
            .axisLabel("# of people")
            .tickFormat(d3.format("d"))
            ;

        // chart.xAxis
        //    .axisLabel("X-axis Label")
        //    ;

        d3.select("#chart svg")
            .datum(data)
            .transition().duration(500).call(chart);

        // nv.utils.windowResize(
        //         function() {
        //             chart.update();
        //         }
        //     );

        return chart;
    });
}

displayData();