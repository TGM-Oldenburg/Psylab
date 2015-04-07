function varargout = psydat_helper-ok(varargin)
% PSYDAT_HELPER M-file for psydat_helper.fig
%      PSYDAT_HELPER, by itself, creates a new PSYDAT_HELPER or raises the existing
%      singleton*.
%
%      H = PSYDAT_HELPER returns the handle to a new PSYDAT_HELPER or the handle to
%      the existing singleton*.
%
%      PSYDAT_HELPER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PSYDAT_HELPER.M with the given input arguments.
%
%      PSYDAT_HELPER('Property','Value',...) creates a new PSYDAT_HELPER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before psydat_helper_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to psydat_helper_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%
% Copyright (C) 2009 by Martin Hansen, Fachhochschule OOW, Oldenburg
% Author :  Martin Hansen <psylab AT jade-hs.de>
% Date   :  24 Feb 2009
 

% Last Modified by GUIDE v2.5 27-Feb-2009 11:05:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @psydat_helper_OpeningFcn, ...
                   'gui_OutputFcn',  @psydat_helper_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before psydat_helper is made visible.
function psydat_helper_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to psydat_helper (see VARARGIN)

% Choose default command line output for psydat_helper
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes psydat_helper wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = psydat_helper_OutputFcn(hObject, eventdata, handles) 
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
        handles.exp_dates = [handles.exp_dates; handles.experiments_datetime(k,:)];
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


