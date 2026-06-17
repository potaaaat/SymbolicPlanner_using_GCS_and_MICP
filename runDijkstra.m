%run the djikstra baseline:

config = config_doorExample(); %config_reducedManufacturing(); 
[path, dist] = dijkstraBaseline(config);

disp(path)
disp(dist)