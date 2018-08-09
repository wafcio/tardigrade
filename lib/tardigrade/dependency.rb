module Tardigrade
  module Dependency
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def with(*argument_names)
        @argument_names = argument_names

        if argument_names.size > 0
          define_method(:initialize) do |**args|
            argument_names.each do |arg_name|
              unless args.keys.include?(arg_name)
                raise ArgumentError.new("argument :#{arg_name} missing")
              end

              instance_variable_set(:"@#{arg_name}", args[arg_name])
              self.class.send(:attr_reader, :"#{arg_name}")
            end
          end
        end
      end

      def argument_names
        @argument_names || []
      end
    end
  end
end
