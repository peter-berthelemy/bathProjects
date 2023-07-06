function [xs, ys, G, latlony] = properregrid
%This function sets up all the regriddy bits, make sure the height is the
%correct one for you
%This should all be similar to what you had before, just in my own style
Re = 6378.137;
H = 96.0;

s = referenceSphere;
s.LengthUnit = 'km';
s.Radius = Re+H;

[X, Y] = meshgrid(linspace(-1, 1, 512), linspace(-1, 1, 512));
zenith = 90*hypot(X, Y);
zenith = deg2rad(zenith);

r = Re + H;
arcDist = r.*acos((Re.*sin(zenith))./(r)) + r.*(zenith- pi./2);
az = atan2d(X, Y);
xs = arcDist.*cosd(az);
ys = arcDist.*sind(az);

latlony = struct('sphere', s, 'arc', arcDist, 'azimuth', az);

G = scatteredInterpolant(xs(:), ys(:), ones(size(xs(:))), 'linear', 'none');