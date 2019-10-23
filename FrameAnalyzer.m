function varargout = FrameAnalyzer(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FrameAnalyzer_OpeningFcn, ...
                   'gui_OutputFcn',  @FrameAnalyzer_OutputFcn, ...
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


function FrameAnalyzer_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


function varargout = FrameAnalyzer_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function NameBox_Callback(hObject, eventdata, handles)


function NameBox_CreateFcn(hObject, eventdata, handles)


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function checkFigureNumber()
    h = findobj('type','figure');
    n= length(h);
    if(n==1)
        figure(1);
        return;

    end

%this function for the open video(initialization button)
function initial_but_Callback(hObject, eventdata, handles)

%fileName = get(handles.NameBox,'String');
%folderName = get(handles.FolderName,'String');

[baseName, folder] = uigetfile('*.MOV');
filePath = fullfile(folder, baseName)
 
folderPath = uigetdir();
global stack
global listy
global frames_path;
global leg_counter;
global frames_path;
global counter;
global data;
global flag;
global flag_;
global flag_2;
global frames_num;
global bool
global TM
TM= false;
bool =0;
stack ={};
listy = {};
leg_counter =0;
frames_num =1;
counter =0;


 
    frames_path = video2frame(filePath,folderPath);
   
frames_num =1;
filename = strcat('frame',num2str(frames_num),'.jpg');
set(handles.frame_numbox,'String',num2str(frames_num));
set(handles.leg_numbox,'String',num2str(0));
I=imread(fullfile(frames_path,filename));

% function start here
SeperateView(I);

% end here

flag =1; % for curve
flag_ =0; % for save
flag_2 = 1;
%this is for display, it works like rereshing the page
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
%this is how we draw the curve
function curve(~,~)
% Init control polygon
%figure;
%axis([0 1 0 1]);
%imshow('frame3.jpg');
global flag;
global flag_;
global pts;
global c;
global canManipulatePts;
global h1;
global h0;
global flag_2;
if(flag)

flag_2 =0;
[x, y] = getpts();
x = x';
y = y';
canManipulatePts = false;



  
    % Plot control polygon
    hold on;
    h0 = plot(x, y, 'b-o');
    hold on;

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

    % Plot curve
    %axis([0 1 0 1]);
    h1 = plot(c(1, :), c(2, :), '-r');
    canManipulatePts = true;

    % Manipulate points
    flag=0;
    flag_2 = 1;
    
    
end
%this is stack implementation
function newStack = pushStack(a,newValue)
newStack = [a,newValue];

function [newStack,popedValue] = popStack(a)
if(size(a,2)==0)
    msgbox("Empty stack");
    return
end
popedValue = a{1};
newStack = a(2:end);


 %this is for excel form update
function changeData(points)
global counter;
global leg_counter;
global data;
global pts;
global frames_num;
 if(counter ==0)
        return;
    end
counter = counter - 1;
    leg_counter=leg_counter-1;
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
    
    for i = 1:size(pts,2)
        data(counter,1) = frames_num;
        data(counter,2 )= leg_counter;
        data(counter,i+2) =points(1,i);
    end
    
    counter = counter+1;
    for i = 1:size(pts,2)
        data(counter,1) = frames_num;
        data(counter,2 )= leg_counter;
        data(counter,i+2) =points(2,i);
    end
    global bool;
    global uitable_handle;
if(isvalid(uitable_handle)==1)
    handles_uitable  = findall(0,'tag','uitable_handle');
    set(handles_uitable,'data',data);   
    counter = counter-2;
end
%this is for keyboard operation when the current
%  window is the 'canvas' 
function press(hObject, eventdata, handles)
key_press = get(gcf,'currentKey');
global frames_path;
global flag_;
global flag_2;
global x;
global y;
global x_;
global y_;
global flag;
global frames_num;
global pts;
global c;
global counter;
global h1;
global h0;
global stack
global listy
global TM
h_box = findall(0,'tag','frame_numbox');
frames_num= str2num(get(h_box,'String'));
global leg_counter;
global data;
global uitable_handle

global canManipulatePts;
%reopen the frame
if((strcmp(key_press,'x')||strcmp(key_press,'X'))&&flag_2)
    handle_fig = figure(1);
    close(handle_fig);
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    flag =1;
end
% redo
if((strcmp(key_press,'z')||strcmp(key_press,'Z'))&&flag_2)
    [stack,p] = popStack(stack);
    handle_fig = figure(1);
    close(handle_fig);
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    ling =zeros(2,size(pts,2));
    changeData(ling);
    figure(1);
    flag =1;
    
    
    tmp = stack;
    len = size(stack,2)
    for i = 1:len
    [tmp,points] = popStack(tmp);
    
     paint(points,'none');
        
    end
    
end
%save
if((strcmp(key_press,'s')||strcmp(key_press,'S'))&&flag_2)
    if(TM==false)
    stack = pushStack({pts},stack);
    flag=1;
    counter = counter + 1;
    leg_counter=leg_counter+1;
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
    
    for i = 1:size(pts,2)
        data(counter,1) = frames_num;
        data(counter,2 )= leg_counter;
        data(counter,i+2) =pts(1,i);
    end
    
    counter = counter+1;
    for i = 1:size(pts,2)
        data(counter,1) = frames_num;
        data(counter,2 )= leg_counter;
        data(counter,i+2) =pts(2,i);
    end
    
    
        if(isvalid(uitable_handle)==1)
    
            set(uitable_handle,'data',data);
        end
    
    flag_2 =0;
    
    else
        display(11111);
         h = findall(0,'tag','frame_numbox');
        frame_num = get(h,'String');
        h = findall(0,'tag','leg_numbox');
        leg_num = get(h,'String');
        for ii =1:size(data,1)
            if(data(ii,1)==str2num(frame_num) && data(ii,2)==str2num(leg_num))
                data(ii,:)=0;
                data(ii+1,:)=0;
                for i = 1:size(pts,2)
                    data(ii,1) = frames_num;
                    data(ii,2 )= str2num(leg_num);
                    data(ii,i+2) =pts(1,i);
                end
    
                
                for i = 1:size(pts,2)
                    data(ii+1,1) = frames_num;
                    data(ii+1,2 )= str2num(leg_num);
                    data(ii+1,i+2) =pts(2,i);
                end
                break;
            end
        end
        TM=false;
        
            if(isvalid(uitable_handle)==1)
    
                set(uitable_handle,'data',data);
            end
        
    end
end
    
%next frame
if((strcmp(key_press,'d')||strcmp(key_press,'D'))&&flag_2)
    stack = {};
    handle_fig = figure(1);
    close(handle_fig);
    frames_num = frames_num +1;
    leg_counter = 1;
    h = findall(0,'tag','frame_numbox');
    set(h,'String',num2str(frames_num));
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    flag =1;
end
%previous frame
if ((strcmp(key_press,'a')||strcmp(key_press,'A'))&&flag_2)
    stack={};
    if(frames_num==1)
        msgbox("No previous frame");
        return
    end
        
    handle_fig = figure(1);
    close(handle_fig);
    frames_num = frames_num -1;
    leg_counter=1;
    h = findall(0,'tag','frame_numbox');
    set(h,'String',num2str(frames_num));
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    flag =1;
   
end
%drag points
if((strcmp(key_press,'r')||strcmp(key_press,'R'))&&flag_2)
    if (canManipulatePts)
       
        pts = reposition(pts); 
        if not(isempty(h1))
            delete(h1);
        end
        if not(isempty(h0))
            delete(h0);
        end
        x = pts(1, :);
        y = pts(2, :);
        hold on;
       
            h0 = plot(x, y, 'b-o');

        
    hold on;

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
   
    h1 = plot(c(1, :), c(2, :), '-r');

    end
    hold on;
    
end
% click an edge and make extra points
if((strcmp(key_press,'e')||strcmp(key_press,'E'))&&flag_2)
    if (canManipulatePts)
       
        pts = reposition_e(pts); 
        if not(isempty(h1))
            delete(h1);
        end
        if not(isempty(h0))
            delete(h0);
        end
        x = pts(1, :);
        y = pts(2, :);
        hold on;
    h0 = plot(x, y, 'b-o');
    hold on;

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

    h1 = plot(c(1, :), c(2, :), '-r');
    end
   
 
end
%delete point
if((strcmp(key_press,'f')||strcmp(key_press,'F'))&&flag_2)
    
   pts = deleteP(pts);
    %if(size(pts,2)<2)
     %   msgbox("line segement <2, cannot delete");
      %  return;
    %end
        if not(isempty(h1))
            delete(h1);
        end
        if not(isempty(h0))
            delete(h0);
        end
        if(size(pts,2)>0)
            x = pts(1, :);
            y = pts(2, :);
        else
            x=[];
            y=[];
            hold on;
            h0 = plot(x, y, 'b-o');
            return;
        end
        hold on;
    h0 = plot(x, y, 'b-o');
    hold on;
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

    h1 = plot(c(1, :), c(2, :), '-r');

    
end
%this is the export button
function export_but_Callback(hObject, eventdata, handles)
global uitable_handle
data = get(uitable_handle,'Data');
 name = datestr(now);
 FileName = uiputfile(strcat(name,'.xlsx'),'Save as');
 xlswrite(FileName,data);
%this is the frame box displaying the current frame number
%    the frame selection function is implemented later
function frame_numbox_Callback(hObject, eventdata, handles)

frame_num = get(handles.frame_numbox,'String');

function frame_numbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% an extraction of the function to repaint curves on canvas when
% we want to go back
% **********here i put some default color setting there
% you can change that to make it look better!
function paint(pts,color)
hold on;
   
    x = pts(1,:);
    y = pts(2,:);
    display(x);
    display(y);
    plot(x, y, 'g-o');
    hold on;

    % Allocate Memory for curve
    stepSize = 0.01; % hundreds pts + 1
    u = 0: stepSize: 1;
    numOfU = length(u);
    c = zeros(2, numOfU);

    % Iterate over curve and apply deCasteljau
    numOfPts = length(x);

    for i = 1: numOfU
        ui = u(i);
        c(:, i) = deCasteljau(ui, pts, numOfPts, numOfPts);
    end
    
    % Plot curve
    %axis([0 1 0 1]);
    if(strcmp(color,'none'))
    plot(c(1, :), c(2, :), '-y');
    else
    plot(c(1, :), c(2, :), color);
    end
 
% implemented TM(time machine) here. the mechanic is that
% when user put a number inside the leg_number box, it will
% go back to the state where users can modify the set of points
% belongs to that leg_number

function leg_numbox_Callback(hObject, eventdata, handles)
global pts;
global data;
global canManipulatePts;
global frames_num;
global frames_path;
global ctf
global leg_num
global TM
ctf={};
count=1;
frame_num = get(handles.frame_numbox,'String');
leg_num = get(handles.leg_numbox,'String');

key_press = get(gcf,'currentKey');
if(strcmp(key_press,'return'))
    for n =0:(size(data,1)/2-1)
        if(abs(data(2*n+1,1)-str2num(frame_num))<0.01)
            
                tmp=[];
                
                for i = 1:size(data,2)-2
                    if(data(2*n+1,i+2)==0&&data(2*n+1+1,i+2)==0)
                        continue;
                    end
                    
                    tmp(1,i) = data(2*n+1,i+2);
                    
                    tmp(2,i) = data(2*n+2,i+2);
                end
                    ctf{count}=tmp;
                    count = count+1;  
        end
    end
    if(leg_num>size(ctf,2))
        msgbox(',leg number not in boundary');
        h = findall(0,'tag','leg_numbox');
        set(h,'String',num2str(size(ctf,2)));
        return;
    end
    handle_fig = figure(1);
    close(handle_fig);
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    figure(1);
    for i =1:size(ctf,2)
        if(i~=str2num(leg_num))
        paint(ctf{i},'none');
        else
            paint(ctf{i},'-c');
        end
         
    end

    pts = ctf{str2num(leg_num)};
    TM= true;
end
canManipulatePts = true;
global flag_2;
flag_2 =1; %?????
figure(1);


function leg_numbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function previous_but_Callback(hObject, eventdata, handles)
stack={};
    if(frames_num==1)
        msgbox("No previous frame");
        return
    end
        
    handle_fig = figure(1);
    close(handle_fig);
    frames_num = frames_num -1;
    leg_counter=1;
    h = findall(0,'tag','frame_numbox');
    set(h,'String',num2str(frames_num));
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);

    
function next_but_Callback(hObject, eventdata, handles)
stack = {};
    handle_fig = figure(1);
    close(handle_fig);
    frames_num = frames_num +1;
    leg_counter = 1;
    h = findall(0,'tag','frame_numbox');
    set(h,'String',num2str(frames_num));
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    flag =1;



