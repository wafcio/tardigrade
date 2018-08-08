require "tardigrade/version"

module Tardigrade
  def self.add_dependency(name, klass)
    @dependencies ||= {}
    @dependencies[name] = klass
  end

  def self.dependencies
    @dependencies || {}
  end
end
