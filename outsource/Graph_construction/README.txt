Classifier Based Graph Construction for Video Segmentation

Code written by Anna Khoreva, Fabio Galasso
Contact: Anna Khoreva, khoreva@mpi-inf.mpg.de

If using any part of this code, please cite:

Anna Khoreva, Fabio Galasso, Matthias Hein and Bernt Schiele.
Classifier Based Graph Construction for Video Segmentation.
In Proceedings of Computer Vision and Pattern Recognition (CVPR), June, (2015)

@inproceedings{khoreva15cvpr,
 title={Classifier Based Graph Construction for Video Segmentation},
 author={A. Khoreva and F. Galasso and M. Hein and B. Schiele},
 booktitle={Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition (CVPR)},
 year={2015}}

Please report bugs to khoreva@mpi-inf.mpg.de

The whole video segmentation pipeline is executed by running the function VSS.
The code provides an example video sequence (21 frames) extracted from vw_commercial of VSB100 [Galasso et al., ICCV'13].
The video sequence is processed by running:

   VSS('vw_commercial_21f','ucm2level','30','uselevelfrw', '1', 'ucm2levelfrw', '1', 'newmethodfrw', '1', 'stpcas', 'paperoptnrm');;

LICENSE

This program is released with a research only license.
The license is enclosed along with this program.
The license is not OSI approved nor GPL compatible.

We have made our best efforts to acknowledge the use, within our program, of third party programs.
Third party programs included in this program are distributed in compliance with the contributors' licenses.

