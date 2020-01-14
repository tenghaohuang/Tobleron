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

% Last Modified by GUIDE v2.5 21-Nov-2019 16:43:11

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
frames_num = getFramesNum();
leg = PM_get();
global data;
global uitable_handle;
if(isempty(pts))
    length =size(data,2)

    for i =1:length
        if(leg==data(i,2)&&frames_num==data(i,1))
            data(i,:)=[];
            data(i,:)=[];
            break;
        end
        
    end

    if(isvalid(uitable_handle)==1)
     
        set(uitable_handle,'data',data);   

    end
    return;
end
begin =0;
    for i =1:size(data,1)
        if(data(i,1)==frames_num)
            begin =i-1;
            break;
        end
    end
    
data(begin+leg*2-1,3:size(data,2))=0;
for i =1:size(pts,2)
    data(begin+leg*2-1,2+i)= pts(1,i);
end
% data(leg*2-1,3:size(pts,2))=pts(1,:);
data(begin+leg*2,3:size(data,2))=0;
for i =1:size(pts,2)
    data(begin+leg*2,2+i)= pts(2,i);
end

if(isvalid(uitable_handle)==1)
     
     set(uitable_handle,'data',data);   

end
% data(leg*2,3:size(pts,2))=pts(2,:);
function newStack = pushStack(a,newValue)
newStack = [a,newValue];

function [newStack,popedValue] = popStack(a)
if(size(a,2)==0)
    msgbox("Empty stack");
    return
end
popedValue = a{1};
newStack = a(2:end);
function updateData(pts)
    global data

    [data,pointer] = getData();
    leg_counter = PM_get()+1;
%     updatePM(leg_counter);
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
    
     for i=1:size(data,1)
         for j=i:size(data,1)
             if(data(i,1)>data(j,1))
                 tmp = data(i,:);
                 data(i,:)=data(j,:);
                 data(j,:)=tmp;
             end
         end
     end
     

      frame_list = data(:,1);
      index_list = find(frame_list==frames_num);
      if(~isempty(index_list))
      
      for i = index_list(1):index_list(end)
          for j = i:index_list(end)
              if(data(i,1)>data(j,1))
                  tmp = data(i,:);
                  data(i,:)=data(j,:);
                  data(j,:)=tmp;
              end
          end
      end
      end
    global uitable_handle;
 if(isvalid(uitable_handle)==1)

     set(uitable_handle,'data',data);   

 end

function updateData2(pts)
    global data

    [data,pointer] = getData();
    leg_counter = PM_get()+1;
%     updatePM(leg_counter);
    frames_num = getFramesNum();
        len = size(data,2);
        insert_x = zeros(1,len);
        insert_y = zeros(1,len);
        insert_x(1,1) = frames_num;
        insert_x(1,2) = leg_counter;
        insert_y(1,1) = frames_num;
        insert_y(1,2) = leg_counter;
        for i=1:size(pts,2)
            insert_x(1,i+2) = pts(1,i);
            insert_y(1,i+2) = pts(2,i);
        end
    if(isempty(data))
        data(1,:)=insert_x;
        data(2,:)=insert_y;
    else


        global s;
        s =[];
        bool =0;
        isIn =0;
        for i =1:size(data,1)
            if(data(i,1)==frames_num)
                isIn=1;
                break;
            end
        end
        for i=size(data,1):-1:1
          if(isIn==1)  
            if(data(i,1)==frames_num && data(i,2)<leg_counter && bool==0)
                s = pushStack(s,{insert_y});
                s = pushStack(s,{insert_x});
                bool=1;
            end
                s = pushStack(s,{data(i,:)});
          else
            if(data(i,1)>frames_num && data(i-1,1)<frames_num && bool==0)
                s = pushStack(s,{insert_y});
                s = pushStack(s,{insert_x});
                bool=1;
            end
                s = pushStack(s,{data(i,:)});              
          end
        end
        count=1;
        tmp=[];
        while(size(s,2)~=0)
            
            [s,output] = popStack(s);
            for i=1:size(output,2)
                tmp(count,i) =output(i);
            end
            count=count+1
        end
        data = tmp;
    end
    
    global uitable_handle;
 if(isvalid(uitable_handle)==1)
     
     set(uitable_handle,'data',data);   

 end
 

