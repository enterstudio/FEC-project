Network = () ->
  width = 960
  height = 800
  # ...
  
  groupCenters = null
  
  groupBy = (d) ->
  	d.group
  
  network = (selection, data) ->
    # main implementation
    
# called once to clean up raw data and switch links to
# point to node instances
# Returns modified data
setupData = (data) ->
  # initialize circle radius scale
  countExtent = d3.extent(data.nodes, (d) -> d.total)
  circleRadius = d3.scale.sqrt().range([3, 12]).domain(countExtent)

  data.nodes.forEach (n) ->
    # set initial x/y to values within the width/height
    # of the visualization
    n.x = randomnumber=Math.floor(Math.random()*width)
    n.y = randomnumber=Math.floor(Math.random()*height)
    # add radius to the node so we can use it later
    n.radius = circleRadius(n.total)

  # id's -> node objects
  nodesMap  = mapNodes(data.nodes)

  # switch links to point to node objects instead of id's
  data.links.forEach (l) ->
    l.source = nodesMap.get(l.source)
    l.target = nodesMap.get(l.target)

    # linkedByIndex is used for link sorting
    linkedByIndex["#{l.source.id},#{l.target.id}"] = 1

  data

  update = () ->
	curNodesData = filterNodes(allData.nodes)
	curLinksData = filterLinks(allData.links, curNodesData)

	force.nodes(curNodesData)
	updateNodes()

	force.links(curLinksData)
	updateLinks()
	
	# enter/exit display for nodes
updateNodes = () ->
  node = nodesG.selectAll("circle.node")
    .data(curNodesData, (d) -> d.id)

  node.enter().append("circle")
    .attr("class", "node")
    .attr("cx", (d) -> d.x)
    .attr("cy", (d) -> d.y)
    .attr("r", (d) -> d.radius)
    .style("fill", (d) -> nodeColors(d.artist))
    .style("stroke", (d) -> strokeFor(d))
    .style("stroke-width", 1.0)

  node.on("mouseover", showDetails)
    .on("mouseout", hideDetails)

  node.exit().remove()

# enter/exit display for links
updateLinks = () ->
  link = linksG.selectAll("line.link")
    .data(curLinksData, (d) -> "#{d.source.id}_#{d.target.id}")
  link.enter().append("line")
    .attr("class", "link")
    .attr("stroke", "#ddd")
    .attr("stroke-opacity", 0.8)
    .attr("x1", (d) -> d.source.x)
    .attr("y1", (d) -> d.source.y)
    .attr("x2", (d) -> d.target.x)
    .attr("y2", (d) -> d.target.y)

  link.exit().remove()

  network.toggleLayout = (newLayout) ->
    setLayout

  return network
  
  $ ->
  myNetwork = Network()
  # ...

  d3.json "data/songs.json", (json) ->
    myNetwork("#vis", json)