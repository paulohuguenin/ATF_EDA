%[sigEda,Fs]=audioread('eda1.wav');
cont=0;
for kSignal=[1,2,5,6,7]
    
    cont=cont+1;
[sigEda,Fs]=audioread(['eda' num2str(kSignal) '.wav']);
for iSig=1:7
sigSeg(iSig,:)=sigEda((iSig-1)*2592+1:iSig*2592);

L = 512;
noverlap = 256;
[pxx,f,pxxc] = pwelch(sigEda,hamming(L),noverlap,200,Fs,'ConfidenceLevel',0.95);
[pseg,fseg,pc] = pwelch(sigSeg(iSig,:),hamming(L/2),noverlap/2,200/2,Fs,'ConfidenceLevel',0.95);

mf(cont)=meanfreq(pxx,f);
mfseg(cont,iSig)=meanfreq(pseg,fseg);
%figure,
%xlim([0 1]);
%plot(f,10*log10(pxx))
%xlim([0 1]);
%hold on
%plot(f,10*log10(pxxc),'-.')
%hold off



%xlabel('Frequência (Hz)')
%ylabel('PSD (dB/Hz)')
%title('Espectro de Frequência EDA')

ifq = instfreq(sigEda,Fs);

totEnergy=sum(pseg);
cump=0;
for i=1:length(fseg)
    cump=cump+pseg(i);
    if cump>totEnergy*0.95
        break
    end
end
Fmax(cont,iSig)=fseg(i);
%xline(mf(cont),'--r',{'Freq.Média'});
%xline(Fmax(cont),'--r',{'Fmáx'});
%legend('Fmax','Freq. Média');
%hold off

if cont==3
    
    subplot(7,1,iSig);
    plot(fseg,10*log10(pseg));
    hold on
    xlim([0 1]);
    xline(mfseg(cont,iSig),'--r',{'Freq','Média'});
    xline(Fmax(cont,iSig),'--r',{'Fmáx'});
    legend('PSD',['Freq. Média - Segmento' num2str(iSig)],['Fmáx - Segmento' num2str(iSig)]);
    hold off
%{
    if iSig==7
    xlabel('Frequência (Hz)')
    end
    ylabel('PSD (dB/Hz)')
    if iSig==1
    title('Espectro de Frequência EDA')
    end
%}

end
end
end
