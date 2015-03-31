#
# Copyright 2015, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

express = require('express')
morgan = require('morgan')
exphbs  = require('express-handlebars')

app = express()
app.engine('.hbs', exphbs(extname: '.hbs'))
app.set('view engine', '.hbs')
app.use(morgan('dev'))
app.use('/static', express.static(__dirname + '/../_static'))
if process.env.server_ENV == 'development'
  app.use(require('connect-livereload')())
  app.use('/_src', express.static(__dirname + '/../'))

app.get '/', (req, res) ->
  res.render('index')

app.listen(process.env.PORT or 3000)
