%% version history
% script for processing cerebus data file
% this script is designed for use in linux
% 20160811 zz.
% 20240704 tjf: batch processing
% 20240711 tjf: batch processing - ndm

%% enviorment preparation
% Save library paths
MatlabPath = getenv('LD_LIBRARY_PATH');
% Make Matlab use system libraries
setenv('LD_LIBRARY_PATH',getenv('PATH'))
cwd=pwd; %save current folder

%% MODIFY: all .dat files and .xml files
interval = 0;  % interval after processing each recording data
xmlFullpaths = { ...
    '/home/lab/Desktop/JifuTong/LE26_COLOR.xml'; ...
    '/home/lab/Desktop/JifuTong/LE26_COLOR.xml'; ...
    '/home/lab/Desktop/JifuTong/LE26_COLOR.xml'  ...
    };
datFullpaths = { ...
    '/media/lab/Jeffrey/LE26_240705/amplifier.dat'; ...
    '/media/lab/Jeffrey/LE26_240706/amplifier.dat'; ...
    '/media/lab/Jeffrey/LE26_240707/amplifier.dat'  ...
    };

%% run ndm
nDat = numel(datFullpaths);
if numel(xmlFullpaths) ~= nDat
    error('Wrong number of xml and dat file. Check again.');
end
for iDat = 1: nDat
    clc
    disp(['processing #' num2str(iDat) ' of ' num2str(nDat) ' recording files']);
    
    % replace: uiget .xml file
    xmlFull = xmlFullpaths{iDat};
    [p, f, ~] = fileparts(xmlFull);
    p_xml_ndm = [p '/'];
    f_xml_ndm = [f '.xml'];
    clear p f

    % replace: uiget .dat file
    datFull = datFullpaths{iDat};
    [p, f, ~] = fileparts(datFull);
    p_dat = [p '/'];
    f_dat = [f '.dat'];
    clear p f
    
    % run ndm scripts
    cd(p_dat);
    locs = strfind(p_dat, '/');
    dir_name=p_dat(locs(end-1)+1:locs(end)-1);
    system(['mv ''' f_dat ''' ''' dir_name '.dat''']);
    cd('..');
    system(['cp ''' p_xml_ndm f_xml_ndm ''' proc.xml']);
    system(['ndm_start proc.xml ' dir_name])
    system('rm proc.xml');
    
    % disp info
    disp('New task will start after some interval');
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    disp('!!!!!! DO NOT STOP THIS SCRIPT !!!!!!');
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    pause(interval);
end

%% recover matlab enviorment
% Reassign old library paths
cd(cwd); % go back to original folder
setenv('LD_LIBRARY_PATH',MatlabPath)