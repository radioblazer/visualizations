
function loadChart(year, gender) {
    var series = [];
    var year;
    d3.json("1850_male.json", function(data) {

        for(var i = data.length -1 ; i >= 0; i--) {
            series.push({
                x:data[i].age, y:data[i].people
            });
        }
        year = "1850";
        var output = [
            {
                key: year,
                values: series
            }
        ];
        renderRightChart(output);
        renderLeftChart(output);


    });
}

function renderRightChart(data) {
    nv.addGraph(function() {
        var chart = nv.models.multiBarHorizontalChart()
        .showLegend(false)
        .showControls(false)
        .margin({top: 40, right: 40, bottom: 40, left: 40})

        ;

        chart.yAxis
            .axisLabel("Female population")
            .tickFormat(d3.format("d"))
            ;

        // chart.xAxis
        //    .axisLabel("X-axis Label")
        //    ;

        d3.select("#rightChart")
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

function renderLeftChart(data) {
    nv.addGraph(function() {
        var chart = nv.models.multiBarHorizontalChart()
        .showLegend(false)
        .showControls(false)
        .margin({top: 40, right: 40, bottom: 40, left: 40})

        ;

        chart.yAxis
            .axisLabel("Male population")
            .tickFormat(d3.format("d"))
            ;

        // chart.xAxis
        //    .axisLabel("X-axis Label")
        //    ;

        d3.select("#leftChart")
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

loadChart();