% --- Executes during object creation, after setting all properties.
function FolderName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function frame_numbox_KeyPressFcn(hObject, eventdata, handles)
global frames_num;
global flag;
global frames_path;
global leg_counter;

%display('HelloWOrld');
key_press = get(gcf,'currentKey');

if(strcmp(key_press,'return'))
    pause(0.2);
    frames_num = str2num(get(handles.frame_numbox,'String'));
    handle_fig = figure(1);
    close(handle_fig);
    %display('HelloWOrld');
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    SeperateView(I);
    leg_counter =0;
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)

%fileName = get(handles.NameBox,'String');
%folderName = get(handles.FolderName,'String');

folderPath = uigetdir();
global frames_path;
global leg_counter;

global counter;
global data;
global flag;
global flag_;
global flag_2;
global frames_num;
global stack;
global TM;
TM=false;
stack = {};
leg_counter =0;
frames_num =1;
counter =0;

global uitable_handle;
global bool;
bool =0;
data =[];
    frames_path = folderPath;

frames_num =1;
filename = strcat('frame',num2str(frames_num),'.jpg');
set(handles.frame_numbox,'String',num2str(frames_num));
set(handles.leg_numbox,'String',num2str(0));
I=imread(fullfile(frames_path,filename));

% function start here
SeperateView(I);

