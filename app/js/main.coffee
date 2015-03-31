d3 = require('d3')

x = (d, i) ->
  i * 6

y = (d, i) ->
  if d == 'good'
    0
  else
    11

g = d3.select('#project-name .project-travis .status-graph')
      .selectAll('.graph-bar')
      .data(['good', 'good', 'nil', 'bad', 'bad', 'good', 'good', 'good'])
g.attr('class', (d) -> return 'graph-'+d)
  .attr('x', x).attr('y', y)
g.enter().append('rect').attr('width', 4).attr('height', 10)
  .attr('class', (d) -> return 'graph-'+d)
  .attr('x', x).attr('y', y)
g.exit().remove()
