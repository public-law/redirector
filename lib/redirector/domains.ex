defmodule Redirector.Domains do
  @moduledoc """
  Data source for domain names.
  """

  @domains_yaml "https://raw.githubusercontent.com/public-law/datasets/master/Intergovernmental/Internet/governmental_domains.yaml"

  def get_gov_domains do
    response = HTTPoison.get(@domains_yaml)

    {:ok, %HTTPoison.Response{body: http_body}} = response
    {:ok, data} = YamlElixir.read_from_string(http_body)

    data
    |> Map.values()
    |> Enum.flat_map(fn x -> x end)
  end
end
