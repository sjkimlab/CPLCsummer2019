
%{
/// MSD calculator for U-track movie ///

Kavya Vaidya
June 13 2019
University of Illinois Urbana-Champaign
Kim Lab

This script calculates average Mean Square Displacements for trajectories obtained from U-track
software and finds average values for the whole movie

To obtain graphs for all MSD values for trajectories in one channel run msdGraph_Utrack.m after running this
script.
---------------------------------------------------------------------------
Input : tracksFinal structure obtained from "Channel_n_tracking result.mat"
in folder 'Tracks' from tracking output after running U-track software

*Change pixelSize and timeInterval values according to microscopy settings
done to obtain results. Also change nFrames threshold in line 44.
---------------------------------------------------------------------------
Output : MSD output in three forms

AverageMSD - Contains Tau (Time intervals) in Column 1 and mean MSD (using
all trajectories in the Channel) in column 2, no. of values used for
calculating mean MSD in column 3

AllMSD- contains all MSD values for each trajectory in one array. Missing
values are given by NaNs. Each row corresponds to MSD value for Tau. Each
column contains MSD values for that trajectory


Field tracksFinal.MSD added to tracksFinal structure.
Calculates MSD vs Tau (time interval) values for each trajectory( n trajectories given by
nx1 tracksFinal structure)

Field contains double structures with rows corresponding to different Tau
values. There are always 4 columns. Column 1 corresponds to values of Tau,
Column 2 corresponds to the Average MSD calculated for that Tau, Column 3
is the standard devation & Column 4 is the number of values used to average
MSD for that particular Tau.

%}

[tracksFinal.MSD]=deal([]); %Creating a new field to store msd data

pixelSize = 160e-9; %metres %% Change pixel size according your experimental data %%
timeInterval = 20.0e-3; %seconds %% Change time interval according your experimental data %%

nTracks = size(tracksFinal,1);
TrajLen = nan(nTracks,1);

for i = 1:nTracks
    nFrames = size(tracksFinal(i).tracksCoordAmpCG,2)/8;
    if nFrames>10 && nFrames<300 %threshold for minimal number of frames for worthwhile MSD
        
        Traj=zeros(nFrames,2);%will store x and y coordinates

        for j = 1:nFrames
            
            Coords=tracksFinal(i).tracksCoordAmpCG;
            
            Traj(j,1)=Coords(1+(j-1)*8)*pixelSize; %x coordinates
            Traj(j,2)=Coords(2+ (j-1)*8)*pixelSize;%y coordinates
        end
        
        nTraj = size(Traj,1); %number of frames in trajectory
        TrajLen(i) = nTraj;
        nTau = floor(nTraj/4); %number of Tau we should choose
        
        msd = zeros(nTau,4);
        for tau = 1:nTau
            dr = Traj(1+tau:end,1:2) - Traj(1:end-tau,1:2);
            dr2 = sum(dr.^2,2);
            
            msd(tau,1)=tau*timeInterval; %The frame difference (time interval)
            msd(tau,2)=mean(dr2,'omitnan'); %Mean MSD
            msd(tau,3)=std(dr2,'omitnan'); %Standard Deviation MSD
            msd(tau,4)=length(dr2) - nnz(isnan(dr2)); %Number of coordinate pairs
        end
        [tracksFinal(i).MSD] = msd;
    end
end

TrajLen = TrajLen(~isnan(TrajLen));


maxsize = size(tracksFinal(1).MSD,1); %To find the maximum number of Tau values in MSD field

for i = 1:nTracks
    if size(tracksFinal(i).MSD,1)>maxsize
        maxsize = size(tracksFinal(i).MSD,1);
    end
end

AllMSD = nan(maxsize,nTracks);

for i = 1:nTracks
    n = size(tracksFinal(i).MSD,1);
    if n>0
    AllMSD(1:n,i) = tracksFinal(i).MSD(:,2); %AllMSD contains every MSD value for each track for the particular channel
    end
end

AverageMSD(:,2) = nanmean(AllMSD,2);
AverageMSD(:,1) = 1:maxsize;
AverageMSD(:,3) = sum(~isnan(AllMSD),2);
AverageMSD(:,1) = AverageMSD(:,1)*timeInterval; %AverageMSD contains time intervals & avg MSD for the channel
