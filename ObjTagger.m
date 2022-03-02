function varargout = ObjTagger(varargin)
% OBJTAGGER MATLAB code for ObjTagger.fig
%      OBJTAGGER, by itself, creates a new OBJTAGGER or raises the existing
%      singleton*.
%
%      H = OBJTAGGER returns the handle to a new OBJTAGGER or the handle to
%      the existing singleton*.
%
%      OBJTAGGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OBJTAGGER.M with the given input arguments.
%
%      OBJTAGGER('Property','Value',...) creates a new OBJTAGGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ObjTagger_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ObjTagger_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ObjTagger

% Last Modified by GUIDE v2.5 16-Jul-2019 02:24:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ObjTagger_OpeningFcn, ...
                   'gui_OutputFcn',  @ObjTagger_OutputFcn, ...
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


% --- Executes just before ObjTagger is made visible.
function ObjTagger_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ObjTagger (see VARARGIN)

% Choose default command line output for ObjTagger
handles.output = hObject;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HideAllPanels(handles)
set(handles.uipanelSelection,'Visible','on')



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ObjTagger wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ObjTagger_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnExit.
function btnExit_Callback(hObject, eventdata, handles)
% hObject    handle to btnExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h1=msgbox('Goodbye','modal')

waitfor(h1);
close(handles.figure1)
% --- Executes on button press in btnpanelVidSelect.


function btnpanelVidSelect_Callback(hObject, eventdata, handles)
% hObject    handle to btnpanelVidSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% %%%%%%%%%%%%%%%%%%%%%%%%5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  We turn off all panels and make only Video Selection panel visible

HideAllPanels(handles)
set(handles.uipanelSelection,'Visible','on')
% mark the Tabbed control button as selected by showing it in bold fonts
set(hObject,'Fontweight','bold');

FileName=get(handles.txtFileSelected,'String');
if isempty(FileName)
   % No File Selected so disable the Info panel
    set(handles.uipanelVideoInfo,'Visible','off')
end


% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in btnpanelSetup.
function btnpanelSetup_Callback(hObject, eventdata, handles)
% hObject    handle to btnpanelSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% %%%%%%%%%%%%%%%%%%%%%%%%5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  We turn off all panels and make only Setup  panel visible


HideAllPanels(handles)
set(handles.uipanelSetup,'Visible','on')
% mark the Tabbed control button as selected by showing it in bold fonts
set(hObject,'Fontweight','bold');
 
global label_tag
label_tag = 'bike'
% Read the Setup CSV file

[Tag,Objsize]= LoadSetupCSV();
handles.Ta=Tag;
handles.Os=Objsize;

% update the setup panel
SetupPanelUpdate(handles,Tag,Objsize)
jfk = findobj('-regexp','Tag','x_pixel')
set(jfk,'String','1')
jgk = findobj('-regexp','Tag','y_pixel')
set(jgk,'String','1')
handles.x_pixel.String = '1'
handles.y_pixel.String = '1'
% Update handles structure
set(handles.w1,'Visible','Off')
set(handles.height1,'Visible','Off')
guidata(hObject, handles);


% --- Executes on button press in btnpanelObjTagging.
function btnpanelObjTagging_Callback(hObject, eventdata, handles)
% hObject    handle to btnpanelObjTagging (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% %%%%%%%%%%%%%%%%%%%%%%%%5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  We turn off all panels and make only Object Tagging  panel visible

HideAllPanels(handles)
set(handles.uipanelObjectTagging,'Visible','on')

% mark the Tabbed control button as selected by showing it in bold fonts
set(hObject,'Fontweight','bold');



c1=findobj('-regexp','Tag','tag__1')
set(c1,'Visible','on')
h1=findobj('-regexp','Tag','listTag1')
f1 = get(h1,'String')
set(c1,'String',f1)
 fil_name = handles.txtFileSelected
 fil_name = get(fil_name , 'String')
 % read once the frame to populate when user starts the tagging
F_saver = csvread(strcat(fil_name(1:end-4),'_latest_frame.csv'));
set(handles.Frameno,'String',num2str(F_saver(1)));
i = get(handles.Frameno,'String')
frame_no = sprintf('_%06d',str2num(i));
 read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
 handles.MyImage=imread(read_add);
 g2=findobj('-regexp','Tag','checkbox[2-8]')
 g1 = sort(g2)
 for n = 2:8
    l = get(g1(n-1,1) , 'Value')
    if(l == 1)
        a = get(g1(n-1,1) , 'Tag')
        
    end
 end
 a = a(end);
 
ShowImage(handles.MyImage,'axes1',handles,str2num(a))


% Update handles structure
guidata(hObject, handles);


function Update_Window_Next(hObject, handles,ch_no)

c1=findobj('-regexp','Tag','tag__1')
set(c1,'Visible','on')
h1=findobj('-regexp','Tag','listTag1')
f1 = get(h1,'String')
set(c1,'String',f1)
fil_name=get(handles.txtFileSelected , 'String')
 
ShowImage(handles.MyImage,'axes1',handles,ch_no)



% --- Executes on button press in btnpanelDetails.
function btnpanelDetails_Callback(hObject, eventdata, handles)
% hObject    handle to btnpanelDetails (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% %%%%%%%%%%%%%%%%%%%%%%%%5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  We turn off all panels and make only Details  panel visible
HideAllPanels(handles)
set(handles.uipanelDetails,'Visible','on')
% mark the Tabbed control button as selected by showing it in bold fonts
set(hObject,'Fontweight','bold');

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in btnVideoSelect.
function btnVideoSelect_Callback(hObject, eventdata, handles)
% hObject    handle to btnVideoSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Open File selection dialog and get video file name 
[VidFileName,VidPathName] = ...
    uigetfile({'*.MP4; *.M4P; *.M4V; *.AVI; *.WMV; *.MOV; *.QT','All Video Files'; ...
    '*.*', 'All Files'},'Select Video for Process')
	
% if user pressed Escape 
if isequal(VidFileName,0)
   disp('User selected Cancel')
   % No File Selected so disable the Info panel
   set(handles.uipanelVideoInfo,'Visible','off')
   set(handles.txtFileSelected,'String','');
   set(handles.txtPathSelected,'String','');
   handles.VidFileName = '';
   handles.VidPathName = '';
else
    % USer selected a video file
   CurrentVidFileSelected =fullfile(VidPathName, VidFileName);
   disp(['User selected ', CurrentVidFileSelected])

   set(handles.uipanelVideoInfo,'Visible','on')

   handles.CurrentVidFileSelected =CurrentVidFileSelected ;
   handles.VidFileName = VidFileName;
   handles.VidPathName = VidPathName
   
   set(handles.txtFileSelected,'String',VidFileName)
   set(handles.txtPathSelected,'String',VidPathName)
   
   % open video nd get its info
    xyloObj = VideoReader(VidFileName);
    info = get(xyloObj)

    % Show the video info in GUI panel.
    
    set(handles.txtDuration,'String',info.Duration);
    set(handles.txtBitPerPixel,'String',info.BitsPerPixel);
    set(handles.txtFrameRate,'String',info.FrameRate);
 fr = (info.FrameRate);
    dr = (info.Duration);
    NumberOfFrames = fr * dr*60;
    set(handles.txtFrameCount,'String',num2str(NumberOfFrames));
    set(handles.txtHeight,'String',info.Height);
    set(handles.txtWidth,'String',info.Width);
    set(handles.txtFormat,'String',info.VideoFormat);
    dit = strcat(VidPathName,VidFileName)
    fil_name=get(handles.txtFileSelected , 'String')
    if exist(strcat(fil_name(1:end-4),'_latest_frame.csv'),'file')
        
        F_saver = csvread(strcat(fil_name(1:end-4),'_latest_frame.csv'));
        set(handles.Frameno,'String',num2str(F_saver(1)))
    else
        csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),'1');    

    end
    FileName=strcat(fil_name(1:end-4),'_frames');
    if ~exist(FileName,'file')
    % No File Selected so disable the Info panel
     v2f(dit)
    end
end






