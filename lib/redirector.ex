defmodule Redirector do
  @moduledoc """
  Redirector keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def preferred_visitor?(domain: domain) when is_bitstring(domain) do
    String.ends_with?(domain, [
      ".cityofsalem.net",
      ".clackamas.us",
      ".edu",
      ".gov",
      ".ca.us",
      ".multco.us",
      ".ny.us",
      ".or.us",
      ".tx.us",
      ".org",
      ".mil",
      "ip98-160-160-3.lv.lv.cox.net"
    ])
  end
end
