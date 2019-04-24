%%%-------------------------------------------------------------------
%%% @author Dell Latitude E7440
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. mar 2019 16:44
%%%-------------------------------------------------------------------
%% kod powinien sie zmiescic na 2 ekranach: pattern matching,
%% nie uzywamy ifow, tylko caseow do wywolania wlasnych funkcji
%% gdzie sie da istniejace funkcje wyzszego rzedu albo anonimowe
%% mapy i rekordy do trzymania podstawowych danych
%% unikatowe wspolrzedne i dane dla stacji
%% dane pomiarowe dodajemy tak, ze znamy wartosci
%% stacja pomiarowa - rekord, stacje trzymamy w mapie (klucze sa unikatowe, wiec bez problemu)
%% filter na mapie, zeby sprawdzic czy nie ma kolizji nazw
%% dane pomiarowe w mapie(klucz - data i godzina) albo w liscie
%% 8 funkcji (8 indywidualna dla kazdego)
%% wspolrzdne jako krotka {szerokosc, dlugosc}
%% caly czas przekazujemy aktualne dane - nie jako zmienna globalna
%% komunikaty bledow - dwuelementowa krotka {atom error, komunikat}

-module('pollution').

%% API

-export([createMonitor/0, addStation/3, addValue/5, removeValue/4, getOneValue/4,
  getStationMean/3, getDailyMean/3]).
-export([getMinimumDistanceStations/1]).
-record(station, {name, coordinates}).
-record(reading, {station, date, type}).
-record(monitor, {stationsMap, readingsMap}).

mean([]) -> {error, "No measurements for these arguments"};
mean(List) -> lists:sum(List)/length(List).

createMonitor() -> #monitor{stationsMap = #{}, readingsMap = #{}}.

addStation(Name, Coordinates, #monitor{stationsMap = Stations, readingsMap = Readings}) ->
  case maps:is_key(Name, Stations) orelse maps:is_key(Coordinates, Stations) of
    true -> {error, "Monitor already contains this station"};
    false -> addStation(Name, Coordinates, Stations, Readings)
  end.

addStation(Name, Coordinates, Stations, Readings) ->
  NewStation = #station{name = Name, coordinates = Coordinates},
  #monitor{stationsMap = Stations#{Name => NewStation, Coordinates => NewStation}, readingsMap = Readings}.

addValue(StationID, Date, Type, Value, #monitor{stationsMap = Stations, readingsMap = Readings}) ->
  case maps:is_key(StationID, Stations) of
    false -> {error, "Monitor doesn't contain given station"};
    true -> addNewValue(StationID, Date, Type, Value, Stations, Readings)
  end.

addNewValue(StationID, Date, Type, Value, Stations, Readings) ->
  NewReading = #reading{station = StationID, date = Date, type = Type},
  #monitor{stationsMap = Stations, readingsMap = Readings#{NewReading => Value}}.

removeValue(StationID, Date, Type, #monitor{stationsMap = Stations, readingsMap = Readings}) ->
  case maps:is_key(StationID, Stations) of
    false -> {error, "Monitor doesn't contain given station"};
    true -> removeVal(StationID, Date, Type, Stations, Readings)
  end.

removeVal(StationID, Date, Type, Stations, Readings) ->
  KeyReading = #reading{station = StationID, date = Date, type = Type},
  #monitor{stationsMap = Stations, readingsMap = maps:remove(KeyReading, Readings)}.

getOneValue(StationID, Date, Type, #monitor{stationsMap = Stations, readingsMap = Readings}) ->
  case maps:is_key(StationID, Stations) of
    false -> {error, "Monitor doesn't contain given station"};
    true -> maps:get(#reading{station = StationID, date = Date, type = Type}, Readings)
  end.

getStationMean(StationID, Type, #monitor{stationsMap = Stations, readingsMap = Readings}) ->
  case maps:is_key(StationID, Stations) of
    false -> {error, "Monitor doesn't contain given station"};
    true -> stationMean(StationID, Type, Readings)
  end.

stationMean(StationID, Type, Readings) ->
  GetValid = fun(R, _) -> R#reading.station == StationID andalso R#reading.type == Type end,
  Valid = maps:filter(GetValid, Readings),
  mean(maps:values(Valid)).

getDailyMean(Date, Type, #monitor{stationsMap = Stations, readingsMap = Readings}) ->
  GetValid = fun(R, _) -> R#reading.date == Date andalso R#reading.type == Type end,
  Valid = maps:filter(GetValid, Readings),
  mean(maps:values(Valid)).


%% ma wyszukac pare najblizszych stacji
getMinimumDistanceStations(#monitor{stationsMap = Stations, readingsMap = Readings}) ->
  erlang:error(not_implemented).