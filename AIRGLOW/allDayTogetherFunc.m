
function [ST] = allDayTogetherFunc(frames, xs, ys, G, dt)

% sizeDataArray = 512;

%Star removal
starGone = filloutliers(frames, 'linear','movmedian', 10, 1);
starGone = filloutliers(starGone, 'linear','movmedian', 10, 2);

four = fftn(starGone);
low = floor(size(four, 3)./4);
four(:,:,[1:low, end-low:end]) = 0;
foured = real(ifftn(four));
foured = foured(:,:,1:end-2);
toGrid = filloutliers(foured, 'linear', 'percentiles', [10 90]);

% dSmooth = imgaussfilt(toGrid, [15,15]);
% toGrid = toGrid - dSmooth;
toGrid = smoothn(toGrid, [3 3 1]);

lastFrame = size(toGrid, 3);
griddy = linspace(-256, 256, 512);
airGrid = zeros(length(griddy), length(griddy), lastFrame);

for n = 1:1:lastFrame
    %Put each frame into the interpolant object
    G.Values = linearise(toGrid(:,:,n));
    dataInterp = G({griddy, griddy});
    %And then into the all data array
    airGrid(:,:,n) = dataInterp;
end

airGrid = airGrid(112:400, 112:400, :);

 
IN2 = airGrid(:,:,1:size(airGrid, 3));
nanlocs = isnan(IN2); IN2(nanlocs) = 0;
scales = 150;
c = [0.25 0.25 1];
point_spacing = [mean(diff(griddy), 'all'), mean(diff(griddy), 'all'), dt];
minwl = [5 5 3*dt];
maxwl = [80 80 50*dt];
% ST = nph_2dst_plus1(IN2,scales,point_spacing,c,'minwavelengths',minwl,'maxwavelengths',maxwl, 'full');
ST = nph_ndst(IN2,scales,point_spacing,c,'minwavelengths',minwl,'maxwavelengths',maxwl);


%%
% Re = 6378.137;
% H = 87.0;
% sizeDataArray = 512;

% camRotate = 22.0;

%Make meshgrid for all the pixels in the OG pic
%Think this is assuming the sizes are always 512x512
%Look back at this
% initialX = -256:1:256; initialX(257) = [];
% initialY = -256:1:256; initialY(257) = [];
% [pixelX, pixelY] = meshgrid(initialX,initialY);
% %Find distances between each pixels
% pixelDist = sqrt((pixelX).^2 + (pixelY).^2);
% %Find elevation, and arc length [using s = r(theta)]
% elevation = atan2(pixelDist, 256);

% zenith = abs(meshgrid(linspace(-90, 90, 512), linspace(-90, 90, 512)));
% [X, Y] = meshgrid(linspace(-1, 1, 512), linspace(-1, 1, 512));
% zenith = 90*hypot(X, Y);
% zenith(abs(zenith)>90) = NaN;
% zenith = deg2rad(zenith);

% r = Re + H;
% arcDist = r.*acos((Re.*sin(zenith))./(r)) + r.*(zenith- pi./2);
% az = atan2d(X, Y);
% xs = arcDist.*cosd(az);
% ys = arcDist.*sind(az);

% % degree_of_arc = acos((Re.*sin(elevation))./(r)) + (elevation - pi./2);
% % Calculate azimuth angle
% azi =  rad2deg(atan2(pixelX, pixelY));
% neggy_azi = azi < 0;
% azi(neggy_azi) = azi(neggy_azi) +360;
% % Rotate to north
% azi = azi + camRotate;
% % Convert to Cartesian
% xs = arcDist.*cosd(azi);
% ys = arcDist.*sind(azi);

% G = scatteredInterpolant(xs(:), ys(:), ones(size(xs(:))), 'linear', 'none');
% G.Values = linearise(Airglow(:,:,25));
% dataInterp = G({griddy, griddy});
% dataInterp(abs(zenith)>(pi/2)) = NaN;
% gridCoords = -floor(sizeDataArray/2):1:floor(sizeDataArray/2);
% [X, Y] = meshgrid(gridCoords, gridCoords);
% radius = hypot(X, Y);
% lastFrame = size(frames, 3);
% griddy = linspace(-400, 400, 512);
% airGrid = zeros(length(griddy), length(griddy), lastFrame);
% % frames = Airglow(:,:,1:100);
% %Lets get this changed
% for n = 1:1:lastFrame
%     %Put each frame into the interpolant object
%     G.Values = linearise(frames(:,:,n));
%     dataInterp = G({griddy, griddy});
%     %And then into the all data array
%     airGrid(:,:,n) = dataInterp;
% end
% %Star removal
% airGrid = filloutliers(airGrid, 'linear','movmedian', 10, 1);
% airGrid = filloutliers(airGrid, 'linear','movmedian', 10, 2);
% % disp("Gridding done")
% 
% airGrid = airGrid(100:400, 100:400, :);
% 
% %Check for time discrepancies, this is obviously wrong but eh
% % if mean(diff(Times, 2)) > 0.01
% %     disp('The timings are off')
% %     return
% % end
% 
% 
% 
% fftnumber = floor(size(airGrid, 3)./8)-1;
% dfft_output = NaN(sizeDataArray,sizeDataArray,16,fftnumber);
% % Need to do the fft removal in sections 
% 
% for i = 1:fftnumber-1
%     startnum = 1+(8.*(i-1));
%     endnum = 16 +(i-1).*8;
%     dii_loop = airGrid(:,:,startnum:endnum);
% 
%     TheFT = fftn(dii_loop); %3d fft
%     LowElements = floor(size(TheFT,3)./4); %remove the bottom quarter of frequencies
%     
%     TheFT(:,:,[1:LowElements,end-LowElements:end]) = 0;  %low frequencies, i.e. zodiacal set to 0
%     dii_loop = real(ifftn(TheFT)); % inverse
%     clear TheFT LowElements
%     
%     dfft_output(:,:,:,i) = dii_loop;
% end
% 
% A = dfft_output(:,:,9:16-4,:);
% sz = size(A);
% foured = reshape(A,sz(1),sz(2),sz(3)*sz(4));
% 
% dSmooth = imgaussfilt(foured, [15,15]);
% foured = foured - dSmooth;
% foured = smoothn(foured, [3 3 1]);
% disp("Fourier transform done")

%% S-TransForm

% IN = foured(:,:,1:size(foured, 3)-8);
% nanlocs = isnan(IN); IN(nanlocs) = 0;
% scales = 150;
% c = [0.25 0.25 1];
% point_spacing = [1 1 dt];
% minwl = [5 5 300];
% maxwl = [30 30 42700];
% ST = nph_ndst(IN,scales,point_spacing,c,'minwavelengths',minwl,'maxwavelengths',maxwl);
% disp("S-transform done")



