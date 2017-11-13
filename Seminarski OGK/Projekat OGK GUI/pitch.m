function f0=pitch(x,fs,T,windowOverlap)
% x-signal input
% fs-sampling frequency
% T-windows length in ms
% windowOverlap-percentage of window overlap

T=T/1000;
korak=round(T*fs); %duzina prozora u odbircima

%signal kroz VF filtar za obradu pitch-a
h2=fir2(90,[0 650/(fs/2) 750/(fs/2) 1],[1 1 0 0]);
x_f0=filter(h2,1,x);
%normalizacija signala
mx=max(x);
x=x./mx;
x_f0=x_f0./mx;

f0=[];

polukorak=round(korak*(100-windowOverlap)/100);

for i= 1:polukorak:length(x)-korak   %definisanje polukoraka zbog trazenog
        %preklapanja prozora 
        %uzimamo prozorom odbirke filtriranog signala
        y_f0=x_f0(i:i+korak-1);
     
        %racunamo osnovnu frekvenciju preko autokorelacije
        R1=xcorr(y_f0,y_f0);
        ly=length(R1);
        %trazimo maksimum i sledeci njemu najblizi maksimum
        probni=R1(1);
        k=1;
        for br_fo=2:ly-1
         if R1(br_fo)>R1(br_fo-1) && R1(br_fo)>R1(br_fo+1)
            
            if R1(br_fo)>probni
                probni=R1(br_fo);
                k=br_fo;
            end;
         end;
        end;
        probni=0;
        k1=1;
        for br_fo=k+1:ly-1
         if R1(br_fo)>R1(br_fo-1) && R1(br_fo)>R1(br_fo+1)
            if R1(br_fo)>probni
                probni=R1(br_fo);
                k1=br_fo;
            end;
         end;
        end;
        k1=k1-1;
        k=k-1;
        %na osnovu k1 i k koji su redni brojevi odbiraka autokorelacije 
        %koje trazimo,racunamo njihovo rastojanje u vremenu
        dt=(k1-k)/fs;
        df=1/dt;
        f0=[f0 df];   
    
      
end;

end