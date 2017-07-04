% gillespie_vclamp.m
% runs the gillespie simultation for a two-state channel under voltage
% clamp
% 
function [output] = Markov_IKr_Cristiano(Nmax)

    global tend
        
    NV = [Nmax/100 Nmax/10 Nmax]; % number of channels
 
    figure1 = figure('Color',[0.992156863212585 0.917647063732147 0.796078443527222]);
           
    axes1 = axes('Parent',figure1,'FontWeight','bold','FontSize',12);    
       
    title('Condut?ncia do canal iCaL'); 
    
    xlabel('tempo em ms','FontWeight','bold','FontSize',12); 
    
    ylabel('Probalidade','FontWeight','bold','FontSize',12);
    
    box; grid;
    
    hold    
           
    for i = 1: length(NV)
        
    [t, g, iKr,v, M] = Markov_function(NV(i));
        
    output{i,1} = [t' g', iKr' v' M];
    
    subplot(4,2,7); box; xlim([1000 tend]); 
    
    stairs(t,v,'r','LineWidth',2); xlim([1000 tend]); grid
    
    title('Voltagem'); 
    
    xlabel('tempo em ms','FontWeight','bold','FontSize',12); 
    
    ylabel('mV','FontWeight','bold','FontSize',12); 
    
    subplot(4,2,2*i-1); box; xlim([1000 tend]); 
    
    title('Condut?ncia iKr'); 
    
    hold on
    
    grid on
    
    if i ==1
        
    stairs(t,g/NV(i),'r','LineWidth',1) % plot normalized, offset conductance  
    
    ylabel('Probabilidade','FontWeight','bold','FontSize',12);
    
    annotation(figure1,'textbox',...
    [0.438464667045741 0.884695290980087 0.0177853329542589 0.0406530794362729],...
    'String',{NV(i)},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FitBoxToText','off');

    hold on    
      
    elseif i == 2
        
    stairs(t,g/NV(i),'b','LineWidth',1) % plot normalized, offset conductance
    
    ylabel('Probabilidade','FontWeight','bold','FontSize',12);
    
    annotation(figure1,'textbox',...
    [0.436902167045741 0.663359298956158 0.0198686662875923 0.0406530794362729],...
    'String',{NV(i)},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FitBoxToText','off');
    
    else
        
    stairs(t,g/NV(i),'m','LineWidth',2) % plot normalized, offset conductance
    
    ylabel('Probabilidade','FontWeight','bold','FontSize',12);
    
    annotation(figure1,'textbox',...
    [0.433777167045741 0.442023306932229 0.0297644996209256 0.0406530794362729],...
    'String',{NV(i)},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FitBoxToText','off');
    
    end 
    
    xlim([1000 tend]);
    
    hold on 
    
    subplot(4,2,8); box; xlim([1000 tend]); 
    
    stairs(t,v,'r','LineWidth',2); xlim([1000 tend]); grid
    
    title('Voltagem'); 
    
    xlabel('tempo em ms','FontWeight','bold','FontSize',12); 
    
    ylabel('mV','FontWeight','bold','FontSize',12); 
    
    ylabel('mV','FontWeight','bold','FontSize',12); 
   
    subplot(4,2,2*i); grid; box
   
    title('Corrente iKr'); 
    
    hold on
    
    if i == 3
    
    stairs(t,iKr,'Color','m','LineWidth',2) % plot normalized, offset conductance 
    ylabel('uA/uF','FontWeight','bold','FontSize',12);
    
    elseif i == 2
        
    stairs(t,iKr,'Color',[0 1 0],'LineWidth',1) % plot normalized, offset conductance
    ylabel('uA/uF','FontWeight','bold','FontSize',12);
    
    else
        
    stairs(t,iKr,'Color',[0 0 1],'LineWidth',1) % plot normalized, offset conductance
    ylabel('uA/uF','FontWeight','bold','FontSize',12);
    
    end
    
    grid on
    
    xlim([1000 tend]);    
          
    end
        
        
    figure2 = figure('Color',[0.992156863212585 0.917647063732147 0.796078443527222]); 

    subplot1 = subplot(4,1,1,'Parent',figure2,'FontWeight','bold','FontSize',12);

    %box(subplot1,'on'); grid(subplot1,'on'); hold(subplot1,'on');

    plot(t,v,'r','LineWidth',3); grid on; box on; xlim([1000 tend]); ylabel('mV','FontWeight','bold','FontSize',12); title('Voltagem');%ylim([v_resting Ap]);

    subplot3 = subplot(4,1,3,'Parent',figure2,'FontWeight','bold','FontSize',12);
    
    plot(t, (M(:,1)+ M(:,2)+ M(:,3))/Nmax','LineWidth',2); hold on; grid on;
    plot(t, (M(:,4))/Nmax,'LineWidth',2); hold on
    plot(t, (M(:,5))/Nmax,'LineWidth',2); hold on
    ylabel('Probability');
    legend('C','I','O'); title('States Calcium Channel'); xlim([1000 tend]);
    ylabel('Probability','FontWeight','bold','FontSize',12);
    %xlabel('time (ms)','FontWeight','bold','FontSize',12)

    subplot2 = subplot(4,1,2,'Parent',figure2,'FontWeight','bold','FontSize',12);

    plot(t, M(:,1)/Nmax,'LineWidth',2); hold on; grid on; box on; xlim([1000 tend]); ylim([0 1]); ylabel('Probability','FontWeight','bold','FontSize',12); title('States Calcium Channel') 
    plot(t, M(:,2)/Nmax,'LineWidth',2); hold on; grid on; box on; xlim([1000 tend]); ylim([0 1]);
    plot(t, M(:,3)/Nmax,'LineWidth',2); hold on; grid on; box on; xlim([1000 tend]); ylim([0 1]);
    legend('C1','C2', 'C3');  title('States Calcium Channel') ;

    subplot4 = subplot(4,1,4,'Parent',figure2,'FontWeight','bold','FontSize',12); 
    
    plot(t,iKr,'k','LineWidth',2); grid on; box on; xlabel('time (ms)','FontWeight','bold','FontSize',12);xlim([1000 tend]);ylabel('Current in uA/uF','FontWeight','bold','FontSize',12); title('Current in uA/uF');

         
end % main function


function [tv,N_open, iKr, v, M] = Markov_function(N)

global tend

tend = 2000;

t_ap = 1200;

Ap = 15;

dt = 0.1;

w = 200;

f = 1;

Delay = 1000*1/f - w;
v_resting = -80;

%Par?metros Biof?sicos
R = 8314;                       % [J/kmol*K]  
Frdy = 96485;                   % [C/mol]  cy
Temp = 310;                     % [K]
FoRT = Frdy/R/Temp;

%Par?metros do canal IKr
Ko = 4;                       % Extracellular K   [mM]
Ki = 135;                     % Intracelular K   [mM]
ek = (1/FoRT)*log(Ko/Ki);	  % [mV]
GKr = 0.0186;                 %mS/uF

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tend  = 2000;

t = 0;  % initial time

i = 0;  % counter for vector of transition times

tv(1) = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Modelagem por Markov (M?todo de Monte Carlo)

n = 5; % Entre com o n?mero de estados do canal
 
nC1 = 0; nC2 = 0; nC3 = 0; nI = 0; nO = 0;

% Gera n?mero aleat?rio entre 0 e n para definir o estado de cada canal 

 for i = 1:N
     
    r = rand(1);
 
    e = round(r*(n-1)) + 1;
 
    if e == 1
     
     nC1 = nC1 + 1;
     
    elseif e == 2
     
     nC2 = nC2 + 1;
    
    elseif e == 3
     
     nC3 = nC3 + 1;
     
    elseif e == 4
     
     nI = nI + 1;
     
    else 
        
     nO = nO + 1;
        
    end
    
 end
 
INICIAL = [nC1 nC2 nC3 nI nO]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
    while (t<tend)
        
        i = i + 1;         
                             
        if t <= t_ap                                            %[ms]
    
        v(i) = v_resting;                                            %[mV]        

       elseif  (t > t_ap) && (t < t_ap + tend) && (mod(t + (1000 - t_ap),(w + Delay)))<= w    
    
        v(i) = Ap;               % trem de pulso retangular;
    
        else
    
        v(i) = v_resting;                                            %[mV]                
   
       end
        
            alfa0(i) = 0.0171*exp(0.0330*v(i));% ms^-1

            beta0(i) = 0.0397*exp(-0.0431*v(i));% ms^-1

            alfa1(i) = 0.0206*exp(0.0262*v(i));% ms^-1 

            beta1(i) = 0.0013*exp(-0.0269*v(i));% ms^-1 %

            alfai(i) = 0.1067*exp(0.0057*v(i));% ms^-1

            betai(i) = 0.0065*exp(-0.0454*v(i));% ms^-1

            alfai3(i) = 8.04e-5*exp(6.98e-7*v(i)); % ms^-1
            
            psi(i) = (beta1(i)*betai(i)*alfai3(i))/(alfa1(i)*alfai(i));
        
            kf = 0.0261; % ms^-1

            kb = 0.1483; % ms^-1          
           
 for j = 1:nO
            
        r = rand(1); 
        
        if r <= beta1(i)*dt
            
            nO = nO - 1;
            nC3 = nC3 + 1;
            
        elseif r > beta1(i)*dt && r <= (beta1(i) + alfai(i))*dt
            
            nO = nO - 1;
            nI = nI + 1;
            
        else 
            
            nO = nO;
            
        end
        
 end
 
 for j = 1: nC1
        
        r = rand(1); % gera n n?meros aleat?rios entre 0 e 1 para determinar a transi??o entre os estados.
        
        if r <= alfa0(i)*dt
            
            nC1 = nC1 - 1;
            nC2 = nC2 + 1;
            
        else
            
            nC1 = nC1;
                        
        end        
              
 end        
                  
 for j = 1:nC2
            
        r = rand(1); 
        
        if r <= beta0(i)*dt
            
            nC1 = nC1 + 1;
            nC2 = nC2 - 1;
            
        elseif r > beta0(i)*dt && r <= (beta0(i)+ kf)*dt
            
            nC3 = nC3 + 1;
            nC2 = nC2 - 1;
            
        else
            
            nC2 = nC2;
                        
        end
        
 end
              
 for j = 1:nC3
            
        r = rand(1);
        
        if r <= kb*dt
            
            nC3 = nC3 - 1;
            nC2 = nC2 + 1;
            
        elseif r > kb*dt && r <= (kb + alfa1(i))*dt
            
            nC3 = nC3 - 1;
            nO = nO + 1;
            
        elseif r > (kb + alfa1(i))*dt  && r <= (kb + alfa1(i) + alfai3(i))*dt
            
            nC3 = nC3 - 1;
            nI = nI + 1;
            
        else 
            
            nC3 = nC3;
            
        end
        
 end                 
                
 for j = 1:nI
            
        r = rand(1); 
        
        if r <= betai(i)*dt
            
            nI = nI - 1;
            nO = nO + 1;
            
        elseif r > betai(i)*dt  && r <= (betai(i) + psi(i))*dt
            
            nI = nI -1;
            nC3 = nC3 + 1;
            
        else
            
            nI = nI;
            
        end
        
  end  
         
        N_open(i)= nO;
        
        N_close_1(i) = nC1;
        
        N_close_2(i) = nC2;
        
        N_close_3(i) = nC3;
        
        N_inativo(i) = nI;
       
        t = t + dt;           
                 
        tv(i) = t; 
        
                      
    end % while loop    
  
M = [N_close_1' N_close_2' N_close_3' N_inativo' N_open']; % Matriz com a evolu??o dos estados de cada canal

%Corrente IKr

OKr = N_open./N;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
iKr = GKr*OKr.*(v - ek);%uA/uF

end
%MarkoLab - Vers?o 1 - RRS
%Estudo dos estados do canal de Pot?ssio IKr
%Fevereiro/2016
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