function press(hObject, eventdata, handles)
global h_blue;
global h_red;
global uitable_handle;
global frames_path;
key_press = get(gcf,'currentKey');
if((strcmp(key_press,'a')||strcmp(key_press,'A')))
    pts = PM_getPts();
    pts = reposition(pts); 
    pts = cleanPts(pts);
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
    tmp_pts= cleanPts(tmp_pts);
    changeData(tmp_pts);
end

if((strcmp(key_press,'f')||strcmp(key_press,'F')))
    
    pts = PM_getPts(); 
    pts = cleanPts(pts);
    pts = deleteP(pts);
    pts = cleanPts(pts);
    if not(isempty(h_red))
       delete(h_red);
    end
    
    if not(isempty(h_blue))
       delete(h_blue);
    end
    if(isempty(pts))
        changeData(pts);
        leg = PM_get();
        updatePM(leg-1);
        return;
    end
       x = pts(1, :);
       y = pts(2, :);
        
    hold on;

    tmp_pts=draw(x,y);
    tmp_pts= cleanPts(tmp_pts);
    changeData(tmp_pts);

end
if((strcmp(key_press,'s')||strcmp(key_press,'S')))
    pts = PM_getPts(); 
    pts = reposition_e(pts);
    pts = cleanPts(pts);
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
    tmp_pts= cleanPts(tmp_pts);
    changeData(tmp_pts);
    
end
if((strcmp(key_press,'g')||strcmp(key_press,'G')))
        
    hold on;
max = PM_getMax();
ct = PM_get();
% if(ct<max)
%     return;
% end
    pts=[]
    
    changeData(pts);
    updatePM(ct-1);
    drawData('startover');
    
end
if((strcmp(key_press,'q')||strcmp(key_press,'Q')))
    if ~(isvalid(uitable_handle))
        [data,pointer] = getData();
        [bool,uitable_handle] = SetUitable(data)
        figure(1);
    end
end
if((strcmp(key_press,'x')||strcmp(key_press,'X')))
    frames_num = getFramesNum();
    
    handle_fig = figure(1);
    close(handle_fig);
    frames_num = frames_num +1;
    leg_counter = 1;
    h = findall(0,'tag','frame_numbox');
    set(h,'String',num2str(frames_num));
    
    updatePM(leg_counter);
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    updatePM(0);
end
if((strcmp(key_press,'z')||strcmp(key_press,'Z')))
    frames_num = getFramesNum();
    
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
    
    updatePM(leg_counter);
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    updatePM(0);
end
function drawData(startover)
    global leg;
    global frames_path;
    global begin;
    [data,pointer] = getData();
    leg = PM_getMax();

    frames_num = getFramesNum();
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    handle_fig = figure(1);
    close(handle_fig);
    SeperateView(I);
    if(leg==0)
        
        return;
    end
    if(isempty(data))
        return;
    end
    begin =0;
    for i =1:size(data,1)
        if(data(i,1)==frames_num)
            begin =i-1;
            break;
        end
    end
    display(begin);
    global points;
    global watch;
    current_leg = PM_get();

    for i =1:leg
        watch = i;
        figure(1);
        x = data(begin+i*2-1,3:size(data,2));
        y = data(begin+i*2,3:size(data,2));
        points =[x;y];
        points = cleanPts(points);
        hold on;
%         draw(x,y);
        if(i~=current_leg)
            paint(points,'none');
        else
            paint(points,'-c');
        end
    end
    



