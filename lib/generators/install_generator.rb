# frozen_string_literal: true

require 'rails/generators'

class ComponentGenerator < Rails::Generators::NamedBase

  class_option :skip_erb, type: :boolean, default: false
  class_option :skip_css, type: :boolean, default: false
  class_option :skip_js, type: :boolean, default: false

  source_root File.expand_path('../templates', __FILE__)

  def create_component_file
    template("component.rb.erb", "app/components/#{name}_component.rb")
  end

  def create_erb_file
    return if options["skip_erb"]

    create_file("app/components/#{name}/_#{filename}.html.erb")
  end

  def copy_javascript_file
    return if options["skip_js"]

    copy_file('install.js', "app/components/#{name}/#{filename}.js")
  end

  def copy_stylesheet_file
    return if options["skip_css"]

    copy_file('install.scss', "app/components/#{name}/#{filename}.scss")
  end

  private

  def filename
    name.split('/').last
  end

end
