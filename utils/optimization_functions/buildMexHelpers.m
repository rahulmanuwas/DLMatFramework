%% Build mex bridge for 2d matrix multiplication

%% Im2col (By hand)
mex  CFLAGS="\$CFLAGS -std=c++11 -O2 -fopenmp" ...
    -Iutils/optimization_functions/include ...
    utils/optimization_functions/mexFunctions/mex_im2col.cpp ...    
    utils/optimization_functions/cpu/im2col.cpp ...
    -outdir work -output mex_im2col;


%% Im2col_back (By hand)
mex  CFLAGS="\$CFLAGS -std=c++11 -O2 -fopenmp" ...
    -Iutils/optimization_functions/include ...
    utils/optimization_functions/mexFunctions/mex_im2col_back.cpp ...    
    utils/optimization_functions/cpu/im2col_back.cpp ...
    -outdir work -output mex_im2col_back;
    
