class Object
  #
  # Partial mocking.
  # Stubs a regular object and expects a specific call on it.
  #
  def expect_call( method_name, params, val_or_callable, &block )
    assert_method = block.binding.eval( 'self' ).method( :assert )
    
    metaclass = class << self; self; end

    orig_method = nil
    orig_method = method( method_name ) if respond_to? method_name

    was_called = false

    new_method = Proc.new do |*args|
      was_called = true

      #
      # Returning methods back after the call.
      #
      metaclass.send :undef_method, method_name
      if orig_method
        metaclass.send :define_method, method_name, orig_method
      end

      assert_method.call params == args,
        "Params do not match\n  Expected: %s\n    Actual: %s" % [ params.inspect, args.inspect ]

      if val_or_callable.respond_to?( :call )
        return val_or_callable.call( *args )
      end

      val_or_callable
    end

    metaclass.send :define_method, method_name, new_method

    yield

    assert_method.call was_called, "Was not called: #{ method_name }"
  ensure
    #
    # If the method was not called we return everything back now.
    #
    unless was_called
      metaclass.send :undef_method, method_name

      if orig_method
        metaclass.send :define_method, method_name, orig_method
      end
    end
  end
end
