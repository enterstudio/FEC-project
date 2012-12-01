var data1 = [110.69033, 52.44986, 218.33799, 118.21271, 367.05700, 202.21211, 3167.76801, 2683.36407, 4403.78334, 3910.41376, 13117.70564]
var data2 = [197.56814, 95.64615, 295.50100, 167.45441, 545.53937, 309.21652, 4481.62560, 2997.94320, 5852.16369, 4793.03715, 13438.54307]

var w = 600;
var h = 500;
var barPadding = 12;			

var chart1 = d3.select("body").append("svg")
  .attr("class", "chart1")
  .attr("width", w)
  .attr("height", h);


chart1.selectAll("rect")
 .data(data1)
 .enter().append("rect")
  .attr("x", function(d, i) {
  return i * (w / data1.length - (3/barPadding));
  })
  .attr("y", function(d) {
  return h - .5;
  })
  .attr("width", (w / data1.length - barPadding))
  
  .transition().delay(function (d,i){
  return i * 200
  ;})
  .duration(200)
  .attr("height", function(d) {
  	return (d/30)
  ;})
  .attr("y", function(d) {
  	return (h - (d/30));
  });
	  
var chart2 = d3.select("body").append("svg")
  .attr("class", "chart2")
  .attr("width", w)
  .attr("height", h);
  
chart2.selectAll("rect")
 .data(data2)
 .enter().append("rect")
  .attr("x", function(d, i) {
  return i * (w / data2.length - (3/barPadding));
  })
  .attr("y", function(d) {
  return h - .5;
  })
  .attr("width", (w / data2.length - barPadding))
  
  .transition().delay(function (d,i){
  return i * 200
  ;})
  .duration(200)
  .attr("height", function(d) {
  	return (d/30)
  ;})  .attr("y", function(d) {
  	return (h - (d/30));
  });
	
chart1.append("line")
  .attr("x1", 0)
  .attr("x2", 700)
  .attr("y1", 500)
  .attr("y2", 500)
  .style("stroke", "#626262")
  .style("stroke-width", "2");
  
 