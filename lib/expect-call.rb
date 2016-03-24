class Object
  #
  # Partial mocking.
  # Stubs a regular object and expects a certain call on it.
  #
  def expect_call( method_name, params, val_or_callable, &block )
    context = block.binding.eval( 'self' )

    if context.respond_to?( :assert )
      assert_method = context.method( :assert )
    else
      assert_method = Proc.new do |condition, message|
        raise RuntimeError, "expect-call assertion\n#{ message }" unless condition
      end
    end
    
    metaclass = class << self; self; end

    orig_method = nil
    orig_method = method( method_name ) if respond_to? method_name

    clean_up = Proc.new do
      metaclass.send :undef_method, method_name
      if orig_method
        metaclass.send :define_method, method_name, orig_method
      end
    end

    was_called = false

    new_method = Proc.new do |*args|
      was_called = true
      clean_up.call

      assert_method.call params == args, <<-MSG % [ method_name, params.inspect, args.inspect ]
Method '%s' called with unexpected arguments
  Expected: %s
    Actual: %s
      MSG

      if val_or_callable.respond_to?( :call )
        return val_or_callable.call( *args )
      end

      val_or_callable
    end

    metaclass.send :define_method, method_name, new_method

    yield

    assert_method.call was_called, "Method '%s' was not called" % [ method_name ]
  ensure
    clean_up.call unless was_called
  end
end
