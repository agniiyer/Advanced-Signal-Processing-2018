function [varargout] = iAmp_import_v40(varargin)

%DESCRIPTION:
% Converts a binary file recorded with the data logger iAmp into decimals,
% saves time points and amplitudes in a .mat-file (and workspace) and
% plots raw data; optionally, details about the trial (name, ...) the setup
% (channel names), and events during the trial can be added to the file
%
% Reads the time of the first block and displays the hour of the start time
%
%INPUT:
% String        FileName        path to input file, including folder (or gui)
% String        FileName        path to output file (or via gui)
% String        Option          'fo', 'fol', and 'folder' as input lets the
%                               user choose a diretory to convert all
%                               .BIN-files
%
%OUTPUT:    stored in file with the file-name from input, diff. extension
% Double        NoCha           number of recorded channels
% Double array  data (NxNoCha)  potentials of all channels
% Double array  time (1xN)      times of sampling points (in s)
% Integer       fs              sampling frequency (in Hz)
% String        version_conv    version of iAmp_import used for conversion
% Integer       start_time      time of the day (in seconds)
% Struct        info            details about subject, date, channels, ...
%
%AUTHOR:
% Wilhelm, Theerasak
%
%VERSION 4.0,   22.10.2015
% similar to 3.3 but more efficient way to read in data
% cuts beginning of file if it has a large amplitude
% 'd':		details about recording are asked in command line
% 'r':		a readme-file is created based on -d
% 's':		use input file-name for output
% 'o':      overwrite existing .mat- and readme-files
% 'f':      convert all files in a folder chosen from a GUI
% 'np':     suppress plotting
% 'v':      assign variables to current workspace (for future use), this
%           used to be done by default in previous versions
%
% iAmp_import_v40('s', 'r'); % create readme and save under the same name

%%% Possible additions:
%%% Low power mode is not implemented yet, only the headers are recognised
%%% Before converting: remove empty time at the end (full of 'F's (111111)) -
%%% To make sure no information is lost, keep more blocks than necessary; at
%%% least the first byte of each block should have a valid time stamp
%%% If using folder-import, offer to input channel description and date
%%% once at the start instead of entering it separately for every subject


% Find the correct folder delimiter depending on the operating system
if ispc
    fol_dim = '\';
elseif isunix
    fol_dim = '/';
end

enquireDetails  = 0;
createReadme    = 0;
savewithInput   = 0;
importFolder    = 0;
overwriteFiles  = 0;
plotChannels    = 1;
assignVars      = 0;
idx = find(strcmp('d',varargin));
if idx
    enquireDetails = 1;
    varargin(idx) = [];
end
idx = find(strcmp('r',varargin));
if idx
    enquireDetails = 1;
    createReadme = 1;
    varargin(idx) = [];
end
idx = find(strcmp('s',varargin));
if idx
    savewithInput = 1;
    varargin(idx) = [];
end
idx = find(strcmp('o',varargin));
if idx
    overwriteFiles = 1;
    varargin(idx) = [];
end
idx = find(strcmp('f',varargin));
if idx
    PathName = uigetdir;
    ident = '*';
    filetype = 'BIN';
    fils = dir(strcat(PathName,fol_dim,'*',ident,'*',filetype));
    files = cell(0,0); % If returns an error for folders, remove this line again
    for ii = 1:length(fils); files{ii} = [PathName, fol_dim, fils(ii).name]; end;
    savewithInput = 1;
    importFolder = length(files);
    varargin(idx) = []; clear PathName filetype ident
end
idx = find(strcmp('np',varargin));
if idx
    plotChannels    = 0;
    varargin(idx)   = [];
end
idx = find(strcmp('v',varargin));
if idx
    assignVars      = 1;
    varargin(idx)   = [];
end

if numel(varargin) > 0 %d, r, s, f, o were removed before
    files{1} = varargin{1};
elseif importFolder == 0
    [FileName,PathName] = uigetfile({'*.bin;*.BIN', 'iAmp files (*.bin,*.BIN)'; '*.mat', 'MATLAB (*.mat)'; '*.*', 'All files (*.*)'},'File Selector');
    files{1} = [PathName, FileName]; clear FileName PathName
end

if files{1}==0
    error('No file chosen');
end

tic

if importFolder
    h = waitbar(0,'Initializing waitbar...');
    hchild = get(h,'children');
    htitle = get(hchild,'title');
    set(htitle,'Interpreter','None')
    fold_count = 0;
