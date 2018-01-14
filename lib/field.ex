defmodule Field do
  @es_type "foo"
  @es_index "foo"
  use Elastic.Document.API

  defstruct name: nil, value: []
end
