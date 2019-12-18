# Lite::Component

[![Gem Version](https://badge.fury.io/rb/lite-component.svg)](http://badge.fury.io/rb/lite-component)
[![Build Status](https://travis-ci.org/drexed/lite-component.svg?branch=master)](https://travis-ci.org/drexed/lite-component)

Lite::Component is a library for building component base objects. This technique simplifies
and organizes often used or logically complex page objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lite-component'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lite-component

## Table of Contents

* [Setup](#setup)
  * [Generator](#generator)
  * [Assets](#assets)
  * [Components](#components)
* [Usage](#usage)
  * [Attribute and blocks](#attributes-and-blocks)
  * [Attributes defaults](#attribute-defaults)
  * [Attributes overrides](#attribute-overrides)
  * [Elements](#elements)
  * [Helper methods](#helper-methods)
  * [Rendering components without a partial](#rendering-components-without-a-partial)
  * [Namespaced components](#namespaced-components)

## Setup

### Generator

Use `rails g component NAME` will generate the following files:
```
/app/assets/javascripts/components/NAME.js
/app/assets/stylesheets/components/NAME.scss
/app/components/NAME_query.rb
/app/views/components/_NAME.html.erb
```
The generator also takes `--skip-css`, `--skip-js` and `--skip-erb` options

### Assets

In the basic Rails app setup component `*.scss` and `*.js` will be automatically load
via the tree lookup.

### Components

If you create a `ApplicationComponent` file in the `app/components` directory, the generator
will create file that inherit from `ApplicationComponent` if not `Lite::Component::Base`.

Components come with view context and helpers already included.

If you want to access route helpers in `*_component.rb` just include them like:

```ruby
# app/components/alert_component.rb

class AlertComponent < Lite::Component::Base
  include Rails.application.routes.url_helpers
end
```

## Usage

### Components

```ruby
# app/components/alert_component.rb

class AlertComponent < Lite::Component::Base

  def close
    link_to("X", "#", data: { alert: :dismiss })
  end

  def icon
    <<~HTML.squish.html_safe
      <i class="icon icon-#{icon_by_context}"></i>
    HTML
  end

  private

  def icon_by_context
    case
  end

end
```

```erb
<% # app/views/components/_alert.html.erb %>

<div class="alert alert-<%= alert.type %>" role="alert">
  <%= component.close %>
  <%= message %>
  <%= %>
</div>
```

```erb
<%= component "alert", message: "Something went right!", context: "success" %>
<%= component AlertComponent, message: "Something went wrong!", context: "danger" %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lite-component. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lite::Component project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/lite-component/blob/master/CODE_OF_CONDUCT.md).
