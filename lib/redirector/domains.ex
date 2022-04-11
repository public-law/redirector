defmodule Redirector.Domains do
  @moduledoc """
  Data source for domain names.
  """

  use Memoize
  require Logger

  @domains_yaml "https://raw.githubusercontent.com/public-law/datasets/master/Intergovernmental/Internet/governmental_domains.yaml"

  defmemo gov_domains do
    response = HTTPoison.get(@domains_yaml)

    {:ok, %HTTPoison.Response{body: http_body}} = response
    {:ok, yaml_data} = YamlElixir.read_from_string(http_body)

    domain_list =
      yaml_data
      |> Map.values()
      |> Enum.flat_map(fn x -> x end)

    Logger.info(fn -> "Loaded gov domains: #{inspect(domain_list)}" end)
    domain_list
  end
end
