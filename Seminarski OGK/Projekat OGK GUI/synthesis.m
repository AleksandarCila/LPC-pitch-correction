function s=synthesis(x,f0,fs,T,windowOverlap,windowOOA)
%s-output signal after LPC synthesis
%x-original signal
%f0-array of pitch values
%T-window length in ms
%windowOverlap-percentage of window overlap
%windowOOA-number of windows for overlap-and-add


T=T/1000;
korak=round(T*fs); %duzina prozora u odbircima

R=round(korak*(100-windowOverlap)/100);

%pravljenje pobude
k=0;%indeks poslednjeg impulsa
i=1;%brojac za odbirke prozora
for j= 1:length(f0)
    if(isnan(f0(j)))%proveravamo ako je NaN onda ubacujemo Gausov sum
        for br=i:(i+R) 
           s(br)=0.01*randn;
           k=0; 
        end;          
    else  %ako nije NaN ubacujemo impulse na rastojanju 1/f0 za taj prozor
        T0=1/(f0(j));%racunamo vremensko rastojanje izmedju impulsa
        %ako prelazimo sa bezvucnog na zvucni krecemo sa impulsima od prvog
        %sledeceg slobodnog,ako naredni impuls prelazi granice trenutnog
        %prozora,pamtimo indeks polozaja poslednjeg impulsa pa od tog
        %impulsa krecemo ako je sledeci segment bezvucan
        if(k==0) 
            %brojac uvecavamo za broj odbiraka koji odgovara 1/f0,gde je f0
            %odgovarajuca osnovna frekvencija trenutnog prozora
            for br=i:T0*fs:(i+R) 
                brr=round(br);
                if((br+T0*fs)>(i+R))
                    k=(i+R)- br;%pamtimo poslednji indeks polozaja
                    s(brr)=1;
                else
                    s(brr)=1;
                    k=0;
                end;
            end;
            
        else
            %ako nastavljamo sa zvucnog na zvucni,na osnovu poslednjeg
            %polozaja impulsa nastavljamo sa dodavanjem novih
            for br=(i-k+T0*fs):T0*fs:(i+R)
                brr=round(br);
                if((br+T0*fs)>(i+R))
                    
                    k=(i+R)- brr;
                    s(brr)=1;
                else
                    
                    s(brr)=1;
                    k=0;
                end;
            end;
            
        end;
        
    end;
    i=i+R;%povecavamo brojac za odgovarajuci broj odbiraka koji odgovara 
          %procentu preklapanja prozora
end;
%stampanje pobude


s_w=[];

k=0;

br_prozora=windowOOA; %broj prozora za overlap-and-add
for i= 1:R:length(x)-korak
    %prozorujemo ulazni signal pravougaonom funkcijom
    x_1=x(i:i+korak-1);
    %skaliramo hamingovim prozorom prethodno odabrane odbirke
    x_w=x_1.*hamming(length(x_1));
    %pozivamo funkciju LPC algoritma za izracunavanje LPC koeficijenata
    [A,G]=autolpc(x_w,20);
    %Overlap-and-add
    %uzimamo prozor pobude tako da je jednak duzini zahtevanog broja poluprozora
    %ako nemamo dovoljno odbiraka pobude da popunimo prozor,dopunimo ga
    %nulama do duzine zahtevanog broja poluprozora
    if((i+br_prozora*R)>length(s))
        s_prozor=s(i:length(s));
        nule=zeros(1,br_prozora*R-length(s_prozor));
        s_prozor=[s_prozor nule];
    else
        s_prozor=s(i:i+R*br_prozora-1);
    end;
    
    Gain=G/(sqrt(sum(s_prozor.^2))+0.01);
    %vrsimo filtriranje pomocu LPC koeficijenata
    s_w_filtrirano=filter(Gain,A,s_prozor);
    %pravljenje jos jedne promenljive zbog lakseg obelezavanja
    s_oaa=s_w_filtrirano;
    %ostatak predstavlja odbirke nasih prozora gde se odbirci svakog
    %poluprozora nalaze u zasebnoj vrsti,i na kraju dodajemo jos jednu
    %vrstu popunjenu nulama
    ostatak=zeros(br_prozora+1,R);
    for ii=1:br_prozora
        ostatak(ii,1:R)=s_oaa((ii-1)*R+1:ii*R);
    end;
    %inicijalizacija pomocnog niza,vrsi se samo jednom
    if(k==0) 
        pom=s_oaa(1:br_prozora*R-1);
        k=k+1;
    end;
    
    [pom,s_w_p]=overlap(ostatak,i,br_prozora,pom,R);
    s_w=[s_w s_w_p];
end;

s=s_w;

end
