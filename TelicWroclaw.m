function [] = TelicWroclaw()

%%%%%%FUNCTION DESCRIPTION
%TelicZv1 is a prototype of TelicZ
%It is meant for standalone use
%It is currently incomplete.
%%%%%%%%%%%%%%%%%%%%%%%%%

Screen('Preference', 'SkipSyncTests', 0);
close all;
sca
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);
rng('shuffle');
KbName('UnifyKeyNames');



%%%%%%%%
%COLOR PARAMETERS
%%%%%%%%
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white/2;

%%%Screen Stuff

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
%opens a window in the most external screen and colors it)
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
%Anti-aliasing or something? It's from a tutorial
ifi = Screen('GetFlipInterval', window);
%Drawing intervals; used to change the screen to animate the image
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
%The size of the screen window in pixels
[xCenter, yCenter] = RectCenter(windowRect);
%The center of the screen window

%%%%%%
%FINISHED PARAMETERS
%%%%%%



minSpace = 20;
%the minimum possible number of frames between steps

breakTime = .5;
%The number of seconds for each pause

crossTime = 1;
%Length of fixation cross time

pauseTime = .5;
%Length of space between loops presentation

textsize = 36;
textspace = 1.5;

%Matlab's strings are stupid, so I have quotes and quotes with spaces in
%variables here
quote = '''';
squote = ' ''';

%%%%%%
%LISTS
%%%%%%

correlation_list = {'corr';'corr';'corr';'corr';'corr';'corr';'corr';...
    'corr';'corr';'corr';'anti';'anti';'anti';'anti';'anti';'anti';...
    'anti';'anti';'anti';'anti'};

list = 'test';
if strcmp(list, 'test')
    trial_list = {[4 5; 5 4;]; [9 7; 7 9]; [6 8; 8 6];};
    trial_list = [trial_list;trial_list];
    correlation_list = {'corr';'corr';'corr';'anti';'anti';'anti'};
elseif strcmp(list, 'blue')
    trial_list = {[4 5; 5 4;]; [4 6; 6 4]; [4 7; 7 4]; [4 8; 8 4]; [4 9; 9 4]; ...
        [9 4; 4 9]; [9 5; 5 9]; [9 6; 6 9]; [9 7; 7 9]; [9 8; 8 9]};
    trial_list = [trial_list;trial_list];
elseif strcmp(list, 'pink')
    trial_list = {[5 6; 6 5]; [5 7; 7 5]; [5 8; 8 5]; [5 9; 9 5]; [4 9; 9 4]; ...
        [9 4; 4 9]; [8 4; 4 8]; [8 5; 5 8]; [8 6; 6 8]; [8 7; 7 8]};
    trial_list = [trial_list;trial_list];
elseif strcmp(list, 'green')
    trial_list = {[6 7; 7 6]; [6 8; 8 6]; [6 9; 9 6]; [5 9; 9 5]; [4 9; 9 4]; ...
        [9 4; 4 9]; [8 4; 4 8]; [7 4; 4 7]; [7 5; 5 7]; [7 6; 6 7]};
    trial_list = [trial_list;trial_list];
elseif strcmp(list, 'orange')
    trial_list = {[7 8; 8 7]; [6 8; 8 6]; [5 8; 8 5]; [4 8; 8 4]; [4 9; 9 4]; ...
        [9 4; 4 9]; [9 5; 5 9]; [8 5; 5 8]; [7 5; 5 7]; [6 5; 5 6]};
    trial_list = [trial_list;trial_list];
elseif strcmp(list, 'yellow')
    trial_list = {[4 9; 9 4]; [5 9; 9 5]; [6 9; 9 6]; [7 9; 9 7]; [8 9; 9 8]; ...
        [5 4; 4 5]; [6 4; 4 6]; [7 4; 4 7]; [8 4; 4 8]; [9 4; 4 9]};
    trial_list = [trial_list;trial_list];
end

shuff = randperm(length(trial_list));
trial_list = trial_list(shuff,:);
correlation_list = correlation_list(shuff);


%%%%%%
%THE ACTUAL FUNCTION!!!
%%%%%%

%%%%%%%Screen Prep
HideCursor;	% Hide the mouse cursor
Priority(MaxPriority(window));

%%%%%%Shape Prep

theImageLocation = 'star.png';
[imagename, ~, alpha] = imread(theImageLocation);
imagename(:,:,4) = alpha(:,:);

