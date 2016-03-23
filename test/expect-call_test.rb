require 'minitest/autorun'
require './lib/expect-call'
require "minitest/mock"

class TestExpectCall < Minitest::Test
  def setup
    @obj = Object.new
  end

  def test_expects_a_specific_call
    @obj.expect_call :something, [ 'PARAM' ], nil do
      @obj.something( 'PARAM' )
    end
  end

  def test_returns_a_value
    @obj.expect_call :something, [ 'PARAM' ], 'RESULT' do
      assert_equal 'RESULT', @obj.something( 'PARAM' )
    end
  end

  def test_returns_a_result_of_callable
    @obj.expect_call :something, [ 'PARAM' ], Proc.new { 'TEST' } do
      assert_equal 'TEST', @obj.something( 'PARAM' )
    end
  end

  def test_checks_params
    metaclass = class << self; self; end

    mocked_assert = Proc.new do |comparison, message|
      if message.match /^Params do not match/
        orig_assert comparison === false, 'Params should have been checked'
      end
    end

    metaclass.send :alias_method, :orig_assert, :assert
    metaclass.send :define_method, :assert, mocked_assert

    @obj.expect_call :something, [ 'PARAM' ], 'RETURN' do
      @obj.something( 'FOO' )
    end

    metaclass.send :alias_method, :assert, :orig_assert
    metaclass.send :undef_method, :orig_assert
  end

  def test_checks_that_call_was_done
    metaclass = class << self; self; end

    mocked_assert = Proc.new do |comparison, message|
      if message.match /^Was not called/
        orig_assert comparison === false, 'Should have checked that the call was done'
      end
    end

    metaclass.send :alias_method, :orig_assert, :assert
    metaclass.send :define_method, :assert, mocked_assert

    @obj.expect_call :something, [ 'PARAM' ], 'RETURN' do
    end

    metaclass.send :alias_method, :assert, :orig_assert
    metaclass.send :undef_method, :orig_assert
  end

  def test_supports_sequential_expectations
    @obj.expect_call :something, [ 'PARAM' ], 'RETURN-2' do
      @obj.expect_call :something, [ 'FOO' ], 'RETURN-1' do
        @obj.something( 'FOO' )
        @obj.something( 'PARAM' )
      end
    end
  end
end