end
for f = files;
    path = f{1};
    k = strfind(path, fol_dim);
    disp(['Reading the file:               ', path(k(end)+1:end)])
    if importFolder
        % Display status bar
        fold_count = fold_count + 1;
        waitbar(fold_count/importFolder,h,['Working on file ', num2str(fold_count), ' out of ', num2str(importFolder), ': ', path(k(end)+1:end)],'interpreter', 'none');
        figure(h);
    end
    
    % % % First byte of the block is the ADC mode, here are all the possible modes:
    % % % Second byte is the number of active channels, i.e. 1 to 8.
    % % % Subsequent two bytes form one 16-bit value in little endian (!) format and indicate number of overflows that happened, if they happened. Overflows happen if writing to the SD card takes too long and the buffers overflow. If no overflows happened then the value of these 16 bits is 0x8000, if one overflow happened then the value will be 0x8001, if 2 then 0x8002 and so forth until 0x8FFF.
    % % % Next 32-bits form one 32-bit value in little endian (!) format and are the timestamp of the block in seconds.
    % % % So overall, the header is 64 bits or 8 bytes.
    %%% Subsequently, channel data follows in the same format as before. ...
    %%% If only one channel is setup then the data will be: 24 bits for ...
    %%% channel 1, 24 bits for channel 1, 24 bits of channel 1, etc. If ...
    %%% two channels are setup then: 24 bits of channel 1, 24 bits of channel 2, 24 bits of channel 1, 24 bit of channel 2, etc.


    fileID  = fopen(path);
    
        head_mode = fread(fileID,1,'uint8');
        NoCha = fread(fileID,1,'uint8');
        head_over = fread(fileID,1,'ubit16')-32768;
        start_time = fread(fileID,1,'ubit32');
    
    if or(start_time<1,start_time>86400)
        start_time = 0;
        warning('Time not recognised');
    end
    
    [fs, res]   = read_Header(head_mode);

    LeBlo   = 512; % number of bytes in each block
    LeHea   = 8; % length of the header in byte
    fileinfo    = dir(path);
    NoBlo       = fileinfo.bytes/LeBlo;
    NoSBl       = floor((LeBlo-LeHea)/3/NoCha); % number of subblocks (samples in one big block of 512)
    NoSam       = NoBlo*NoSBl;
    NoBloSam    = NoCha*NoSBl;

    frewind(fileID);
    %%% Read the data
    data = zeros(NoSam,NoCha);
    
    %***** read data *****
    dat_no = 1;
    for blk_no = 1:NoBlo
        fseek(fileID,512*(blk_no-1),'bof');
        header_tmp = fread(fileID,8,'int8');
        if ~isequal(header_tmp, -1*ones(8,1))
            if res == 24
                tmp = fread(fileID,NoBloSam,'ubit24'); % ubit24 uses little endian format
                dat_blk = reshape(tmp,NoCha,[]);
                data(dat_no:dat_no+size(dat_blk,2)-1,:) = dat_blk';
                dat_no = dat_no+size(dat_blk,2);
            elseif res == 16
                error('Low resolution mode not implemented yet.')
            end;
        else
            warning(['After ', num2str((blk_no-1)*NoSBl/fs), ' seconds the header was zero and no further data were imported.'])
            disp(['After ', num2str((blk_no-1)*NoSBl/fs), ' seconds the header was zero and no further data were imported.'])
            data(dat_no:end,:) = [];
            break;
        end
    end;
    
    fclose(fileID);
    
    data = swapbytes(int32(data)); %convert little to big endian
    data = (data+1)./256; %shift right 8 bit because of int32
    data = double(data)*0.400/(2^24)*1000; %data will be in mV
    
    disp(['Binaries converted to decimals: ', num2str(toc)])
    
    start_hour = floor(start_time/60/60);
    start_min = floor((start_time-start_hour*60*60)/60);
    start_sec = floor((start_time-start_hour*60*60-start_min*60));
    disp(['Recording started at:                     ', ...
        num2str(start_hour), ':', num2str(start_min), ':', num2str(start_sec)]);
    % Create time-axis
    time = (1:size(data,1))'/fs+start_time;
    
    info            = [];
    info.time_unit  = 's';
    info.data_unit  = 'mV';
    temp            = mfilename;
    info.version    = temp(end-2:end); % alternatively: [ST,I] = dbstack
    
    
    %%% Cut first bit of the file if it has a large amplitude
    MedAmp = median(data(2*fs+1:min(8*fs,size(data,1)),:));
    highAmp = abs(data(:,1)-MedAmp(1))>5;
    las = find(highAmp(1:2*fs)==1,1, 'last');
    if ~isempty(las)
        start_time = start_time+las/fs;
        time(1:las) = [];
        data(1:las,:) = [];
        if plotChannels
            msgbox(['First ' num2str(las/fs) ' seconds were removed.'],'Cutting start');
        end
        info.notes = ['First ' num2str(las/fs) ' seconds were removed.'];
    end; clear highAmp MedAmp;
            
    
    if enquireDetails
        info.experiment = input('Type of experiment (e.g. stress, ASSR, ...): ', 's');
        info.name = input('Name of subject: ', 's');
        info.trial = input('Trial: ', 's');
        info.channels = cell(0,0);
        todayYN = input('Was the recording today? - (y)es/(n)o: ', 's');
        if or(strcmp(todayYN,'y'),or(strcmp(todayYN,'Y'),or(strcmp(todayYN,'Yes'),strcmp(todayYN,'yes'))))
            temp = datestr(today(),'yyyy/mm/dd');
        else
            temp = input('Date of the recording in yyyy/mm/dd: ', 's');
        end
        info.date = datevec(temp);
        exclude = [];
        for i = 1:NoCha
            temp = input(['Description channel ', num2str(i), ': '], 's');
            info.channels = {info.channels{1:end}, temp};
            if strcmpi(temp,'empty')
                exclude = [exclude i];
            end
        end
        if createReadme
            info.Comment = input('Public comment: ', 's');
        end
        counter = 1;
        info.Events = cell(0,0);
        while counter
            temp1 = input(['Description event (if applicable)', num2str(counter), ': '], 's');
            if ~strcmp(temp1, '')
                temp2 = input(['Time of event ', num2str(counter), ' (in seconds, days, or HH:MM:SS): '], 's');
                if strfind(temp2, ':') % Format: HH:MM:SS
                    temp2 = datevec(temp2,'HH:MM:SS');
                    temp2 = datenum([0 0 0 temp2(4:6)]);
                else % Then it must be a numer
                    temp2 = str2double(temp2);
                    if temp2 > 1 % It's in seconds
                        temp2 = temp2/24/60/60;
                    else % It's in days
                        
                    end
                end
                info.Events{end+1,1} = temp1;
                info.Events{end,2} = temp2;
                counter = counter + 1;
            else
                counter = 0;
            end
        end
        clear counter temp1 temp2;
        if createReadme
            info.notes = [info.notes, ';', input('Notes (semicolon starts new line):', 's')];
        end
        data(:,exclude) = [];
        info.channels(exclude) = [];
        NoCha = NoCha-length(exclude);
        if and(length(exclude>0),isfield(info, 'notes'))
            info.notes = [info.notes, ';; Channel(s) ', num2str(exclude), ' were removed as they were described as empty;     '];
            warning(['Channel(s) ', num2str(exclude), ' were removed as they were described as empty'])
        end
    end
    info.date(4:6) = [start_hour start_min start_sec]; clear start_hour start_min start_sec
    
    %% Save data
    save_path = [path(1:end-4),'.mat'];
    
    if ~savewithInput % otherwise .BIN-file is used to name output .mat-file
        if numel(varargin) > 1
            save_path = varargin{2};
        else
            [save_file,save_folder] = uiputfile(save_path, 'Select File to Write');
            save_path = [save_folder, save_file];
            overwriteFiles = 1;
        end
    end
    
    stopSaving = 0;
    if and(~overwriteFiles, exist([save_path(1:end-4), '.mat'],'file'))
        temp = input('Overwrite existing .mat-file? - (y)es/(n)o: ', 's');
        if ~or(strcmpi(temp,'Y'),strcmpi(temp,'YES'))
            stopSaving = 1;
        end
    end
    if stopSaving
        disp('---------- .mat-file was not created ----------');
    else
        if save_path
            save(save_path, 'data', 'time', 'fs', 'NoCha', 'start_time', 'info');
            disp(['Saving complete after:          ', num2str(toc)])
        else
            warning('File was not saved')
        end
    end
    
    %% Create a readme file
    if and(createReadme, and(~overwriteFiles, exist([path(1:end-4), '_readme.txt'],'file')))
        temp = input('Overwrite existing readme-file? - (y)es/(n)o: ', 's');
        if ~or(strcmpi(temp,'Y'),strcmpi(temp,'YES'))
            createReadme = 0;
        end
    end
    if createReadme
        end_hour = floor(time(end)/60/60);
        end_min  = floor((time(end)-end_hour*60*60)/60);
        end_sec  = floor((time(end)-end_hour*60*60-end_min*60));
        
        fid = fopen([path(1:end-4), '_readme.txt'], 'wt' );
        fprintf(fid, 'File:                %s\n\n', save_path);
        fprintf(fid, 'Experiment:          %s\n\n', info.experiment);
        fprintf(fid, 'Name of subject:     %s\n\n', info.name);
        fprintf(fid, 'Date of recording:   %s\n', datestr(info.date, 'dd mmmm yyyy'));
        fprintf(fid, 'Start of recording:  %s\n', datestr(info.date, 'HH:MM:SS'));
        fprintf(fid, 'End of recording:    %s\n', datestr([1900 1 1 end_hour end_min end_sec], 'HH:MM:SS'));
        fprintf(fid, 'Duration (HH:MM:SS): %s\n\n', datestr((time(end)-time(1)+1/fs)/86400, 'HH:MM:SS'));
        fprintf(fid, 'Sampling frequency:  %.0f\n\n', fs);
        for i = 1:NoCha
            fprintf(fid, ['Channel %.0f:',repmat(' ',1,11),'%s\n'], i, info.channels{i});
        end; clear i;
        fprintf(fid, ['\nComment:',repmat(' ',1,12),'%s\n'], info.Comment);
        for i = 1:size(info.Events,1)
            fprintf(fid, ['At  %s:',repmat(' ',1,8),'%s\n'], datestr(info.Events{i,2}, 'HH:MM:SS'), info.Events{i,1});
        end; clear i;
        fprintf(fid, '\nNotes:\n');
        fprintf(fid, strrep(strrep(info.notes,'; ', '\n'), ';', '\n'));
        
        fprintf(fid, '\n\n------------------------\n');
        fclose(fid);
        disp(['Readme completed after:         ', num2str(toc)])
    end; clear end_hour end_min end_sec
    
    if nargout > 0
        varargout{1} = NoCha;
        varargout{2} = data;
        varargout{3} = time;
        varargout{4} = fs;
        varargout{5} = info;
        varargout{6} = start_time;
    else
        varargout = {};
    end
    
    if plotChannels
        if and(exist('iAmp_adjust_v12','file')==2, and(~stopSaving, save_path))
            iAmp_adjust_v12(save_path);
        else
            fig = figure;
            try
                fig.Position = [fig.Position(1)-fig.Position(3)/2 fig.Position(2)-fig.Position(4) fig.Position(3:4)*2];
            catch % for older MATLAB versions (before 2014b or so)
                pos = get(fig,'Position');
                set(fig,'Position', [pos(1)-pos(3)/2 pos(2)-pos(4) pos(3:4)*2])
            end
            for j = 1:NoCha
                ax(j) = subplot(NoCha,1,j);
                plot((time)/(60*60*24), data(:,j));
                datetick('x', 'HH:MM:SS');
                if enquireDetails
                    title([info.channels{j}, ', raw signal']);
                else
                    title(['raw signal, channel ', num2str(j)]);
                end
                xlabel(['Time (', info.time_unit, ')']);
                ylabel(['Potential (', info.data_unit, ')']);
            end; clear j;
            zoom on;
            z = zoom(fig);
            p = pan(fig);
            set(z,'ActionPostCallback',@zoomDateTick)
            set(p,'ActionPostCallback',@zoomDateTick)
            linkaxes(ax,'x');
            xlim([time(1)/(60*60*24) time(end)/(60*60*24)]);
            
            set(gcf, 'name', fliplr(strtok(fliplr(path), fol_dim)));
            
            drawnow
        end
    end
