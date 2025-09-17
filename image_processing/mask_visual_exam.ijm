// Define directories for images and ROIs
dir = getDirectory("Choose the directory containing images and rois");

// Specify file extensions for images and ROIs
imageExt = ".tif"; 
roiExtGreenInput = "_rois_green.zip"; //input green roi
roiExtRedInput = "_rois_red.zip"; //input red roi
roiExtGreenOutput = "_rois_green_true.zip"; //output green roi
roiExtRedOutput = "_rois_red_true.zip"; //output red roi

// Set desired measurements
run("Set Measurements...", "area mean standard min integrated display redirect=None decimal=3");

// Process all files in the directory
list = getFileList(dir);

// Process each image and corresponding ROI file
for (i = 0; i < list.length; i++) {
	  filename = list[i];
	  if (endsWith(filename, imageExt)) {
	  	baseName = File.getNameWithoutExtension(filename);
	  	// Open the image
	  	open(dir + filename);
	  	if (File.exists(dir + baseName + roiExtGreenOutput)) {
	  		showMessage("The green ROI has been processed already!");
	  		}
  		else {
  			// Open the corresponding green ROI file
  			open(dir + baseName + roiExtGreenInput);
		  	// Wait for user to modify ROIs
			waitForUser("Modify GREEN ROIs as needed, then click OK");
		  	roiManager("Save", dir + baseName + roiExtGreenOutput);
			roiManager("reset");}
	  	if (File.exists(dir + baseName + roiExtRedOutput)) {
	  		showMessage("The red ROI has been processed already!");
	  		}
  		else {
  			// Open the corresponding red ROI file
		  	open(dir + baseName + roiExtRedInput);
		  	// Wait for user to modify ROIs
			waitForUser("Modify RED ROIs as needed, then click OK");
		  	roiManager("Save", dir + baseName + roiExtRedOutput);
		  	roiManager("reset");}
	  	close();
	  }
}
