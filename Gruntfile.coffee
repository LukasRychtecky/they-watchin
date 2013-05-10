module.exports = (grunt) ->

  coffeeScripts = [
#    'bower_components/este-library/**/*.coffee'
#    '!bower_components/este-library/Gruntfile.coffee'
#    '!bower_components/este-library/node_modules/**/*.coffee'
    'client/**/*.coffee'
  ]

  clientDirs = [
    'bower_components/closure-library'
#    'bower_components/este-library'
    'client'
  ]

  clientDepsPath = 'client/deps.js'
  clientDepsPrefix = '../../../../'

  jsWatchTasks = [
    'esteDeps:all'
    'esteUnitTests:app'
  ]
  if grunt.option 'stage'
    jsWatchTasks.push 'esteBuilder:app'

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-este'

  grunt.initConfig
    clean:
      app:
        options:
          force: true
        src: [
          'bower_components/este-library/**/*.css'
          'bower_components/este-library/**/*.js'
          '!bower_components/este-library/node_modules/**/*.js'
          'client/**/*.js'
        ]

    coffee:
      options:
        bare: true
      app:
        files: [
          expand: true
          src: coffeeScripts
          ext: '.js'
        ]

    coffee2closure:
      app:
        files: [
          expand: true
          src: coffeeScripts
          ext: '.js'
        ]

    esteDeps:
      all:
        options:
          outputFile: clientDepsPath
          prefix: clientDepsPrefix
          root: clientDirs

    esteBuilder:
      options:
        root: clientDirs
        depsPath: clientDepsPath
        compilerFlags: if grunt.option('stage') == 'debug' then [
          '--output_wrapper="(function(){%output%})();"'
          '--compilation_level="ADVANCED_OPTIMIZATIONS"'
          '--warning_level="VERBOSE"'
          '--define=goog.DEBUG=true'
          '--debug=true'
          '--formatting="PRETTY_PRINT"'
        ]
        else [
            '--output_wrapper="(function(){%output%})();"'
            '--compilation_level="ADVANCED_OPTIMIZATIONS"'
            '--warning_level="VERBOSE"'
            '--define=goog.DEBUG=false'
          ]

      app:
        options:
          namespace: 'app.start'
          outputFilePath: 'client/spot.js'

    esteUnitTests:
      options:
        depsPath: clientDepsPath
        prefix: clientDepsPrefix
      app:
        src: [
          'bower_components/este-library/**/*_test.js'
          '!bower_components/este-library/node_modules/**/*.js'
          'client/**/*_test.js'
        ]

    coffeelint:
      options:
        no_backticks:
          level: 'ignore'
        max_line_length:
          level: 'ignore'
      all:
        files: [
          expand: true
          src: coffeeScripts
        ]

  # remember, sudo ulimit -n 10000 github.com/gruntjs/grunt-contrib-watch#how-do-i-fix-the-error-emfile-too-many-opened-file
    watch:
      options:
        nospawn: true
        livereload: true

      coffee:
        files: coffeeScripts
        tasks: [
          'coffee:app'
          'coffee2closure:app'
        ].concat jsWatchTasks

  # ensure only changed files are compiled
  grunt.event.on 'watch', (action, filepath) ->
    fileExtension = filepath.split('.')[1]
    switch fileExtension
      when 'coffee'
        coffeeArgs = [
          expand: true
          src: filepath
          ext: '.js'
        ]
        grunt.config ['coffee', 'app', 'files'], coffeeArgs
        grunt.config ['coffee2closure', 'app', 'files'], coffeeArgs
        grunt.config ['esteUnitTests', 'app', 'src'], filepath

  grunt.registerTask 'build', 'Build app.', (app) ->
    tasks = [
      "clean:#{app}"
      "coffee:#{app}"
      "coffee2closure:#{app}"
      "coffeelint"
      "esteDeps"
      "esteUnitTests:#{app}"
    ]
    if grunt.option 'stage'
      tasks.push "cssmin:#{app}"
      tasks.push "esteBuilder:#{app}"
    grunt.task.run tasks

  grunt.registerTask 'run', 'Build app and run watchers.', (app) ->
    tasks = [
      "build:#{app}"
      "watch"
    ]
    grunt.task.run tasks

  grunt.registerTask 'default', 'run:app'
  grunt.registerTask 'test', 'build:app'
