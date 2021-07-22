# frozen_string_literal: true

module Rails
  class ComponentGenerator < Rails::Generators::NamedBase

    source_root File.expand_path('../templates', __FILE__)
    check_class_collision suffix: 'Component'

    class_option :skip_erb, type: :boolean, default: false
    class_option :skip_css, type: :boolean, default: false
    class_option :skip_js, type: :boolean, default: false

    def copy_components
      path = File.join('app', 'components', class_path, "#{file_name}_component.rb")
      template('component.rb.tt', path)
    end

    def create_erbs
      return if options['skip_erb']

      path = File.join('app', 'views', 'components', class_path, "_#{file_name}.html.erb")
      create_file(path)
    end

    def copy_javascripts
      return if options['skip_js']

      path = File.join('app', 'assets', 'javascripts', 'components', class_path, "#{file_name}.js")
      template('component.js', path)
    end

    # rubocop:disable Layout/LineLength
    def copy_stylesheets
      return if options['skip_css']

      path = File.join('app', 'assets', 'stylesheets', 'components', class_path, "#{file_name}.scss")
      template('component.scss', path)
    end
    # rubocop:enable Layout/LineLength

    private

    def file_name
      @_file_name ||= remove_possible_suffix(super)
    end

    def remove_possible_suffix(name)
      name.sub(/_?component$/i, '')
    end

  end
end
