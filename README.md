[![Build Status](https://travis-ci.org/d-ash/expect-call.svg?branch=master)](https://travis-ci.org/d-ash/expect-call)

# expect-call

Partial mocking.

Stubs a regular object and expects a certain call to it.

## Usage

```Ruby
@obj = Object.new

# Passing a value to be a result
@obj.expect_call :something, [ 'PARAM' ], 'RESULT' do
    assert_equal 'RESULT', @obj.something( 'PARAM' )
end

# Passing a proc to return a result
@obj.expect_call :something, [ 'PARAM' ], Proc.new { 'TEST' } do
  assert_equal 'TEST', @obj.something( 'PARAM' )
end

# Expectations could be put in sequence
@obj.expect_call :something, [ 'PARAM' ], 'RETURN-2' do
  @obj.expect_call :something, [ 'FOO' ], 'RETURN-1' do
    @obj.something( 'FOO' )     # => RETURN-1
    @obj.something( 'PARAM' )   # => RETURN-2
  end
end
```
