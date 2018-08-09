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
          dep_klass.respond_to?(:call) ? dep_klass : dep_klass.new
        end
      end

      def call_method(klass)
        if klass.respond_to?(:call)
          klass.method(:call)
        else
          klass.instance_method(:call)
        end
      end

      def cache(name, value, memoize)
        if memoize
          RequestStore.store[:"tardigrade_#{name}"] ||= value
        else
          value
        end
      end

      def import(*dependency_names)
        dependency_names.each do |dep_name|
          dep = Tardigrade.dependencies[dep_name]
          klass = dep[:class]
          memoize = dep[:memoize]

          if call_method(klass).arity == 0
            define_method(dep_name) do
              result = self.class.build_dependency(self, klass).call
              self.class.cache(dep_name, result, memoize)
            end
          else
            define_method(dep_name) do |*args|
              result = self.class.build_dependency(self, klass).call(*args)
              self.class.cache(dep_name, result, memoize)
            end
          end
        end
      end
    end
  end
end
