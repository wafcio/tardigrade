module Tardigrade
  module Injector
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def build_dependency(parent_instance, dep_klass)
        if dep_klass.respond_to?(:argument_names) && dep_klass.argument_names.size > 0
          arguments = {}
          dep_klass.argument_names.each do |name|
            arguments[name] = parent_instance.send(name)
          end
          dep_klass.new(arguments)
        else
          dep_klass.new
        end
      end

      def import(*dependency_names)
        dependency_names.each do |dependency_name|
          klass = Tardigrade.dependencies[dependency_name]

          if klass.instance_method(:call).arity == 0
            define_method(dependency_name) do
              dep_object = self.class.build_dependency(self, klass)
              dep_object.call
            end
          else
            define_method(dependency_name) do |*args|
              dep_object = self.class.build_dependency(self, klass)
              dep_object.call(*args)
            end
          end
        end
      end
    end
  end
end
