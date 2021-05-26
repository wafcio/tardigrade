module Tardigrade
  module Injector
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def build_dependency(parent_instance, source)
        if source.respond_to?(:argument_names) && source.argument_names.size > 0
          arguments = {}
          source.argument_names.each do |name|
            arguments[name] = parent_instance.send(name)
          end
          source.new(arguments)
        else
          source.respond_to?(:call) ? source : source.new
        end
      end

      def call_method(klass)
        if klass.respond_to?(:call)
          klass.method(:call)
        else
          klass.instance_method(:call)
        end
      end

      def pass_through_or_cache(name, value, memoize)
        if memoize
          RequestStore.store[:"tardigrade_#{name}"] ||= value
        else
          value
        end
      end

      def import(*dependency_names)
        dependency_names.each do |dependency_name|
          dependency = Tardigrade.dependencies[dependency_name]
          source, memoize = dependency[:source], dependency[:memoize]

          if call_method(source).arity == 0
            define_dependency_method_without_arguments(dependency_name, source, memoize)
          else
            define_dependency_method_with_arguments(dependency_name, source, memoize)
          end
        end
      end

      def define_dependency_method_without_arguments(dependency_name, source, memoize)
        define_method(dependency_name) do
          result = self.class.build_dependency(self, source).call
          self.class.pass_through_or_cache(dependency_name, result, memoize)
        end
      end

      def define_dependency_method_with_arguments(dependency_name, source, memoize)
        define_method(dependency_name) do |*args|
          result = self.class.build_dependency(self, source).call(*args)
          self.class.pass_through_or_cache(dependency_name, result, memoize)
        end
      end
    end
  end
end
