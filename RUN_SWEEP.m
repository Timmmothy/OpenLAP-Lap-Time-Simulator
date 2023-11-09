%% Clearing Memory
clear
clc
close all force
diary('off')
fclose('all');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% USER INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VEHICLE SELECTION
VEHICLE_NAME = "FB24";

%% TRACK SELECTION
TRACK_FILE = 'OpenTRACK Tracks/OpenTRACK_MIS Endurance 2023_Closed_Forward.mat';

%% SAVE FOLDER
SWEEP_FOLDER = "TEST_SWEEP"; % CHANGE FOR EACH SWEEP OR PREVIOUS SWEEP WILL BE DELETED

%% FILE SWEEP PARAMS BASE
SWEEP_PARAMS_FILE_EXTENSION_BASE = "PARAMS";
%SWEEP_PARAMS_FILE_EXTENSION = "";

%% SWEEP VARIABLES
% Need to use string name of variables you want to sweep from
% Initialize_VEHICLE.m
% ORDER NEEDS TO MATCH SWEEP_VALUES ORDER
SWEEP_VARIABLES = ["df" "L" "ratio_final"]';
% These values correspond to FRONT MASS DISTRIBUTION, WHEEL BASE, and FINAL
% GEAR REDUCTION variables in the simulation
%% SWEEP VALUES
% Need to provide arrays containing the data values you want to sweep for the
% corresponding variables above, also need to make sure that the data is in
% the same units as the OpenLAP sim data, this means that if you see that the 
% data is divided by 100 or 1000 in the Initialize_VEHICLE.m file, then YOU 
% NEED TO DIVIDE YOUR DATA VALUES BY THOSE VALUES HERE IN THE ARRAYS, see sample inputs.
% NOTE: the array lengths do NOT need to match
% ORDER NEEDS TO MATCH SWEEP_VARIABLES ORDER
SWEEP_VALUES = {[41/100 50/100]; [1500/1000 1582/1000 1600/1000]; [3 3.273]};
% these values include data from the FB24 excel file for reference as well
% as some random/arbitrary sample data to test/compare
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% RUNNING SWEEP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Delete previous file contents
delete("SWEEPS_LAP/"+SWEEP_FOLDER+"\*");
delete("SWEEPS_VEHICLE/"+SWEEP_FOLDER+"\*");

%% Initialize vehicle variables
Initialize_VEHICLE;

%% Global variables for storing laptimes and simulations
global LAP_TIMES
LAP_TIMES = [];
global SIMULATIONS
SIMULATIONS = {};

%% Run sweep
SWEEP(SWEEP_VARIABLES, SWEEP_VALUES, SWEEP_PARAMS_FILE_EXTENSION_BASE);

%% Save LAPTIMES in A_LAPTIMES.mat and SIMULATIONS in A_SIMULATIONS.mat
save("SWEEPS_LAP/"+SWEEP_FOLDER+"/A_LAPTIMES.mat", "LAP_TIMES");
save("SWEEPS_LAP/"+SWEEP_FOLDER+"/A_SIMULATIONS.mat", "SIMULATIONS");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% IMPORTANT - DATA/OUTPUT FORMAT
% the iterations are done recursively through the arrays provided in
% SWEEP_VALUES, so for example if we take the arrays/parameters
% {[1 2 3]
%  [4 5]
%  [6 7 8 9]}
% The simulations would run using the parameters like so
% 146, 147, 148, 149, (ROW 1 of LAP_TIMES)
% 156, 157, 158, 159, (ROW 2 of LAP_TIMES)
% 246, 247, 248, 249, (ROW 3 of LAP_TIMES)
% 256, 257, 258, 259, (ROW 4 of LAP_TIMES)
% 346, 347, 348, 349, (ROW 5 of LAP_TIMES)
% 356, 357, 358, 359, (ROW 6 of LAP_TIMES)
% DONE
% for SIMULATIONS, the data is flattened but follows the same order
% (So read the above parameters left-to-right then top-to-bottom, like a book)

%% OTHER
% Figures, logs, and mat files for vehicles and lap simulations are saved
% in the corresponding SWEEP folders
