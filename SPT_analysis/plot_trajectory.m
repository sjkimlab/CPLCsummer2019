%First load the tracks.m variable from your tracking

%Set variabiles for your tracking localization
timeStep = 1; %0.0051;
pixel2micron = 1; %0.16;
min_trajectory_length = 10;
max_trajectory_length = 100;
cellCounter = 1;
%Go through all trajectories in the tracksFinal structure
for ii = 1:length(tracksFinal)
    %Find trajectories that fit your desired parameters
    if length(tracksFinal(ii).tracksFeatIndxCG) >= min_trajectory_length & length(tracksFinal(ii).tracksFeatIndxCG) <= max_trajectory_length
        
        %Start the time counter
        timeCounter = 0;
        counter = 1;
        
        %Go through the tracks coordinates field and extract all of the x
        %and y positions of your data
        for jj = 1:8:length(tracksFinal(ii).tracksCoordAmpCG)
            if ~isnan(tracksFinal(ii).tracksCoordAmpCG(jj))
                trajAll{cellCounter}(counter,1) = timeCounter;
                trajAll{cellCounter}(counter,2:3) = tracksFinal(ii).tracksCoordAmpCG(jj:(jj+1)).*pixel2micron;
                trajAll{cellCounter}(counter,2) = trajAll{cellCounter}(counter,2) - 0; %Shift in x coordinates if needed
                trajAll{cellCounter}(counter,3) = trajAll{cellCounter}(counter,3) - 0; %Shift in y coordinates if needed
                counter = counter + 1;
            end
            timeCounter = timeCounter + timeStep;
        end
        cellCounter = cellCounter + 1;
    end
end

%Designate which trajectory you want to plot
%track2plot = 1;
img = imread("Captured Phase-Ixon001.tif");
figure, imshow(img); hold on;
for track2plot = 1:cellCounter-1
	plot(trajAll{track2plot}(:,2),trajAll{track2plot}(:,3)); hold on;
end;