% Get the size of the image
[s1, s2, ~] = size(imagename);

% Here we check if the image is too big to fit on the screen and abort if
% it is. See ImageRescaleDemo to see how to rescale an image.
if s1 > screenYpixels || s2 > screenYpixels
    disp('ERROR! Image is too big to fit on the screen');
    sca;
    return;
end

% Make the image into a texture
starTexture = Screen('MakeTexture', window, imagename);

theImageLocation = 'heart.png';
[imagename, ~, alpha] = imread(theImageLocation);
imagename(:,:,4) = alpha(:,:);

% Get the size of the image
[s1, s2, ~] = size(imagename);

% Here we check if the image is too big to fit on the screen and abort if
% it is. See ImageRescaleDemo to see how to rescale an image.
if s1 > screenYpixels || s2 > screenYpixels
    disp('ERROR! Image is too big to fit on the screen');
    sca;
    return;
end

% Make the image into a texture
heartTexture = Screen('MakeTexture', window, imagename);

scale = screenYpixels / 10;%previously 15

vbl = Screen('Flip', window);

%%%%%%DATA FILES


%%%%%Conditions and List Setup

%Format is [number_of_loops total_animation_time]

blockList = {'mass'}; %'count'};
keys = [1, 2, 3, 4, 5, 6, 7, 8, 9];
correlated_values = [.75, 1.5, 2.25, 3, 3.75, 4.5, 5.25, 6, 6.75];
anticorrelated_values = [9, 8.25, 7.5, 6.75, 6, 5.25, 4.5, 3.75, 3];

%%%%%%RUNNING
for condition = blockList
    if strcmp(condition,'mass')
        breakType = 'random';
    else
        breakType='equal';
    end


    %%%%%%TRAINING

    % breakType = 'equal';
    % numberOfLoops = 1;
    % loopTime = 1;
    % totaltime =
    % framesPerLoop = round(loopTime / ifi) + 1;

    % trainSentence(window, textsize, textspace, 1, breakType, screenYpixels);
    % animateEventLoops(numberOfLoops, framesPerLoop, ...
    %     minSpace, scale, xCenter, yCenter, window, ...
    %     pauseTime, breakType, breakTime, screenNumber, heartTexture, ...
    %     ifi, vbl)
    % 
    % trainSentence(window, textsize, textspace, 2, breakType, screenYpixels);
    % numberOfLoops = 2;
    % loopTime = 1;
    % framesPerLoop = round(loopTime / ifi) + 1;
    % animateEventLoops(numberOfLoops, framesPerLoop, ...
    %     minSpace, scale, xCenter, yCenter, window, ...
    %     pauseTime, breakType, breakTime, screenNumber, heartTexture, ...
    %     ifi, vbl)
    % 
    % trainSentence(window, textsize, textspace, 3, breakType, screenYpixels);
    % numberOfLoops = 3;
    % loopTime = 1;
    % framesPerLoop = round(loopTime / ifi) + 1;
    % animateEventLoops(numberOfLoops, framesPerLoop, ...
    %     minSpace, scale, xCenter, yCenter, window, ...
    %     pauseTime, breakType, breakTime, screenNumber, heartTexture, ...
    %     ifi, vbl)


    %%%%%%RUNNING
     
    for x = 1:length(trial_list)
        trial = trial_list{x};
        trial = trial(randi([1,2]),:);
        numberOfLoops = trial(1);
        totaltime = anticorrelated_values(numberOfLoops);
        if strcmp(correlation_list{x}, 'corr')
            disp('test corr')
            totaltime = correlated_values(numberOfLoops);
        end
        loopTime = totaltime/numberOfLoops;
        framesPerLoop = round(loopTime / ifi) + 1;

        animateEventLoops(numberOfLoops, framesPerLoop, ...
            minSpace, scale, xCenter, yCenter, window, ...
            pauseTime, breakType, breakTime, screenNumber, starTexture, ...
            ifi, vbl)
        
        numberOfLoops = trial(2);
        totaltime = correlated_values(numberOfLoops);
        loopTime = totaltime/numberOfLoops;
        framesPerLoop = round(loopTime / ifi) + 1;

        animateEventLoops(numberOfLoops, framesPerLoop, ...
            minSpace, scale, xCenter, yCenter, window, ...
            pauseTime, breakType, breakTime, screenNumber, heartTexture, ...
            ifi, vbl)
    end


