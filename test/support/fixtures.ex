defmodule BlitzChallenge.Support.Fixtures do
  @region "americas"
  @summoner_name "lateapex"
  @match_id "NA1_4930980878"
  @puuid "mocked_puuid"
  @subdomain "na1"

  @match_ids [
    @match_id,
    "NA1_4930920313",
    "NA1_4930889106",
    "NA1_4910106105",
    "NA1_4901047774"
  ]

  @recent_summoners [
    %{
      summoner_name: @summoner_name,
      puuid: @puuid,
      match_id: @match_id
    },
    %{
      summoner_name: "RedRider",
      puuid: "Te81neqEANHBD1tGYchQUEkCkUfidxz0pfi1Xpt",
      match_id: @match_id
    },
    %{
      summoner_name: "CitrusHaricot",
      puuid: "qQCwNwsvGXme_7KNnqxeppp8wQ54rjmMurRR1mwUL3JhDL",
      match_id: @match_id
    },
    %{
      summoner_name: "XZoeX",
      puuid: "hzpeq8hxsPCjx6qKGfVbpJhRhEX_0-UOWx1Vuml951jBU",
      match_id: @match_id
    },
    %{
      summoner_name: "CitrusHaricotPlayer2",
      puuid: "SSKLaocPz2Q0CCkYhiK0Hp-zCx24InnLC5Jiu26EukaVR",
      match_id: @match_id
    },
    %{
      summoner_name: "raft",
      puuid: "bOv3kHrzEoULfQ4vi5p9uhHbxjZki7ugKeN6_sLm-XiHdf",
      match_id: @match_id
    },
    %{
      summoner_name: "Zero",
      puuid: "WP4xgaDb7Arl410Zb-E76IPHNLxP3ogKw0Z9YxJeWMXK_yj",
      match_id: @match_id
    },
    %{
      summoner_name: "shi20",
      puuid: "V9wtdj_VBk90RfYQoU5YuPBkVnW1gJT7-BVnTGFLj3Lvq53",
      match_id: @match_id
    },
    %{
      summoner_name: "WorriedPlayer3",
      puuid: "UTUEF29bMbyewRn-1_EyFF9xBFLw0Zwq13L1ea9Bmxvz5Wjcg",
      match_id: @match_id
    },
    %{
      summoner_name: "MOREMilk",
      puuid: "XCWHXMnohj5KraAX68KctAyA4s238XBSPyNagFkmr6C9pcyFP",
      match_id: @match_id
    }
  ]

  @decoded_match_response %{
    "info" => %{
      "participants" => [
        %{
          "puuid" => @puuid,
          "summonerName" => @summoner_name
        },
        %{
          "puuid" => "Te81neqEANHBD1tGYchQUEkCkUfidxz0pfi1Xpt",
          "summonerName" => "RedRider"
        },
        %{
          "puuid" => "qQCwNwsvGXme_7KNnqxeppp8wQ54rjmMurRR1mwUL3JhDL",
          "summonerName" => "CitrusHaricot"
        },
        %{
          "puuid" => "hzpeq8hxsPCjx6qKGfVbpJhRhEX_0-UOWx1Vuml951jBU",
          "summonerName" => "XZoeX"
        },
        %{
          "puuid" => "SSKLaocPz2Q0CCkYhiK0Hp-zCx24InnLC5Jiu26EukaVR",
          "summonerName" => "CitrusHaricotPlayer2"
        },
        %{
          "puuid" => "bOv3kHrzEoULfQ4vi5p9uhHbxjZki7ugKeN6_sLm-XiHdf",
          "summonerName" => "raft"
        },
        %{
          "puuid" => "WP4xgaDb7Arl410Zb-E76IPHNLxP3ogKw0Z9YxJeWMXK_yj",
          "summonerName" => "Zero"
        },
        %{
          "puuid" => "V9wtdj_VBk90RfYQoU5YuPBkVnW1gJT7-BVnTGFLj3Lvq53",
          "summonerName" => "shi20"
        },
        %{
          "puuid" => "UTUEF29bMbyewRn-1_EyFF9xBFLw0Zwq13L1ea9Bmxvz5Wjcg",
          "summonerName" => "WorriedPlayer3"
        },
        %{
          "puuid" => "XCWHXMnohj5KraAX68KctAyA4s238XBSPyNagFkmr6C9pcyFP",
          "summonerName" => "MOREMilk"
        }
      ],
      "platformId" => "NA1"
    },
    "metadata" => %{
      "matchId" => @match_id
    }
  }

  @state %{
    user: %{summoner_name: @summoner_name, puuid: @puuid},
    region: @region,
    subdomain: @subdomain,
    recent_summoners: nil
  }

  def state, do: @state
  def subdomain, do: @subdomain
  def puuid, do: @puuid
  def region, do: @region
  def user_summoner_name, do: @summoner_name
  def decoded_match_response, do: @decoded_match_response
  def match_id, do: @match_id
  def match_ids, do: @match_ids
  def recent_summoners, do: @recent_summoners
end