% --- Executes during object creation, after setting all properties.
function uipanelSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanelSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)


m=eventdata;

disp(m)
disp(isequal(eventdata.Modifier, {'alt'}))
if isequal(upper(eventdata.Character),'X') && isequal(eventdata.Modifier, {'alt'})
    disp('Goodbye ... ');
    close(handles.figure1)

end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% UTILITY FUNCTIONS %%%%%%%%%%%%%%%%%%%%%% 


function HideAllPanels(handles)
% Hides all panels on the GUI
set(handles.uipanelObjectTagging,'Visible','off')
set(handles.uipanelSelection,'Visible','off')
set(handles.uipanelSetup,'Visible','off')
set(handles.uipanelDetails,'Visible','off')


% now we restore font of all Tabbed control buttons to normal font
set(handles.btnpanelVidSelect,'Fontweight','normal');
set(handles.btnpanelSetup,'Fontweight','normal');
set(handles.btnpanelObjTagging,'Fontweight','normal');
set(handles.btnpanelDetails,'Fontweight','normal');



function [Tag,ObjSize] = LoadSetupCSV
% global Tag 
% global Objsize 
Tag = importdata('SetupTag.csv')
global n
n = length(Tag);
% for i = 1:n
%     
%     Tag{i} = a(i)
% end

% Tag1{1}='car'
% Tag1{2}='truck'
ObjSize = importdata('SetupSize.csv');
if not(isequal( size(ObjSize,1) ,length(Tag)))
    ErrorLine=' Mismatch in Tag and Object sizes entries';
    msgbox(ErrorLine,'modal')
    disp(ErrorLine);
    disp([size(ObjSize,1) ,length(Tag)])
    len1=min([size(ObjSize,1) ,length(Tag)]);
    T=Tag; OS=ObjSize;
    clear Tag ObjSize
    
    for j=1:len1
        Tag{j}=T{j};
        ObjSize(j,:)=OS(j,:);
    end
end
%debug Tag
%debug ObjSize

    



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btnpanelSetup.
function btnpanelSetup_ButtonDownFcn(~, ~, ~)
% hObject    handle to btnpanelSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function SetupPanelUpdate(~,Tag,ObjSize)
% identify the required objects
h1=findobj('-regexp','Tag','listTag[0-9]+');
h2=findobj('-regexp','Tag','w[0-9]');
h3=findobj('-regexp','Tag','height[0-9]');
h4=findobj('-regexp','Tag','checkbox[0-9]');
set(h4,'Visible','Off');

set(h3,'Visible','Off');
set(h2,'Visible','Off');
len1=min([size(ObjSize,1) ,length(Tag)]);

for k = 1: len1
    
    set(h2(9-k),'String',ObjSize(k,1))
    set(h2(9-k),'Visible','On')
end
for k = 1: len1
    
    set(h3(9-k),'String',ObjSize(k,2))
    set(h3(9-k),'Visible','On')
end
for k = 1: len1-1
    set(h4(9-k),'Visible','On')
end
set(h1,'Visible','Off');
% populate them with given info
for i=1:length(Tag)
set(h1(9-i),'String',Tag(i))
set(h1(9-i),'Visible','On')
end



% --- Executes during object creation, after setting all properties.
function infosetup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to infosetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% 
% c1=findobj('-regexp','Tag','tag__1')
% set(c1,'Visible','on')
% h1=findobj('-regexp','Tag','listTag1')
% f1 = get(h1,'String')
% set(c1,'String',f1)
%  fil_name = handles.txtFileSelected
%  fil_name = fil_name.String
% 
% % if (handles.FrameChanged == 1)
%     read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),'_000008.jpg');
%     handles.MyImage=imread(read_add);
% %    handles.FrameChanged =0;
% %end
% 
%  
% % ShowImage(handles.MyImage,'axes1',handles)

guidata(hObject,handles)
 
function ShowImage(MyImage,MyObj,handles,chk_no)


%myaxes=findobj('Tag',MyObj) 
% get the object by Tag for axes1
myaxes= handles.axes1

%[Tg,Os]= LoadSetupCSV();
Os=handles.Os;

hx = str2num(handles.x_pixel.String);
hy = str2num(handles.y_pixel.String);

disp([chk_no hx hy])

if isempty(myaxes)
    myaxes=handles.axes1;
end

hold(myaxes,'off')
% image(myaxes,zeros(size(MyImage)))
% pause(3);

image(MyImage)
hold(myaxes,'on')
% chk_no = str2num(chk_no);
rectangle('Position',[hx,hy,Os(chk_no,1),Os(chk_no,2)],...
            'Curvature',[0,0],...
            'LineWidth',2,'LineStyle','-','EdgeColor','g')
hold(myaxes,'off')


% --- Executes during object creation, after setting all properties.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if(handles.checkbox1.Value == 1)
    o1=findobj('-regexp','Tag','tag__??');
    set(o1,'Visible','off');
    c1=findobj('-regexp','Tag','tag__1')
    set(c1,'Visible','on')
    h1=findobj('-regexp','Tag','listTag1')
    f1 = get(h1,'String')
    set(c1,'String',f1)
    % mark the Tabbed control button as selected by showing it in bold fonts
    guidata(hObject, handles);
end

function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
chk_2=findobj('-regexp','Tag','checkbox2');
v = get(chk_2,'Value');

if(v == 1)
    chk_all=findobj('-regexp','Tag','checkbox??');
    set(chk_all,'Value',0);
    set(handles.checkbox2,'Value', 1)
    o1=findobj('-regexp','Tag','tag__??');
    set(o1,'Visible','off');
    c1=findobj('-regexp','Tag','tag__2')
    set(c1,'Visible','on')
    h1=findobj('-regexp','Tag','listTag2')
    f1 = get(h1,'String')
    set(c1,'String',f1)
        c1=findobj('-regexp','Tag','tag__1')
    set(c1,'Visible','on')
    % mark the Tabbed control button as selected by showing it in bold fonts
    guidata(hObject, handles);
end

function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
chk=findobj('-regexp','Tag','checkbox3');
v = get(chk,'Value');

if(v == 1)
    chk_all=findobj('-regexp','Tag','checkbox??');
    set(chk_all,'Value',0);
    set(handles.checkbox3,'Value', 1)
    o1=findobj('-regexp','Tag','tag__??');
    set(o1,'Visible','off');
    c1=findobj('-regexp','Tag','tag__3')
    set(c1,'Visible','on')
    h1=findobj('-regexp','Tag','listTag3')
    f1 = get(h1,'String')
     
    set(c1,'String',f1)
        c1=findobj('-regexp','Tag','tag__1')
    set(c1,'Visible','on')
    
    % mark the Tabbed control button as selected by showing it in bold fonts
    guidata(hObject, handles);
end

function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
chk=findobj('-regexp','Tag','checkbox4');
v = get(chk,'Value');

if(v == 1)
    chk_all=findobj('-regexp','Tag','checkbox??');
    set(chk_all,'Value',0);
    set(handles.checkbox4,'Value', 1)
    o1=findobj('-regexp','Tag','tag__??');
    set(o1,'Visible','off');
    c1=findobj('-regexp','Tag','tag__4')
    set(c1,'Visible','on')
    h1=findobj('-regexp','Tag','listTag4')
    f1 = get(h1,'String')
    set(c1,'String',f1)
        c1=findobj('-regexp','Tag','tag__1')
    set(c1,'Visible','on')
    % mark the Tabbed control button as selected by showing it in bold fonts
    guidata(hObject, handles);
end

function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
chk=findobj('-regexp','Tag','checkbox5');
v = get(chk,'Value');

if(v == 1)   
    chk_all=findobj('-regexp','Tag','checkbox??');
    set(chk_all,'Value',0);
    set(handles.checkbox5,'Value', 1)
    o1=findobj('-regexp','Tag','tag__??');
    set(o1,'Visible','off');
    c1=findobj('-regexp','Tag','tag__5')
    set(c1,'Visible','on')
    h1=findobj('-regexp','Tag','listTag5')
    f1 = get(h1,'String')
     
    set(c1,'String',f1)
        c1=findobj('-regexp','Tag','tag__1')
    set(c1,'Visible','on')
    % mark the Tabbed control button as selected by showing it in bold fonts
    guidata(hObject, handles);
