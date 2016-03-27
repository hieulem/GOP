function install_mlsm
%
% Run this function to compile the associated c++ code
% 

fprintf(1, 'Compiling mex file for multilabel submodular optimization.\n');
fprintf(1, 'Please make sure your mex compiler is properly set up,\n');
fprintf(1, 'if not, please type \n>> mex -setup\nin matlab and select \n');
fprintf(1, 'visual studio compiler (for Windows machines), or gcc (for Linux machines).\n');

% compiling
try
    mex -O -largeArrayDims -DNDEBUG graph.cpp maxflow.cpp...
        MultiLabelSubModular_mex.cpp -output MultiLabelSubModular_mex
catch em
    fprintf(1, '\n\nFailed to compile!\n==>Please fix all errors before trying to use this code!<==\n\n');
    rethrow(em);
end

% path?
fprintf(1, '\nCompilation succeeded.\nYou may now use the code.\n');
fprintf(1, 'You might want to add\n%s\nto your Matlab''s path.\n\n', pwd());
