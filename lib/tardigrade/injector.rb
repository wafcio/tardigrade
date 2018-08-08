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

      def call_dependency(instance, dep_name, klass, &block)
        unless instance.instance_variable_get(:"@#{dep_name}")
          dep_object = build_dependency(instance, klass)
          result = block.call(dep_object)
          instance.instance_variable_set(:"@#{dep_name}", result)
        end
        instance.instance_variable_get(:"@#{dep_name}")
      end

      def import(*dependency_names)
        dependency_names.each do |dep_name|
          klass = Tardigrade.dependencies[dep_name]

          if klass.instance_method(:call).arity == 0
            define_method(dep_name) do
              self.class.call_dependency(self, dep_name, klass) do |dep_object|
                dep_object.call
              end
            end
          else
            define_method(dep_name) do |*args|
              self.class.call_dependency(self, dep_name, klass) do |dep_object|
                dep_object.call(*args)
              end
            end
          end
        end
      end
    end
  end
end
