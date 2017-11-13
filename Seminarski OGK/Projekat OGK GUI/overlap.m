function [y,signal]=overlap(windows,i,n,s,R)
%     windows-sadrzi po R odbiraka u n+1 vrsti,filtrirane vrednosti
%     i-redni broj iteracije
%     n-broj preklapajucih prozora za overlap
%     s-signal sa prethodno sabranim vrednostima preklapanja
%     R-broj odbiraka prozora
%     y-ovaj signal cemo poslati rekurzivno kao signal s
%     signal-odbirci krajnjeg signala koje pakujemo u konacni signal
    if(i==1) 
        y=[];
        for ii=1:n
            y=[y windows(ii,1:R)]; 
        end;
        y=[y zeros(1,R)]; %dopunjujemo nulama zbog preklapanja u narednim iteracijama
        signal=windows(1,1:R);
    else
        %trenutne odbirke prozora sabiramo sa prethodnim odbircima pocevsi
        %od drugog poluprozora
        y=[];
        for ii=1:n
            windows(ii,1:R)=windows(ii,1:R)+s(ii*R+1:(ii+1)*R);               
        end;
        for ii=1:n
            y=[y windows(ii,1:R)];
        end;
        y=[y zeros(1,R)];
        signal=windows(1,1:R);
    end;
end