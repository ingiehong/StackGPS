StackGPS v1.1 - Ingie Hong
==========================

For the rigid registration of 2D or 3D image stacks and visualization of the results.
Particularly useful when trying to keep a microscopic sample in identical 
orientation accross multiple days, as in in vivo two-photon imaging.
A reference image (either 2D or 3D z-stack) taken on first day will allow 
accurate registration of subsequent day images, and guide the movement/rotation
required for alignment of sample.


Installation:

	1. Install elastix (http://elastix.isi.uu.nl/)
		(set PATH or add line to elastix.m: comm = '"C:\Program Files\elastix_v4.7\elastix" ';)
	2. Install elastix wrapper (https://github.com/rcasero/gerardus)
		(add to ElastixToolbox and FileFormatToolbox to MATLAB path)
	3. Install findposition (add to MATLAB path)


App pseudocode:

	1. Open single-plane target image (2D or 3D Moving)
	2. Open reference Z-stack (2D or 3D Fixed)
	3. Run elastix (rigid registration mode) to either: 
        a.register 2D moving image on to each slice of the 2D or 3D fixed reference image.
        b.register 3D moving image to the 3D fixed reference image.
	4. Check validity of registration and visualize registration.
	5. Present parameters for adjustment of microscope/sample position.

Later features to work on:

	1. Automatic positioning for Scanimage/Prariescan
	2. Tilt adjustment (3D to 3D fitting) (done in v1.1)
	3. Multi-resolution image adaptation
	4. Plots for fit
    5. Automatic image header reading - for dimension/channel/XYZ spacing information etc.
    6. Option to use a subvolume of reference image.

Updates:

	v1.1
	-Added 3D-to-3D registration
	-Added save_tif.m for simple tif saving.
	-Fixed bug with Elastix parameter file location
	-Optimized Elastix parameters




	
	