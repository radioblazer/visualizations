
function displayData(year) {
    console.log(year);
    year = parseInt(year);
    console.log(year);
    var series1 = [];
    var series2 = [];

    var year;
    d3.json("data.json", function(data) {
        console.log(data);
        console.log(data.length);
        console.log(data[0]);

        for(var i = data.length-1; i >= 0; i--) {
            if (data[i].year === year && data[i].sex === 1) {
                series1.push({
                    x:data[i].age, y:data[i].people
                });  
            } 
            else if (data[i].year === year && data[i].sex === 2)  {
                series2.push({
                    x:data[i].age, y: -Math.abs(data[i].people)
                }); 
            }
        }

        var output = [
            {
                key: "Males",
                values: series1
            },
            {
                key: "Females",
                values: series2
            }
        ];
        
        renderChart(output);
        $('#centerLabel').text(year);
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

         nv.utils.windowResize(
                 function() {
                     chart.update();
                 }
             );

        return chart;
    });
}
$(document).ready(function() {
        $('.btn-default').click(function() {
            displayData($(this).attr("value"));
        });
});

displayData(1850);
