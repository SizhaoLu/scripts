Dialog.create("RGB/RGCB Batch Merge");
Dialog.addMessage("Select the number of available channels:");
Dialog.addChoice("Number of Channels", newArray("2", "3", "4"));
Dialog.show();
numChannels = Dialog.getChoice();

Dialog.create("Channel Suffixes");
if (numChannels == "2") {
    Dialog.addString("Blue Suffix", "_CH1");
    Dialog.addString("Red Suffix:", "_CH2");
} else if (numChannels == "3") {
    Dialog.addString("Red Suffix:", "_CH2");
    Dialog.addString("Green Suffix:", "_CH3");
    Dialog.addString("Blue Suffix:", "_CH1");
} else {
    Dialog.addString("Red Suffix:", "_CH2");
    Dialog.addString("Green Suffix:", "_CH3");
    Dialog.addString("Blue Suffix:", "_CH1");
    Dialog.addString("Cyan Suffix:", "_CH4");
}
Dialog.addCheckbox("Open as Stack", true);
Dialog.show();

if (numChannels == "2") {
    blueSuffix = Dialog.getString() + ".";
    redSuffix = Dialog.getString() + ".";
} else {
    greenSuffix = Dialog.getString() + ".";
    if (numChannels == "4")
        cyanSuffix = Dialog.getString() + ".";
    else
        cyanSuffix = "";
}
openAsStack = Dialog.getCheckbox();

if (openAsStack)
    openImagesAsStack();
else
    batchConvert();

exit;

function openImagesAsStack() {
    dir1 = getDirectory("Choose Source Directory ");
    dir2 = getDirectory("Choose Destination Directory ");
    list1 = getFileList(dir1);
    list = Array.sort(list1);
    setBatchMode(true);
    n = list.length;
    if (numChannels == "2" && (n % 2) != 0)
        exit("The number of files must be a multiple of 2");
    else if (numChannels == "3" && (n % 3) != 0)
        exit("The number of files must be a multiple of 3");
    else if (numChannels == "4" && (n % 4) != 0)
        exit("The number of files must be a multiple of 4");
    stack = 0;
    first = 0;
    for (i = 0; i < n / (numChannels == "2" ? 2 : numChannels == "3" ? 3 : 4); i++) {
        showProgress(i + 1, n / (numChannels == "2" ? 2 : numChannels == "3" ? 3 : 4));
        ch1 = "?";
        ch2 = "?";
        red = "?";
        green = "?";
        blue = "?";
        cyan = "?";
        for (j = first; j < first + (numChannels == "2" ? 2 : numChannels == "3" ? 3 : 4); j++) {
            if (numChannels == "2") {
                if (indexOf(list[j], ch1Suffix) != -1)
                    ch1 = list[j];
                if (indexOf(list[j], ch2Suffix) != -1)
                    ch2 = list[j];
            } else {
                if (indexOf(list[j], redSuffix) != -1)
                    red = list[j];
                if (indexOf(list[j], greenSuffix) != -1)
                    green = list[j];
                if (indexOf(list[j], blueSuffix) != -1)
                    blue = list[j];
                if (numChannels == "4" && indexOf(list[j], cyanSuffix) != -1)
                    cyan = list[j];
            }
        }
        if (numChannels == "2") {
            open(dir1 + ch1);
            run("16-bit");
            run("Grays");
            open(dir1 + ch2);
            run("16-bit");
            run("Grays");
            run("Merge Channels...", "c1=[" + ch1 + "] c2=[" + ch2 + "] create");
        } else if (numChannels == "3") {
            open(dir1 + red);
            run("16-bit");
            run("Red");
            open(dir1 + green);
            run("16-bit");
            run("Green");
            open(dir1 + blue);
            run("16-bit");
            run("Blue");
            run("Merge Channels...", "c1=[" + red + "] c2=[" + green + "] c3=[" + blue + "] create");
        } else {
            open(dir1 + red);
            run("16-bit");
            run("Red");
            open(dir1 + green);
            run("16-bit");
            run("Green");
            open(dir1 + blue);
            run("16-bit");
            run("Blue");
            open(dir1 + cyan);
            run("16-bit");
            run("Merge Channels...", "c1=[" + red + "] c2=[" + green + "] c3=[" + blue + "] c4=[" + cyan + "] create");
        }
        index = indexOf(ch1, ch1Suffix);
        if (index == -1)
            index = indexOf(red, redSuffix);
        name = substring(ch1, 0, index);
        saveAs("Tiff", dir2 + name);
        first += (numChannels == "2" ? 2 : numChannels == "3" ? 3 : 4);
    }
}