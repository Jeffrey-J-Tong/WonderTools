%%
% script for batch running KlustaKwik in linux
% 20240713 tjf

%% all folders
folders = { ...
    '/media/lab008/Jeffrey_3/LE26_240705'; ...
    '/media/lab008/Jeffrey_3/LE26_240706'; ...
    '/media/lab008/Jeffrey_3/LE26_240707'  ...
    };
interval = 0;  % interval before processing next folder

%%
cwd = pwd;
nFolder = size(folders, 1);
for iFolder = 1: nFolder
    folder = folders{iFolder};
    cd(folder);
    fetFile = dir('*.fet.*');
    loc = strfind(fetFile(1).name, '.');
    if ~iscell(fetFile)
        for iFile = 1: numel(fetFile)
            c_idle = check_load_linux;
            while c_idle < 10
                disp(['System resource is low now(' num2str(c_idle) '%), will wait for 10 seconds to resubmit the job.']);
                pause(10)
                c_idle=check_load_linux;
            end
            system(['KlustaKwik ' fetFile(1).name(1:loc(end-1)-1) ' ' num2str(iFile) ...
                ' -MinClusters 20-MaxClusters 30 '...
                ' -MaxPossibleClusters 50&' ]);
            disp(['Job submitted ' num2str(iFile) '/' num2str(length(fetFile)) ' current system resource:' num2str(c_idle) '%']);
        end
    end
    pause(interval);
end
cd(cwd);