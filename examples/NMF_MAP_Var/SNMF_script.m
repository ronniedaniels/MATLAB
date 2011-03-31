clear
savethis = 1;
ncomp = [3 4 5 6];
niter=1; %number of evaluation of each dataset

for ncompindex = 1:length(ncomp);
    for iterindex=1:niter
        ca;
        data_core = ['D3ptBMrand_N3_offset50_delta10'];
        if savethis
            [peval.logfile, peval.fid] = initlogfile;
        end
        
        paramsNMF %reads the parameters        
        datasource = [peval.home '/' peval.data_path '/' peval.data_dir '/' peval.data_file];
        
        readdata
        
        % Estimating / subtracting background:
        %         [dpixc, peval]=backgroundestimation(dpixc, peval, p.offset);
        
        peval.bg=p.offset;
        %         dpixc=bgsubtractbyhand(dpixc,peval);
        peval.ncomp=ncomp(ncompindex);
        
        % Initialization of W:
        %             winit = init_wmap('rand',peval,double(array2im(dpixc_ind)));
        winit = init_w_general(peval.init_w_method,peval,sum(dpixc,3));
        hinit = init_h_general(peval.init_h_method,peval,[]);
               
        dvec=reshape(dpixc,peval.nx*peval.ny,peval.nt);
        
        % Main computation:
        [res, peval]=peval.fun(peval, dvec,winit, hinit);
        
        if savethis
            peval = createresname(peval,iterindex);
            saveresults(res, peval, p, [peval.res_path peval.res_dir '/' peval.res_name])
            fclose(peval.fid(2));
        end
    end
    if savethis
        % Saving parametes and logfile into the directory with resuls
        saveparameters(peval,p)
    end
end
% plottingmulti
% plotscattehvsblinkmat
