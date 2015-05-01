# Elevator <a href="https://codeclimate.com/github/arikalfus/Elevator"><img src="https://codeclimate.com/github/arikalfus/Elevator/badges/gpa.svg" /></a> <img src=https://codeship.com/projects/15a52a80-d1b4-0132-b094-4afb0344239b/status?branch=master>

## Description

Program is run by calling ```ruby sim.rb```.

#### Simulation
The simulation is run through the ```Simulation``` class. After being passed a certain number of turns to run, the ```Simulation``` constructs a ```Building``` with two ```Elevators``` and five ```Floors```. I was going to implement a method to manually construct X number of floors and Y number of elevators with Z number of people on each floor, but I did not have time due to the deadline. After constructing the objects, the ```Simulation``` merely keeps track of the number of turns to make and prints the current state of the simulation.

#### Building
From there, ```Building``` takes over. On each turn, ```Building``` simply calls each ```Elevator's``` ```start_turn``` method, but ```Building``` keeps track of some more important data. When a new ```Person``` is added to a ```Floor```, the ```Floor``` logs the pickup request with the ```Building``` class. The ```Building``` manages these pickup requests and alerts ```Elevators``` when they have a pickup request above their current floor.

#### Elevator
On each ```Elevator's``` turn, several things are happening. First, the ```Elevator``` determines what direction it is traveling in, and calls the appropriate ```move``` method. In that method, the ```Persons``` on the current floor are boarded onto the ```Elevator```, thereby removing them from that ```Floor``` and removing the pickup request in ```Building```. Then the ```Elevator``` moves to the next floor, and unloads its passengers that want to get off at that floor. 

On each turn, before moving up the ```Elevator``` calculates whether any of its passengers want to go up or if there are any pickup requests on a floor above the ```Elevator```. If neither of these things are true, the ```Elevator``` stops moving up and moves down to its resting floor (which is set to the first floor in this simulation). When on the resting floor the ```Elevator``` stops moving unless there are new pickup requests logged.

#### Floor
When a new ```Person``` is added to a ```Floor```, they are inserted into a ```waiting_line``` hash by the location of their desired ```Floor``` relative to the ```Floor``` they are currently on (e.g. one would be suffled into the ```:up``` hash if they want to go to floor 5 and they are on floor 2). Then the ```Floor``` sends a pickup request to the ```Building``` to notify it that there is a ```Person``` waiting to be pickd up.

Similarly, when a ```Person``` is boarded onto an elevator, the ```Floor``` checks whether there are any others waiting to board, and if not sends a message to ```Building``` to cancel its pickup request.

## Interesting Features
#### Simulation
One interesting feature I implemented in the ```Simulation``` class is the creation of a new ```Person``` on a random floor at random intervals. On each turn, there is a 1/3 chance of generating a new ```Person```. This feature led to the identification of a bug, which I explain below.

#### Building
The ```Building``` class stores its pickup requests in a set, which may not be particularly interesting, but I have not used sets before in Ruby, so I considered that a nice design implementation - I can send pickup requests to the ```Building``` every time a ```Person``` is added to a ```Floor```, and not worry about having to remove X pickup requests when X ```Persons``` on that ```Floor``` are picked up because of the nature of a set.

The building also stores its floors in a hash, where the keys are the floor numbers. This provides easy and fast access to any floor, although it did make accumulating certain values a little tricky.

#### Elevator
The ```Elevator``` stores a hash of passengers, where each key is a floor number. That way, when the ```Elevator``` is on a certain ```Floor```, it can just empty a key's value onto that ```Floor```. Boarding is similarly very easy.

#### Floor
On a similar note to the ```Elevator```, each ```Floor``` class stores its ```Persons``` waiting for an ```Elevator``` in a hash, where the keys are ```up``` and ```down```, corresponding to the direction from the current floor the ```Persons``` want to travel to. This makes loading and unloading a ```Floor``` very easy.

## Current Problems
There is one bug that I cannot seem to remove. As is mentioned above, I sometimes generate a new ```Person``` and add it to a random ```Floor``` during the simulation. When running the simulation on a high number of turns, I noticed that some ```Persons``` are not picked up by any ```Elevator```. They will appear in the queue of ```Persons``` waiting to be picked up, but the ```Elevators``` will not grab them. If more ```Persons``` appear on that ```Floor```, the ```Elevators``` may stop at that ```Floor``` and pick up the other ```Persons``` (e.g. if 2 people are waiting on a floor, the elevator may pick up the new one but leave the other that has been waiting).

I have debugged this in several ways, but have not been able to identify why this extra ```Person``` is not being picked up. It may merely be a counting issue - the ```Floor``` is not reducing its ```waiting_count``` when it should, so it appears as if there's someone waiting when there is in fact not, but as I said, I have not been able to identify the root cause. What really interests me is that others can appear and be picked up on that ```Floor```, while still leaving this other ```Person``` waiting.