end; clear f k;
if importFolder
    close(h);
end

if assignVars
    assignin('base', 'NoCha', NoCha);
    assignin('base', 'data', data);
    assignin('base', 'time', time);
    assignin('base', 'fs', fs);
    assignin('base', 'info', info);
    assignin('base', 'start_time', start_time);
end

    function [freq_s, resolut] = read_Header(head_idx)
        switch head_idx
            case 128 % 0x80, HIGH_RES_32K_SPS
                freq_s  = 32000; % sampling frequency of 32K
                resolut = 24; % ADC resolution, default: 24 bit
            case 129 % 0x81, HIGH_RES_16K_SPS
                freq_s  = 16000; % sampling frequency of 16K
                resolut = 24; % ADC resolution, default: 24 bit
            case 130 % 0x82, HIGH_RES_4K_SPS
                freq_s  = 8000; % sampling frequency of 8K
                resolut = 24; % ADC resolution, default: 24 bit
            case 131 % 0x83, HIGH_RES_4K_SPS
                freq_s  = 4000; % sampling frequency of 4K
                resolut = 24; % ADC resolution, default: 24 bit
            case 132 % 0x84, HIGH_RES_2K_SPS
                freq_s  = 2000; % sampling frequency of 2K
                resolut = 24; % ADC resolution, default: 24 bit
            case 133 % 0x85, HIGH_RES_1K_SPS
                freq_s  = 1000; % sampling frequency of 1000
                resolut = 24; % ADC resolution, default: 24 bit
            case 134 % 0x86, HIGH_RES_500_SPS
                freq_s  = 500; % sampling frequency of 1000
                resolut = 24; % ADC resolution, default: 24 bit
            case 0 % 0x00, LOW_RES_16K_SPS
                freq_s  = 16000; % sampling frequency of 16K
                resolut = 24; % ADC resolution, 16 bit
            case 1 % 0x01, LOW_RES_8K_SPS
                freq_s  = 8000; % sampling frequency of 8K
                resolut = 24; % ADC resolution, 16 bit
            case 2 % 0x02, LOW_RES_4K_SPS
                freq_s  = 4000; % sampling frequency of 4K
                resolut = 24; % ADC resolution, 16 bit
            case 3 % 0x03, LOW_RES_2K_SPS
                freq_s  = 2000; % sampling frequency of 2K
                resolut = 24; % ADC resolution, 16 bit
            case 4 % 0x04, LOW_RES_1K_SPS
                freq_s  = 1000; % sampling frequency of 1K
                resolut = 24; % ADC resolution, 16 bit
            case 5 % 0x05, LOW_RES_500_SPS
                freq_s  = 200; % sampling frequency of 500
                resolut = 24; % ADC resolution, 16 bit
            case 6 % 0x06, LOW_RES_250_SPS
                freq_s  = 250; % sampling frequency of 250
                resolut = 24; % ADC resolution, 16 bit
