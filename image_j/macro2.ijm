input = getDirectory("C:/Documents and Settings/Roman/Escritorio/Dropbox/facultad/l6/29ene2015");
output = input; //getDirectory("C:\Documents and Settings\Roman\Escritorio\Matías\29ene2015\test");
suffix = ".avi";

setBatchMode(true);
processFolder(input);

function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(list[i]))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
    run("AVI...", "select=[" + input + file + "]");
    
    setThreshold(90, 255);

    run("Make Binary", "method=Default thresholded remaining black");
    run("Clear Results");
    run("Analyze Particles...", "size=40-60 circularity=0.50-1.00 display stack");
    saveAs("Results", output + file + "-marca.csv");

    run("Make Binary", "method=Default thresholded remaining black");
    run("Clear Results");
    run("Analyze Particles...", "size=1000-2000 circularity=0.50-1.00 include display stack");
    saveAs("Results", output + file + "-duela.csv");
    
    //run("AVI...", "select=[" + input + file + "] first=1 last=300");
}
