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

% Last Modified by GUIDE v2.5 30-Jun-2020 14:45:07

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


 
% Press Function
% -usage: Handles all the keyboard pressing events
% -Parameter: a pressing event
% -Output: Respond with specified events

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
    global watch;
    
    watch = pts;
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
    display('success');

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
    global api;
    global r;
    r = api.getVisibleLocation();
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
end
if((strcmp(key_press,'z')||strcmp(key_press,'Z')))
    global api;
    global r;
    r = api.getVisibleLocation();
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
    figure(1);
end

function [pts]=drawData(startover)
    global leg;
    global frames_path;
    global begin;
    global data
    pts =[];
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
    
    global points;
    global watch;
    current_leg = PM_get();
    global tmpp;
    tmpp=[];
    for i =1:leg
        
        
        figure(1);
        x = data(begin+i*2-1,3:size(data,2));
        y = data(begin+i*2,3:size(data,2));
        points =[x;y];
        points = cleanPts(points);
        hold on;
%         draw(x,y);
        
        if(i~=current_leg)
            pts_ = paint(points,'none');
        else
            pts_ = paint(points,'-c');
        end
        tmpp = [tmpp;pts_]
    end
    pts = tmpp;


    

function SeperateView(I)
    global api;
    global r;
    h = findall(0,'tag','MagBox');
    mag_num = str2num(get(h,'string'));
    hFig = figure('Toolbar','none',...
    'Menubar','none');
    % set(hFig,'Position',[2,2,2,2])
    global hIm;
    hIm = imshow(I);
    %hFig= figure(1);
    global hSP;
    hSP = imscrollpanel(hFig,hIm);
    api = iptgetapi(hSP);
    api.setMagnification(mag_num) % 2X = 200%



    hMagBox = immagbox(hFig, hIm);

     boxPosition = get(hMagBox, 'Position');
     set(hMagBox,'Position', [0, 0, boxPosition(3), boxPosition(4)])

    set(0,'units','pixels'); %Sets the units of your root object (screen) to pixels
    Pix_SS = get(0,'screensize'); %Obtains this pixel information
    width=Pix_SS(3)-302;
    height=Pix_SS(4);
    x0=0;
    y0=0;
    set(hFig,'position',[x0,y0,width,height])

    global ret
    global overview;
    f1 =  findall(0,'tag','figure1');
    overview = imoverviewpanel(f1,hIm)
    set(overview,'Units','Normalized',...
    'Position',[0.125 0.05 0.75 .25]) %This controls the size and the position of the magnification window.
    % Get the scroll panel API to programmatically control the view.
    api = iptgetapi(hSP);
    % Get the current magnification and position.
    if(isempty(r))
        r = api.getVisibleLocation();
    end
    api.setVisibleLocation(r);
    mag = api.getMagnification();

    set(hIm,'ButtonDownFcn',@curve);
    set(hFig,'KeyPressFcn',@press);

function [points]=draw(x,y)
    
    global h_blue;
    h_blue = plot(x, y, 'b-o');
    global h_red
    hh = findall(0,'tag','step_box');
    tmp = get(hh,'string');

    if (isempty(tmp))
        stepSize = 0.01;
    else
        stepSize = 1/str2num(tmp);
    end 

    % Allocate Memory for curve
     
    u = 0: stepSize: 1;
    numOfU = length(u);
    global c;
    c = zeros(2, numOfU);
    
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

function [points] = CalcDecas(pts)
    hh = findall(0,'tag','step_box');
    tmp = get(hh,'string');

    if (isempty(tmp))
        stepSize = 0.01;
    else
        stepSize = 1/str2num(tmp);
    end 

    % Allocate Memory for curve
     
    u = 0: stepSize: 1;
    numOfU = length(u);
    global pts_watch;
    pts_watch = pts;
    c = zeros(2, numOfU);
    pts= cleanPts(pts);
    % Iterate over curve and apply deCasteljau
    numOfPts = length(pts(1,:));
    
    
    
    for i = 1: numOfU
        ui = u(i);
        c(:, i) = deCasteljau(ui, pts, numOfPts, numOfPts);
    end
    
    points = c;   
function loadMeshPoints(data)
    for i = 1:(size(data,1)/2)
        pts = [data(2*i-1,3:end);data(2*i,3:end)];
        mesh_pts = CalcDecas(pts);
        mesh_push(mesh_pts,data(2*i-1,1),data(2*i-1,2));    
            
    end   
