module Tardigrade
  module Injector
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def import(*dependency_names)
        dependency_names.each do |dependency_name|
          service = Tardigrade.dependencies[dependency_name].new

          if service.method(:call).arity == 0
            define_method(dependency_name) { service.call }
          else
            define_method(dependency_name) { |*args| service.call(*args) }
          end
        end
      end
    end
  end
end
