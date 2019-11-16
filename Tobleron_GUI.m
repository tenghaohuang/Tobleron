function varargout = Tobleron_GUI(varargin)
%TOBLERON_GUI MATLAB code file for Tobleron_GUI.fig
%      TOBLERON_GUI, by itself, creates a new TOBLERON_GUI or raises the existing
%      singleton*.
%
%      H = TOBLERON_GUI returns the handle to a new TOBLERON_GUI or the handle to
%      the existing singleton*.
%
%      TOBLERON_GUI('Property','Value',...) creates a new TOBLERON_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Tobleron_GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TOBLERON_GUI('CALLBACK') and TOBLERON_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TOBLERON_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Tobleron_GUI

% Last Modified by GUIDE v2.5 15-Nov-2019 20:26:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Tobleron_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Tobleron_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


function Tobleron_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Tobleron_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

function varargout = Tobleron_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function [ret,pointer]=getData()
global data;
ret =data;
pointer = size(data,1)+1;


function num = getFramesNum()
hh = findall(0,'tag','frame_numbox');
global tmp;
tmp = get(hh,'string');
if(isa(tmp,'cell'))
num = str2num(tmp{1});
elseif(isa(tmp,'char'))
    num= str2num(tmp);
else
    assert(0);
end

function changeData(pts)
global leg
leg = PM_get();
global data;
data(leg*2-1,3:size(data,2))=0;
for i =1:size(pts,2)
    data(leg*2-1,2+i)= pts(1,i);
end
% data(leg*2-1,3:size(pts,2))=pts(1,:);
data(leg*2,3:size(data,2))=0;
for i =1:size(pts,2)
    data(leg*2,2+i)= pts(2,i);
end
% data(leg*2,3:size(pts,2))=pts(2,:);

function updateData(pts)
    global data

    [data,pointer] = getData();
    leg_counter = PM_get();
    updatePM(leg_counter);
    frames_num = getFramesNum();
    for i = 1:size(pts,2)
        data(pointer,1) = frames_num;
        data(pointer,2 )= leg_counter;
        data(pointer,i+2) =pts(1,i);
    end
    
    pointer = pointer+1;
    for i = 1:size(pts,2)
        data(pointer,1) = frames_num;
        data(pointer,2 )= leg_counter;
        data(pointer,i+2) =pts(2,i);
    end
    
    
    
%     global uitable_handle;
% if(isvalid(uitable_handle)==1)
%     handles_uitable  = findall(0,'tag','uitable_handle');
%     set(handles_uitable,'data',data);   
%     counter = counter-2;
% end
function pts = getPts()
    
    [data,pointer] = getData();
    leg = (pointer-1)/2;
    if(isempty(data))
        return;
    end
    x = data(leg*2-1,3:size(data,2));
    y = data(leg*2,3:size(data,2))
    pts = [x;y]

function press(hObject, eventdata, handles)
global h_blue;
global h_red;
key_press = get(gcf,'currentKey');
if((strcmp(key_press,'a')||strcmp(key_press,'A')))
    pts = getPts();
    pts = reposition(pts); 
    if not(isempty(h_red))
       delete(h_red);
    end
    
    if not(isempty(h_blue))
       delete(h_blue);
    end
       x = pts(1, :);
       y = pts(2, :);
        
    hold on;

    tmp_pts=draw(x,y);
    changeData(tmp_pts);
end
 if((strcmp(key_press,'h')||strcmp(key_press,'H')))
    
    pts = getPts(); 
    pts = cleanPts(pts);
    pts = deleteP(pts);
    if not(isempty(h_red))
       delete(h_red);
    end
    
    if not(isempty(h_blue))
       delete(h_blue);
    end
    if(isempty(pts))
        return;
    end
       x = pts(1, :);
       y = pts(2, :);
        
    hold on;

    tmp_pts=draw(x,y);
    changeData(tmp_pts);

 end
 
function [points]=cleanPts(pts)
for i =1:size(pts,2)
    if(pts(1,i)==pts(2,i)&&pts(1,i)==0)
        continue;
    end
    points(1,i)=pts(1,i);
    points(2,i)=pts(2,i);
end


function SeperateView(I)
hFig = figure('Toolbar','none',...
'Menubar','none');
hIm = imshow(I);
%hFig= figure(1);
hSP = imscrollpanel(hFig,hIm);
api = iptgetapi(hSP);
api.setMagnification(2) % 2X = 200%

