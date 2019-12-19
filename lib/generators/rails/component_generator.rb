# frozen_string_literal: true

require 'rails/generators'

module Rails
  class ComponentGenerator < Rails::Generators::NamedBase

    class_option :skip_erb, type: :boolean, default: false
    class_option :skip_css, type: :boolean, default: false
    class_option :skip_js, type: :boolean, default: false

    source_root File.expand_path('../templates', __FILE__)
    check_class_collision suffix: 'Component'

    def create_component_file
      template('install.rb.erb', "app/components/#{name}_component.rb")
    end

    def create_erb_file
      return if options['skip_erb']

      name_parts = name.split('/')
      file_parts = name_parts[0..-2]
      file_parts << "_#{name_parts.last}.html.erb"

      create_file("app/views/components/#{file_parts.join('/')}")
    end

    def copy_javascript_file
      return if options['skip_js']

      copy_file('install.js', "app/assets/javascripts/components/#{name}.js")
    end

    def copy_stylesheet_file
      return if options['skip_css']

      copy_file('install.scss', "app/assets/stylesheets/components/#{name}.scss")
    end

  end
end
