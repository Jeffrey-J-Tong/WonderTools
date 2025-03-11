%%
% script for processing cerebus data file
% this script is designed for use in linux
% 20160811 zz.
% 20240704 tjf: batch processing
% 20240711 tjf: batch processing - ndm
% 20250311 tjf: prompt select

%% enviorment preparation
% Save library paths
MatlabPath = getenv('LD_LIBRARY_PATH');
% Make Matlab use system libraries
setenv('LD_LIBRARY_PATH',getenv('PATH'))
cwd=pwd; %save current folder

%% run ndm
clc
[f_xml_ndm, p_xml_ndm ]=uigetfile({'*.xml','*.xml|xml file for data pre-processing'},'Please select xml file for data pre-processing');
[f_dat,p_dat]=uigetfile({'*.dat','*.dat|file needs to be resampled'},'Please select the file needs to be resampled');
% run ndm scripts
cd(p_dat);
locs = strfind(p_dat, '/');
dir_name=p_dat(locs(end-1)+1:locs(end)-1);
system(['mv ''' f_dat ''' ''' dir_name '.dat''']);
cd('..');
system(['cp ''' p_xml_ndm f_xml_ndm ''' proc.xml']);
system(['ndm_start proc.xml ' dir_name])
system('rm proc.xml');

%% recover matlab enviorment
% Reassign old library paths
cd(cwd); % go back to original folder
setenv('LD_LIBRARY_PATH',MatlabPath)