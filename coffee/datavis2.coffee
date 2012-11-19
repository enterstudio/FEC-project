class BubbleChart
  constructor: (data) ->
    @data = data
    @width = 940
    @height = 600

    @tooltip = CustomTooltip("gates_tooltip", 240)

    @center = {x: @width / 2, y: @height / 2}

    @layout_gravity = -0.01
    @damper = 0.1

    @vis = null
    @nodes = []
    @force  = null
    @circles = null

    # Changed colors to political themes
    @fill_color = d3.scale.ordinal()
      .domain(["Conservative", "Liberal"])
      .range(["#E3170D", "#4169E1"])

    max_amount = d3.max(@data, (d) -> parseInt(d.Liberal+d.Conservative))
    @radius_scale = d3.scale.pow().exponent(0.5).domain([0, max_amount]).range([2,99])
    
    this.create_nodes()
    this.create_vis()

  create_nodes: () =>
    @data.forEach (d) =>
      node = {
        id: d.id
        radius: @radius_scale(parseInt(d.Liberal+d.Conservative))
        value: d.Liberal+d.Conservative
        name: d.group
        liberal: d.Liberal
        conservative: d.Conservative
        x: Math.random() * 900
        y: Math.random() * 800
      }
      
      @nodes.push node

    @nodes.sort (a,b) -> b.value - a.value


  # create svg at #vis and then 
  # create circle representation for each node
  create_vis: () =>
    @vis = d3.select("#vis").append("svg")
      .attr("width", @width)
      .attr("height", @height)
      .attr("id", "svg_vis")

    @node.enter = d3.select("nodes").append("rect")
      .attr("class", "g-overlay")
      .attr("width", width)
      .attr("height", height)

  democratEnter = nodeEnter.append("g").attr("class", "g-democrat")
  democratEnter.append("clipPath").attr("id", (d) ->
    "g-clip-democrat-" + d.id
  ).append "rect"
  democratEnter.append "circle"
  republicanEnter = nodeEnter.append("g").attr("class", "g-republican")
  republicanEnter.append("clipPath").attr("id", (d) ->
    "g-clip-republican-" + d.id
  ).append "rect"
  republicanEnter.append "circle"
  nodeEnter.append("line").attr "class", "g-split"
  node.selectAll("rect").attr("y", (d) ->
    -d.r - clipPadding
  ).attr "height", (d) ->
    2 * d.r + 2 * clipPadding

  node.select(".g-democrat rect").style("display", (d) ->
    (if d.k > 0 then null else "none")
  ).attr("x", (d) ->
    -d.r - clipPadding
  ).attr "width", (d) ->
    2 * d.r * d.k + clipPadding

  node.select(".g-republican rect").style("display", (d) ->
    (if d.k < 1 then null else "none")
  ).attr("x", (d) ->
    -d.r + 2 * d.r * d.k
  ).attr "width", (d) ->
    2 * d.r

  node.select(".g-democrat circle").attr "clip-path", (d) ->
    (if d.k < 1 then "url(#g-clip-democrat-" + d.id + ")" else null)

  node.select(".g-republican circle").attr "clip-path", (d) ->
    (if d.k > 0 then "url(#g-clip-republican-" + d.id + ")" else null)

  node.select(".g-split").attr("x1", (d) ->
    -d.r + 2 * d.r * d.k
  ).attr("y1", (d) ->
    -Math.sqrt(d.r * d.r - Math.pow(-d.r + 2 * d.r * d.k, 2))
  ).attr("x2", (d) ->
    -d.r + 2 * d.r * d.k
  ).attr "y2", (d) ->
    Math.sqrt d.r * d.r - Math.pow(-d.r + 2 * d.r * d.k, 2)

  node.selectAll("circle").attr "r", (d) ->
    r d.count

fraction = (a, b) ->
  k = a / (a + b)
  if k > 0 and k < 1
    t0 = undefined
    t1 = Math.pow(12 * k * Math.PI, 1 / 3)
    i = 0 # Solve for theta numerically.

    while i < 10
      t0 = t1
      t1 = (Math.sin(t0) - t0 * Math.cos(t0) + 2 * k * Math.PI) / (1 - Math.cos(t0))
      ++i
    k = (1 - Math.cos(t1 / 2)) / 2
  k


    # radius will be set to 0 initially.
    # see transition below

  show_details: (data, i, element) =>
    d3.select(element).attr("stroke", "black")
    content = "<span class=\"name\">Title:</span><span class=\"value\"> #{data.name}</span><br/>"
    content +="<span class=\"name\">Amount:</span><span class=\"value\"> $#{addCommas(data.value)}</span><br/>"
    content +="<span class=\"name\">Leaning</span><span class=\"value\"> #{data.leaning}</span>"
    @tooltip.showTooltip(content,d3.event)


  hide_details: (data, i, element) =>
    d3.select(element).attr("stroke", (d) => d3.rgb(@fill_color(d.leaning)).darker())
    @tooltip.hideTooltip()


root = exports ? this

$ ->
  chart = null

  render_vis = (csv) ->
    chart = new BubbleChart csv
    chart.start()
    root.display_all()
  root.display_all = () =>
    chart.display_group_all()

  d3.csv "data/FEC_new_short.csv", render_vis