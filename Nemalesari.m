close all;clear all;clearvars;clc;


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

total = 500;
ZeroInit = [0.89 -0.07 0.34 -0.30 0.10 0.95 0.17 -0.24];
z = zeros(1,4);
angle = zeros(1,total);
measure = linspace(1,total,total);
count = 0;
Y = zeros(1,8);
while (count < total)   
    sms = fscanf(s);
    if (length(sms) > 40)
        count = count+1;
        %Y = [Y;str2num(sms)-ZeroInit];
        %hold on
        %plot(count,Y(count,:),'.');
        %drawnow();
        sms = str2num(sms)-ZeroInit;
        z(1,1) = sms(1)*sms(5) + sms(2)*sms(6) + sms(3)*sms(7) + sms(4)*sms(8);
        z(1,2) = -sms(1)*sms(6) + sms(2)*sms(5) - sms(3)*sms(8) - sms(4)*sms(7);
        z(1,3) = -sms(1)*sms(7) + sms(2)*sms(8) + sms(3)*sms(5) - sms(4)*sms(6);
        z(1,4) = -sms(1)*sms(8) - sms(2)*sms(7) + sms(3)*sms(6) - sms(4)*sms(5);

        angle(count) = 2*acos(z(1,1)) *57.2958;
        hold on
        plot(measure(1:count),angle(1:count),'o');
        drawnow();
    end
    
end



fclose(s);