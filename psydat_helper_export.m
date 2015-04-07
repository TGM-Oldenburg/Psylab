function varargout = psydat_helper_export(varargin)
% PSYDAT_HELPER_EXPORT M-file for psydat_helper_export.fig
%      PSYDAT_HELPER_EXPORT, by itself, creates a new PSYDAT_HELPER_EXPORT or raises the existing
%      singleton*.
%
%      H = PSYDAT_HELPER_EXPORT returns the handle to a new PSYDAT_HELPER_EXPORT or the handle to
%      the existing singleton*.
%
%      PSYDAT_HELPER_EXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PSYDAT_HELPER_EXPORT.M with the given input arguments.
%
%      PSYDAT_HELPER_EXPORT('Property','Value',...) creates a new PSYDAT_HELPER_EXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before psydat_helper_export_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to psydat_helper_export_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%
% Copyright (C) 2009 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  24 Feb 2009
 

% Last Modified by GUIDE v2.5 19-Mar-2009 16:25:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @psydat_helper_export_OpeningFcn, ...
                   'gui_OutputFcn',  @psydat_helper_export_OutputFcn, ...
                   'gui_LayoutFcn',  @psydat_helper_export_LayoutFcn, ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before psydat_helper_export is made visible.
function psydat_helper_export_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to psydat_helper_export (see VARARGIN)

% Choose default command line output for psydat_helper_export
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes psydat_helper_export wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = psydat_helper_export_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
psy_filenames = dir('psydat_*');
snames = [];
for k=1:length(psy_filenames),
    subject_name = psy_filenames(k).name(8:end);
    
    % omit empty names, autosave filesnames and names ending in '_subset'
    if ~isempty(subject_name) &  subject_name(end) ~= '~' & isempty(strfind(subject_name,'_subset')),
        % concatenate the subject names
        snames = [snames cellstr(subject_name) ];
    end
end
   
set(handles.listbox1, 'String', snames)



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
contents = get(hObject,'String');
handles.subject_name = contents{get(hObject,'Value')};

handles.psydat_filename = ['psydat_' handles.subject_name];
handles.psydat_all_lines = textread(handles.psydat_filename, '%s',  'whitespace', '\n');
% find occurrences of new experiment results
handles.experiments_line_idx = strmatch ('#### ', handles.psydat_all_lines);

handles.experiments_name = {};
for k=1:length(handles.experiments_line_idx),
  tok = mpsy_split_lines_to_toks(char(handles.psydat_all_lines(handles.experiments_line_idx(k))));
  handles.experiments_name(k,:) = tok(2);
  exp_datetime = char(tok(4));
  exp_date(k,:)   = exp_datetime(1:11);
  exp_year(k,:)   = str2num(exp_datetime(8:11));
  exp_month(k,:)  = exp_datetime(4:6);
  exp_day(k,:)    = str2num(exp_datetime(1:2));
  exp_time(k,:)   = exp_datetime(14:end);
  exp_hour(k,:)   = str2num(exp_datetime(14:15));
  exp_minute(k,:) = str2num(exp_datetime(17:18));
    
  handles.experiments_datetime(k,:) = exp_datetime;
  handles.experiments_npar(k,1) = str2num(char(tok(6)));
end

handles.uni_experiments = unique(handles.experiments_name);
set(handles.listbox2, 'String', handles.uni_experiments);
set(handles.listbox2, 'Value', 1);

% and clear listbox 3
set(handles.listbox3, 'String', '');
set(handles.listbox3, 'Value', 1);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

contents = get(hObject,'String');
handles.exp_name = contents{get(hObject,'Value')};

handles.exp_dates = {};
handles.exp_npar = [];
handles.exp_lines_idx = [];
for k=1:length(handles.experiments_line_idx),
    if strcmp(handles.exp_name, handles.experiments_name(k)),
        handles.exp_dates(end+1) = cellstr(handles.experiments_datetime(k,:));
        handles.exp_npar = [handles.exp_npar; handles.experiments_npar(k)];
        handles.exp_lines_idx = [handles.exp_lines_idx; handles.experiments_line_idx(k)];
    end
end

% put all occuring dates pertaining to THIS experiment (with its name
% stored in handes.exp_name) into listbox3
set(handles.listbox3, 'String', handles.exp_dates);
set(handles.listbox3, 'Value', 1);
    
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3

% note(MH): this callback does nothing but it has to be here because it
% gets called upon clicks into the listbox.


function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% see which items were selected in the listbox3.  these numbers are an
% index into yet the different index-arrays:  'handles.exp_lines_idx' and
% 'handles.exp_npar'
date_idx = get(handles.listbox3, 'Value');

subname  = [handles.subject_name, '_subset'];
filename = ['psydat_', subname];
[fid,msg] = fopen(filename, 'w' );
if ~strcmp(msg,''),
    error('fopen on file % returned with message %s\n',file_name, msg);
end