% Merely push mesh points 
function mesh_push(pts,fra_num,leg_num)

    global mesh_points;
 
        
%     [mesh_points,pointer] = getData();
    pointer = size(mesh_points,1)+1;
    
%     updatePM(leg_counter);

    if(isempty(leg_num))
        leg_counter = PM_get();
    else
        leg_counter = leg_num;
    end   
    
    if(isempty(fra_num))
        frames_num = getFramesNum();
    else
        frames_num = fra_num;
    end
    
    for i = 1:size(pts,2)
        mesh_points(pointer,1) = frames_num;
        mesh_points(pointer,2 )= leg_counter;
        mesh_points(pointer,i+2) =pts(1,i);
    end
    
    pointer = pointer+1;
    
    
    for i = 1:size(pts,2)
        mesh_points(pointer,1) = frames_num;
        mesh_points(pointer,2 )= leg_counter;
        mesh_points(pointer,i+2) =pts(2,i);
    end
    
     for i=1:size(mesh_points,1)
         for j=i:size(mesh_points,1)
             if(mesh_points(i,1)>mesh_points(j,1))
                 tmp = mesh_points(i,:);
                 mesh_points(i,:)=mesh_points(j,:);
                 mesh_points(j,:)=tmp;
             end
         end
     end
     
      frame_list = mesh_points(:,1);
      index_list = find(frame_list==frames_num);
      if(~isempty(index_list))
      
      for i = index_list(1):index_list(end)
          for j = i:index_list(end)
              if(mesh_points(i,1)>mesh_points(j,1))
                  tmp = mesh_points(i,:);
                  mesh_points(i,:)=mesh_points(j,:);
                  mesh_points(j,:)=tmp;
              end
          end
      end
      end
      
      
      
%     TODOOOOOOO step size  
function [pts] = paint(pts,color)
global c;
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
    pts = c;
%     mesh_push(c);
    % Plot curve
    plot(c(1, :), c(2, :), '-y');
%     if(strcmp(color,'none'))
%         plot(c(1, :), c(2, :), '-y');
%         hlod on;
%     else
%         hold on;
%         plot(c(1, :), c(2, :),'.');
%     end
    
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
% mesh_push(pts,'','');

% Select video button
% -usage: Select a video and decompose it into frames
% ------- Will directly open up drawing window based on the decomposed
% --------frames
% -Parameter: N/A
% -Output: A drawing window contains a image listening to keypress function, mouse
% -------- clicking function
function initial_but_Callback(hObject, eventdata, handles)
global frames_path;
global r;
r = 0;
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

global mesh_points;
mesh_points = [];
% Export button
% -usage: Ecport a Xlsx file, two folders: one named "WRTleg", which
% ------- outputs N txt files (N is the number of legs), each 
%-------- contaning the coordinates of tracked appendages from the 1st 
%-------- frame to the last one; There is another folder named "WRTframe", 
%-------- which outputs M txt file (M is the number of processed frames), 
%-------- each containing the coordinates of tracked appendages within a
%-------- frame.
% -Parameter: 
% -Output: One xlsx file, two folders containing txt files.
% -------- 
function export_but_Callback(hObject, eventdata, handles)
global data;
global mesh_points;
global data_exp;
global uitable_handle;
[bool,uitable_handle] = SetUitable(data)
data = get(uitable_handle,'Data');
    if(isempty(data))
        return
    end

    hh = findall(0,'tag','scale');
    step_box = findall(0,'tag','step_box');
    tmp = get(hh,'string');
    tmp2 = get(step_box,'string');
    if(isempty(tmp) ||isempty(tmp2))
        waitfor(msgbox("scale or mesh pieces parameter cannot be none",'modal'));
        return
    else
          mesh_points = [];
          loadMeshPoints(data);
          data_exp = zeros(size(data,1),size(data,2));
            mesh_points_exp = zeros(size(mesh_points,1),size(mesh_points,2));
          data_exp(:,1:2) = data(:,1:2);
            mesh_points_exp(:,1:2)= mesh_points(:,1:2)
            mesh_points_exp(:,3:end) = mesh_points(:,3:end)/str2num(tmp);
          data_exp(:,3:end) = data(:,3:end)/str2num(tmp);
    end
    
