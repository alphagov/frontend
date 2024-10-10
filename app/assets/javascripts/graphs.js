//= require vendor/d3.v7.min.js

window.onload = function() {
  var container = document.getElementById('container')
  var data = JSON.parse(container.getAttribute('data-rows'))
  console.log(data)

  var firstel = data[0]
  var lastel = data[data.length - 1]
  // FIXME would be good if the data already contained the ranges for the axes
  var min = 0
  var max = 0
  var actualData = []
  data.forEach(el => {
    console.log(el)
    actualData.push([el["Date"], el["value"]])
    if (el["value"] > max) {
      max = el["value"]
    }
  })
  console.log(actualData)

  // Declare the chart dimensions and margins.
  const width = 640;
  const height = 400;
  const marginTop = 20;
  const marginRight = 20;
  const marginBottom = 30;
  const marginLeft = 40;

  // Declare the x (horizontal position) scale.
  const x = d3.scaleUtc()
      .domain([new Date(firstel["Date"]), new Date(lastel["Date"])])
      .range([marginLeft, width - marginRight]);

  // Declare the y (vertical position) scale.
  const y = d3.scaleLinear()
      .domain([min, max])
      .range([height - marginBottom, marginTop]);

  // Create the SVG container.
  const svg = d3.create("svg")
      .attr("width", width)
      .attr("height", height);

  // Add the x-axis.
  svg.append("g")
      .attr("transform", `translate(0,${height - marginBottom})`)
      .call(d3.axisBottom(x));

  // Add the y-axis.
  svg.append("g")
      .attr("transform", `translate(${marginLeft},0)`)
      .call(d3.axisLeft(y));

  // Declare the line generator.
  // const line = d3.line()
  //     .x(d => x(d.date))
  //     .y(d => y(d.close));

  var xScale = d3.scaleLinear().domain([0, 100]).range([0, width])
  var yScale = d3.scaleLinear().domain([0, 200]).range([height, 0])

  var dataset1 = [
    [1,1], [12,20], [24,36],
    [32, 50], [40, 70], [50, 100],
    [55, 106], [65, 123], [73, 130],
    [78, 134], [83, 136], [89, 138],
    [100, 140]
];

  svg.append('g')
  .selectAll("dot")
  .data(dataset1)
  .enter()
  .append("circle")
  .attr("cx", function (d) { return xScale(d[0]); } )
  .attr("cy", function (d) { return yScale(d[1]); } )
  .attr("r", 2)
  .attr("transform", "translate(" + 100 + "," + 100 + ")")
  .style("fill", "#CC0000");

  // var line = d3.line()
  //   .x(function(d) { return xScale(d[0]); })
  //   .y(function(d) { return yScale(d[1]); })
  //   .curve(d3.curveMonotoneX)

  // svg.append("path")
  //   .datum(data)
  //   .attr("class", "line")
  //   .attr("transform", "translate(" + 100 + "," + 100 + ")")
  //   .attr("d", line)
  //   .style("fill", "none")
  //   .style("stroke", "#CC0000")
  //   .style("stroke-width", "2");

  // Append the SVG element.
  container.append(svg.node());
};
