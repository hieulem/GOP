Video Segmentation with Superpixels

Code written and maintained by Fabio Galasso
Contact: Fabio Galasso, research@fabiogalasso.org

Date: 18 May 2013
Version: 1.1

If using any part of this code, please cite:

Fabio Galasso, Roberto Cipolla and Bernt Schiele.
Video Segmentation with Superpixels.
In Proceedings of Asian Conference on Computer Vision (ACCV), 2012.

@inproceedings {GalassoCipollaSchieleACCV12,
	author = {Fabio Galasso and Roberto Cipolla and Bernt Schiele},
	title = {Video Segmentation with Superpixels},
	booktitle = {Asian Conference on Computer Vision (ACCV)},
	year = {2012}
}

Please report bugs to galasso@mpi-inf.mpg.it



GETTING STARTED - First run

The whole video segmentation pipeline is executed by running the function VSS.
The code provides an example video sequence (20 frames, half resolution) extracted from Marple1 [Brox and Malik, ECCV'10].
The video sequence is processed by running:

    VSS('Marpleone_20ff');

Next, the results can be benchmarked with different benchmark metrics.
The first benchmark is the per-pixel global and average error rate:

    Setthepath();
    basedrive=['.',filesep]; %Directory where the VideoProcessingTemp dir is located
    basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep];
    filenames=Getfilenames(basename_variables_directory,[]);

    requestdelconf=true;
    additionalname='VS_perpixelerror_benchmark'; Computecm(filenames,additionalname,requestdelconf,'g');

The second is given by Boundary PR, SC, PRI and VI, extended from image to video segmentation

    Setthepath();
    basedrive=['.',filesep]; %Directory where the VideoProcessingTemp dir is located
    basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep];
    filenames=Getfilenames(basename_variables_directory,[]);

    nthresh=51;
    requestdelconf=true;
    additionalmasname='VS_benchmark'; Computerpimvid(filenames,nthresh,additionalmasname,requestdelconf,0,'r',false);

where "VS_benchmark" and "VS_perpixelerror_benchmark" are defined by the variables options.clustaddname and options.newsegname in VSS.
These correspond to two output directories in the folder "VideoProcessingTemp/Shared/Benchmark".



MORE DETAILS - Image segmentation benchmark

We propose in this work an extension of the hierarchical image segmentation algorithm by Arbelaez et al., TPAMI'11.
Our extension makes the image segmentation motion-aware and we denote it Motion-Aware Hierarchical Image Segmentation (MAHIS).
The MAHIS output is an intermediate result of the video segmentation process.
Corresponding images can be found in the directory "ucm2images" inside the video sequence directory.

The MAHIS output can be benchmarked by setting the specific boolean variable "testthesegmentation" to true in the VSS function:

    options.testthesegmentation=true; options.segaddname='MAHIS_benchmark'; %Hierarchical image segmentation benchmark (Boundary PR, SC, PRI, VI)

You should then re-run the main function (this will exit after processing MAHIS):

    VSS('Marpleone_20ff');

The image segmentation output for which a ground truth is available are copied into the directory "MAHIS_benchmark" as specified by the variable "options.segaddname" in VSS.
Next, the image segmentation output can be benchmarked as follows (Boundary PR, SC, PRI, VI):

    Setthepath();
    basedrive=['.',filesep]; %Directory where the VideoProcessingTemp dir is located
    basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep];
    filenames=Getfilenames(basename_variables_directory,[]);

    requestdelconf=true;
    nthresh=51;
    additionalmasname='MAHIS_benchmark'; Computerpimvid(filenames,nthresh,additionalmasname,requestdelconf,0,'r',false);



MORE DETAILS - Next runs

Executing the code on long video sequences is costly. Additionally many of the utilized sub-algorithms (Optical Flow, Image Segmentation) are also costly.
For this reason most partial output is saved into specific files and sub-folders in the video sequence folder.
When experimenting your own changes to this code, you may want to recompute part of this partial outputs.

To do this, you can either delete the partial outputs from the corresponding folders or (recommended) set the variable "options.cleanifexisting" in VSS.
Variable "options.cleanifexisting" will recompute partial outputs from a specified pipeline-step on, as explained in Doallprocessing.m

0 all outputs are deleted;
1 the video images are deleted (cim) and all following computation;
2 the optical flow estimations (flows) are deleted and all following computation;
3 the image segmentations (ucm2, providing therefore the superpixelization) are deleted and all following computation;
4 the filtered optical flows are deleted and all following computation;
5 the video segmentation outputs are deleted.

The variable is set to Inf by default, to store and load partial outputs at all stages.



SETUP OF NEW VIDEO SEQUENCES

The video sequence 'Marpleone_20ff' is setup as an example in the function VSS.

We analyze the relevant setup lines here in more detail.

The location of the video working directory:

    basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep];
    filenames=Getfilenames(basename_variables_directory,[],options);

The location and file pattern of the original video frames:

    filename_sequence_basename_frames_or_video.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep,'origimages',filesep,'marple1_'];
    filename_sequence_basename_frames_or_video.number_format='%03d';
    filename_sequence_basename_frames_or_video.closure='.jpg';
    filename_sequence_basename_frames_or_video.startNumber=1;

