#!/usr/bin/python3

import functools

class Cities:
    def __init__(self, city_roads):
        self.city_roads = city_roads
        self.city_list = list(city_roads.keys())

    def __del__(self):
        self.city_roads = None
        self.city_list = []

    def cities(self):
        return self.city_list

    def neighbors(self, city):
        if city in self.city_list:
            return list(self.city_roads[city].keys())
        else:
            return []

    def neighbor_distance(self, city, city2):
        if city == city2:
            return 0
        elif city in self.city_list and city2 in self.city_roads[city].keys():
            return self.city_roads[city][city2]
        else:
            return False

    def distance(self, city_list):
        l0 = len(city_list)
        if l0 <= 1:
            return 0
        else:
            (dist, _) = functools.reduce(
                lambda x, y: (x[0] + self.neighbor_distance(x[1], y), y),
                city_list,
                (0, city_list[0])
            )
            return dist

    def _get_roads(self, travelled_path, target_city):
        last_city = travelled_path[-1]
        if last_city == target_city:
            return [travelled_path]
        else:
            neighbors = self.neighbors(last_city)
            next_cities = [city for city in neighbors if not city in travelled_path]
            return \
                functools.reduce(
                    lambda acc_roads, next_city: acc_roads + self._get_roads(travelled_path + [next_city], target_city),
                    next_cities,
                    []
                )

    def roads(self, city, city2):
        return self._get_roads([city], city2)

    def distance_of_roads(self, roads):
        for road in roads:
            print(road, self.distance(road))
        return None

CityRoads = {
    "Y":{"A": 4, "B": 5, "C": 2},
    "A":{"P": 3, "Y": 4},
    "B":{"P": 1,"Y": 5, "N": 3},
    "C":{"J": 6, "T": 10, "Y": 2},
    "J":{"C": 6},
    "T":{"C": 10},
    "P":{"A": 3, "B": 1},
    "N":{"B": 5}
}

CRS = Cities(CityRoads)
print(CRS.cities())
print(CRS.neighbors("Y"))
print(CRS.neighbor_distance("Y","B"))
print(CRS.distance(["Y", "B", "P", "A"]))
print(CRS.roads("Y", "A"))
print(CRS.distance_of_roads(CRS.roads("Y", "A")))



