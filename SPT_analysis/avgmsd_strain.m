%{
/// average MSD calculator for different movies  ///

Kavya Vaidya
July 16 2019
University of Illinois Urbana-Champaign
Kim Lab

*run msd_Utrack.m before running this*

This script gives an average MSD graph and avg MSD values saved in 'avgTotalMSD'
variable for all MSD values obtained across different movies obtained from
U-track Single Particle Tracking 

INPUT
This code takes in "AllMSD" variable which is output from msd_Utrack.m
Save the "AllMSD" variable from each movie's post-processing as .mat file in a single folder before using this code
Make that folder the MATLAB Current Folder or add it to the MATLAB path

note : Do not use file names beginning with ' or ! because of the way dir structure is saved
%}

files = dir('\Users\kvaidya2\Desktop\Microscopy\SK187 output\TIRF'); %Plug in the folder path containing mat files
timeInterval = 20.0e-3;
Num = 12; %Number of data points to be taken (correspond to index of Tau)

TotalMSD = [];
for i=3:numel(files) %begins at 3 because of the first two entries in 'files' structure
    load(files(i).name)
    MSD = AllMSD(1:Num,:);
    TotalMSD = [TotalMSD MSD]; %concatenating into a big array containing all MSD values across all tracks in all movies
end

avgTotalMSD(:,2) = nanmean(TotalMSD,2);
avgTotalMSD(:,1) = 1:Num;
avgTotalMSD(:,1) = avgTotalMSD(:,1)*timeInterval;
avgTotalMSD(:,3) = nanstd(TotalMSD,0,2); % stdev of MSDs
avgTotalMSD(:,4) = sum(~isnan(TotalMSD),2); % number of MSDs 

%Scatter plot for average MSD for the channel
figure, scatter(avgTotalMSD(:,1),avgTotalMSD(:,2),6)
xlabel({'Time interval'})
ylabel({'Avg MSD for all trajectories'})

figure,
errorbar(avgTotalMSD(:,1),avgTotalMSD(:,2),avgTotalMSD(:,3)./sqrt(avgTotalMSD(:,4)))

figure,
scatter(avgTotalMSD(:,1),avgTotalMSD(:,4),6)
xlabel({'Time interval'})
ylabel({'Number of trajectories per MSD value'})
