defmodule BlitzChallenge.RiotAPI.Util do
  @riot_api_key Application.compile_env!(:blitz_challenge, :riot_api_key)

  @error_reasons [
    {400, "Bad request"},
    {401, "Unauthorized"},
    {403, "Forbidden"},
    {404, "Data not found"},
    {405, "Method not allowed"},
    {415, "Unsupported media type"},
    {429, "Rate limit exceeded"},
    {500, "Internal server error"},
    {502, "Bad Gateway"},
    {503, "Service Unavailable"},
    {504, "Gateway Timeout"}
  ]

  @expected_error_statuses [400, 401, 403, 404, 405, 415, 429, 500, 502, 503, 504]

  @headers [
    {"X-Riot-Token", "#{@riot_api_key}"},
    {"Content-Type", "application/json"}
  ]

  @region_subdomain_assoc %{
    "americas" => ~w(na1 br1 la1 la2),
    "asia" => ~w(kr jp1),
    "europe" => ~w(eun1 euw1 tr1 ru),
    "sea" => ~w(oc1 ph2 sg2 th2 tw2 vn2)
  }

  @subdomains ~w(br1 eun1 euw1 jp1 kr la1 la2 na1 oc1 ph2 ru sg2 th2 tr1 tw2 vn2)

  def expected_error_status_codes, do: @expected_error_statuses

  def error_reasons, do: @error_reasons

  def fetch_subdomains_for_region(region) do
    @region_subdomain_assoc[String.downcase(region)]
  end

  def find_region_by_subdomain(subdomain) do
    {region, _subdomains} =
      Enum.find(@region_subdomain_assoc, fn {_region, subdomains} ->
        subdomain in subdomains
      end)

    region
  end

  def headers, do: @headers

  def regions do
    Map.keys(@region_subdomain_assoc)
  end

  def subdomains, do: @subdomains
end
