module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')

        project:
            app: 'www'
            assets: '<%= project.app %>/assets/build'
            css: '<%= project.assets %>/css'
            js: '<%= project.assets %>/js'

        tag:
            banner:
                '/*!\n' +
                ' * <%= pkg.name %>\n' +
                ' * <%= pkg.title %>\n' +
                ' * <%= pkg.url %>\n' +
                ' * @author <%= pkg.author %>\n' +
                ' * @version <%= pkg.version %>\n' +
                ' * Copyright <%= pkg.copyright %>. <%= pkg.license %> licensed.\n' +
                ' */\n'

        sass:
            build:
                options:
                    style: 'expanded'
                    banner: '<%= tag.banner %>'
                    compass: true
                    quiet: false
                files: [
                    'www/assets/build/css/app.css': ['www/modules/**/sass/*']
                ]

        coffee:
            build:
                options:
                    sourceMap: true
                    join: true
                files: [
                    'www/assets/build/js/app.js': ['www/modules/**/coffee/*']
                ]

        bower:
            install:
                options:
                    targetDir: './www/lib/'
                    copy: false
                    layout: 'byComponent'
                    overrideBowerDir: true
                    verbose: true

        connect:
            server:
                options:
                    port: 8080
                    base: 'www'
                    keepalive: true

        watch:
            coffee:
                files: ['www/modules/**/coffee/*']
                tasks: ['coffee']
            sass:
                files: ['www/modules/**/sass/*']
                tasks: ['sass']

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-bower-installer'

    grunt.registerTask 'default', ['coffee', 'sass']
