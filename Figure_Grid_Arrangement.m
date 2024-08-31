% Get number of figures
figHandles = findobj('Type', 'figure');
numFigs = length(figHandles);

% Estimated taskbar height (adjust as necessary)
taskbarHeight = 50; % (in pixels)

% Get the screen dimensions
screenSize = get(0, 'ScreenSize');
screenWidth = screenSize(3);
screenHeight = screenSize(4) - taskbarHeight;

% Estimates for window dimensions (adjust as necessary)
windowFrameWidth = 2; % Width of window frame (each side)
titleBarHeight = 60; % Estimated height of the title bar and toolbars

% Determine the number of rows and columns for the grid
numCols = ceil(sqrt(numFigs));
numRows = ceil(numFigs / numCols);

% Determine the width and height of each figure including estimated decorations
figWidth = (screenWidth / numCols) - 2 * windowFrameWidth;
figHeight = (screenHeight / numRows) - titleBarHeight;

% Loop through each figure and set its position
for i = 1:numFigs
    % Calculate the column and row for the current figure
    col = mod(i-1, numCols) + 1;
    row = ceil(i / numCols);
    
    % Calculate the position for the current figure
    posX = (col-1) * (figWidth + 2 * windowFrameWidth);
    posY = screenHeight - row * (figHeight + titleBarHeight) + taskbarHeight;
    
    % Set the figure position
    figure(i); % Bring figure to the front (create it if it does not exist)
    set(gcf, 'Position', [posX, posY, figWidth, figHeight]);
end