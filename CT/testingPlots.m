
a = dir(fullfile(cd, 'data', 'ozone', '*.nc'));
n = numel(a);

ozbig = zeros(18, 23, n);

for bean = 1:n
    ozone = rCDF(fullfile(a(1).folder, a(bean).name), 0);
    ozbig(:,:,bean) = ozone.merged_ozone_concentration;
%     clear ozone
end
% figure
% m_proj('miller')
% m_grid
% % pcolor(ozone.merged_ozone_vmr);shading flat
for x = 1:size(ozbig, 3)
%         m_pcolor(sea.lon-180, sea.lat, sea.sla');shading flat
        pcolor(ozone.approximate_altitude, ozone.latitude_centers, ozbig(:,:,x));shading flat
        colorbar
        drawnow
        pause(0.05*2)
end


% sea = rCDF('ESACCI-SEALEVEL-L4-MSLA-MERGED-20000215000000-fv02.nc', 0);
% 
% 
% m_pcolor(sea.lon-180, sea.lat, sea.sla');shading flat
% hold on
% m_coast