% end here

flag =1; % for curve
flag_ =0; % for save
flag_2 = 1;



%done
function Add_Edge_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global canManipulatePts;
global pts;
global h1;
global h0;
global flag_2;
if(flag_2)
if (canManipulatePts)
       
        pts = reposition_e(pts); 
        if not(isempty(h1))
            delete(h1);
        end
        if not(isempty(h0))
            delete(h0);
        end
        x = pts(1, :);
        y = pts(2, :);
        hold on;
    h0 = plot(x, y, 'b-o');
    hold on;

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

    h1 = plot(c(1, :), c(2, :), '-r');
    end
end
%done
function Delete_Point_Callback(hObject, eventdata, handles)
% hObject    handle to Delete_Point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pts;
global h1;
global h0;
global flag_2;
if(flag_2)
pts = deleteP(pts);
    %if(size(pts,2)<2)
     %   msgbox("line segement <2, cannot delete");
      %  return;
    %end
        if not(isempty(h1))
            delete(h1);
        end
        if not(isempty(h0))
            delete(h0);
        end
        if(size(pts,2)>0)
            x = pts(1, :);
            y = pts(2, :);
        else
            x=[];
            y=[];
            hold on;
            h0 = plot(x, y, 'b-o');
            return;
        end
        hold on;
    h0 = plot(x, y, 'b-o');
    hold on;
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

    h1 = plot(c(1, :), c(2, :), '-r');
