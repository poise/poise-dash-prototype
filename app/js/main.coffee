d3 = require('d3')

buildGraph = (elm, data) ->
  x = (d, i) ->
    i * 6

  y = (d, i) ->
    if d == 'good'
      0
    else
      11

  applyRect = (graph) ->
    graph
      .attr('class', (d) -> return 'graph-bar graph-'+d)
      .attr('x', x)
      .attr('y', y)

  graph = elm.select('.status-graph')
      .selectAll('.graph-bar')
      .data(data)
  applyRect(graph)
  applyRect(graph.enter().append('rect'))
    .attr('width', 4)
    .attr('height', 10)
  graph.exit()
    .remove()

barGraph = (elm, data) ->
  data = [
    data[0] + data[1] + data[2],
    data[0] + data[1],
    data[0],
  ]
  xScale = d3.scale.linear().domain([0, data[0]]).range([0, 60])
  classScale = d3.scale.ordinal().domain([0, 1, 2]).range(['graph-good', 'graph-nil', 'graph-bad'])
  graph = elm.select('.status-graph g')
    .selectAll('rect')
    .data(data)
  graph
    .attr('width', xScale)
  graph.enter()
    .append('rect')
    .attr('class', (d, i) -> classScale(i))
    .attr('width', xScale)
    .attr('height', 5)
  graph.exit()
    .remove()


buildGraph(d3.select('#project-name .project-travis'), ['good', 'good', 'nil', 'bad', 'bad', 'good', 'good', 'good', 'bad', 'good'])
buildGraph(d3.select('#project-name2 .project-travis'), ['good', 'bad', 'nil', 'nil', 'good', 'good', 'bad', 'bad', 'bad', 'good'])

barGraph(d3.select('#project-name .project-codeclimate'), [4, 20, 18])
barGraph(d3.select('#project-name .project-gemnasium'), [0, 3, 8])
