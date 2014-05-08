% synthesize rdk
clear all
addpath(genpath('/home/bosse/dev/matlab/0.1-bosse/functionPool'))
addpath(genpath('/home/bosse/devmotionClouds/function'))
dataPath = '/export/data/motionClouds/MOCO_lifetime_MatFiles_30Hz_8.6deg_sec_MoreFrm';

listing = dir(fullfile(dataPath,'MOCO*mat'));

monitorRefresh = 60;
frameRefresh   = 30 ;
stimModRate    = 1 ;
numberOfReps   = 12 ;
framesPerMod   = frameRefresh/stimModRate/2 ; 

offsetRdk      = 45;

for fileIdx = 1:1%length(listing)
tic
  % read MOCO
  load(fullfile(dataPath, listing(fileIdx).name)) ;
  phCohCloud  = squeeze(images);
  boilingPart = phCohCloud(:,:,1:framesPerMod); 
  motionPart  = phCohCloud(:,:,offsetRdk+1:offsetRdk+framesPerMod);
  
  boilingEnv  = fftn(boilingPart) ;
  motionEnv   = fftn(motionPart)  ;
  
  stimulus    = zeros(size(phCohCloud,1),size(phCohCloud,2), frameRefresh/stimModRate*numberOfReps) ;
  for repIdx = 1:numberOfReps
    % boiling
    randPhase      = 2 * pi* rand(size(boilingEnv));
    randPhase      = angle( fftn( real( ifftn( exp(1j*randPhase)))));
    stimPart   = real(ifftn(boilingEnv.* exp(1j*randPhase))) ;
    % rectify
    stimPart = stimPart-mean(stimPart(:));
    stimPart = (.5* stimPart/max(abs(stimPart(:))) + .5) ;
    stimulus(:,:, framesPerMod*2*(repIdx-1)+[1:15] ) = stimPart ;   
    
    % motion
    % change every second repitition
    randPhase  = 2 * pi* rand(size(motionEnv));
    randPhase  = angle( fftn( real( ifftn( exp(1j*randPhase)))));
    stimPart   = real(ifftn(motionEnv.* exp(1j*randPhase))) ;
    stimPart   = stimPart-mean(stimPart(:));
    stimPart   = (.5* stimPart/max(abs(stimPart(:))) + .5) ;
    if mod(repIdx,2)==0
      stimulus(:,:, framesPerMod*2*(repIdx-1)+[16:30] ) = stimPart(:,:,15:-1:1) ;
    else
      stimulus(:,:, framesPerMod*2*(repIdx-1)+[16:30] ) = stimPart ;
    end
    
    
  end
toc
end

% 2. fill envelope with random randPhases