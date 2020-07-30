function varargout = IMAGER(varargin)
% IMAGER MATLAB code for IMAGER.fig
%      IMAGER, by itself, creates a new IMAGER or raises the existing
%      singleton*.
%
%      H = IMAGER returns the handle to a new IMAGER or the handle to
%      the existing singleton*.
%
%      IMAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGER.M with the given input arguments.
%
%      IMAGER('Property','Value',...) creates a new IMAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IMAGER_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IMAGER_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IMAGER

% Last Modified by GUIDE v2.5 19-Jun-2012 12:08:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IMAGER_OpeningFcn, ...
                   'gui_OutputFcn',  @IMAGER_OutputFcn, ...
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


% --- Executes just before IMAGER is made visible.
function IMAGER_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IMAGER (see VARARGIN)

% Choose default command line output for IMAGER
handles.output = hObject;

%Default Values 
set(handles.edit4_GCP_Numbers, 'String', 3) 
handles.Interpolation_Method = 'nearest'; 
handles.Solution_Model = 'affine'; 
handles.SM_Value = get(handles.popupmenu1_Solution_Model, 'Value'); 
handles.Show_Output = get(handles.checkbox_Compare_Output, 'Value'); 
handles.NoGCPs = 3; 
handles.Path_Ref = get(handles.edit_Ref_Image_Path, 'String'); 
handles.Path_Input = get(handles.edit_Input_Image_Path, 'String'); 
handles.xy_Input_Out = []; 
handles.xy_Ref_Out = []; 
handles.Full_Out_Path = get(handles.edit_Output_Image_path, 'String'); 


% Update handles structure
guidata(hObject, handles);


% UIWAIT makes IMAGER wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IMAGER_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Pushbutton_Cancel.
function Pushbutton_Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Pushbutton_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close IMAGER



% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) 
if (size(handles.xy_Input_Out,1) < handles.NoGCPs) || (size(handles.xy_Ref_Out,1) < handles.NoGCPs) 
        handles.Selected_GCPs = 'Less'; 
        msgbox('Please select minimum number of required GCPs', 'Minimum GCPs', 'warn')
else
if strcmp(handles.Solution_Model, 'polynomial') 
    if handles.NoGCPs == 6 
        TForm = cp2tform(handles.xy_Input_Out, handles.xy_Ref_Out, handles.Solution_Model, 2); 
    elseif handles.NoGCPs == 10 
        TForm = cp2tform(handles.xy_Input_Out, handles.xy_Ref_Out, handles.Solution_Model, 3); 
    elseif handles.NoGCPs == 15 
        TForm = cp2tform(handles.xy_Input_Out, handles.xy_Ref_Out, handles.Solution_Model, 4); 
    end 
else 
    TForm = cp2tform(handles.xy_Input_Out, handles.xy_Ref_Out, handles.Solution_Model); 
end 
Transformed_Image = imtransform(handles.Input_Image, TForm, handles.Interpolation_Method); 
imwrite(Transformed_Image, handles.Full_Out_Path); 
if handles.Show_Output == 1 
    figure 
    imshow(handles.Ref_Image) 
    hold on 
    Im = imshow(Transformed_Image, gray(256)); 
    set(Im, 'AlphaData', 0.5) 
    hold off 
else 
    msgbox('Registration Complete', 'Done !!!', 'help')
end 
end


function edit_Input_Image_Path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Input_Image_Path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Input_Image_Path as text
%        str2double(get(hObject,'String')) returns contents of edit_Input_Image_Path as a double
handles.Path_Input = get(hObject, 'String'); 
if isempty(handles.Path_Input) 
    msgbox('Please select an input image', 'File Missing', 'error') 
elseif isempty(dir(handles.Path_Input)) 
    msgbox('Image file doesn''t exist, please select another image', 'File Missing', 'error') 
else 
    Input_Img = imread(handles.Path_Input); 
    handles.Input_Image = Input_Img; 
end 
guidata(hObject, handles); 