end

function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
chk=findobj('-regexp','Tag','checkbox6');
v = get(chk,'Value');

if(v == 1)
   
    chk_all=findobj('-regexp','Tag','checkbox??');
    set(chk_all,'Value',0);
    set(handles.checkbox6,'Value', 1)
    o1=findobj('-regexp','Tag','tag__??');
    set(o1,'Visible','off');
    c1=findobj('-regexp','Tag','tag__6')
    set(c1,'Visible','on')
    h1=findobj('-regexp','Tag','listTag6')
    f1 = get(h1,'String')
     
    set(c1,'String',f1)
        c1=findobj('-regexp','Tag','tag__1')
    set(c1,'Visible','on')
    % mark the Tabbed control button as selected by showing it in bold fonts
    guidata(hObject, handles);
end

function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
chk=findobj('-regexp','Tag','checkbox7');
v = get(chk,'Value');

if(v == 1)
    chk_all=findobj('-regexp','Tag','checkbox??');
    set(chk_all,'Value',0);
    set(handles.checkbox7,'Value', 1)

    o1=findobj('-regexp','Tag','tag__??');
    set(o1,'Visible','off');
    c1=findobj('-regexp','Tag','tag__7')
    set(c1,'Visible','on')
    h1=findobj('-regexp','Tag','listTag7')
    f1 = get(h1,'String')
     
    set(c1,'String',f1)
        c1=findobj('-regexp','Tag','tag__1')
    set(c1,'Visible','on')
    % mark the Tabbed control button as selected by showing it in bold fonts
    guidata(hObject, handles);
end

function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
chk=findobj('-regexp','Tag','checkbox8');
v = get(chk,'Value');

if(v == 1)
    chk_all=findobj('-regexp','Tag','checkbox??');
    set(chk_all,'Value',0);
    set(handles.checkbox8,'Value', 1)
    o1=findobj('-regexp','Tag','tag__??');
    set(o1,'Visible','off');
    c1=findobj('-regexp','Tag','tag__8')
    set(c1,'Visible','on')
    h1=findobj('-regexp','Tag','listTag8')
    f1 = get(h1,'String')
     set(c1,'String',f1)
        c1=findobj('-regexp','Tag','tag__1')
    set(c1,'Visible','on')
    % mark the Tabbed control button as selected by showing it in bold fonts
    guidata(hObject, handles);
end





% --- Executes on button press in tag__1.
function tag__1_Callback(hObject, eventdata, handles)
% hObject    handle to tag__1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[Ta,Ob]= LoadSetupCSV();
for i = 1:1500
    
Ob=handles.Os;
video_name = get(handles.txtFileSelected,'String');
video_name=video_name(1:end-4);
i = get(handles.Frameno,'String');
frame_no = sprintf('_%06d',str2num(i));
fil_name=get(handles.txtFileSelected , 'String');
read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
MyImage=rgb2gray(imread(read_add));
hx = str2num(handles.x_pixel.String);
hy = str2num(handles.y_pixel.String);


 g2=findobj('-regexp','Tag','checkbox[2-8]');
 g1 = sort(g2);
 for n = 2:8
    l = get(g1(n-1,1) , 'Value');
    if(l == 1)
        a = get(g1(n-1,1) , 'Tag');
        
    end
 end
 a = a(end);
save_MyImage = MyImage(hy:hy+Ob(str2num(a),2),hx:hx+Ob(str2num(a),1));
w_x = strcat('w',a);
w_x = findobj('-regexp','Tag',w_x);
h_y = strcat('height',a);
h_y = findobj('-regexp','Tag',h_y);

b = a;
a = strcat('listTag',a);
lt=findobj('-regexp','Tag',a);
label_tag =get(lt , 'String');
 feature = '\negative';
destdirectory = strcat('.\',video_name,'\',label_tag{1},feature);
mkdir(destdirectory);
ax =handles.x_pixel.String;
ay =handles.y_pixel.String;
ax = sprintf('_%06d',str2num(ax));
ay = sprintf('_%06d',str2num(ay)); 
ax = num2str(ax); ay = num2str(ay); 
filename = strcat(fil_name(1:end-4),'_',string(frame_no),'_y',ay,'_x', ax,'.jpg');
fulldestination = fullfile(destdirectory, filename);  %name file relative to that directory
imwrite(save_MyImage, fulldestination);
handles.hh = strcat(destdirectory,'\',filename);
handles.x_pixel.String=num2str(str2num(handles.x_pixel.String)+8);
hx = str2num(handles.x_pixel.String);
hy = str2num(handles.y_pixel.String);

jfk = findobj('-regexp','Tag','x_pixel');
set(jfk,'String',hx);
jgk = findobj('-regexp','Tag','y_pixel');
set(jgk,'String',hy);
%handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
x_1 = str2num(get(w_x,'String')) ;
j = size(handles.MyImage);
j = j(2);
if(hx + x_1 > j-8)
    handles.x_pixel.String = '1';
    y_1 = str2num(get(h_y,'String')) ;
    k = size(handles.MyImage);
    k = k(1);

    handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8);
    if(hy+y_1 > k-8) 
        set(handles.Frameno,'String',num2str(str2num(i)+1));
        handles.x_pixel.String='1';
        handles.y_pixel.String='1';
        fil_name=get(handles.txtFileSelected , 'String');
        read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
        handles.MyImage=imread(read_add);
            f_saver = str2num(i)+1;
    csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),f_saver);
    end
    
    
end


    handles.x_pixel.String;
    handles.y_pixel.String;
guidata(hObject,handles);
end
Update_Window_Next(hObject, handles,str2num(b));


% --- Executes on button press in tag__2.
function tag__2_Callback(hObject, eventdata, handles)
% hObject    handle to tag__2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[Ta,Ob]= LoadSetupCSV();

C1 = get(handles.axes1, 'CurrentPoint')
pause(5);
C2 = get(handles.axes1, 'CurrentPoint')
%top left
cx1 = C1(1,1)
cx1 = round(cx1/8)
cxx1 = cx1
cx1 = cx1*8 +1
cy1 = C1(1,2)
cy1 = round(cy1/8)
cyy1 =cy1
cy1 = cy1*8 +1

%bottom right
cx2 = C2(1,1)
cx2 = round(cx2/8)
cxx2 = cx2
cx = abs(cxx1-cxx2)
cx2 = cx2*8+1
cy2 = C2(1,2)
cy2 = round(cy2/8)
cyy2 = cy2
cy = abs(cyy1-cyy2)
cy2 = cy2*8+1
Ob=handles.Os;

hx = cx1
hy = cy1
%for z=(cy1-1)/8:(cy2-9)/8
val_xy = ((cx)*(cy))


for xval=1:val_xy
    if(hy<= cy2 - Ob(2,2)) 
video_name = get(handles.txtFileSelected,'String')
video_name=video_name(1:end-4)
i = get(handles.Frameno,'String')
frame_no = sprintf('_%06d',str2num(i));
fil_name=get(handles.txtFileSelected , 'String')
read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
MyImage=rgb2gray(imread(read_add));

save_MyImage = MyImage(hy:hy+Ob(2,2),hx:hx+Ob(2,1));


a = '2'

w_x = strcat('w',a)
w_x = findobj('-regexp','Tag',w_x)
h_y = strcat('height',a)
h_y = findobj('-regexp','Tag',h_y)


a = strcat('listTag',a)
lt=findobj('-regexp','Tag',a)
label_tag =get(lt , 'String')
 
label_tag = get(handles.tag__2,'String');
feature = '\positive'

