
# ÖBB Stations

Client to get meta data from a ÖBB station, like:
* name
* ID
* Longitude
* Latitude 
* zip-codes (optional)

You can search for stations by name, resulting in a list of possible stations and their meta data.
This project uses [tickets.oebb.at/api](https://tickets.oebb.at/api/) as data source.

## Setup
Use `./setup.sh` to automatically setup the `python3 venv` for this project. 

## Run
If set up with `./setup.sh`, you can use `./start.sh` to run the script effortlessly. 
```
Usage:
    ./start.sh STATION_NAME
```

## Example
Using this project to find results to station "Praterstern", run `./start.sh Praterstern`:
```
Search ÖBB Station ID for "Praterstern"...
25 entries found!

station: Wien Praterstern Bahnhof (U)
id: 1290201
longitude: 16392153
latitude: 48219082

station: Wien Rotensterngasse/Praterstraße
id: 902040
longitude: 16386400
latitude: 48216358

station: Wien Pensionistenwohnhaus Prater
id: 902026
longitude: 16418636
latitude: 48213356

...
```
