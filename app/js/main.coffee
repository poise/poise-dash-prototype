d3 = require('d3')
$ = require('jquery')

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

  graph = d3.select(elm[0]).select('.status-graph')
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
  xScale = d3.scale.linear().domain([0, data[0]]).range([0, elm.width()])
  classScale = d3.scale.ordinal().domain([0, 1, 2]).range(['graph-good', 'graph-nil', 'graph-bad'])
  graph = d3.select(elm[0]).select('.status-graph g')
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


coverageGraph = (elm, data) ->
  sparklineId = elm.parents('.project').attr('id')
  console.log(sparklineId)
  w = elm.find('.status-graph').width()
  h = elm.find('.status-graph').height()
  xMargin = 4
  yMargin = 4

  y = d3.scale.linear()
              .domain([d3.min(data), d3.max(data)])
              .range([yMargin, h - yMargin])
  x = d3.scale.linear()
              .domain([0, data.length - 1])
              .range([xMargin, w - xMargin])

  gradientY = d3.scale.threshold().domain([50, 90]).range(['#E00', '#FFEE00', '#0A0'])

  percentageMargin = 100 / data.length
  percentageX = d3.scale.linear()
                        .domain([0, data.length - 1])
                        .range([percentageMargin, 100 - percentageMargin])

  vis = d3.select(elm[0]).select('.status-graph')

  g = vis.append("svg:g")
          .attr("stroke", "url(#sparkline-gradient-" + sparklineId + ")")
          .attr("fill", "url(#sparkline-gradient-" + sparklineId + ")")

  line = d3.svg.line()
      .interpolate("linear")
      .x((d, i) -> x(i))
      .y((d) -> h - y(d))

  g.append('svg:path').attr("d", line(data))

  vis.append("svg:defs")
        .append("svg:linearGradient")
        .attr("id", "sparkline-gradient-" + sparklineId)
        .attr("x1", "0%").attr("y1", "0%").attr("x2", "100%").attr("y2", "0%")
        .attr('gradientUnits', "userSpaceOnUse")
        .selectAll(".gradient-stop")
        .data(data)
        .enter()
        .append("svg:stop")
        .attr('offset', (d, i) -> percentageX(i) + "%")
        .attr("style", (d) -> "stop-color:" + gradientY(d) + ";stop-opacity:1")


buildGraph($('#project-name .project-travis'), ['good', 'good', 'nil', 'bad', 'bad', 'good', 'good', 'good', 'bad', 'good'])
buildGraph($('#project-name2 .project-travis'), ['good', 'bad', 'nil', 'nil', 'good', 'good', 'bad', 'bad', 'bad', 'good'])

barGraph($('#project-name .project-codeclimate'), [4, 20, 18])
barGraph($('#project-name .project-gemnasium'), [0, 3, 8])
barGraph($('#project-name2 .project-codeclimate'), [0, 4, 22])
barGraph($('#project-name2 .project-gemnasium'), [0, 0, 12])

coverageGraph($('#project-name .project-codecov'), [100, 100, 100, 95, 98, 80, 81, 82, 83, 95, 98])
coverageGraph($('#project-name2 .project-codecov'), [0, 0, 0, 0, 0, 0, 0, 0, 10, 60, 55, 40, 45, 45, 45])
