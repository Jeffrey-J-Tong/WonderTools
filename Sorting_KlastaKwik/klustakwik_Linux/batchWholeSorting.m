%% version history
% script for processing cerebus data file
% this script is designed for use in linux
% 20160811 zz.
% 20240704 tjf: batch processing

%% enviorment preparation
% Save library paths
MatlabPath = getenv('LD_LIBRARY_PATH');
% Make Matlab use system libraries
setenv('LD_LIBRARY_PATH',getenv('PATH'))
cwd=pwd; %save current folder

%% all .dat files and .xml files
interval = 0;  % interval after processing each recording data
xmlFullpaths = { ...
    '/home/lab/Desktop/JifuTong/LE22_COLOR.xml'; ...
    '/home/lab/Desktop/JifuTong/LE22_COLOR.xml'; ...
    '/home/lab/Desktop/JifuTong/LE22_COLOR.xml'; ...
    '/home/lab/Desktop/JifuTong/LE22_COLOR.xml'; ...
    '/home/lab/Desktop/JifuTong/LE22_COLOR.xml'; ...
    '/home/lab/Desktop/JifuTong/LE22_COLOR.xml'; ...
    '/home/lab/Desktop/JifuTong/LE22_COLOR.xml'; ...
    '/home/lab/Desktop/JifuTong/LE22_COLOR.xml'; ...
    '/home/lab/Desktop/JifuTong/LE22_COLOR.xml'; ...
    '/home/lab/Desktop/JifuTong/LE22_COLOR.xml'  ...
    };
datFullpaths = { ...
    '/media/lab/Jeffrey_3/LE22_240524/amplifier.dat'; ...
    '/media/lab/Jeffrey_3/LE22_240525/amplifier.dat'; ...
    '/media/lab/Jeffrey_3/LE22_240526/amplifier.dat'; ...
    '/media/lab/Jeffrey_3/LE22_240527/amplifier.dat'; ...
    '/media/lab/Jeffrey_3/LE22_240528/amplifier.dat'; ...
    '/media/lab/Jeffrey_3/LE22_240529/amplifier.dat'; ...
    '/media/lab/Jeffrey_3/LE22_240530/amplifier.dat'; ...
    '/media/lab/Jeffrey_3/LE22_240531/amplifier.dat'; ...
    '/media/lab/Jeffrey_3/LE22_240601/amplifier.dat'; ...
    '/media/lab/Jeffrey_3/LE22_240602/amplifier.dat'  ...
    };

%%
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
    
    % run sorter
    cd(p_dat);
    fet_file=dir('*.fet.*');
    loc=strfind(fet_file(1).name,'.');
    if ~iscell(fet_file)
        for idx=1:length(fet_file)
            c_idle=check_load_linux;
            while c_idle<10
                disp(['System resource is low now(' num2str(c_idle) '%), will wait for 10 seconds to resubmit the job.']);
                pause(10)
                c_idle=check_load_linux;
            end
            %         system(['KlustaKwik ' fet_file(1).name(1:loc(end-1)-1) ' ' num2str(idx) ...
            %             ' -UseDistributional 0 -MinClusters 20 -MaxClusters 21 '...
            %         ' -MaxPossibleClusters 50 -DropLastNfeatures 1 &' ]);
            system(['KlustaKwik ' fet_file(1).name(1:loc(end-1)-1) ' ' num2str(idx) ...
                ' -MinClusters 20-MaxClusters 30 '...
                ' -MaxPossibleClusters 50&' ]);
            disp(['Job submitted ' num2str(idx) '/' num2str(length(fet_file)) ' current system resource:' num2str(c_idle) '%']);
        end
    end

    % disp info
    disp('All Jobs submitted to backend, come back later to check .clu files')
    disp(['#' num2str(iDat) ' of ' num2str(nDat) ' recording files is submitted.']);
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