end
% done
function Start_Over_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  global flag;
  global flag_2;
if(flag_2)
    handle_fig = figure(1);
    close(handle_fig);
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    flag =1;
end
% done
function Save_Curve_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TM;
global stack;
global flag;
global counter;
global leg_counter;
global data;
global flag_2;

if(flag_2)
if(TM==false)
    stack = pushStack({pts},stack);
    flag=1;
    counter = counter + 1;
    leg_counter=leg_counter+1;
    h = findall(0,'tag','leg_numbox');
    set(h,'String',num2str(leg_counter));
    
    for i = 1:size(pts,2)
        data(counter,1) = frames_num;
        data(counter,2 )= leg_counter;
        data(counter,i+2) =pts(1,i);
    end
    
    counter = counter+1;
    for i = 1:size(pts,2)
        data(counter,1) = frames_num;
        data(counter,2 )= leg_counter;
        data(counter,i+2) =pts(2,i);
    end
    
    
        if(isvalid(uitable_handle)==1)
    
            set(uitable_handle,'data',data);
        end
    
    flag_2 =0;
    
    else
        
         h = findall(0,'tag','frame_numbox');
        frame_num = get(h,'String');
        h = findall(0,'tag','leg_numbox');
        leg_num = get(h,'String');
        for ii =1:size(data,1)
            if(data(ii,1)==str2num(frame_num) && data(ii,2)==str2num(leg_num))
                data(ii,:)=0;
                data(ii+1,:)=0;
                for i = 1:size(pts,2)
                    data(ii,1) = frames_num;
                    data(ii,2 )= str2num(leg_num);
                    data(ii,i+2) =pts(1,i);
                end
    
                
                for i = 1:size(pts,2)
                    data(ii+1,1) = frames_num;
                    data(ii+1,2 )= str2num(leg_num);
                    data(ii+1,i+2) =pts(2,i);
                end
                break;
            end
        end
        TM=false;
        
            if(isvalid(uitable_handle)==1)
    
                set(uitable_handle,'data',data);
            end
        
    end
end
% --- Executes on button press in Data_Window.
function Data_Window_Callback(hObject, eventdata, handles)
% hObject    handle to Data_Window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data
global uitable_handle
global bool

[bool,uitable_handle] = SetUitable(data)


% --- Executes on button press in Drag_Point.
function Drag_Point_Callback(hObject, eventdata, handles)
% hObject    handle to Drag_Point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pts;
global h1;
global h0;
global flag_2;
if(flag_2)
 if (canManipulatePts)
       
        pts = reposition(pts); 
        if not(isempty(h1))
            delete(h1);
        end
        if not(isempty(h0))
            delete(h0);
        end
        x = pts(1, :);
        y = pts(2, :);
        hold on;
       
            h0 = plot(x, y, 'b-o');

        
    hold on;

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
   
    h1 = plot(c(1, :), c(2, :), '-r');

  end
    hold on;
end