function pts = PM_getPts()
    frames_num = getFramesNum();
    [data,pointer] = getData();
    leg = PM_get();
    if(isempty(data))
        return;
    end
    begin =0;
    for i =1:size(data,1)
        if(data(i,1)==frames_num)
            begin =i-1;
            break;
        end
    end
    x = data(begin+leg*2-1,3:size(data,2));
    y = data(begin+leg*2,3:size(data,2))
    pts = [x;y]




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

function [points]=draw(x,y)
    global h_blue;
    h_blue = plot(x, y, 'b-o');
    global h_red
    % Allocate Memory for curve
    stepSize = 0.01; % hundreds pts + 1
    u = 0: stepSize: 1;
    numOfU = length(u);
    c = zeros(2, numOfU);
    global pts
    % Iterate over curve and apply deCasteljau
    numOfPts = length(x);
    pts = [x; y];
    pts= cleanPts(pts);
    for i = 1: numOfU
        ui = u(i);
        c(:, i) = deCasteljau(ui, pts, numOfPts, numOfPts);
    end
   
    h_red = plot(c(1, :), c(2, :), '-r');
    points = pts;
    
function paint(pts,color)
hold on;
    if(isempty(pts))
        return;
    end
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
    
function curve(~,~)
% Init control polygon
%figure;
%axis([0 1 0 1]);
%imshow('frame3.jpg');
max = PM_getMax();
ct = PM_get();
if(ct<max)
    return;
end
[x, y] = getpts();
x = x';
y = y';

    % Plot control polygon
    hold on;
    pts= draw(x,y);
    hold on;
    updateData(pts);
    leg = PM_getMax();
    updatePM(leg+1);
    

    
function initial_but_Callback(hObject, eventdata, handles)
global frames_path;
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
global data;
data=[];




function export_but_Callback(hObject, eventdata, handles)
global data;

global uitable_handle;
[bool,uitable_handle] = SetUitable(data)
data = get(uitable_handle,'Data');
%name = datestr(now);
%  FileName = uiputfile(strcat(name,'.xlsx'),'Save as');
%  xlswrite(FileName,data);
name = uigetdir();
mkdir(name);
cd(name);
save2txt(data);
cd ..;

function save2txt(data)
for i=1:size(data,1)
    fra = data(i,1);
    leg = -1;
    
    if(fra~=data(i,1))
        fra = data(i,1);
    else
        if(leg~= data(i,2) && i~=size(data,1))
            leg = data(i,2);
            data2save(1,:) = data(i,:);
            data2save(2,:) = data(i+1,:);
            mkdir(num2str(fra));
            cd(num2str(fra));
            fname = sprintf('%i.txt',leg);
            save(fname);
            fid=fopen(fname,'w');
    for ii=1:size(data2save,1)
        for j=1:size(data2save,2)
            if j==size(data2save,2)
                fprintf(fid,'%d\n',data2save(ii,j));%如果是最后一个，就换行
            else
                fprintf(fid,'%d  ',data2save(ii,j));%如果不是最后一个，就tab
            end
        end

    end
        fclose(fid);

            cd ..
        end
    end
end
        
    
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
    [data,pointer] = getData();
    frames_num = getFramesNum();
    global frames_path;
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
    
    updatePM(leg_counter);
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    updatePM(0);

    [legnum,begin] = getNums(frames_num);
    if(begin ==-1)
        return;
    end
    updatePM(legnum);
    drawData();
    
function [num,begin]=getNums(framenum)
    [data,pointer] = getData();
    if(isempty(data))
        return;
    end
    begin =-1;
    for i =1:size(data,1)
        if(data(i,1)==framenum)
            begin = max(1,i-1);
            break;
        end
    end
    if(begin ==-1)
        num =0;
        return;
    end
    count=0;
    for i =begin:size(data,1)
        if(data(i,1)==framenum)
            count = count+1;
        end
    end
    num = count/2;
    
