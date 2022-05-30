function out = readstl(fname);


% This code reads in a .stl shape file containing a triangular facet
% representation of an object and returns the facets defined in a compact
% matrix form. Only recognizes "facet" definition in .stl files. Not overly
% smart; doesn't try to allocate correct amount of memory in advance;
% no error or consistency checking; should preserve CW/CCW but doesn't
% care which it is.
%
% syntax: out = readstl(fname);
%
% where fname is a string  with the filename.
%
% output argument out is a matrix where each row is a facet:
%   each row is [x1 y1 z1 x2 y2 z2 x3 y3 z3]
%   where vertex i has coords (xi,yi,zi)
%
%  Greg Balco -- Berkeley Geochronology Center
%  Checked and edited Oct 2011
%
% This file is for use in the course of reviewing an accompanying paper
% ('Simple computer code for estimating cosmic-ray shielding by oddly
% shaped objects', submitted to Quaternary Geochronology). It is not
% licensed for use for any other purpose. 

% Open file

fid = fopen(fname,'r');

% Initializations

thisfacet = 0;
thisvertex = 0;
data = zeros(1,9); % 1 row, 9 cols

% Outer loop

while 1
    
    % Get a line
    thisline = fgetl(fid);
    
    % Bail on EOF
    if thisline < 0; break; end;
    
    % Clear previous line information
    clear parsed_text;
    % Parse the line
    remains = strtrim(thisline);
    k = 1;
    while true;
        [parsed_text{k}, remains] = strtok(remains);
        if isempty(parsed_text{k}); break; end;
        k = k+1;
    end;
        
    % Decide what to do with it
    if strcmp(parsed_text{1},'facet');
        % Start a new facet
        thisfacet = thisfacet + 1;
    elseif strcmp(parsed_text{1},'vertex');
        thisvertex = thisvertex + 1; % Increment vertex
        % Get the data
        thisvertexdata = [str2num(parsed_text{2}) str2num(parsed_text{3}) str2num(parsed_text{4})];
    end; % Those are the only options
    
    % Now decide what to do with the vertex data
    if thisvertex == 1;
        data(thisfacet,:) = zeros(1,9); % Make a new row
        data(thisfacet,1:3) = thisvertexdata;
    elseif thisvertex == 2;
        data(thisfacet,4:6) = thisvertexdata;
    elseif thisvertex == 3;
        data(thisfacet,7:9) = thisvertexdata;
        % Reset vertex
        thisvertex = 0;
    end;
end;

fclose(fid);

out = data;