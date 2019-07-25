%{
/// average MSD graphs for U-track channel/movie ///

Kavya Vaidya
June 13 2019
University of Illinois Urbana-Champaign
Kim Lab

*run msd_Utrack.m before running this*

This script gives graphs for all MSD values for trajectories in one channel &
average MSD for the whole channel

---------------------------------------------------------------------------
Input : tracksFinal structure obtained from "Channel_n_tracking result.mat"
in folder 'Tracks' from tracking output after running U-track software
AllMSD variable & AverageMSD variable

Field "MSD" added to tracksFinal using msd_Utrack.m
Also needs values nTracks, timeInterval from msd_Utrack.m
---------------------------------------------------------------------------
Output : 4 Figures

Figure 1: Graph of all MSD values vs Time interval for all trajectories in
the Channel

Figure 2: Graph of average MSD value vs Time interval for all trajectories
in the Channel

Figure 3:Bar graph of number of trajectories vs time interval used to
calculate the average MSD value.

Figure 4: Histogram of length of trajectories
%}

%Scatter plot calculating MSDs for all trajectories
for i = 1:nTracks
    if size(tracksFinal(i).MSD,1)>1
        scatter(tracksFinal(i).MSD(:,1),tracksFinal(i).MSD(:,2),4)
        hold on
    end
end
hold off
xlabel({'Time interval'})
ylabel({'MSDs of all trajectories'})
figure()

%Scatter plot for average MSD for the channel
scatter(AverageMSD(:,1),AverageMSD(:,2),6)
xlabel({'Time interval'})
ylabel({'Avg MSD for all trajectories'})
figure()

%Length of Average for AvgMSD scatterplot
bar(AverageMSD(:,1),AverageMSD(:,3))
ylabel(('No. of trajectories for Avg'))
xlabel({'Time interval'})
figure()

histogram(TrajLen)
xlabel('Length of Trajectories')
ylabel('Number')