The location and file pattern of the ground truth annotations for the video:

    filename_sequence_basename_frames_or_video.gtbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep,'gtimages',filesep,'marple1_'];
    filename_sequence_basename_frames_or_video.gtnumber_format='%03d';
    filename_sequence_basename_frames_or_video.gtclosure='.pgm';
    filename_sequence_basename_frames_or_video.gtstartNumber=1;

The location and file pattern of the image segmentation outputs to generate for each video frame:

    ucm2filename.basename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep,'ucm2images',filesep,'ucm2image'];
    ucm2filename.number_format='%03d';
    ucm2filename.closure='_ucm2.bmp';
    ucm2filename.startNumber=0;

The location and file pattern of temporary working video frames:

    filename_sequence_basename_frames_or_video.wrpbasename=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep,'wrpimages',filesep,'marple1wrp_'];
    filename_sequence_basename_frames_or_video.wrpnumber_format='%03d';
    filename_sequence_basename_frames_or_video.wrpclosure='.png';
    filename_sequence_basename_frames_or_video.wrpstartNumber=1;

The video correction parameters, specifying whether the frames are to be de-interlaced, be processed at full resolution or resized, and whether the frames should be cropped:

    videocorrectionparameters.deinterlace=false;
    videocorrectionparameters.rszratio=0.5; %if 0 image is not resized
    videocorrectionparameters.croparea=[]; %[width,height,xjshift (+right),yishift (+down)] odd margins leave a pixel top-left

The number of frames to process from the video sequence

    noFrames=20;

The provided VSS function contains already the setup of the video sequences of BMDS [Brox and Malik, ECCV'10], as processed in the paper (namely up to 100 frames).
In order to repeat the experiments, the videos need to be downloaded and set up into folders, as indicated in VSS and shown with the "Marpleone_20ff" example.



ADDITIONAL UTILITIES

The computed video segmentations are saved in the benchmark sub-folder indicated by the variable "options.newsegname" (e.g. VS_benchmark/Ucm2 in the provided example case).
In the directory the files allsegs<video name>.mat contain the hierarchical video segmentation output as cell arrays (e.g. allsegsmarpleone_20ff.mat in the provided example case).
The video segmentations can be retrieved by loading those mat files, or by using the functions provided with this code.

In particular a single video segmentation output can be retrived by running the following:

    Setthepath();
    basedrive=['.',filesep]; %Directory where the VideoProcessingTemp dir is located
    basename_variables_directory=[basedrive,'VideoProcessingTemp',filesep,'Marpleone_20ff',filesep];
    filenames=Getfilenames(basename_variables_directory,[]);

    additionalmasname='VS_benchmark';
    videoname='marpleone_20ff';
    clustercase=2;
    asegmentation=Retrievevideosegmentations(filenames,additionalmasname,videoname,clustercase);

clustercase will refer to the number of clusters specified in input with the option "clustcompnumbers".
By default the computed number of clusters are [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,30,40,50,60,70,80,100,150,200,250,300,350,400,500,600].
Requesting "clustcompnumbers=2" will load the solution correponding to the 3rd specfied cluster number, i.e. 2.



FURTHER OPTIONS AND UTILITIES

The experiments in the paper are performed by specifying the use of different affinities:
- STT: Short-Term-Temporal affinity
- LTT: Long-Term-Temporal affinity
- STA: Spatio-Temporal-Appearance affinity
- STM: Spatio-Temporal-Motion affinity
- ABA: Across-Boundary-Appearance affinity
- ABM: Across-Boundary-Motion affinity

These experiments may be repeated by setting up the corresponding variable in VSS:

    options.requestedaffinities={'stt','ltt','aba','abm','stm','sta'};

When selecting sets of affinities, it must be taken care that the final affinity matrix fully connects all superpixels.
This is the case for the experiments reported in the paper, but it does not apply to specifying e.g. 'aba' alone.
By default, all affinities are used.

Another experimental option is "faffinityv", also to specify in VSS:

    options.faffinityv=10;

This restricts the number of considered frames just for the clustering algorithm (i.e. affinity computation + spectral clustering).
The optical flow and superpixelization is still computed for the whole sequence up to noFrames, as specified in the video setup.

Other options are available for experiments, as commented in the code.



FINAL COMMENTS

The code has been written and tested with Linux and Windows.
However some parts (MAHIS) and some of the utilized third party programs (long term trajectories) require Linux.
Since all processing stages are saved, it is possible to execute the code in windows after having pre-computed the long term tracks and the image segmentations.

The execution of the algorithm requires in general a large amount of memory.
Processing sequences of more than 50 frames and resolution larger than 320x240 may take some time.
The software has also been tested, however, with more than hundred frames and HD quality images.



LICENSE

This program is released with a research only license.
The license is enclosed along with this program.
The license is not OSI approved nor GPL compatible.

We have made our best efforts to acknowledge the use, within our program, of third party programs.
Third party programs included in this program are distributed in compliance with the contributors' licenses.