% --- Executes during object creation, after setting all properties.
function edit_Input_Image_Path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Input_Image_Path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Ref_Image_Path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Ref_Image_Path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Ref_Image_Path as text
%        str2double(get(hObject,'String')) returns contents of
%        edit_Ref_Image_Path as a double 
handles.Path_Ref = get(hObject, 'String'); 
if isempty(handles.Path_Ref) 
    msgbox('Please select a reference image', 'File Missing', 'error') 
elseif isempty(dir(handles.Path_Ref)) 
    msgbox('Image file doesn''t exist, please select another image', 'File Missing', 'error') 
else 
    Ref_Img = imread(handles.Path_Ref); 
    handles.Ref_Image = Ref_Img; 
end 
guidata(hObject, handles); 


% --- Executes during object creation, after setting all properties.
function edit_Ref_Image_Path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Ref_Image_Path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Pushbutton_Browse_Input_Image.
function Pushbutton_Browse_Input_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Pushbutton_Browse_Input_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Input_Name, Input_Path] = uigetfile({'*.BMP';'*.CUR';'*.GIF';'*.HDF4';'*.ICO';'*.JPEG';'*.JPEG 2000';'*.PBM';'*.PCX';'*.PGM';'*.PNG';'*.PPM';'*.RAS';'*.TIF';'*.XWD'}, 'Open Input Image');
if isequal(Input_Name,0)
else 
    Full_Input_Path = fullfile(Input_Path, Input_Name); 
    handles.Path_Input = Full_Input_Path; 
    Input_Img = imread(Full_Input_Path); 
    handles.Input_Image = Input_Img; 
    set(handles.edit_Input_Image_Path,'String', Full_Input_Path) 
end
guidata(hObject, handles);   



% --- Executes on button press in Pushbutton_Browse_Reference_Image.
function Pushbutton_Browse_Reference_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Pushbutton_Browse_Reference_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Ref_Name, Ref_Path] = uigetfile({'*.BMP';'*.CUR';'*.GIF';'*.HDF4';'*.ICO';'*.JPEG';'*.JPEG 2000';'*.PBM';'*.PCX';'*.PGM';'*.PNG';'*.PPM';'*.RAS';'*.TIF';'*.XWD'}, 'Open Reference Image');
if isequal(Ref_Name,0)
else 
    Full_Ref_Path = fullfile(Ref_Path, Ref_Name); 
    handles.Path_Ref = Full_Ref_Path; 
    Ref_Img = imread(Full_Ref_Path); 
    handles.Ref_Image = Ref_Img; 
    set(handles.edit_Ref_Image_Path,'String', Full_Ref_Path) 
end 
guidata(hObject, handles);
 


% --- Executes on button press in Pushbutton_Collect_GCPs.
function Pushbutton_Collect_GCPs_Callback(hObject, eventdata, handles) 
% hObject    handle to Pushbutton_Collect_GCPs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) 
handles.Path_Ref = get(handles.edit_Ref_Image_Path, 'String'); 
handles.Path_Input = get(handles.edit_Input_Image_Path, 'String'); 
if isempty(handles.Path_Input) 
    msgbox('Please select an input image !', 'Image missing', 'error') 
elseif isempty(handles.Path_Ref) 
    msgbox('Please select a reference image !', 'Image missing', 'error') 
else 
    [Input_Out, Ref_Out] = cpselect(handles.Input_Image, handles.Ref_Image, 'Wait', true); 
    handles.xy_Input_Out = Input_Out; 
    handles.xy_Ref_Out = Ref_Out; 
    if (size(handles.xy_Input_Out,1) < handles.NoGCPs) || (size(handles.xy_Ref_Out,1) < handles.NoGCPs) 
        handles.Selected_GCPs = 'Less'; 
        msgbox('Please select minimum number of required GCPs', 'Minimum GCPs', 'warn')
    end
end 
guidata(hObject, handles);
handles 
 


% --- Executes on selection change in popupmenu1_Solution_Model.
function popupmenu1_Solution_Model_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1_Solution_Model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1_Solution_Model contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1_Solution_Model
handles.Solution_Model = get(handles.popupmenu1_Solution_Model, 'String'); 
handles.SM_Value = get(handles.popupmenu1_Solution_Model, 'Value'); 

