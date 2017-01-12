function [out]= writeTaxelsFile(file2Write, name, size, nTaxels, taxels)

    pos = [400 320 240 100 80 60 50 40 30 20 10 8 6 5 4 3 2 1 1 1]
    P   = [0.5 1 0.16:-0.01:0.01 0.005 0.001]

    neg = zeros(1,20);
    for i=1:20
        neg(i) = perfectTaxel(pos(i),P(i));
        if (rem(neg(i)*10,10)>=5)
            neg(i) = ceil(neg(i));
        else
            neg(i) = floor(neg(i));
        end
        %sprintf('%3.0',neg(i))
    end

    POS = sprintf('%d ',pos)
    NEG = sprintf('%d ',neg)                                
    
    fid = fopen(file2Write,'w');

    fprintf(fid,'[%s]\n',name);
    fprintf(fid,'modality\t1D\n');
    fprintf(fid,'size\t\t%d\n',size);
    fprintf(fid,'nTaxels\t\t%d\n',nTaxels);
    fprintf(fid,'ext\t\t\t(-0.05 0.45)\n');
    fprintf(fid,'binsNum\t\t(20 1)\n');
    
    fprintf(fid,'Mapping (');
    for i=1:length(taxels)
        for j=1:12
           fprintf(fid,'%d ',taxels(i));
        end
    end
    fprintf(fid,')\n');
    
    for j=1:length(taxels)
        taxel_string = sprintf('%s (%s)(%s)',num2str(taxels(j)),POS,NEG)
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