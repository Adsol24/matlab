clear all; close all;
cmap = [1 1 1; ...
        0 0 0; ...
        1 0 0; ...
        0 0 1; ...
        0 1 0; ...
        1 1 0; ...
	0.5 0.5 0.5];
colormap(cmap);

% set up color map for display
white = 1; % clear cell
black = 2; % obstacle
red = 3; % visited
blue = 4; % on list
green = 5; % start
yellow = 6; % Goal
gray = 7; % Route Path

map = ones(10); % Start Grid all Free Cells (White)

% % TEST SETUP
map(1:5,6) = black; % Obstacles
startn = 16;%23; % Start Node 1-D Index
% goaln = 88;%82;  % Stop Node 1-D Index

% COMPLEX SETUP
% map(1:7,5) = black; % Obstacles
% map(5:10,7) = black; % Obstacles

% Add an obstacle
% map(1:5, 6) = black;
% map(6:10, 4) = black;
% startn = 23; % Start Node 1-D Index
% goaln = 100;  % Stop Node 1-D Index

parent = zeros(10); % Parent Node Table

[dx,dy] = ind2sub(size(map),goaln);
[X,Y] = meshgrid(1:10,1:10);

% Manhattan distance
H = abs(X - dx) + abs(Y - dy);
%H = H';

% Initialize cost arrays
f = Inf(10);
g = Inf(10);

f(startn) = H(startn);
g(startn) = 0;

NodesExp = 0;

while 1
    % Draw current map
    map(startn) = green;
    % map(goaln) = yellow;
    
    % make drawMapEveryTime = true if you want to see how the 
    % nodes are expanded on the grid. 
    if (1)
        image(1.5, 1.5, map);
        grid on;
        axis image;
        drawnow;
    end
    
    [fmin, current] = min(f(:)); % Next Node to Explore
    
    if (isinf(fmin))
        break;
    end
    
    % Update input_map
    map(current) = red; % Mark as visited Node
    f(current) = Inf; % remove this node from further consideration
    NodesExp = NodesExp + 1;
    
    [i, j] = ind2sub(size(f), current);    
    
    % Explore the 4-Neighborhood
    
    N4 = [i-1 j; i+1 j; ...
          i j-1; i j+1];
    
    for n = 1:4
        x = N4(n,1); y = N4(n,2);
        if ( (x<1) || (x>10) || (y<1) || (y>10) )
        else
            if ( (map(x,y) ~= 2) && (map(x,y) ~= 3) && ...
                (map(x,y) ~= 5) && (g(x,y) > g(i,j) + 1) )
            map(x,y) = 4; %blue
            g(x,y) = g(i,j)+1;
            f(x,y) = H(x,y) + g(x,y);
            parent(x,y) = current;
            end
        end     
    end
    
    pause(.1);    
end

NodesExp

% Construct a Route
if (isinf(goaln))
    route = [];
else
    route = [goaln];
end

while (parent(route(1))~=0)
    route = [parent(route(1)), route];
end

for n = 2:length(route)-1
    map(route(n)) = gray;
    image(1.5,1.5,map);
    grid on;
    axis image;
    drawnow;
end