hMagBox = immagbox(hFig, hIm);
boxPosition = get(hMagBox, 'Position');
set(hMagBox,'Position', [0, 0, boxPosition(3), boxPosition(4)])
imoverview(hIm)

% Get the scroll panel API to programmatically control the view.
api = iptgetapi(hSP);
% Get the current magnification and position.
mag = api.getMagnification();
r = api.getVisibleImageRect();
set(hIm,'ButtonDownFcn',@curve);
set(hFig,'KeyPressFcn',@press);

function [pts]=draw(x,y)
    global h_blue;
    h_blue = plot(x, y, 'b-o');
    global h_red
    % Allocate Memory for curve
    stepSize = 0.01; % hundreds pts + 1
    u = 0: stepSize: 1;
    numOfU = length(u);
    c = zeros(2, numOfU);

    % Iterate over curve and apply deCasteljau
    numOfPts = length(x);
    pts = [x; y];
    
    for i = 1: numOfU
        ui = u(i);
        c(:, i) = deCasteljau(ui, pts, numOfPts, numOfPts);
    end
   
    h_red = plot(c(1, :), c(2, :), '-r');

function curve(~,~)
% Init control polygon
%figure;
%axis([0 1 0 1]);
%imshow('frame3.jpg');

[x, y] = getpts();
x = x';
y = y';

    % Plot control polygon
    hold on;
    pts= draw(x,y);
    hold on;
    updateData(pts);
    leg = PM_get();
    updatePM(leg+1);
    
function initial_but_Callback(hObject, eventdata, handles)
[baseName, folder] = uigetfile('*.MOV');
filePath = fullfile(folder, baseName)
 
folderPath = uigetdir();
frames_path = video2frame(filePath,folderPath);
   
frames_num =1;
filename = strcat('frame',num2str(frames_num),'.jpg');
set(handles.frame_numbox,'String',num2str(frames_num));


I=imread(fullfile(frames_path,filename));

% function start here
SeperateView(I);



function export_but_Callback(hObject, eventdata, handles)
global uitable_handle
data = get(uitable_handle,'Data');
 name = datestr(now);
 FileName = uiputfile(strcat(name,'.xlsx'),'Save as');
 xlswrite(FileName,data);



function frame_numbox_Callback(hObject, eventdata, handles)

function frame_numbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_numbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function previous_but_Callback(hObject, eventdata, handles)

function next_but_Callback(hObject, eventdata, handles)

function [num] = PM_get()
    global items
    global idx
    handles = findall(0,'tag','PM');
    idx = get(handles,'value');
    items = get(handles,'string');
    if(isa(items,'cell'))
        leg_num = str2num(items{idx});
    elseif(isa(items,'char'))
        leg_num = str2num(items);
    end
    num = leg_num

function updatePM(leg_counter)
    hh = findall(0,'tag','PM');
    if(leg_counter ==0)
        set(hh,'string','0');
        set(hh,'value',1);
        return;
    end
 
    popupList = {};
    popupList{1} = leg_counter;
    for i =1:leg_counter-1
        if(leg_counter==1)
            break;
        end
        popupList{i+1} = i;
    end
    set(hh, 'string', popupList);


function OEF_Callback(hObject, eventdata, handles)
global data;
data =[];
updatePM(0);
folderPath = uigetdir();
frames_num =1;
filename = strcat('frame',num2str(frames_num),'.jpg');
set(handles.frame_numbox,'String',num2str(frames_num));
updatePM(PM_get());
I=imread(fullfile(folderPath,filename));
SeperateView(I);

function Add_Edge_Callback(hObject, eventdata, handles)

function Delete_Point_Callback(hObject, eventdata, handles)

function Start_Over_Callback(hObject, eventdata, handles)

function Data_Window_Callback(hObject, eventdata, handles)

function Drag_Point_Callback(hObject, eventdata, handles)

function pushbutton16_Callback(hObject, eventdata, handles)

function pushbutton17_Callback(hObject, eventdata, handles)

function PM_Callback(hObject, eventdata, handles)

function PM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
a= {0,0};
h= findall(0,'tag','PM');
set(h, 'String',a);


% --- Executes during object creation, after setting all properties.
function Data_Window_CreateFcn(hObject, eventdata, handles)
global data;
data = [];