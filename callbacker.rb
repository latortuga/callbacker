Object.send(:define_method, :callback) do |kind, main_method, cb_method|

  klass = self.class
  eigen = class << self; self; end

  eigen.instance_eval do
    @cbs ||= {}
    @cbs[main_method] = cb_method
  end

  alias_method(:"z_old_#{main_method}", main_method)

  define_method(main_method) do
    send(cb_method) if kind == :before
    result = send(:"z_old_#{main_method}")
    send(cb_method) if kind == :after
    result
  end

  eigen.instance_eval do
    define_method(:method_added) do |added_name|
      if added_name == main_method
        self.send(:alias_method, :"z_old_#{added_name}", added_name)
        undef_method added_name
        define_method(main_method) do
          send(cb_method) if kind == :before
          result = send(:"z_old_#{main_method}")
          send(cb_method) if kind == :after
          result
        end
      end
    end
  end
end
