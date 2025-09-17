// Define directories for images and ROIs
dir = getDirectory("Choose the directory containing images and rois");

// Specify file extensions for images and ROIs
imageExt = ".tif";  // Adjust as needed
roiExt = "_rois.zip";   // Adjust as needed

// Set desired measurements
run("Set Measurements...", "area mean standard min integrated display redirect=None decimal=3");

// Process all files in the directory
list = getFileList(dir);

// Process each image and corresponding ROI file
for (i = 0; i < list.length; i++) {
	  filename = list[i];
	  if (endsWith(filename, imageExt)) {
	  	// Open the image
	  	open(dir + filename);
	  	nChannels = nSlices;
	  	// Open the corresponding ROI file
	  	roiFilename = replace(filename, imageExt, roiExt);
	  	open(dir + roiFilename);
	  	// Measure intensities on each channel for each ROI
	  	for (c = 1; c <= nChannels; c++) {
	  		selectWindow(filename);
	  		setSlice(c);
	  		roiManager("Measure");
	  		}
	  	// the following are for measuring the background level
	  	// merge all ROIs and reverse selection
	  	roiManager("Deselect");
		roiManager("Combine");
		roiManager("Add");
		length = roiManager("count");
		roiManager("Select", length-1);
		run("Make Inverse");
	  	// Measure background intensities on each channel
	  	for (c = 1; c <= nChannels; c++) {
	  		selectWindow(filename);
	  		setSlice(c);
	  		run("Measure");
	  		}
	  	// Close image and reset ROI manager
	  	close();
	  	roiManager("reset");
	  	}
}
