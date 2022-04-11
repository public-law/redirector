defmodule Redirector do
  @moduledoc """
  Redirector keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @private_list [
    ".edu",
    ".mil",
    ".org",
    ".us",
    ".ac.uk",
    ".austin.com",
    ".cityofalbany.net",
    ".cityofsalem.net",
    ".mcgill.ca",
    ".ongov.net"
  ]

  @spec preferred_visitor?([{:domain, binary}, ...]) :: boolean
  def preferred_visitor?(domain: domain) when is_bitstring(domain) do
    String.ends_with?(domain, @private_list)
  end
end
