function f0_corrected=correction(f0,mode)
%f0-array of pitch values
%mode-tones or semitones (0-tones 1-semitones)
if(mode==0) 
    factor=12;
end;
if(mode==1) 
    factor=6;    
end;
k=0;
df=2^(1/factor); %faktor koji definise razliku izmedju frekvencija na skali polutonova
f0_start=440; %f0(1) bilo pre
for i=1:length(f0)
   
    razl=f0(i);
    for j=1:88
        if(abs(f0(i)-df^(j-49)*f0_start)<razl)
            k=j;
            razl=abs(f0(i)-df^(j-49)*f0_start);
            
        else 
            break;
            
        end;
   end;

   f0(i)=df^(k-49)*f0_start;
       
    
end;
f0_corrected=f0;
end