switch handles.SM_Value 
    case 1 
        set(handles.edit4_GCP_Numbers, 'String', 3) 
        handles.NoGCPs = 3; 
        handles.Solution_Model = 'affine'; 
    case 2 
        set(handles.edit4_GCP_Numbers, 'String', 12) 
        handles.NoGCPs = 12; 
        handles.Solution_Model = 'lwm'; 
    case 3 
        set(handles.edit4_GCP_Numbers, 'String', 2) 
        handles.NoGCPs = 2; 
        handles.Solution_Model = 'nonreflective similarity'; 
    case 4 
        set(handles.edit4_GCP_Numbers, 'String', 4) 
        handles.NoGCPs = 4; 
        handles.Solution_Model = 'piecewise linear'; 
    case 5 
        set(handles.edit4_GCP_Numbers, 'String', 6) 
        handles.NoGCPs = 6; 
        handles.Solution_Model = 'polynomial'; 
    case 6 
        set(handles.edit4_GCP_Numbers, 'String', 10) 
        handles.NoGCPs = 10; 
        handles.Solution_Model = 'polynomial'; 
    case 7 
        set(handles.edit4_GCP_Numbers, 'String', 15) 
        handles.NoGCPs = 15; 
        handles.Solution_Model = 'polynomial'; 
    case 8 
        set(handles.edit4_GCP_Numbers, 'String', 4) 
        handles.NoGCPs = 4; 
        handles.Solution_Model = 'projective'; 
    case 9 
        set(handles.edit4_GCP_Numbers, 'String', 3) 
        handles.NoGCPs = 3; 
        handles.Solution_Model = 'similarity'; 
end
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function popupmenu1_Solution_Model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1_Solution_Model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Output_Image_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Output_Image_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Output_Image_path as text
%        str2double(get(hObject,'String')) returns contents of edit_Output_Image_path as a double
Output_Path = get(hObject, 'String'); 
handles.Full_Out_Path = Output_Path;  
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit_Output_Image_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Output_Image_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Pushbutton_Browse_Output_Image.
function Pushbutton_Browse_Output_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Pushbutton_Browse_Output_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Out_Name, Out_Path] = uiputfile({'*.BMP';'*.GIF';'*.HDF';'*.JPG';'*.JPEG';'*.JP2';'*.JPX';'*.PBM';'*.PCX';'*.PGM';'*.PNG';'*.PNM';'*.PPM';'*.RAS';'*.TIF';'*.TIFF';'*.XWD'}, 'Save Output Image As');
if isequal(Out_Name,0)
else 
    handles.Full_Out_Path = fullfile(Out_Path, Out_Name); 
    set(handles.edit_Output_Image_path,'String', handles.Full_Out_Path) 
end 
guidata(hObject, handles);


% --- Executes on selection change in popupmenu_Interpolation.
function popupmenu_Interpolation_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Interpolation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Interpolation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Interpolation
handles.Interpolation_Method = get(handles.popupmenu_Interpolation, 'String'); 
handles.Interpolation_Value = get(handles.popupmenu_Interpolation, 'Value'); 
switch handles.Interpolation_Value 
    case 1 
        handles.Interpolation = 'bicubic'; 
    case 2 
        handles.Interpolation = 'bilinear'; 
    case 3 
        handles.Interpolation = 'nearest'; 
end 
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_Interpolation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Interpolation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on edit_Input_Image_Path and none of its controls.
function edit_Input_Image_Path_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit_Input_Image_Path (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_Compare_Output.
function checkbox_Compare_Output_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Compare_Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of
% checkbox_Compare_Output 
handles.Show_Output = get(hObject, 'Value'); 
guidata(hObject, handles);




function edit4_GCP_Numbers_Callback(hObject, eventdata, handles)
% hObject    handle to edit4_GCP_Numbers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4_GCP_Numbers as text
%        str2double(get(hObject,'String')) returns contents of edit4_GCP_Numbers as a double


% --- Executes during object creation, after setting all properties.
function edit4_GCP_Numbers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4_GCP_Numbers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
