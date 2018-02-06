-module(my_bfs).

-author("Song Feng").

%% APIs
-export([main/0]).


main() ->
    CityRoads = #{
        "Y" => [{"A", 4}, {"B", 5}, {"C", 2}],
        "A" => [{"P", 3}, {"Y", 4}],
        "B" => [{"P", 1}, {"Y", 5}, {"N", 3}],
        "C" => [{"J", 6}, {"T", 10}, {"Y", 2}],
        "J" => [{"C", 6}],
        "T" => [{"C", 10}],
        "P" => [{"A", 3}, {"B", 1}],
        "N" => [{"B", 5}]
    },
    io:format("~p~n", [cities(CityRoads)]),
    io:format("~p~n", [neighbors(CityRoads, "Y")]),
    io:format("~p~n", [neighbor_distance(CityRoads, "Y", "B")]),
    io:format("~p~n", [distance(CityRoads, ["Y", "B", "P"])]),
    io:format("------------------------------~n"),
    io:format("~p~n", [get_roads(CityRoads, ["Y"], "B")]).


cities(CRS) ->
    maps:keys(CRS).

neighbors(CRS, City) ->
    IsInvalidCity = maps:is_key(City, CRS),
    if IsInvalidCity ->
            {ok, NeighborRoads} = maps:find(City, CRS),
            [Neighbor || {Neighbor, _} <- NeighborRoads];
        true ->
            []
    end.

neighbor_distance(_CRS, City, City) -> 0;

neighbor_distance(CRS, City, City2) ->
    case maps:find(City, CRS) of
        {ok, NeighborRoads} ->
            {City2, Dist} = lists:keyfind(City2, 1, NeighborRoads),
            Dist;
        _ ->
            false
    end.

distance(CRS, CityPath) ->
    if length(CityPath) =< 1 ->
            0;
        true ->
            {_, Dist} = lists:foldl(
                fun (X, {Last, Acc}) -> {X, Acc + neighbor_distance(CRS, Last, X)} end,
                {hd(CityPath), 0},
                CityPath
            ),
            Dist
    end.

get_roads(CRS, TravelledPath, TargetCity) ->
    LastCity = hd(lists:reverse(TravelledPath)),
    case LastCity of
        TargetCity ->
            [TravelledPath];
        _ ->
            Neighbors = neighbors(CRS, LastCity),
            NextCities = [City || City <- Neighbors, not lists:member(City, TravelledPath)],
            case NextCities of
                [] ->
                    [];
                _ ->
                    lists:foldl(
                        fun (NextCity, AccRoads) -> AccRoads ++ get_roads(CRS, TravelledPath ++ [NextCity], TargetCity) end,
                        [],
                        NextCities)
            end
    end.
