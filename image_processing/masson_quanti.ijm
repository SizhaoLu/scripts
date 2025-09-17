   // select the green channel, which has the best contrast
   run("RGB Stack");
   setSlice(1);
   // set threshold
   setAutoThreshold();
   getThreshold(min, max)
   setThreshold(0, max/163*224);
   // measure area and area fraction
   // run("Set Measurements...", "area area_fraction limit display redirect=None decimal=3");
   run("Measure");
   selectWindow("Results"); 