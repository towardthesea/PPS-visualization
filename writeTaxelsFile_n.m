function [out]= writeTaxelsFile_n(file2Write, name, size, nTaxels, taxels)

%     pos = [400 320 240 100 80 60 50 40 30 20 10 8 6 5 4 3 2 1 1 1]
    neg = 100*ones(1,20);
    P   = [0.7 0.99 0.16:-0.01:0.01 0.005 0.001]
    
%     neg = zeros(1,20);
    pos = zeros(1,20);
    for i=1:20
        pos(i) = perfectTaxel_n(neg(i),P(i));
        if (rem(pos(i)*10,10)>=5)
            pos(i) = ceil(pos(i));
        else
            pos(i) = floor(pos(i));
        end
        %sprintf('%3.0',neg(i))
    end

    POS = sprintf('%d ',pos)
    NEG = sprintf('%d ',neg)                                
    
    fid = fopen(file2Write,'w');

    fprintf(fid,'[%s]\n',name);
    fprintf(fid,'modality\t1D\n');
    fprintf(fid,'size    \t%d\n',size);
    fprintf(fid,'nTaxels \t%d\n',nTaxels);
    fprintf(fid,'ext     \t(-0.05 0.45)\n');
    fprintf(fid,'binsNum \t(20 1)\n');
    
    fprintf(fid,'Mapping (');
    for i=1:length(taxels)
        for j=1:12
           fprintf(fid,'%d ',taxels(i));
        end
    end
    fprintf(fid,')\n');
    
    for j=1:length(taxels)
        taxel_string = sprintf('%s (%s) (%s)',num2str(taxels(j)),POS,NEG)
        fprintf(fid,'%d (',taxels(j));
        for k = 1:length(pos)-1
            fprintf(fid,'%d ',pos(k));
        end
        fprintf(fid,'%d)(',pos(k+1));
        for k = 1:length(neg)-1
            fprintf(fid,'%d ',neg(k));
        end
        fprintf(fid,'%d)\n',neg(k+1));
    end
    fclose(fid); 
end