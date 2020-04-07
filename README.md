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
  * [Routes](#routes)
* [Usage](#usage)
  * [Rendering](#rendering)
  * [Context](#context)
  * [Helpers](#helpers)
  * [Locals](#locals)
  * [Iterations](#iterations)
  * [Views](#views)

## Setup

### Generator

Use `rails g component NAME` will generate the following files:

```erb
app/assets/javascripts/components/[name].js
app/assets/stylesheets/components/[name].scss
app/components/[name]_component.rb
app/views/components/_[name].html.erb
```

The generator also takes `--skip-css`, `--skip-js` and `--skip-erb` options. It will also
properly namespace nested components.

If a `ApplicationComponent` file in the `app/components` directory is available, the
generator will create file that inherit from `ApplicationComponent` if not it will
fallback to `Lite::Component::Base`.

### Assets

Component's `*.scss` and `*.js` will be automatically load via the tree lookup in basic
Rails setups.

### Routes

If you want to access route helpers in `*_component.rb` just include them like:

```ruby
# app/components/alert_component.rb

class AlertComponent < Lite::Component::Base
  include Rails.application.routes.url_helpers

  def link_to_account
    link_to('Return to account', account_path, class: 'text-underline')
  end

end
```

## Usage

### Rendering

To render a component in any view template or partial, you can use the the provided helper.
Its has the same setup as `render` and takes all [Action View Partials](https://api.rubyonrails.org/classes/ActionView/PartialRenderer.html)
options.

```erb
<%= component("alert") %>
<%= component(AlertComponent, locals: { message: "Something went right!", type: "success" }) %>
```

Render namespaced components by following standard naming conventions:

```erb
<%= component("admin/alert") %>
<%= component(Admin::AlertComponent) %>
```

Render collection of components just as you would render collections of partials.

```erb
<%= component("comment_card", collection: @comments, spacer_template: "components/spacer") %>
```

If you can skip rendering by evaluating complex logic in the `render?` method:

```ruby
# app/components/alert_component.rb

class AlertComponent < Lite::Component::Base

  def render?
    object.some_complex_check?
  end

end
```

### Context

All components include `ActionView::Context` which will give you access to request context such as
helpers, controllers, etc. It can be accessed using `context` or `c` methods.

```ruby
# app/components/alert_component.rb

class AlertComponent < Lite::Component::Base

  def protected_page?
    context.controller_name == 'admin'
  end

end
```

### Helpers

All components include `ActionView::Helpers` which will give you access to default Rails
helpers without the need to invoke the context. Use the helper methods to access helper methods
from your `app/helpers` directory. It can be accessed using `helpers` or `h` methods.

```ruby
# app/components/alert_component.rb

class AlertComponent < Lite::Component::Base

  def close_icon
    h.icon_tag(:close)
  end

  def link_to_close
    link_to(close_icon, '#', data: { alert: :dismiss })
  end

end
```

### Locals

All components include access to partial locals via the `locals` or `l` methods.
*Note: Objects will be automatically added to locals when rendering collections.*

```erb
<%= component("alert", locals: { object: @user }) %>
```

```ruby
# app/components/alert_component.rb

class AlertComponent < Lite::Component::Base

  def type_tag
    <<~HTML.squish.html_safe
      <b>#{locals.object.first_name}!</b>
    HTML
  end

end
```

### Iterations

All components will hav access to an iteration object which can be accessed
using the `iteration` or `i` methods. It provides access to each iterations
`first?`, `last?`, `size`, and `index` methods.

```erb
<%= component("alert", collection: @users) %>
```

```ruby
# app/components/alert_component.rb

class AlertComponent < Lite::Component::Base

  def limit_hit?
    i.index == 5
  end

end
```

### Views

*For the following examples, components will have the following setup:*

```ruby
# app/components/alert_component.rb

class AlertComponent < Lite::Component::Base

  def link_to_back
    link_to('Go back', :back, class: 'text-underline')
  end

end
```

```erb
<%= component("alert", collection: @users, locals: { message: "Something went right!", type: "success" }) %>
```

Component view partials behave just as a normal view partial would. All locals can be
accessed by their key.

```erb
<%# app/views/components/_alert.html.erb %>

<div class="alert alert-<%= type %>" role="alert">
  <%= message %>
</div>
```

Access to anything provided within its `*_component.rb` file can be done using the
`component` or `c` local methods which is the instance of the component.

```erb
<%# app/views/components/_alert.html.erb %>

<div class="alert alert-<%= type %>" role="alert">
  <%= component.locals.message %>
  <%= component.link_to_back %>
</div>
```

Rendering a collection will automatically give you access to the iteration and object variables.

```erb
<%# app/views/components/_alert.html.erb %>

<div class="alert alert-<%= type %>" role="alert">
  <% if iteration.size > 1 %>
    Alert #<%= iteration.index %>
    <% content_tag(:br, nil) unless iteration.last? %>
  <% end %>

  Hi <%= object.first_name %>,
  <br />
  <%= message %>
</div>
```

To bypass having a partial and just rendering content directly override the `render_content` method.

```ruby
# app/components/alert_component.rb

class AlertComponent < Lite::Component::Base

  def render_content
    content_tag(:span, 'Success', class: "alert-#{l.type}")
  end

end
```

To add components as part of another component build a `block` and `yield` it in the component's view.

```erb
<%# app/views/components/_sidebar.html.erb %>

<div class="sidebar">
  <%= component("sidebar/navigation", locals: { class_name: "js-nav-links" }) do |c| %>
    <% c.add("sidebar/navigation/link", locals: { text: "Link: 1", path: "/home", active: false }) %>
    <% c.add("sidebar/navigation/link", locals: { text: "Link: 2", path: "/about", active: true }) %>
    <% c.add("sidebar/navigation/link", locals: { text: "Link: 3", path: "/help", active: false }) do |n_c| %>
      <% n_c.add("sidebar/something", locals: { test: "something" }) %>
    <% end %>
  <% end %>
</div>
```

```erb
<%# app/views/components/sidebar/_navigation.html.erb %>

<div class="sidebar-navigation">
  <%= c.yield %>
</div>
```

```erb
<%# app/views/components/sidebar/navigation/_link.html.erb %>

<%= link_to(text, path, class: ("active" if l.active)) %>
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
