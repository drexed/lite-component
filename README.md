# Lite::Component

[![Gem Version](https://badge.fury.io/rb/lite-component.svg)](http://badge.fury.io/rb/lite-component)
[![Build Status](https://travis-ci.org/drexed/lite-component.svg?branch=master)](https://travis-ci.org/drexed/lite-component)

Lite::Component is a library for building component base objects. This technique simplifies
and organizes often used or logically comply page objects.

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
/app/assets/javascripts/components/[name].js
/app/assets/stylesheets/components/[name].scss
/app/components/[name]_query.rb
/app/views/components/_[name].html.erb
```
The generator also takes `--skip-css`, `--skip-js` and `--skip-erb` options

### Assets

In the basic Rails app setup component `*.scss` and `*.js` will be automatically load
via the tree lookup.

In order to require assets such manually require them in the manifest, e.g. `application.css`:
*Similar process for both CSS and JS*

```
/*
 * All components:
 *= require lite-component
 *
 * - or -
 *
 * Specific component:
 *= require component/alert
 */
```

### Components

If you create a `ApplicationComponent` file in the `app/components` directory, the generator
will create file that inherit from `ApplicationComponent` if not `Lite::Component::Base`.

## Usage

### Attributes and blocks

There are two ways of passing data to components: `attributes` and `blocks`. Attributes are useful for data such as ids, modifiers and data structures (models, etc). Blocks are useful when you need
to inject HTML content into components.

```ruby
# app/components/alert_component.rb

class AlertComponent < Components::Component
  attribute :context
  attribute :message
end
```

```erb
<% # app/views/components/_alert.html.erb %>

<div class="alert alert--<%= alert.context %>" role="alert">
  <%= alert.message %>
</div>
```

```erb
<%= component "alert", message: "Something went right!", context: "success" %>
<%= component AlertComponent, message: "Something went wrong!", context: "danger" %>
```

To inject some text or HTML content into our component we can print the component variable in our template, and populate it by passing a block to the component helper:

```erb
<% # app/views/components/_alert.html.erb %>

<div class="alert alert--<%= alert.context %>" role="alert">
  <%= alert %>
</div>
```

```erb
<%= component "alert", context: "success" do %>
  <em>Something</em> went right!
<% end %>
```

Another good use case for attributes is when you have a component backed by a model:

```ruby
# app/components/comment_component.rb

class CommentComponent < Components::Component
  attribute :comment

  delegate :id, :author, :body, to: :comment
end
```

```erb
<% # app/views/components/_comment.html.erb %>

<div id="comment-<%= comment.id %>" class="comment">
  <div class="comment__author">
    <%= link_to comment.author.name, author_path(comment.author) %>
  </div>
  <div class="comment__body">
    <%= comment.body %>
  </div>
</div>
```

```erb
<% comments.each do |comment| %>
  <%= component "comment", comment: comment %>
<% end %>
```

### Attribute defaults

Attributes can have default values:

```ruby
# app/components/alert_component.rb

class AlertComponent < Components::Component
  attribute :message
  attribute :context, default: "primary"
end
```

### Attribute overrides

It's easy to override an attribute with additional logic:

```ruby
# app/components/alert_component.rb

class AlertComponent < Components::Component
  attribute :message
  attribute :context, default: "primary"

  def message
    @message.upcase if context == "danger"
  end
end
```

### Attribute validation

To ensure your components get initialized properly you can use `ActiveModel::Validations` in your elements or components:

```ruby
# app/components/alert_component.rb

class AlertComponent < Components::Component
  attribute :label

  validates :label, presence: true
end
```

Your validations will be executed during the components initialization and raise an `Lite::Component::ValidationError` if any validation fails.

### Elements

Attributes and blocks are great for simple components or components backed by a data structure, such as a model. Other components are more generic in nature and can be used in a variety of contexts. Often they consist of multiple parts or elements, that sometimes repeat, and sometimes need their own modifiers.

Take a card component. In React, a common approach is to create subcomponents:

```jsx
<Card flush={true}>
  <CardHeader centered={true}>
    Header
  </CardHeader>
  <CardSection size="large">
    Section 1
  </CardSection>
  <CardSection size="small">
    Section 2
  </CardSection>
  <CardFooter>
    Footer
  </CardFooter>
</Card>
```

There are two problems with this approach:

1. The card header, section and footer have no standalone meaning, yet we treat them as standalone components. This means a `CardHeader` could be placed outside of a `Card`.
2. We lose control of the structure of the elements. A `CardHeader` can be placed below, or inside a `CardFooter`.

Using this gem, the same component can be written like this:

```ruby
# app/components/card_component.rb

class CardComponent < Components::Component
  attribute :flush, default: false

  element :header do
    attribute :centered, default: false
  end

  element :section, multiple: true do
    attribute :size
  end

  element :footer
end
```

```erb
<% # app/views/components/_card.html.erb %>

<div class="card <%= "card--flush" if card.flush %>">
  <div class="card__header <%= "card__header--centered" if card.header.centered %>">
    <%= card.header %>
  </div>
  <% card.sections.each do |section| %>
    <div class="card__section <%= "card__section--#{section.size}" %>">
      <%= section %>
    </div>
  <% end %>
  <div class="card__footer">
    <%= card.footer %>
  </div>
</div>
```

Elements can be thought of as isolated subcomponents, and they are defined on the component. Passing `multiple: true` makes it a repeating element, and passing a block lets us declare attributes on our elements, in the same way we declare attributes on components.

In order to populate them with data, we pass a block to the component helper, which yields the component, which lets us set attributes and blocks on the element in the same way we do for components:

```erb
<%= component "card", flush: true do |c| %>
  <% c.header centered: true do %>
    Header
  <% end %>
  <% c.section size: "large" do %>
    Section 1
  <% end %>
  <% c.section size: "large" do %>
    Section 2
  <% end %>
  <% c.footer do %>
    Footer
  <% end %>
<% end %>
```

Multiple calls to a repeating element, such as `section` in the example above, will append each section to an array.

Another good use case is a navigation component:

```ruby
# app/components/navigation_component.rb

class NavigationComponent < Components::Component
  element :items, multiple: true do
    attribute :label
    attribute :url
    attribute :active, default: false
  end
end
```

```erb
<%= component "navigation" do |c| %>
  <% c.item label: "Home", url: root_path, active: true %>
  <% c.item label: "Explore" url: explore_path %>
<% end %>
```

An alternative here is to pass a data structure to the component as an attribute, if no HTML needs to be injected when rendering the component:

```erb
<%= component "navigation", items: items %>
```

Elements can have validations, too:

```ruby
# app/components/navigation_component.rb

class NavigationComponent < Components::Component
  element :items, multiple: true do
    attribute :label
    attribute :url
    attribute :active, default: false

    validates :label, presence: true
    validates :url, presence: true
  end
end
```

Elements can also be nested, although it is recommended to keep nesting to a minimum:

```ruby
# app/components/card_component.rb

class CardComponent < Components::Component
  ...

  element :section, multiple: true do
    attribute :size

    element :header
    element :footer
  end
end
```

### Helper methods

In addition to declaring attributes and elements, it is also possible to declare helper methods. This is useful if you prefer to keep logic out of your templates. Let's extract the modifier logic from the card component template:

```ruby
# app/components/card_component.rb

class CardComponent < Components::Component
  ...

  def css_classes
    css_classes = ["card"]
    css_classes << "card--flush" if flush
    css_classes.join(" ")
  end
end
```

```erb
<% # app/views/components/_card.html.erb %>

<%= content_tag :div, class: card.css_classes do %>
  ...
<% end %>
```

It's even possible to declare helpers on elements:

```ruby
# app/components/card_component.rb %>

class CardComponent < Components::Component
  ...

  element :section, multiple: true do
    attribute :size

    def css_classes
      css_classes = ["card__section"]
      css_classes << "card__section--#{size}" if size
      css_classes.join(" ")
    end
  end
end
```

```erb
<% # app/views/components/_card.html.erb %>

<%= content_tag :div, class: card.css_classes do %>
  ...
  <%= content_tag :div, class: section.css_classes do %>
    <%= section %>
  <% end %>
  ...
<% end %>
```

Helper methods can also make use of the `@view` instance variable in order to call Rails helpers such as `link_to` or `content_tag`.

### Rendering components without a partial

For some small components, such as buttons, it might make sense to skip the partial altogether, in order to speed up rendering. This can be done by overriding `render` on the component:

```ruby
# app/components/button_component.rb

class ButtonComponent < Components::Component
  attribute :label
  attribute :url
  attribute :context

  def render
    @view.link_to label, url, class: css_classes
  end

  def css_classes
    css_classes = "button"
    css_classes << "button--#{context}" if context
    css_classes.join(" ")
  end
end
```

```erb
<%= component "button", label: "Sign up", url: sign_up_path, context: "primary" %>
<%= component ButtonComponent, label: "Sign in", url: sign_in_path %>
```

### Namespaced components

Components can be nested under a namespace. This is useful if you want to practice things like [Atomic Design](http://bradfrost.com/blog/post/atomic-web-design/), [BEMIT](https://csswizardry.com/2015/08/bemit-taking-the-bem-naming-convention-a-step-further/) or any other component classification scheme. In order to create a namespaced component, stick it in a folder and wrap the class in a module:

```ruby
module Objects
  class MediaObject < Components::Component; end
end
```

Then call it from a template like so:

```erb
<%= component "objects/media_object" %>
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
