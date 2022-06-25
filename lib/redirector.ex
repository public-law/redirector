defmodule Redirector do
  @moduledoc """
  Redirector keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  use Memoize
  require Logger

  @private_list [
    "edu",
    "edu.au",
    "org",
    "us",
    "ac.uk",
    "austin.com",
    "cityofalbany.net",
    "cityofsalem.net",
    "mcgill.ca",
    "ongov.net"
  ]

  def preferred_visitor?(domain: domain) when is_bitstring(domain) do
    String.ends_with?(domain, domain_list())
  end

  defmemo domain_list do
    result =
      Enum.concat(@private_list, Redirector.Domains.gov_domains())
      |> Enum.sort()
      |> Enum.uniq()

    Logger.info(fn -> "Built domain list: #{inspect(result)}" end)
    result
  end
end
