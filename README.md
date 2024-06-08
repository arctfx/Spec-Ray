# Spectral Raytracer
Initial commit

Forked from [raytracing in one weekend](https://github.com/rogerallen/raytracinginoneweekendincuda)

Added interface for connecting to a visualizer: _TO DO: add link to app repo_ 

This is solely a raytracer that requires no additional libraries other than CUDA.
Once any image data has been calculated, it can be sent to the visualizer client through named pipes 
(see _interface/pipes.cu_). The server and client are meant to function independently
and will connect to each other automatically.
The client is a simple window program written in python that uses tkinter.

Goal: to implement fully functioning spectral raytracer