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
map(1:5, 6) = black; % Obstacles
startn = 16; % Start Node 1-D Index
destn = 88;  % Stop Node 1-D Index

start_coords = [6, 2];
dest_coords  = [8, 8];

% Generate linear indices of start and dest nodes
startn = sub2ind(size(map), start_coords(1), start_coords(2));
destn  = sub2ind(size(map), dest_coords(1),  dest_coords(2));

distance = Inf(10);
parent = zeros(10);

distance(startn) = 0; %Mark start node on distance map
NodesExp = 0;

while 1
    
    map(startn) = green; % start node
    map(destn) = yellow; % stop node
    %    
        image(1.5,1.5,map);
        grid on;
        axis image;
        drawnow;
    
    [mindist, current] = min(distance(:));
    
    if ((current == destn) || isinf(mindist))
        break;
    end
    
    map(current) = red; %Mark as visited node
    distance(current) = Inf; % Do not consider the node anymore
    NodesExp = NodesExp+1;
    
    % find 2D index for the current node
    [i, j] = ind2sub(size(map), current);
    
    % Explore the 4-Neighborhood
    
    N4 = [i-1 j; i+1 j; ...
          i j-1; i j+1];
    
    for n = 1:4
        x = N4(n,1); y = N4(n,2);
        if ( (x<1) || (x>10) || (y<1) || (y>10) )
        else
            if ( (map(x,y) ~= 2) && (map(x,y) ~= 3) && ...
                (map(x,y) ~= 5) && (distance(x,y) > mindist+1) )
                distance(x,y) = mindist+1;
                map(x,y) = 4;
                parent(x,y) = current;
            end
        end 
        
      pause(.1)
    end
    
end

if min(distance(destn)) == Inf
    route=[];
else
    route = [destn];
    
    % Retrace the path from Goal to Start Node (back tracking)
    while parent(route(1)) ~= 0
        route = [parent(route(1)), route];
    end
    
    for k = 2:length(route)-1
        map(route(k)) = gray; % Mark the path from dest to start
        image(1.5,1.5,map);
        grid on;
        axis image;
    end
end

NodesExp
