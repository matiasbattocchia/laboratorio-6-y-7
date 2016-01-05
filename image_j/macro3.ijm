run("AVI...", "select=[C:/Documents and Settings/Roman/Escritorio/Dropbox/facultad/l6/29ene2015/0002.avi] first=400 last=405");

setThreshold(90, 255);

run("Make Binary", "method=Default thresholded remaining black");
run("Clear Results");
run("Analyze Particles...", "size=40-60 circularity=0.50-1.00 display stack");
saveAs("Results", "C:/Documents and Settings/Roman/Escritorio/Dropbox/facultad/l6/29ene2015/0002a.csv");

run("Make Binary", "method=Default thresholded remaining black");
run("Clear Results");
run("Analyze Particles...", "size=1000-5000 circularity=0.50-1.00 include display stack");
saveAs("Results", "C:/Documents and Settings/Roman/Escritorio/Dropbox/facultad/l6/29ene2015/0002b.csv");
