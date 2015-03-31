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

browserify = require('browserify')
gulp = require('gulp')
bower = require('gulp-bower')
less = require('gulp-less')
gls = require('gulp-live-server')
modernizr = require('gulp-modernizr')
rename = require('gulp-rename')
sourcemaps = require('gulp-sourcemaps')
uglify = require('gulp-uglify')
transform = require('vinyl-transform')


gulp.task 'bower', ->
  bower()

gulp.task 'css', ['bower'], ->
  gulp.src('app/css/**/*.less')
    .pipe(sourcemaps.init())
    .pipe(less(paths: 'bower_components'))
    .pipe(sourcemaps.write('maps', includeContent: false, sourceRoot: '/_src/app/css'))
    .pipe(gulp.dest('_static/css'))

gulp.task 'fonts', ['bower'], ->
  gulp.src('bower_components/font-awesome/fonts/*')
    .pipe(gulp.dest('_static/fonts'))

gulp.task 'modernizr', ->
  gulp.src('app/js/*.coffee')
    .pipe(modernizr())
    .pipe(uglify())
    .pipe(gulp.dest('_static/js'))

gulp.task 'js', ['bower', 'modernizr'], ->
  gulp.src('app/js/main.coffee')
    .pipe transform (filename) ->
      b = browserify(entries: filename, debug: true, extensions: ['.coffee'])
      b.bundle()
    .pipe(sourcemaps.init(loadMaps: true))
    .pipe(uglify())
    .pipe(rename(extname: '.js'))
    .pipe(sourcemaps.write('maps', includeContent: false, sourceRoot: '/_src'))
    .pipe(gulp.dest('_static/js/'))

gulp.task 'serve', ->
  server = gls.new('index.js')
  server.start()
  gulp.watch(['_static/**/*.css', '_static/**/*.js'], server.notify)
  gulp.watch('src/**/*.coffee', server.start)

