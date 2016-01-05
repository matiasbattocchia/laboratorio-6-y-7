setBatchMode(true);
run("AVI...", "select=[C:\\Documents and Settings\\Roman\\Escritorio\\Dropbox\\facultad\\l6\\aluminio.avi] first=1 last=300");

setAutoThreshold("Default");


run("Analyze Particles...", "size=100-500 circularity=0.50-1.00 include stack");
saveAs("Results", "C:\\Documents and Settings\\Roman\\Escritorio\\Dropbox\\facultad\\l6\\Results.csv");
