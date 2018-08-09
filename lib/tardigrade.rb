require "request_store"

require "tardigrade/dependency"
require "tardigrade/injector"
require "tardigrade/version"

module Tardigrade
  def self.add_dependency(name, klass, **options)
    @dependencies ||= {}
    @dependencies[name] = { class: klass, memoize: !!options[:memoize] }
  end

  def self.dependencies
    @dependencies || {}
  end
end
