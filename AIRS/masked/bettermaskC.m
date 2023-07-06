function Mask = bettermaskC(strans, sumCutoff, sizeCutoff, blurCutoff,Vars,SmoothSize,NDerivs)
%{
Creates a mask given an S-transform and a cutoff
Generally works by normalising the variables to between -1 and 1
Then takes the absolute difference between consecutive points
Sum these together for each variable (plus the second differential of each)
Anything less than the given cutoff is assumed to be a wave
Anything above the cutoff is noise

Then removes any small waves (this is slow feel free to comment out)
Does some smoothing and image wrangling then the mask is complete
%
%written by Peter Berthelemy, May 2023
%reformatted by Corwin Wright, June 2023 - no change to fundamental logic, but large syntactic changes
%}

%create an array we will use to sum all of the tests applied
Sigma = zeros(size(strans.A));

%now, for each variable used in the test...
for iVar=1:1:numel(Vars)

  %extract the variable from the input S-Transform structure and normalise it into the range -1 to 1
  V = strans.(Vars{iVar});
  V = ((V-min(V(:)))./range(V(:))) .*2 -1;

  %compute the absolute value of the first NDerivs derivatives in each direction, and add this to the Sigma array
  for iDiff=1:1:NDerivs
    for iDir=1:1:2;
      if     iDir == 1; x = size(V,1)-iDiff; y = size(V,2);
      elseif iDir == 2; x = size(V,1);       y = size(V,2)-iDiff;
      end     
      Sigma(1:x,1:y,:) = Sigma(1:x,1:y,:) + abs(diff(V,iDiff,iDir));
    end
  end

end; clear iVar V iDiff iDir x y strans

%now, apply the cutoff to produce a binary mask
Mask = zeros(size(Sigma));
sumCutoff.*NDerivs.*numel(Vars)
Mask(Sigma <= sumCutoff.*NDerivs.*numel(Vars)) = 1;
clear sumCutoff

%this mask is jumpy, which waves usually aren't. 
%to resolve this, first discard small unconnected regions at each height individually 
%(3D here is extremely computationally expensive and would give similar results)
Mask2 = zeros(size(Mask));
for iZ=1:1:size(Mask,3)
  pp = regionprops(logical(Mask(:,:,iZ)), 'area', 'PixelIdxList');
  stats = pp([pp.Area] > sizeCutoff);
  M3 = Mask2(:,:,iZ);
  M3(vertcat(stats.PixelIdxList)) = 1;
  Mask2(:,:,iZ) = M3;
end; 
Mask = Mask2;
clear Mask2 iZ pp stats M3 sizeCutoff

%finally, apply some smoothing to the end product and then filter the final product one last time
Mask = smoothn(Mask,SmoothSize);
Mask(Mask > blurCutoff) = true;
Mask(Mask~=1) = 0;
Mask = imclose(Mask, strel("disk",2));
Mask = imfill(Mask, 'holes');