destdirectory = strcat('.\',video_name,'\',label_tag{1},feature);
mkdir(destdirectory);

ax =hx
ay =hy

ax = sprintf('_%06d',ax);
ay = sprintf('_%06d',ay);
ax = num2str(ax);
ay = num2str(ay);
filename = strcat(fil_name(1:end-4),'_',string(frame_no),'_y',ay,'_x', ax,'.jpg');
fulldestination = fullfile(destdirectory, filename);  %name file relative to that directory
imwrite(save_MyImage, fulldestination);
del_destdirectory = strcat('.\',video_name,'\',label_tag{1},'\negative');
del_fulldestination = fullfile(del_destdirectory, filename);  %name file relative to that directory
delete(del_fulldestination)

handles.hh = strcat(destdirectory,'\',filename)

%handles.x_pixel.String=num2str(str2num(handles.x_pixel.String)+8)
hx = hx+8
handles.x_pixel.String=num2str(hx)
%hy = str2num(handles.y_pixel.String)
handles.y_pixel.String = num2str(hy)
%handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
x_1 = str2num(get(w_x,'String')) 
j = size(handles.MyImage)
j = cx2
if(hx + x_1 > j)
    hx=cx1
    handles.x_pixel.String=num2str(hx)
    y_1 = str2num(get(h_y,'String')) 
    k = size(handles.MyImage)
    k = cy2
    hy = hy+8
    handles.y_pixel.String = num2str(hy)
%    handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
%     if(hy+y_1 > k) 
%         set(handles.Frameno,'String',num2str(str2num(i)+1))
%         handles.x_pixel.String='1'
%         handles.y_pixel.String='1'
%         fil_name=get(handles.txtFileSelected , 'String')
%         read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
%         handles.MyImage=imread(read_add);
%             f_saver = str2num(i)+1;
%     csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),f_saver);
%     end
    

end
    end
Update_Window_Next(hObject, handles,2);
guidata(hObject,handles);
end
%end
Update_Window_Next(hObject, handles,2);

guidata(hObject,handles);


% --- Executes on button press in tag__3.
function tag__3_Callback(hObject, eventdata, handles)
% hObject    handle to tag__2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[Ta,Ob]= LoadSetupCSV();
tag_number = 3
C1 = get(handles.axes1, 'CurrentPoint')
pause(5);
C2 = get(handles.axes1, 'CurrentPoint')
%top left
cx1 = C1(1,1)
cx1 = round(cx1/8)
cxx1 = cx1
cx1 = cx1*8 +1
cy1 = C1(1,2)
cy1 = round(cy1/8)
cyy1 =cy1
cy1 = cy1*8 +1

%bottom right
cx2 = C2(1,1)
cx2 = round(cx2/8)
cxx2 = cx2
cx = abs(cxx1-cxx2)
cx2 = cx2*8+1
cy2 = C2(1,2)
cy2 = round(cy2/8)
cyy2 = cy2
cy = abs(cyy1-cyy2)
cy2 = cy2*8+1
Ob=handles.Os;

hx = cx1
hy = cy1
%for z=(cy1-1)/8:(cy2-9)/8
val_xy = ((cx)*(cy))


for xval=1:val_xy
    if(hy<= cy2 - Ob(3,2)) 
video_name = get(handles.txtFileSelected,'String')
video_name=video_name(1:end-4)
i = get(handles.Frameno,'String')
frame_no = sprintf('_%06d',str2num(i));
fil_name=get(handles.txtFileSelected , 'String')
read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
MyImage=rgb2gray(imread(read_add));

save_MyImage = MyImage(hy:hy+Ob(3,2),hx:hx+Ob(3,1));


a = '3'

w_x = strcat('w',a)
w_x = findobj('-regexp','Tag',w_x)
h_y = strcat('height',a)
h_y = findobj('-regexp','Tag',h_y)


a = strcat('listTag',a)
lt=findobj('-regexp','Tag',a)
label_tag =get(lt , 'String')
 
label_tag = get(handles.tag__3,'String');
feature = '\positive'

destdirectory = strcat('.\',video_name,'\',label_tag{1},feature);
mkdir(destdirectory);

ax =hx
ay =hy

ax = sprintf('_%06d',ax);
ay = sprintf('_%06d',ay);
ax = num2str(ax);
ay = num2str(ay);
filename = strcat(fil_name(1:end-4),'_',string(frame_no),'_y',ay,'_x', ax,'.jpg');
fulldestination = fullfile(destdirectory, filename);  %name file relative to that directory
imwrite(save_MyImage, fulldestination);
del_destdirectory = strcat('.\',video_name,'\',label_tag{1},'\negative');
del_fulldestination = fullfile(del_destdirectory, filename);  %name file relative to that directory
delete(del_fulldestination)
handles.hh = strcat(destdirectory,'\',filename)

%handles.x_pixel.String=num2str(str2num(handles.x_pixel.String)+8)
hx = hx+8
handles.x_pixel.String=num2str(hx)
%hy = str2num(handles.y_pixel.String)
handles.y_pixel.String = num2str(hy)
%handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
x_1 = str2num(get(w_x,'String')) 
j = size(handles.MyImage)
j = cx2
if(hx + x_1 > j)
    hx=cx1
    handles.x_pixel.String=num2str(hx)
    y_1 = str2num(get(h_y,'String')) 
    k = size(handles.MyImage)
    k = cy2
    hy = hy+8
    handles.y_pixel.String = num2str(hy)
%    handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
%     if(hy+y_1 > k) 
%         set(handles.Frameno,'String',num2str(str2num(i)+1))
%         handles.x_pixel.String='1'
%         handles.y_pixel.String='1'
%         fil_name=get(handles.txtFileSelected , 'String')
%         read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
%         handles.MyImage=imread(read_add);
%             f_saver = str2num(i)+1;
%     csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),f_saver);
%     end
    

end
    end
end
%end
Update_Window_Next(hObject, handles,3);

guidata(hObject,handles);

% --- Executes on button press in tag__4.
function tag__4_Callback(hObject, eventdata, handles)
% hObject    handle to tag__3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[Ta,Ob]= LoadSetupCSV();
tag_number = 4
C1 = get(handles.axes1, 'CurrentPoint')
pause(5);
C2 = get(handles.axes1, 'CurrentPoint')
%top left
cx1 = C1(1,1)
cx1 = round(cx1/8)
cxx1 = cx1
cx1 = cx1*8 +1
cy1 = C1(1,2)
cy1 = round(cy1/8)
cyy1 =cy1
cy1 = cy1*8 +1

%bottom right
cx2 = C2(1,1)
cx2 = round(cx2/8)
cxx2 = cx2
cx = abs(cxx1-cxx2)
cx2 = cx2*8+1
cy2 = C2(1,2)
cy2 = round(cy2/8)
cyy2 = cy2
cy = abs(cyy1-cyy2)
cy2 = cy2*8+1
Ob=handles.Os;

hx = cx1
hy = cy1
%for z=(cy1-1)/8:(cy2-9)/8
val_xy = ((cx)*(cy))


for xval=1:val_xy
    if(hy<= cy2 - Ob(4,2)) 
video_name = get(handles.txtFileSelected,'String')
video_name=video_name(1:end-4)
i = get(handles.Frameno,'String')
frame_no = sprintf('_%06d',str2num(i));
fil_name=get(handles.txtFileSelected , 'String')
read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
MyImage=rgb2gray(imread(read_add));

save_MyImage = MyImage(hy:hy+Ob(4,2),hx:hx+Ob(4,1));


a = '4'

w_x = strcat('w',a)
w_x = findobj('-regexp','Tag',w_x)
h_y = strcat('height',a)
h_y = findobj('-regexp','Tag',h_y)


a = strcat('listTag',a)
lt=findobj('-regexp','Tag',a)
label_tag =get(lt , 'String')
 
label_tag = get(handles.tag__4,'String');
feature = '\positive'

destdirectory = strcat('.\',video_name,'\',label_tag{1},feature);
mkdir(destdirectory);

ax =hx
ay =hy

ax = sprintf('_%06d',ax);
ay = sprintf('_%06d',ay);
ax = num2str(ax);
ay = num2str(ay);
filename = strcat(fil_name(1:end-4),'_',string(frame_no),'_y',ay,'_x', ax,'.jpg');
fulldestination = fullfile(destdirectory, filename);  %name file relative to that directory
imwrite(save_MyImage, fulldestination);
del_destdirectory = strcat('.\',video_name,'\',label_tag{1},'\negative');
del_fulldestination = fullfile(del_destdirectory, filename);  %name file relative to that directory
delete(del_fulldestination)
handles.hh = strcat(destdirectory,'\',filename)

%handles.x_pixel.String=num2str(str2num(handles.x_pixel.String)+8)
hx = hx+8
handles.x_pixel.String=num2str(hx)
%hy = str2num(handles.y_pixel.String)
handles.y_pixel.String = num2str(hy)
%handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
x_1 = str2num(get(w_x,'String')) 
j = size(handles.MyImage)
j = cx2
if(hx + x_1 > j)
    hx=cx1
    handles.x_pixel.String=num2str(hx)
    y_1 = str2num(get(h_y,'String')) 
    k = size(handles.MyImage)
    k = cy2
    hy = hy+8
    handles.y_pixel.String = num2str(hy)
%    handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
%     if(hy+y_1 > k) 
%         set(handles.Frameno,'String',num2str(str2num(i)+1))
%         handles.x_pixel.String='1'
%         handles.y_pixel.String='1'
%         fil_name=get(handles.txtFileSelected , 'String')
%         read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
%         handles.MyImage=imread(read_add);
%             f_saver = str2num(i)+1;
%     csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),f_saver);
%     end
    

end
    end
Update_Window_Next(hObject, handles,4);
guidata(hObject,handles);
end
%end
Update_Window_Next(hObject, handles,4);

guidata(hObject,handles);


% --- Executes on button press in tag__5.
function tag__5_Callback(hObject, eventdata, handles)
% hObject    handle to tag__3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[Ta,Ob]= LoadSetupCSV();
tag_number = 5
C1 = get(handles.axes1, 'CurrentPoint')
pause(5);
C2 = get(handles.axes1, 'CurrentPoint')
%top left
cx1 = C1(1,1)
cx1 = round(cx1/8)
cxx1 = cx1
cx1 = cx1*8 +1
cy1 = C1(1,2)
cy1 = round(cy1/8)
cyy1 =cy1
cy1 = cy1*8 +1

%bottom right
cx2 = C2(1,1)
cx2 = round(cx2/8)
cxx2 = cx2
cx = abs(cxx1-cxx2)
cx2 = cx2*8+1
cy2 = C2(1,2)
cy2 = round(cy2/8)
cyy2 = cy2
cy = abs(cyy1-cyy2)
cy2 = cy2*8+1
Ob=handles.Os;

hx = cx1
hy = cy1
%for z=(cy1-1)/8:(cy2-9)/8
val_xy = ((cx)*(cy))


for xval=1:val_xy
    if(hy<= cy2 - Ob(5,2)) 
video_name = get(handles.txtFileSelected,'String')
video_name=video_name(1:end-4)
i = get(handles.Frameno,'String')
frame_no = sprintf('_%06d',str2num(i));
fil_name=get(handles.txtFileSelected , 'String')
read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
MyImage=rgb2gray(imread(read_add));

save_MyImage = MyImage(hy:hy+Ob(5,2),hx:hx+Ob(5,1));


a = '5'

w_x = strcat('w',a)
w_x = findobj('-regexp','Tag',w_x)
h_y = strcat('height',a)
h_y = findobj('-regexp','Tag',h_y)


a = strcat('listTag',a)
lt=findobj('-regexp','Tag',a)
label_tag =get(lt , 'String')
 
label_tag = get(handles.tag__5,'String');
feature = '\positive'

destdirectory = strcat('.\',video_name,'\',label_tag{1},feature);
mkdir(destdirectory);

ax =hx
ay =hy

ax = sprintf('_%06d',ax);
ay = sprintf('_%06d',ay);
ax = num2str(ax);
ay = num2str(ay);
filename = strcat(fil_name(1:end-4),'_',string(frame_no),'_y',ay,'_x', ax,'.jpg');
fulldestination = fullfile(destdirectory, filename);  %name file relative to that directory
imwrite(save_MyImage, fulldestination);

del_destdirectory = strcat('.\',video_name,'\',label_tag{1},'\negative');
del_fulldestination = fullfile(del_destdirectory, filename);  %name file relative to that directory
delete(del_fulldestination)
handles.hh = strcat(destdirectory,'\',filename)

%handles.x_pixel.String=num2str(str2num(handles.x_pixel.String)+8)
hx = hx+8
handles.x_pixel.String=num2str(hx)
%hy = str2num(handles.y_pixel.String)
handles.y_pixel.String = num2str(hy)
%handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
x_1 = str2num(get(w_x,'String')) 
j = size(handles.MyImage)
j = cx2
if(hx + x_1 > j)
    hx=cx1
    handles.x_pixel.String=num2str(hx)
    y_1 = str2num(get(h_y,'String')) 
    k = size(handles.MyImage)
    k = cy2
    hy = hy+8
    handles.y_pixel.String = num2str(hy)
%    handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
%     if(hy+y_1 > k) 
%         set(handles.Frameno,'String',num2str(str2num(i)+1))
%         handles.x_pixel.String='1'
%         handles.y_pixel.String='1'
%         fil_name=get(handles.txtFileSelected , 'String')
%         read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
%         handles.MyImage=imread(read_add);
%             f_saver = str2num(i)+1;
%     csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),f_saver);
%     end
    

end
    end
Update_Window_Next(hObject, handles,5);
guidata(hObject,handles);
end
%end
Update_Window_Next(hObject, handles,5);

guidata(hObject,handles);


% --- Executes on button press in tag__6.
function tag__6_Callback(hObject, eventdata, handles)
% hObject    handle to tag__3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[Ta,Ob]= LoadSetupCSV();
tag_number = 6
C1 = get(handles.axes1, 'CurrentPoint')
pause(5);
C2 = get(handles.axes1, 'CurrentPoint')
%top left
cx1 = C1(1,1)
cx1 = round(cx1/8)
cxx1 = cx1
cx1 = cx1*8 +1
cy1 = C1(1,2)
cy1 = round(cy1/8)
cyy1 =cy1
cy1 = cy1*8 +1

%bottom right
cx2 = C2(1,1)
cx2 = round(cx2/8)
cxx2 = cx2
cx = abs(cxx1-cxx2)
cx2 = cx2*8+1
cy2 = C2(1,2)
cy2 = round(cy2/8)
cyy2 = cy2
cy = abs(cyy1-cyy2)
cy2 = cy2*8+1
Ob=handles.Os;

hx = cx1
hy = cy1
%for z=(cy1-1)/8:(cy2-9)/8
val_xy = ((cx)*(cy))


for xval=1:val_xy
    if(hy<= cy2 - Ob(6,2)) 
video_name = get(handles.txtFileSelected,'String')
video_name=video_name(1:end-4)
i = get(handles.Frameno,'String')
frame_no = sprintf('_%06d',str2num(i));
fil_name=get(handles.txtFileSelected , 'String')
read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
MyImage=rgb2gray(imread(read_add));

save_MyImage = MyImage(hy:hy+Ob(6,2),hx:hx+Ob(6,1));


a = '6'

w_x = strcat('w',a)
w_x = findobj('-regexp','Tag',w_x)
h_y = strcat('height',a)
h_y = findobj('-regexp','Tag',h_y)


a = strcat('listTag',a)
lt=findobj('-regexp','Tag',a)
label_tag =get(lt , 'String')
 
label_tag = get(handles.tag__6,'String');
feature = '\positive'

destdirectory = strcat('.\',video_name,'\',label_tag{1},feature);
mkdir(destdirectory);

ax =hx
ay =hy

ax = sprintf('_%06d',ax);
ay = sprintf('_%06d',ay);
ax = num2str(ax);
ay = num2str(ay);
filename = strcat(fil_name(1:end-4),'_',string(frame_no),'_y',ay,'_x', ax,'.jpg');
fulldestination = fullfile(destdirectory, filename);  %name file relative to that directory
imwrite(save_MyImage, fulldestination);
del_destdirectory = strcat('.\',video_name,'\',label_tag{1},'\negative');
del_fulldestination = fullfile(del_destdirectory, filename);  %name file relative to that directory
delete(del_fulldestination)
handles.hh = strcat(destdirectory,'\',filename)

%handles.x_pixel.String=num2str(str2num(handles.x_pixel.String)+8)
hx = hx+8
handles.x_pixel.String=num2str(hx)
%hy = str2num(handles.y_pixel.String)
handles.y_pixel.String = num2str(hy)
%handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
x_1 = str2num(get(w_x,'String')) 
j = size(handles.MyImage)
j = cx2
if(hx + x_1 > j)
    hx=cx1
    handles.x_pixel.String=num2str(hx)
    y_1 = str2num(get(h_y,'String')) 
    k = size(handles.MyImage)
    k = cy2
    hy = hy+8
    handles.y_pixel.String = num2str(hy)
%    handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
%     if(hy+y_1 > k) 
%         set(handles.Frameno,'String',num2str(str2num(i)+1))
%         handles.x_pixel.String='1'
%         handles.y_pixel.String='1'
%         fil_name=get(handles.txtFileSelected , 'String')
%         read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
%         handles.MyImage=imread(read_add);
%             f_saver = str2num(i)+1;
%     csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),f_saver);
%     end
    

end
    end
Update_Window_Next(hObject, handles,6);
guidata(hObject,handles);
end
%end
Update_Window_Next(hObject, handles,6);

guidata(hObject,handles);


% --- Executes on button press in tag__7.
function tag__7_Callback(hObject, eventdata, handles)
% hObject    handle to tag__3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[Ta,Ob]= LoadSetupCSV();
tag_number = 7
C1 = get(handles.axes1, 'CurrentPoint')
pause(5);
C2 = get(handles.axes1, 'CurrentPoint')
%top left
cx1 = C1(1,1)
cx1 = round(cx1/8)
cxx1 = cx1
cx1 = cx1*8 +1
cy1 = C1(1,2)
cy1 = round(cy1/8)
cyy1 =cy1
cy1 = cy1*8 +1

%bottom right
cx2 = C2(1,1)
cx2 = round(cx2/8)
cxx2 = cx2
cx = abs(cxx1-cxx2)
cx2 = cx2*8+1
cy2 = C2(1,2)
cy2 = round(cy2/8)
cyy2 = cy2
cy = abs(cyy1-cyy2)
cy2 = cy2*8+1
Ob=handles.Os;

hx = cx1
hy = cy1
%for z=(cy1-1)/8:(cy2-9)/8
val_xy = ((cx)*(cy))


for xval=1:val_xy
    if(hy<= cy2 - Ob(7,2)) 
video_name = get(handles.txtFileSelected,'String')
video_name=video_name(1:end-4)
i = get(handles.Frameno,'String')
frame_no = sprintf('_%06d',str2num(i));
fil_name=get(handles.txtFileSelected , 'String')
read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
MyImage=rgb2gray(imread(read_add));

save_MyImage = MyImage(hy:hy+Ob(7,2),hx:hx+Ob(7,1));


a = '7'

w_x = strcat('w',a)
w_x = findobj('-regexp','Tag',w_x)
h_y = strcat('height',a)
h_y = findobj('-regexp','Tag',h_y)


a = strcat('listTag',a)
lt=findobj('-regexp','Tag',a)
label_tag =get(lt , 'String')
 
label_tag = get(handles.tag__7,'String');
feature = '\positive'

destdirectory = strcat('.\',video_name,'\',label_tag{1},feature);
mkdir(destdirectory);

ax =hx
ay =hy

ax = sprintf('_%06d',ax);
ay = sprintf('_%06d',ay);
ax = num2str(ax);
ay = num2str(ay);
filename = strcat(fil_name(1:end-4),'_',string(frame_no),'_y',ay,'_x', ax,'.jpg');
fulldestination = fullfile(destdirectory, filename);  %name file relative to that directory
imwrite(save_MyImage, fulldestination);
del_destdirectory = strcat('.\',video_name,'\',label_tag{1},'\negative');
del_fulldestination = fullfile(del_destdirectory, filename);  %name file relative to that directory
delete(del_fulldestination)
handles.hh = strcat(destdirectory,'\',filename)

%handles.x_pixel.String=num2str(str2num(handles.x_pixel.String)+8)
hx = hx+8
handles.x_pixel.String=num2str(hx)
%hy = str2num(handles.y_pixel.String)
handles.y_pixel.String = num2str(hy)
%handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
x_1 = str2num(get(w_x,'String')) 
j = size(handles.MyImage)
j = cx2
if(hx + x_1 > j)
    hx=cx1
    handles.x_pixel.String=num2str(hx)
    y_1 = str2num(get(h_y,'String')) 
    k = size(handles.MyImage)
    k = cy2
    hy = hy+8
    handles.y_pixel.String = num2str(hy)
%    handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
%     if(hy+y_1 > k) 
%         set(handles.Frameno,'String',num2str(str2num(i)+1))
%         handles.x_pixel.String='1'
%         handles.y_pixel.String='1'
%         fil_name=get(handles.txtFileSelected , 'String')
%         read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
%         handles.MyImage=imread(read_add);
%             f_saver = str2num(i)+1;
%     csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),f_saver);
%     end
    

end
    end
Update_Window_Next(hObject, handles,7);
guidata(hObject,handles);
end
%end
Update_Window_Next(hObject, handles,7);

guidata(hObject,handles);


% --- Executes on button press in tag__8.
function tag__8_Callback(hObject, eventdata, handles)
% hObject    handle to tag__3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[Ta,Ob]= LoadSetupCSV();
tag_number = 4
C1 = get(handles.axes1, 'CurrentPoint')
pause(5);
C2 = get(handles.axes1, 'CurrentPoint')
%top left
cx1 = C1(1,1)
cx1 = round(cx1/8)
cxx1 = cx1
cx1 = cx1*8 +1
cy1 = C1(1,2)
cy1 = round(cy1/8)
cyy1 =cy1
cy1 = cy1*8 +1

%bottom right
cx2 = C2(1,1)
cx2 = round(cx2/8)
cxx2 = cx2
cx = abs(cxx1-cxx2)
cx2 = cx2*8+1
cy2 = C2(1,2)
cy2 = round(cy2/8)
cyy2 = cy2
cy = abs(cyy1-cyy2)
cy2 = cy2*8+1
Ob=handles.Os;

hx = cx1
hy = cy1
%for z=(cy1-1)/8:(cy2-9)/8
val_xy = ((cx)*(cy))


for xval=1:val_xy
    if(hy<= cy2 - Ob(8,2)) 
video_name = get(handles.txtFileSelected,'String')
video_name=video_name(1:end-4)
i = get(handles.Frameno,'String')
frame_no = sprintf('_%06d',str2num(i));
fil_name=get(handles.txtFileSelected , 'String')
read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
MyImage=rgb2gray(imread(read_add));

save_MyImage = MyImage(hy:hy+Ob(8,2),hx:hx+Ob(8,1));


a = '8'

w_x = strcat('w',a)
w_x = findobj('-regexp','Tag',w_x)
h_y = strcat('height',a)
h_y = findobj('-regexp','Tag',h_y)


a = strcat('listTag',a)
lt=findobj('-regexp','Tag',a)
label_tag =get(lt , 'String')
 
label_tag = get(handles.tag__8,'String');
feature = '\positive'

destdirectory = strcat('.\',video_name,'\',label_tag{1},feature);
mkdir(destdirectory);

ax =hx
ay =hy

ax = sprintf('_%06d',ax);
ay = sprintf('_%06d',ay);
ax = num2str(ax);
ay = num2str(ay);
filename = strcat(fil_name(1:end-4),'_',string(frame_no),'_y',ay,'_x', ax,'.jpg');
fulldestination = fullfile(destdirectory, filename);  %name file relative to that directory
imwrite(save_MyImage, fulldestination);
del_destdirectory = strcat('.\',video_name,'\',label_tag{1},'\negative');
del_fulldestination = fullfile(del_destdirectory, filename);  %name file relative to that directory
delete(del_fulldestination)
handles.hh = strcat(destdirectory,'\',filename)

%handles.x_pixel.String=num2str(str2num(handles.x_pixel.String)+8)
hx = hx+8
handles.x_pixel.String=num2str(hx)
%hy = str2num(handles.y_pixel.String)
handles.y_pixel.String = num2str(hy)
%handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
x_1 = str2num(get(w_x,'String')) 
j = size(handles.MyImage)
j = cx2
if(hx + x_1 > j)
    hx=cx1
    handles.x_pixel.String=num2str(hx)
    y_1 = str2num(get(h_y,'String')) 
    k = size(handles.MyImage)
    k = cy2
    hy = hy+8
    handles.y_pixel.String = num2str(hy)
%    handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
%     if(hy+y_1 > k) 
%         set(handles.Frameno,'String',num2str(str2num(i)+1))
%         handles.x_pixel.String='1'
%         handles.y_pixel.String='1'
%         fil_name=get(handles.txtFileSelected , 'String')
%         read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
%         handles.MyImage=imread(read_add);
%             f_saver = str2num(i)+1;
%     csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),f_saver);
%     end
    

end
    end
Update_Window_Next(hObject, handles,8);
guidata(hObject,handles);
end
%end
Update_Window_Next(hObject, handles,8);

guidata(hObject,handles);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function v2f(dir)
video = VideoReader(dir);
get(video)
video_name =video.Name;
video_name = video_name(1:end-4);
destdirectory = strcat('.\',video_name,'_frames');
mkdir(destdirectory);

for i = 1:video.NumberOfFrames
    
    frame_no = sprintf('_%06d',i);
    filename = strcat(video_name,frame_no,'.jpg');
    temp_read = read(video,i);
   %temp_read =  imresize(temp_read,[257 257]);
   % imwrite(temp_read,filename);
   fulldestination = fullfile(destdirectory, filename);  %name file relative to that directory
   imwrite(temp_read, fulldestination);
    
end


% --- Executes during object creation, after setting all properties.
function checkbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function ObjHandle= GetObjectTag(StringTagName)
t1=findobj('-regexp','Tag',StringTagName);
if isempty(t1)
    ErrorMsg1=['Error finding ' ,StringTagName];
    % msgbox(ErrorMsg1,'modal');
    disp(ErrorMsg1)
    %error(ErrorMsg1)
end
ObjHandle=t1;


%%%%%%%%% examples
% sprintf('%s_%06d_%06d_jpg','MyFile123_' ,x,y)
% gives
% ans =
%     'MyFile123__000035_000023_jpg'


% --- Executes on button press in btnNextFrame.
function btnNextFrame_Callback(hObject, eventdata, handles)
% hObject    handle to btnNextFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        i = get(handles.Frameno,'String')
        frame_no = sprintf('_%06d',str2num(i)+1);
        set(handles.Frameno,'String',num2str(str2num(i)+1))
        handles.x_pixel.String='1'
        handles.y_pixel.String='1'
        fil_name=get(handles.txtFileSelected , 'String')
        read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
        handles.MyImage=imread(read_add);
        g2=findobj('-regexp','Tag','checkbox[2-8]')
        g1 = sort(g2)
        for n = 2:8
        l = get(g1(n-1,1) , 'Value')
        if(l == 1)
        a = get(g1(n-1,1) , 'Tag')

        end
        end
        a = a(end)
Update_Window_Next(hObject, handles,str2num(a));
    handles.x_pixel.String
    handles.y_pixel.String
    f_saver = str2num(i)+1;
    csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),f_saver);
    
guidata(hObject,handles);


% --- Executes on button press in btnDeletePrevious.
function btnDeletePrevious_Callback(hObject, eventdata, handles)
% hObject    handle to btnDeletePrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        i = get(handles.Frameno,'String')
        frame_no = sprintf('_%06d',str2num(i));
        set(handles.Frameno,'String',num2str(str2num(i)))
        if(str2num(handles.x_pixel.String)== 1)
        handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)-8)
        else
        handles.x_pixel.String = num2str(str2num(handles.x_pixel.String)-8)
        end
         
        fil_name=get(handles.txtFileSelected , 'String')
        read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
        handles.MyImage=imread(read_add);
        delete(handles.hh)
        Update_Window_Next(hObject, handles,1);
guidata(hObject,handles);

    
    


% --- Executes on button press in btnDiscardWindow.
function btnDiscardWindow_Callback(hObject, eventdata, handles)
% hObject    handle to btnDiscardWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Ob=handles.Os;

video_name = get(handles.txtFileSelected,'String')
video_name=video_name(1:end-4)
i = get(handles.Frameno,'String')
frame_no = sprintf('_%06d',str2num(i));
fil_name=get(handles.txtFileSelected , 'String')
read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
MyImage=rgb2gray(imread(read_add));
hx = str2num(handles.x_pixel.String)
hy = str2num(handles.y_pixel.String)


 g2=findobj('-regexp','Tag','checkbox[2-8]')
 g1 = sort(g2)
 for n = 2:8
    l = get(g1(n-1,1) , 'Value')
    if(l == 1)
        a = get(g1(n-1,1) , 'Tag')
        
    end
 end
 a = a(end)
save_MyImage = MyImage(hy:hy+Ob(str2num(a),2),hx:hx+Ob(str2num(a),1));
w_x = strcat('w',a)
w_x = findobj('-regexp','Tag',w_x)
h_y = strcat('height',a)
h_y = findobj('-regexp','Tag',h_y)

b = a;
a = strcat('listTag',a)
lt=findobj('-regexp','Tag',a)
label_tag =get(lt , 'String')
 feature = '\discarded'
destdirectory = strcat('.\',video_name,'\',label_tag{1},feature);
mkdir(destdirectory);
ax =handles.x_pixel.String
ay =handles.y_pixel.String
ax = sprintf('_%06d',str2num(ax)); ay = sprintf('_%06d',str2num(ay)); ax = num2str(ax); ay = num2str(ay); filename = strcat(fil_name(1:end-4),'_',string(frame_no),'_y',ay,'_x', ax,'.jpg');;
fulldestination = fullfile(destdirectory, filename);  %name file relative to that directory
imwrite(save_MyImage, fulldestination);
del_destdirectory = strcat('.\',video_name,'\',label_tag{1},'\negative');
del_fulldestination = fullfile(del_destdirectory, filename);  %name file relative to that directory
delete(del_fulldestination)
handles.hh = strcat(destdirectory,'\',filename)
handles.x_pixel.String=num2str(str2num(handles.x_pixel.String)+8)
hx = str2num(handles.x_pixel.String)
hy = str2num(handles.y_pixel.String)

jfk = findobj('-regexp','Tag','x_pixel')
set(jfk,'String',hx)
jgk = findobj('-regexp','Tag','y_pixel')
set(jgk,'String',hy)
%handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
x_1 = str2num(get(w_x,'String')) 
j = size(handles.MyImage)
j = j(2)
if(hx + x_1 > j-8)
    handles.x_pixel.String = '1'
    y_1 = str2num(get(h_y,'String')) 
    k = size(handles.MyImage)
    k = k(1)

    handles.y_pixel.String = num2str(str2num(handles.y_pixel.String)+8)
    if(hy+y_1 > k-8) 
        set(handles.Frameno,'String',num2str(str2num(i)+1))
        handles.x_pixel.String='1'
        handles.y_pixel.String='1'
        fil_name=get(handles.txtFileSelected , 'String')
        read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
        handles.MyImage=imread(read_add);
            f_saver = str2num(i)+1;
    csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),f_saver);
    end
    
    
end

Update_Window_Next(hObject, handles,str2num(b));
    handles.x_pixel.String
    handles.y_pixel.String
guidata(hObject,handles);


% --- Executes on button press in btnPrevious.
function btnPrevious_Callback(hObject, eventdata, handles)
% hObject    handle to btnPrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        i = get(handles.Frameno,'String')
        frame_no = sprintf('_%06d',str2num(i)-1);
        set(handles.Frameno,'String',num2str(str2num(i)-1))
        handles.x_pixel.String='1'
        handles.y_pixel.String='1'
        fil_name=get(handles.txtFileSelected , 'String')
        read_add = strcat('.\',fil_name(1:end-4),'_frames\',fil_name(1:end-4),string(frame_no), '.jpg');
        handles.MyImage=imread(read_add);
        g2=findobj('-regexp','Tag','checkbox[2-8]')
        g1 = sort(g2)
        for n = 2:8
        l = get(g1(n-1,1) , 'Value')
        if(l == 1)
        a = get(g1(n-1,1) , 'Tag')

        end
        end
        a = a(end)
Update_Window_Next(hObject, handles,str2num(a));        
    handles.x_pixel.String
    handles.y_pixel.String
    f_saver = str2num(i)+1
    csvwrite(strcat(fil_name(1:end-4),'_latest_frame.csv'),f_saver);
    
guidata(hObject,handles);


% --- Executes on button press in tick2.
function tick2_Callback(hObject, eventdata, handles)
% hObject    handle to tick2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tick2


% --- Executes on button press in tick3.
function tick3_Callback(hObject, eventdata, handles)
% hObject    handle to tick3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tick3


% --- Executes on button press in tick1.
function tick1_Callback(hObject, eventdata, handles)
% hObject    handle to tick1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tick1


% --- Executes on button press in tick5.
function tick5_Callback(hObject, eventdata, handles)
% hObject    handle to tick5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tick5


% --- Executes on button press in tick6.
function tick6_Callback(hObject, eventdata, handles)
% hObject    handle to tick6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tick6


% --- Executes on button press in tick4.
function tick4_Callback(hObject, eventdata, handles)
% hObject    handle to tick4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tick4


% --- Executes on button press in btnGenerate.
function btnGenerate_Callback(hObject, eventdata, handles)
% hObject    handle to btnGenerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bighog = [];
biglbp = [];
video_name = get(handles.txtFileSelected,'String');
video_name=video_name(1:end-4);

g2=findobj('-regexp','Tag','checkbox[2-8]');
 g1 = sort(g2);
 for n = 2:8
    l = get(g1(n-1,1) , 'Value');
    if(l == 1)
        a = get(g1(n-1,1) , 'Tag');
        
    end
 end
 a = a(end);

a = strcat('listTag',a);
lt=findobj('-regexp','Tag',a);
label_tag =get(lt , 'String');
feature_id = '\positive';
destdirectory = strcat('.\',video_name,'\',label_tag{1},feature_id);
imagefiles = dir(strcat(destdirectory,'\*.jpg'));
nfiles = length(imagefiles);    % Number of files found
for ii=1:nfiles
currentfilename = imagefiles(ii).name;
currentimage = imread(strcat(destdirectory,'\' ,currentfilename));
%cameraman = imresize(cameraman, [64 128]);
%cameraman = rgb2gray(currentimage);
chk=findobj('-regexp','Tag','tick1');
vhog = get(chk,'Value');

if(vhog == 1) 
currentimage_Hog = extractHOGFeatures(currentimage,'CellSize',[16 16]);
bighog = [bighog ; currentimage_Hog];

% mkdir(strcat('.\',video_name,'_hog\',label_tag{1},feature_id));
% csvwrite(strcat('.\',video_name,'_hog\',label_tag{1},feature_id,'\',currentfilename,'.csv'),currentimage_Hog);
end

chk=findobj('-regexp','Tag','tick2');
vlbp = get(chk,'Value');

if(vlbp == 1) 
currentimage_Lbp = extractLBPFeatures(currentimage,'CellSize',[16 16]);
biglbp = [biglbp ; currentimage_Lbp];

% mkdir(strcat('.\',video_name,'_Lbp\',label_tag{1},feature_id));
% csvwrite(strcat('.\',video_name,'_Lbp\',label_tag{1},feature_id,'\',currentfilename,'.csv'),currentimage_Lbp);
end

if(vlbp == 1 && vhog ==1)
    currentimage_hogLbp = [currentimage_Hog currentimage_Lbp];
%     mkdir(strcat('.\',video_name,'_hogLbp\',label_tag{1},feature_id));
%     csvwrite(strcat('.\',video_name,'_hogLbp\',label_tag{1},feature_id,'\',currentfilename,'.csv'),currentimage_hogLbp);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

if(vhog == 1) 

mkdir(strcat('.\',video_name,'_bighog\',label_tag{1},feature_id));
csvwrite(strcat('.\',video_name,'_bighog\',label_tag{1},feature_id,'.csv'),bighog);
end

if(vlbp == 1) 
mkdir(strcat('.\',video_name,'_biglbp\',label_tag{1},feature_id));
csvwrite(strcat('.\',video_name,'_biglbp\',label_tag{1},feature_id,'.csv'),biglbp);
end

if(vlbp == 1 && vhog ==1)
bighoglbp = [bighog biglbp];
mkdir(strcat('.\',video_name,'_bighoglbp\',label_tag{1},feature_id));
csvwrite(strcat('.\',video_name,'_bighoglbp\',label_tag{1},feature_id,'.csv'),bighoglbp);
end





feature_id = '\negative';
destdirectory = strcat('.\',video_name,'\',label_tag{1},feature_id);
imagefiles = dir(strcat(destdirectory,'\*.jpg'));
nfiles = length(imagefiles);    % Number of files found
for ii=1:nfiles
currentfilename = imagefiles(ii).name;
currentimage = imread(strcat(destdirectory,'\' ,currentfilename));
%cameraman = imresize(cameraman, [64 128]);
%cameraman = rgb2gray(currentimage);
chk=findobj('-regexp','Tag','tick1');
vhog = get(chk,'Value');

if(vhog == 1) 
currentimage_Hog = extractHOGFeatures(currentimage,'CellSize',[16 16]);
bighog = [bighog ; currentimage_Hog];

% mkdir(strcat('.\',video_name,'_hog\',label_tag{1},feature_id));
% csvwrite(strcat('.\',video_name,'_hog\',label_tag{1},feature_id,'\',currentfilename,'.csv'),currentimage_Hog);
end

chk=findobj('-regexp','Tag','tick2');
vlbp = get(chk,'Value');

if(vlbp == 1) 
currentimage_Lbp = extractLBPFeatures(currentimage,'CellSize',[16 16]);
biglbp = [biglbp ; currentimage_Lbp];

% mkdir(strcat('.\',video_name,'_Lbp\',label_tag{1},feature_id));
% csvwrite(strcat('.\',video_name,'_Lbp\',label_tag{1},feature_id,'\',currentfilename,'.csv'),currentimage_Lbp);
end

if(vlbp == 1 && vhog ==1)
    currentimage_hogLbp = [currentimage_Hog currentimage_Lbp];
%     mkdir(strcat('.\',video_name,'_hogLbp\',label_tag{1},feature_id));
%     csvwrite(strcat('.\',video_name,'_hogLbp\',label_tag{1},feature_id,'\',currentfilename,'.csv'),currentimage_hogLbp);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

if(vhog == 1) 

mkdir(strcat('.\',video_name,'_bighog\',label_tag{1},feature_id));
csvwrite(strcat('.\',video_name,'_bighog\',label_tag{1},feature_id,'.csv'),bighog);
end

if(vlbp == 1) 
mkdir(strcat('.\',video_name,'_biglbp\',label_tag{1},feature_id));
csvwrite(strcat('.\',video_name,'_biglbp\',label_tag{1},feature_id,'.csv'),biglbp);
end

if(vlbp == 1 && vhog ==1)
bighoglbp = [bighog biglbp];
mkdir(strcat('.\',video_name,'_bighoglbp\',label_tag{1},feature_id));
csvwrite(strcat('.\',video_name,'_bighoglbp\',label_tag{1},feature_id,'.csv'),bighoglbp);
end

 
 