name = datestr(now);
waitfor(msgbox("Select a folder to save xlsx file",'modal'));
 FileName = uiputfile(strcat(name,'.xlsx'),'Save as');
waitfor(msgbox("Select a folder to save the data",'modal'));
 name = uigetdir();
 currentFolder = pwd;
cd(name)

xlswrite(FileName,data_exp);
mkdir MeshPoints;

cd MeshPoints;
    
%     save2txt(mesh_points_exp);
    gatherLeg(mesh_points_exp)
% cd ..;
% mkdir WRTframe;
% cd WRTframe;
%     save2txt(mesh_points_exp);
% cd ..;
% 
% mkdir WRTleg;
% cd WRTleg
% gatherLeg(mesh_points_exp);
% cd ..;
 cd ..;
 cd(currentFolder);

function gatherLeg(data)
    
    if(isempty(data))
        return;
    end
    global leg_list;
    leg_list = data(:,2);
    leg_list = unique(leg_list);
    counter =1
    for iii = 1:size(leg_list,1)
        leg = leg_list(iii);
        for i=1:size(data,1)
            if(i==size(data,1))
                break;
            end
            fra = data(i,1);
            if(isEqual(fra,data(i,1))& isEqual(fra,data(i+1,1))& isEqual(leg,data(i,2))& isEqual(leg,data(i+1,2)))
                    data2save(2*counter-1,:) = data(i,:);
                    data2save(2*counter,:) = data(i+1,:);
                    display(data2save);
                    counter = counter+1;
%                     mkdir(num2str(leg));
%                     cd(num2str(leg));
%                     cd ..
            end
            
        end
        fname = sprintf('%i.txt',leg);
        save(fname);
        fid=fopen(fname,'w');
        data2save(:,2)=[];
        for ii=1:size(data2save,1)
            for j=1:size(data2save,2)
                if j==size(data2save,2)
                    fprintf(fid,'%d\r\n',data2save(ii,j));
                else
                    fprintf(fid,'%d  ',data2save(ii,j));
                end
            end

         end
         fclose(fid);
         data2save = [];
         counter=1;
    end
function bool = isEqual(a,b)
bool = (abs(a-b)<0.001);



function save2txt(data)
for i=1:size(data,1)
    fra = data(i,1);
    leg= data(i,2);
    
    if(i==size(data,1))
        break;
    end
    if(fra==data(i,1)&&fra==data(i+1,1)&&leg == data(i,2)&&leg==data(i+1,2))
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
                        fprintf(fid,'%d\n',data2save(ii,j));
                    else
                        fprintf(fid,'%d ',data2save(ii,j));
                    end
                end

            end
            fclose(fid);
            cd ..
       
        
    end
end
        
% FrameNum box
% -usage: 
% ------- Take in an interger as input
% ------------ Refresh the drawing window and display the corresponded imgae as
% -------------the interger specified
% -------------Redraw the appendages of that frame from [data]
% -Parameter: an integer within the length of decomposed frames.
% -Output: Refresh the drawing window by the specified frame of picture

function frame_numbox_Callback(hObject, eventdata, handles)
    
    [data,pointer] = getData();
    frames_num = getFramesNum();
    global frames_path;
    if(frames_num==1)
        msgbox("No previous frame");
        return
    end
       
    handle_fig = figure(1);
    close(handle_fig);
    leg_counter=1;
    h = findall(0,'tag','frame_numbox');
    set(h,'String',num2str(frames_num));
    
    updatePM(leg_counter);
    filename = strcat('frame',num2str(frames_num),'.jpg');
    I=imread(fullfile(frames_path,filename));
    updatePM(0);

    [legnum,begin] = getNums(frames_num);
    if(begin ==-1)
        return;
    end
    updatePM(legnum);
    drawData();
function frame_numbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_numbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Previous Frame button
% -usage: Display the previous image in the drawing window
% -Parameter: N/A
% -Output: Refresh the drawing window by the previous frame of picture
function previous_but_Callback(hObject, eventdata, handles)
    global api;
    global r;
    r = api.getVisibleLocation();
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
%     snake =eeee
    count=0;
    begin =0;
    if(isempty(data))
        num =0;
        begin =0;
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
    
    for i =begin:size(data,1)
        if(data(i,1)==framenum)
            count = count+1;
        end
    end
    num = count/2;
    
    