end %ending the block
%%%%%%Finishing and exiting
sca
Priority(0);
end






%%%%%START/FINISH/BREAK FUNCTIONS%%%%%

function [] = animateEventLoops(numberOfLoops, framesPerLoop, ...
    minSpace, scale, xCenter, yCenter, window, ...
    pauseTime, breakType, breakTime, screenNumber, imageTexture, ...
    ifi, vbl)
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    grey = white/2;
    [xpoints, ypoints] = getPoints(numberOfLoops, framesPerLoop);
    totalpoints = numel(xpoints);
    Breaks = makeBreaks(breakType, totalpoints, numberOfLoops, framesPerLoop, minSpace);
    xpoints = (xpoints .* scale) + xCenter;
    ypoints = (ypoints .* scale) + yCenter;
    %points = [xpoints ypoints];
    
    pt = 1;
    waitframes = 1;
    Screen('FillRect', window, grey);
    Screen('Flip', window);
    while pt <= totalpoints
        %If the current point is a break point, pause
        if any(pt == Breaks)
            WaitSecs(breakTime);
        end
        destRect = [xpoints(pt) - 128/2, ... %left
            ypoints(pt) - 128/2, ... %top
            xpoints(pt) + 128/2, ... %right
            ypoints(pt) + 128/2]; %bottom
        
        % Draw the shape to the screen
        Screen('DrawTexture', window, imageTexture, [], destRect, 0);
        Screen('DrawingFinished', window);
        % Flip to the screen
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        pt = pt + 1;
        
    end
    Screen('FillRect', window, black);
    vbl = Screen('Flip', window);
    WaitSecs(pauseTime);
end




%%%%%%RESPONSE FUNCTION%%%%%

function [response, time] = getResponse(window, screenXpixels, screenYpixels, textsize, testq)
    black = BlackIndex(window);
    white = WhiteIndex(window);
    textcolor = white;
    xedgeDist = floor(screenXpixels / 3);
    numstep = floor(linspace(xedgeDist, screenXpixels - xedgeDist, 7));
    Screen('TextFont',window,'Arial');
    Screen('TextSize',window,textsize);

    DrawFormattedText(window, testq, 'center', screenYpixels/3, textcolor, 70);
    for x = 1:7
        DrawFormattedText(window, int2str(x), numstep(x), 'center', textcolor, 70);
    end
    DrawFormattedText(window, '  not  \n at all \nsimilar', numstep(1) - (xedgeDist / 25),...
        screenYpixels/2 + 30, textcolor);
    DrawFormattedText(window, 'very \nsimilar', numstep(7) - (xedgeDist / 25), screenYpixels/2 + 30, textcolor);
    Screen('Flip',window);

    % Wait for the user to input something meaningful
    inLoop=true;
    oneseven = [KbName('1!') KbName('2@') KbName('3#') KbName('4$')...
        KbName('5%') KbName('6^') KbName('7&')];
%     numkeys = [89 90 91 92 93 94 95];
    starttime = GetSecs;
    while inLoop
        response = 0;
        [keyIsDown, ~, keyCode]=KbCheck;
        if keyIsDown
            code = find(keyCode);
            if any(code(1) == oneseven)
                endtime = GetSecs;
                response = KbName(code);
                response = response(1);
                if response
                    inLoop=false;
                end
            end
        end
    end
    time = endtime - starttime;
end




%%%%%%FIXATION CROSS FUNCTION%%%%%

function[] = fixCross(xCenter, yCenter, black, window, crossTime)
    fixCrossDimPix = 40;
    xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
    yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
    allCoords = [xCoords; yCoords];
    lineWidthPix = 4;
    Screen('DrawLines', window, allCoords,...
        lineWidthPix, black, [xCenter yCenter], 2);
    Screen('Flip', window);
    WaitSecs(crossTime);
end


%%%%%TRAINING FUNCTIONS%%%%%