%             case 0 % 0x00, LOW_RES_16K_SPS
%                 freq_s  = 16000; % sampling frequency of 16K
%                 resolut = 16; % ADC resolution, 16 bit
%             case 1 % 0x01, LOW_RES_8K_SPS
%                 freq_s  = 8000; % sampling frequency of 8K
%                 resolut = 16; % ADC resolution, 16 bit
%             case 2 % 0x02, LOW_RES_4K_SPS
%                 freq_s  = 4000; % sampling frequency of 4K
%                 resolut = 16; % ADC resolution, 16 bit
%             case 3 % 0x03, LOW_RES_2K_SPS
%                 freq_s  = 2000; % sampling frequency of 2K
%                 resolut = 16; % ADC resolution, 16 bit
%             case 4 % 0x04, LOW_RES_1K_SPS
%                 freq_s  = 1000; % sampling frequency of 1K
%                 resolut = 16; % ADC resolution, 16 bit
%             case 5 % 0x05, LOW_RES_500_SPS
%                 freq_s  = 200; % sampling frequency of 500
%                 resolut = 16; % ADC resolution, 16 bit
%             case 6 % 0x06, LOW_RES_250_SPS
%                 freq_s  = 250; % sampling frequency of 250
%                 resolut = 16; % ADC resolution, 16 bit
            otherwise
                error('Header format not recognised.')
        end
    end

    function zoomDateTick(obj,event_obj)
        nticks = 5;                             % How many tick marks to use
        ax_units = get(event_obj.Axes, 'units');
        set(event_obj.Axes, 'units', 'pixels');
        g = get(event_obj.Axes, 'position');
        nticks = max(floor(g(3)/100),2);
        set(event_obj.Axes, 'units', ax_units);
        
        limits = get(event_obj.Axes,'XLim');    % Get x limits after zooming
        newticks = linspace(limits(1),limits(2),nticks); % Create nticks ticks
        set(event_obj.Axes,'XTick',newticks);   % Set x tick marks in axes
        % Change format using "datetick" but preserve custom ticks:
        datetick(event_obj.Axes,'x','HH:MM:SS','keepticks')
        child_types = get(get(obj,'children'),'type');
        types_sorted = unique(child_types,'sorted');
        subplots = cell2mat(cellfun(@(x) sum(ismember(child_types,x)),types_sorted,'un',0));
        for kk = 1:subplots(1)
            subplot(subplots(1),1,kk);
            xlims = get(gca,'XLim');    % Get x limits after zooming
            if isequal(xlims, limits)
                set(gca,'XTick',newticks);   % Set x tick marks in axes
                datetick(gca,'x','HH:MM:SS','keepticks')
            end
        end
    end

end
