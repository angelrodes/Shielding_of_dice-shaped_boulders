function out = unpackHorizonFile(fname);

% This reads in a text file containing horizon information and returns a
% variable structure containing the information in the text file. 
%
% Syntax: out = unpackHorizonFile(fname);
%
% fname is string containing filename to read
%
% out has fields:
%   out.az
%   out.el
%   out.strike
%   out.dip
%
% in the form needed by skyline.m. 
%
% file has form:
%
% a line of azimuths separated by spaces (if none, line reads 0);
% a line of elevations separated by spaces (if none, line reads 0);
% a line giving the strike (optional)
% a line giving the dip (optional)
%
% Greg Balco -- Berkeley Geochronology Center -- 2009-2011
% Edited and checked - April 2012
%
% This file is for use in the course of reviewing an accompanying paper
% ('Simple computer code for estimating cosmic-ray shielding by oddly
% shaped objects', submitted to Quaternary Geochronology). It is not
% licensed for use for any other purpose. 
%


fid = fopen(fname,'r');

line_az = fgetl(fid);
line_el = fgetl(fid);
sdFlag = 0;
line_strike = fgetl(fid);
if line_strike < 0;
    % Case EOF
elseif isempty(str2num(line_strike));
    % Case empty string this line
else;
    sdFlag = 1;
    line_dip = fgetl(fid);
end;

fclose(fid);


% parse azimuth line

out.az = str2num(line_az);
if length(out.az) == 1 & out.az == 0;
    out.az = [];
end;

% parse elevation line

out.el = str2num(line_el);
if length(out.el) == 1 & out.el == 0;
    out.el = [];
end;


% read in strike and dip lines if needed

if sdFlag;
    out.strike = str2num(line_strike);
    out.dip = str2num(line_dip);
end;