% copy the first header line of the psydat file
fprintf(fid,'%s\n', char(handles.psydat_all_lines(1)));
% add a notice about data being a subset of all data
fprintf(fid,'##############################################################\n');
fprintf(fid,'## NOTICE: this file was auto-generated by psydat_helper.   ##\n');
fprintf(fid,'##         it contains only a subset of the original number ##\n');
fprintf(fid,'##         of data points belonging to subject %12s ##\n', handles.subject_name);
fprintf(fid,'##         and experiment %33s ##\n', handles.exp_name);
fprintf(fid,'##############################################################\n');
for l=1:length(date_idx),
    % this is the starting line index into the psydat file
    line_idx_exp_start = handles.exp_lines_idx(date_idx(l));
    % this is the npar of this experiment
    this_npar = handles.exp_npar(date_idx(l));
    
    % this would copy the starting line of the experiment
    %%% fprintf(fid, '%s\n', char(handles.psydat_all_lines(line_idx_exp_start)));
    
    % and this copies the starting line of the experiment with a replaced
    % subject name, ending in '_subset'
    old_string = char(handles.psydat_all_lines(line_idx_exp_start));
    new_string = strrep(old_string, handles.subject_name, subname);
    fprintf(fid, '%s\n', new_string);
    
    % copy the following npar+1 lines with parameter lines and result lines
    for jj= 1 : 1+this_npar,
        fprintf(fid, '%s\n', char(handles.psydat_all_lines(line_idx_exp_start+jj)));
    end
end

fclose(fid);

figure(201);
display_psydat(subname, handles.exp_name);

    
    


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure(200);
display_psydat(handles.subject_name, handles.exp_name);




% --- Creates and returns a handle to the GUI figure. 
function h1 = psydat_helper_export_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', 2, ...
    'pushbutton', 4, ...
    'popupmenu', 2, ...
    'slider', 3, ...
    'listbox', 6, ...
    'uipanel', 3, ...
    'text', 4, ...
    'togglebutton', 2), ...
    'override', 0, ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastSavedFile', '/home/martin/psydat_helper_export.m', ...
    'lastFilename', '/home/martin/psylab/psylab-2.3/psydat_helper.fig');
appdata.lastValidTag = 'figure1';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'figure1');

h1 = figure(...
'Units','characters',...
'PaperUnits','centimeters',...
'Color',[0.701960784313725 0.701960784313725 0.701960784313725],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','psydat_helper',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'PaperSize',[20.98404194812 29.67743169791],...
'PaperType',get(0,'defaultfigurePaperType'),...
'Position',[103.8 32.8186813186813 125 28.6428571428571],...
'Resize','off',...
'UseHG2','off',...
'HandleVisibility','callback',...
'Tag','figure1',...
'UserData',[],...
'Visible','on',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton1';

h2 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','psydat_helper_export(''pushbutton1_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[8 25 26 1.71428571428571],...
'String','find all subject names',...
'Tag','pushbutton1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'listbox1';

h3 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','psydat_helper_export(''listbox1_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[8 7 26 14.3571428571429],...
'String',{  'Listbox' },...
'Style','listbox',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, 'psydat_helper_export(''listbox1_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','listbox1');

appdata = [];
appdata.lastValidTag = 'listbox2';

h4 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','psydat_helper_export(''listbox2_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[41.5 7 33.5 14.2857142857143],...
'String',{  'Listbox' },...
'Style','listbox',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, 'psydat_helper_export(''listbox2_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','listbox2');

appdata = [];
appdata.lastValidTag = 'listbox3';

h5 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','psydat_helper_export(''listbox3_Callback'',gcbo,[],guidata(gcbo))',...
'Max',2,...
'Position',[83 7 33.5 14.3571428571429],...
'String',{  'Listbox' },...
'Style','listbox',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, 'psydat_helper_export(''listbox3_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','listbox3');

appdata = [];
appdata.lastValidTag = 'text1';

h6 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[8.5 21.4285714285714 15.8333333333333 1.35714285714286],...
'String','subject names',...
'Style','text',...
'Tag','text1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text2';

h7 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[41.8333333333333 21.4285714285714 13.5 1.35714285714286],...
'String','experiments',...
'Style','text',...
'Tag','text2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text3';

h8 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[83.5 21.4285714285714 14.6666666666667 1.28571428571429],...
'String','dates / times',...
'Style','text',...
'Tag','text3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton2';

h9 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','psydat_helper_export(''pushbutton2_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[83 3.5 33.5 1.78571428571429],...
'String','extract these and plot',...
'Tag','pushbutton2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton3';

h10 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','psydat_helper_export(''pushbutton3_Callback'',gcbo,[],guidata(gcbo))',...
'Position',[41.5 3.5 33.5 1.71428571428571],...
'String','plot all data',...
'Tag','pushbutton3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );


hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   eval(createfcn);
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error('MATLAB:gui_mainfcn:FieldNotFound', 'Could not find field %s in the gui_State struct in GUI M-file %s', gui_StateFields{i}, gui_Mfile);
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % PSYDAT_HELPER_EXPORT
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % PSYDAT_HELPER_EXPORT(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallbak(gui_State, varargin{:})
    % PSYDAT_HELPER_EXPORT('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % PSYDAT_HELPER_EXPORT(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~isa(handle(fig),'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || isprop(fig,'__GUIDEFigure');
    end
        
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else       
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end

    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.

    
    % Do feval on layout code in m-file if it exists
    gui_Exported = ~isempty(gui_State.gui_LayoutFcn);
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.   
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);

        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')

        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
    end

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end

    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});

    if isscalar(gui_hFigure) && ishandle(gui_hFigure)
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure); 
        
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);

        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~gui_Exported
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end

        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end

    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end

    if isscalar(gui_hFigure) && ishandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    gui_hFigure = openfig(name, singleton, visible);
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
             && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallbak(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
             (ischar(varargin{1}) ...
             && isequal(ishandle(varargin{2}), 1) ...
             && ~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])));
catch
    result = false;
end