function [] = trainSentence(window, textsize, textspace, phase, breakType, screenYpixels)
    Screen('TextFont',window,'Arial');
    Screen('TextSize',window,textsize + 5);
    black = BlackIndex(window);
    white = WhiteIndex(window);
    Screen('FillRect', window, black);
    Screen('Flip', window);
    quote = '''';
    if strcmp(breakType, 'random')
        verb = 'gleeb';
    else
        verb = 'blick';
    end
    
    switch phase
        case 1
            DrawFormattedText(window, ['You' quote 're going to see the star ' verb 'ing.'],...
                'center', 'center', white, 70, 0, 0, textspace);
        case 2
            DrawFormattedText(window, ['Now you' quote 're going to see the star ' verb 'ing some more.'],...
                'center', 'center', white, 70, 0, 0, textspace);
        case 3
            if strcmp(breakType, 'random')
                DrawFormattedText(window, ['Last one for now. You' quote 're going to see the star ' verb 'ing.'],...
                    'center', 'center', white, 70, 0, 0, textspace);
            else
                DrawFormattedText(window, ['Let' quote 's see that again. You' quote 're going to see the star ' verb 'ing some more.'],...
                    'center', 'center', white, 70, 0, 0, textspace);
            end
    end
    
    Screen('TextSize',window,textsize);
    DrawFormattedText(window, 'Ready? Press spacebar.', 'center', ...
        screenYpixels/2+50, white, 70, 0, 0, textspace);
    Screen('Flip', window);
    % Wait for keypress
    RestrictKeysForKbCheck(KbName('space'));
    KbStrokeWait;
    Screen('Flip', window);
    RestrictKeysForKbCheck([]);
end

%%%%%STIMULUS MATH FUNCTIONS%%%%%


function [xpoints, ypoints] = getPoints(numberOfLoops, numberOfFrames)
    %OK, so, the ellipses weren't lining up at the origin very well, so
    %smoothframes designates a few frames to smooth this out. It uses fewer
    %frames for the ellipse, and instead spends a few frames going from the
    %end of the ellipse to the origin.
    smoothframes = 5;
    xpoints = [];
    ypoints = [];
    majorAxis = 2;
    minorAxis = 1;
    centerX = 0;
    centerY = 0;
    theta = linspace(0,2*pi,numberOfFrames-smoothframes);
    %The orientation starts at 0, and ends at 360-360/numberOfLoops
    %This is to it doesn't make a complete circle, which would have two
    %overlapping ellipses.
    orientation = linspace(0,360-round(360/numberOfLoops),numberOfLoops);


    for i = 1:numberOfLoops
        %orientation calculated from above
        loopOri=orientation(i)*pi/180;

        %Start with the basic, unrotated ellipse
        initx = (majorAxis/2) * sin(theta) + centerX;
        inity = (minorAxis/2) * cos(theta) + centerY;

        %Then rotate it
        x = (initx-centerX)*cos(loopOri) - (inity-centerY)*sin(loopOri) + centerX;
        y = (initx-centerX)*sin(loopOri) + (inity-centerY)*cos(loopOri) + centerY;

        %then push it out based on the rotation
        for m = 1:numel(x)
            x2(m) = x(m) + (x(round(numel(x)*.75)) *1);
            y2(m) = y(m) + (y(round(numel(y)*.75)) *1);
        end

        %It doesn't start from the right part of the ellipse, so I'm gonna
        %shuffle it around so it does. (this is important I promise)  
        %It also adds in some extra frames to smooth the transition between
        %ellipses
        start = round((numberOfFrames-smoothframes)/4);
        x3 = [x2(start:numberOfFrames-smoothframes) x2(1:start) linspace(x2(start),0,smoothframes)];
        y3 = [y2(start:numberOfFrames-smoothframes) y2(1:start) linspace(x2(start),0,smoothframes)];

        %Finally, accumulate the points in full points arrays for easy graphing
        %and drawing
        xpoints = [xpoints x3];
        ypoints = [ypoints y3];
    end
end

function [Breaks] = makeBreaks(breakType, totalpoints, loops, loopFrames, minSpace)
    if strcmp(breakType, 'equal')
        Breaks = 1 : totalpoints/loops : totalpoints;

    elseif strcmp(breakType, 'random')
        Breaks = randi([1 (loops*loopFrames)], 1, loops-1);
        x = 1;
        y = 2;
        while x <= numel(Breaks)
            while y <= numel(Breaks)
                if x ~= y && abs(Breaks(x) - Breaks(y)) < minSpace || Breaks(x) < minSpace ||...
                        (loops*loopFrames) - Breaks(x) < minSpace
                    Breaks(x) =  randi([1, (loops*loopFrames)], 1, 1);
                    x = 1;
                    y = 0;
                end
                y = y + 1;
            end
            x = x + 1;
            y = 1;
        end

    else
        Breaks = [];
    end
end