% Next Frmae button
% -usage: Display the next image in the drawing window
% -Parameter: N/A
% -Output: Refresh the drawing window by the next frame of picture

function next_but_Callback(hObject, eventdata, handles)
    global api;
    global r;
    r = api.getVisibleLocation();
    
%     boxPosition = get(hMagBox, 'Position');
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
    try
        [legnum,begin] = getNums(frames_num);
        if(begin ==-1)
            return;
        end
        updatePM(legnum);
    catch
        
    end
    
    drawData();

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


    
function OEF_Callback(hObject, eventdata, handles)
global frames_path;
global data;
data =[];
global mesh_points;
mesh_points =[];

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

global frames_path;
global data;

h =findall(0,'tag','Start_Over');
% set(h,'Enable','off')
fNum = getFramesNum()

figure(1);
    hold on;
max = PM_getMax();
ct = PM_get();
if(ct ==0)
    return;
end
 if(ct<max)
     msgbox('Dont do this, young Jedi. Only the final curve can be deleted.')
    return;
 end
%     pts=[]
%     changeData(pts);
data = deleteCurve(fNum,ct)
    updatePM(ct-1);
    drawData('startover');
    data_ui =findall(0,'figure','DataTable');
    close(figure(2))
 

function ret = deleteCurve(fNum,ct)
[data,p] = getData();
begin =0;
for i=1:size(data,1)
    if(data(i,1)==fNum & data(i,2)==ct)
        begin = i;
        break;
    end
end
data(begin,:)=[]
data(begin,:)=[]
ret = data;
%% Data window
% - Usage: display [data] information in a Fig. The first column represents
% --- 
% - Parameter:
% - Output
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


%pushdown manual set up
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


% Load button
% -usage: Display the next image in the drawing window
% -Parameter: an csv. file contaning appendages' coordinates information
% --- in standard format + a folder contaning decomposed frames
% -Output: Resume the previous work by reloading the [data] information,
% --- and source frame folder

function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data
global frames_path
global mesh_points;
mesh_points = [];
waitfor(msgbox("Select mat file path",'modal'));
[baseName, folder] = uigetfile('*.mat');

filePath = fullfile(folder, baseName);
% data = csvread(filePath);
%     hh = findall(0,'tag','scale');
%     tmp = get(hh,'string');
%     if(isempty(tmp))
%         waitfor(msgbox("scale parameter cannot be none",'modal'));
%         return
%     else
%           
%           data(:,3:end) = data(:,3:end)*str2num(tmp);
%     end
load(filePath);
waitfor(msgbox("Select frames path",'modal'));
folderPath = uigetdir();
frames_path= folderPath;
frames_num =1;
set(handles.frame_numbox,'String',num2str(frames_num));
count =0;
for i = 1:size(data,1)
    if data(i,1)==1
        count = count+1;
    end
end
updatePM(count/2);

drawData(data);
% loadMeshPoints(data);

        


function MagBox_Callback(hObject, eventdata, handles)
% hObject    handle to MagBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MagBox as text
%        str2double(get(hObject,'String')) returns contents of MagBox as a double
global api;
h = findall(0,'tag','MagBox');
mag_num = str2num(get(h,'string'));
api.setMagnification(mag_num);


% --- Executes during object creation, after setting all properties.
function MagBox_CreateFcn(hObject, eventdata, handles)

% hObject    handle to MagBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
h = findall(0,'tag','MagBox');
set(h,'string',num2str(2))



function step_box_Callback(hObject, eventdata, handles)
% hObject    handle to step_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_box as text
%        str2double(get(hObject,'String')) returns contents of step_box as a double


% --- Executes during object creation, after setting all properties.
function step_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scale_Callback(hObject, eventdata, handles)
% hObject    handle to scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scale as text
%        str2double(get(hObject,'String')) returns contents of scale as a double


% --- Executes during object creation, after setting all properties.
function scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LoadProject_Callback(hObject, eventdata, handles)

global data;
global mesh_points;
global data_exp;
global uitable_handle;
[bool,uitable_handle] = SetUitable(data)
data = get(uitable_handle,'Data');
    
 name = uigetdir();
  currentFolder = pwd;
 cd(name);

save(datestr(now),'data');
cd(currentFolder);
