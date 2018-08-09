# Tardigrade

Inject dependency in ruby class.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tardigrade'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tardigrade

## Usage

Define dependency:
```ruby
class Foo
  def call
    :foo_response  
  end
end
Tardigrade.add_dependency :foo, Foo
```

Use dependency in class
```ruby
class Action
  include Tardigrade::Injector
  
  import :foo
end

Action.new.foo # => :foo_response
```

### Dependencies

Dependency can be:
* lambda, proc
* class with `call` class method
* module with `self.call` method
* class with `call` instance method

Class with `call` instance method can have context only.

### Context

The biggest advantage of `Tardigarde` is having context by dependency:

Define dependency:
```ruby
class Foo
  include Tardigrade::Dependency
  
  with :name

  def call
    name  
  end
end
Tardigrade.add_dependency :foo, Foo
```

Use dependency in class
```ruby
class Action
  include Tardigrade::Injector
  
  import :foo
  
  attr_reader :name
  
  def initialize(name:)
    @name = name
  end
end

Action.new(name: "John").foo # => "John"
```

### Memoization

You can tell tardigrade to memoize method after first call. To do it write:
```ruby
Tardigrade.add_dependency :foo, Foo, memoize: true
```

As cache store `tardigrade` uses `request_store` gem which you can use with [Ruby on Rails application](https://github.com/steveklabnik/request_store#the-solution) and with [Rack application](https://github.com/steveklabnik/request_store#no-rails-no-problem).

### Testing

You can easily test dependency without main object:

```ruby
class Foo
  include Tardigrade::Dependency
  
  with :name

  def call
    name  
  end
end

Foo.new(name: "John").call # => "John"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wafcio/tardigrade.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
