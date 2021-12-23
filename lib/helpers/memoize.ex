defmodule Memoize do
  def memoized(fun, args) do
    case Process.get(args) do
      nil ->
        res = fun.(args)
        Process.put(args, res)
        res

      res ->
        res
    end
  end
end
