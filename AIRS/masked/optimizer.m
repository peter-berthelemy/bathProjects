
strans = struct('k', ST12.k, 'l', ST12.l);
true = 
results = struct('sum', zeros(10^4, 1), 'size', zeros(10^4, 1), 'blur', zeros(10^4, 1), 'wavelength', zeros(10^4, 1), 'ratio', zeros(10^4, 1));
for sumCutoff = 1:10
    sumCutoff
    for sizeCutoff = 1:10
        for blurCutoff = 1:10
            for wavelengthCutoff = 1:10

                mask = thirdMask(strans, sumCutoff, sizeCutoff, blurCutoff, wavelengthCutoff, {'k', 'l'}, [5, 5, 1], 2);
                results.sum = sumCutoff;
                results.size = sizeCutoff;
                results.blur= blurCutoff;
                results.wavelength = wavelengthCutoff;
                results.ratio = nnz(mask)/nnz(true);
            end
        end
    end
end

