defmodule CouchdbUtils do
  defp do_encode(<<>>, result) do
    result
  end

  defp do_encode(<<ch, rest::binary>>, result) do
    if ((ch >= ?a and ch <= ?z) or (ch >= ?A and ch <= ?Z) or (ch >= ?0 and ch <= ?9) or (ch == ?_) or (ch == ?.)) do
      do_encode(rest, result <> <<ch>>)
    else
      s = Integer.to_string(ch, 16)
      do_encode(rest, result <> "!" <> if String.length(s) == 1 do " " <> s else s end)
    end
  end

  def encode_name(name) do
    do_encode(name, "")
  end
end
