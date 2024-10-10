//= require vendor/d3.v7.min.js

window.onload = function() {
  var container = document.getElementById('container')
  var data = JSON.parse(container.getAttribute('data-rows'))

  var firstel = data[0]
  var lastel = data[data.length - 1]
  var min = 0
  var max = 0
  data.forEach(el => {
    console.log(el)
    if (el["value"] > max) {
      max = el["value"]
    }
  })

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

  // Append the SVG element.
  container.append(svg.node());
};
