close all;clear all;clc;


%% Create serial object for Arduino
baudrate = 115200;
%baudrate = 1200;
s = serial('COM6','BaudRate',baudrate); % change the COM Port number as needed
s.ReadAsyncMode = 'manual';
set(s,'InputBufferSize',100);

%% Connect the serial port to Arduino
try
    fopen(s);
catch err
    fclose(instrfind);
    error('Make sure you select the correct COM Port where the Arduino is connected.');
end

%% Read and plot the data from Arduino
Tmax = 60;Ts = 0.02; i = 1;ata = 0;t = 0;
tic % Start timer
T(i)=0;
FLAG_CASTING = false;
CubH = [];
Sensor=zeros(1,8);
Flag_Initializing = true;

while(Flag_Initializing)
    while(strcmp(s.TransferStatus,'read'))
        pause(0.1);
    end    
    readasync(s);
    sms = fscanf(s);
   % if ~strcmp(sms(1:1),'ypr')
   %     fprintf(sms)
   % else
       Flag_Initializing = false;
   % end
end

count = 1;
Y = zeros(1,8);
while (count <= 1000)   
    sms = fscanf(s);
    if (length(sms) > 40)
        count = count+1;
        Y = [Y;str2num(sms)];
        hold on
        plot(count,Y(count,:),'.');
        drawnow();
    end
    
end



fclose(s);