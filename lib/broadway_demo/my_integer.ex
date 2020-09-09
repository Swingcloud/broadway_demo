defmodule BroadwayDemo.MyInteger do
  defmacro is_even(number) do
    quote do
      is_integer(unquote(number)) and rem(unquote(number), 2) == 0
    end
  end

  defmacro is_odd(number) do
    quote do
      is_integer(unquote(number)) and rem(unquote(number), 2) == 1
    end
  end
end