function next_but_Callback(hObject, eventdata, handles)
    [data,pointer] = getData();
    frames_num = getFramesNum();
    global frames_path;
    handle_fig = figure(1);
    close(handle_fig);
    frames_num = frames_num +1;
    leg_counter = 1;
    h = findall(0,'tag','frame_numbox');
    set(h,'String',num2str(frames_num));
    
    updatePM(leg_counter);
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    
    SeperateView(I);
    updatePM(0);
    [legnum,begin] = getNums(frames_num);
    if(begin ==-1)
        return;
    end
    updatePM(legnum);
    drawData();
  
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

global max

    hh = findall(0,'tag','PM');
    if(leg_counter ==0)
        set(hh,'string','0');
        set(hh,'value',1);
        return;
    end
 
    max = PM_getMax();
%     if(leg_counter>=max)
        popupList = {};
        popupList{1} = leg_counter;
        for i =1:leg_counter-1
            if(leg_counter==1)
                break;
            end
            popupList{i+1} = i;
        end
        set(hh, 'string', popupList);

function [maxi]=PM_getMax()
global items
    hh = findall(0,'tag','PM');
    items = get(hh,'string');
    

    
    if(isa(items,'cell'))
        for i =1:size(items,1)
            tmp{i}=str2num(items{i});
        end
        maxi = max([tmp{:}]);
    else
        maxi =0;
    end
function OEF_Callback(hObject, eventdata, handles)
global frames_path;
global data;
data =[];

updatePM(0);
folderPath = uigetdir();
frames_num =1;
filename = strcat('frame',num2str(frames_num),'.jpg');
set(handles.frame_numbox,'String',num2str(frames_num));
updatePM(PM_get());
I=imread(fullfile(folderPath,filename));
frames_path= folderPath;
SeperateView(I);

function realAdd_Point_Callback(hObject, eventdata, handles)
global h_blue;
global h_red;
global uitable_handle;
global frames_path;
figure(1);

    pts = PM_getPts(); 
    pts = reposition_e(pts);
    pts = cleanPts(pts);
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
    tmp_pts= cleanPts(tmp_pts);
    changeData(tmp_pts);

key_press = get(gcf,'currentKey');
function Delete_Point_Callback(hObject, eventdata, handles)
global h_blue;
global h_red;
global uitable_handle;
global frames_path;
figure(1);
    pts = PM_getPts(); 
    pts = cleanPts(pts);
    pts = deleteP(pts);
    pts = cleanPts(pts);
    if not(isempty(h_red))
       delete(h_red);
    end
    
    if not(isempty(h_blue))
       delete(h_blue);
    end
    if(isempty(pts))
        changeData(pts);
        leg = PM_get();
        updatePM(leg-1);
        return;
    end
       x = pts(1, :);
       y = pts(2, :);
        
    hold on;

    tmp_pts=draw(x,y);
    tmp_pts= cleanPts(tmp_pts);
    changeData(tmp_pts);
function Start_Over_Callback(hObject, eventdata, handles)
global h_blue;
global h_red;
global uitable_handle;
global frames_path;
figure(1);
    hold on;
max = PM_getMax();
ct = PM_get();
% if(ct<max)
%     return;
% end
    pts=[]
    changeData(pts);
    updatePM(ct-1);
    drawData('startover');
    
function Data_Window_Callback(hObject, eventdata, handles)
global uitable_handle;
[data,pointer] = getData();
[bool,uitable_handle] = SetUitable(data)

function Drag_Point_Callback(hObject, eventdata, handles)
global h_blue;
global h_red;
global uitable_handle;
global frames_path;
figure(1);

    pts = PM_getPts();
    pts = reposition(pts); 
    pts = cleanPts(pts);
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
    tmp_pts= cleanPts(tmp_pts);
    changeData(tmp_pts);

function PM_Callback(hObject, eventdata, handles)
figure(1);
global h_blue;
global h_red;
h_blue = [];
h_red=[];
drawData();
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
global uitable_handle;
[bool,uitable_handle,fig] = SetUitable(data)
delete(fig);
