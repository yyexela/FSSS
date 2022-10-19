# Files

`Extra/`: Contains a notebook to generate and visualize the harmonic edge, soliton edge, and wedge itself. See **Extra** below.
`FSSS/`: Contains the MATLAB code to run the FS-SS algorithm. See **FSSS** below.
`Image Preprocessing/`: Contains MATLAB code to align images. See **Pre-Processing Images** below.
`OpenPIV/`: Contains Python code to generate the displacement field for FS-SS. See **Displacement Field** below.
`Reports/`: Contains my Bi-Weekly reports.

# Requirements
* MATLAB (I used R2021a on both Linux and Windows)
* Make sure [pivmat](http://www.fast.u-psud.fr/pivmat/) is installed so that the `loadvec` function works directly from the MATLAB terminal.
* Also make sure that the `/FSSS` folder has the file `intgrad2.m` downloaded from the [MATLAB file exchange](https://www.mathworks.com/matlabcentral/fileexchange/9734-inverse-integrated-gradient?s_tid=srchtitle) or copied over from the private directory in [pivmat](http://www.fast.u-psud.fr/pivmat/)'s toolbox.
* We'll also be using [Jupyter](https://jupyter.org/) notebooks.

# Instructions

These instructions are for members of the Dispersive Hydrodynamics Lab to use the software I developed for reconstructing three dimensional models of gravity capillary waves through the Free-Surface Synthetic Schlieren method.

## Physical set-up
* This section requires you to be in the Dispersive Hydrodynamics Lab.
* Attach a dot pattern to the bottom of the water table where you will be imaging the surface waves (I used the dot pattern generated by `makebospattern(760000,0.28)` from `pivmat`, printed *without* fitting the pattern to the page).
* Then, make sure the camera is above the water table and the dot pattern fills most, if not all, of the imaged area (the application called `EOS Utility` will be helpful here, since it has a *live view* option showing what the camera sees in real time).
* Also make sure the camera's settings are set correctly, I normally used the following settings:
```
ISO: 4000
Shutter: 1/3200
Aperture: F5.6
Color/K: 3800
Resolution: Large
``` 
* Make sure the LED panel is mounted below the dot pattern and has the PVC pipes with microfiber cloths supporting the acrylic from below. The PVC's should be located near the center of the four sides of the dot pattern paper, but not too close where the PVC's shadow is on the pattern. This is to try to keep the acrylic from bending between images taken.
* Also, make sure that the closet rods with zip-ties are in the camera's field of view, as close to the water table's surface as possible without touching the water, and not obstructing the dot pattern. We want to use the zip-ties in our images for image registration later.

## Collecting Data
* This section requires you to be in the DHL.
* Take a [photo](https://drive.google.com/file/d/1osWzPG0wka1-RvSXWasxabIIJ9RdS4dJ/view?usp=sharing) of a ruler to be able to determine the pixels-per-mm of the image with your set-up.
* Don't leave the lab without the following quantities:
```
Pixels per mm
Camera-pattern distance
Acrylic thickness
Acrylic-pattern distance
Water depth
```
* Next, fill up the tank at the bottom of the water table a couple of inches above the pump inlet pipe, we want to make sure that when the pumps are running they are only drawing in water and not air (I usually do around 4 inches higher) (also, due to leaking you might need to re-fill the stock tank a bit).
* Now you need to decide how many pumps you want to run for your images and what the sluice gate height should be. I found one pump to be sufficient where the sluice gate height was one orange rubber.
* You also need to have a plan for when you'll take pictures, here's an example I used for [Experiment 12](https://drive.google.com/drive/folders/1MctLo6h8wRmsJgD5uGMNowbEexO-CRRa?usp=sharing):
```
use one pump (left one), let the reservoir (at the output of the pumps) fill up to max height, disconnect left pump and at the same time start camera timed photos (20 photos, one second apart, 0 second delay)
```
* To take 20 photos spaced one second apart I used a polaroid timer attached to the camera in the lab. You can also use the `EOS Utility` application to set up timing as well.
* Make sure to take images of the waves you are interested in (our *moving* images) along with images with no surface disturbances (our *still* images).
* Also make sure to record the surface height of the water for the still images, you may need to run the still image experiment twice, once for the images and another time for the surface height.

### Considerations
* Try to reduce vibrations for the camera as much as possible, since slight deviations between images will result in large errors in FSSS.
* If the wedge is in the moving image, outline the area of the wedge in the moving image, fill that area with pure red (#FF00000) and make sure that same area is also red in the still image.

## Pre-Processing Images
* It is impossible to have two images where there is no deviation between the two.
* So, we want to use [Image Registration](https://www.mathworks.com/help/images/ref/fitgeotrans.html) to re-align the images as best as possible.
* The file `/ImageProcessing/ProjectionDistortion.m` contains code to perform a fit for your still and moving images.
* First, crop the still and moving image so only the dot pattern is visible (a wedge can be on the dot pattern, that's OK).
* Then, in `ProjectionDistortion.m` read in a pair of still and moving images you are interested in aligning and select *fixed points* between the two images (this is why we have zip-ties in the image, since we don't expect them to differ in location between images).
* Close the window when you're done and the program will spit out your still and moving image, except they're aligned better.
* `/ImageProcessing/red_cyan.m` shows the two images overlayed, getting a better sense of how well the image registration worked. Similar code is run after you do the fit in `/ImageProcessing/ProjectionDistortion.m`.

### Considerations
* Make sure the directories you read and write from are what you expect.
* I had the still images as the reference image, so the moving image was fit to the still image.
* I couldn't think of a clever way to automate this, but it could probably be done! (QR codes instead of zip-ties maybe?).

## Displacement Field
* FSSS requires a displacement field, so we'll be using `OpenPIV/OpenPIV.ipynb` to get it from our aligned images.
* We're using an open-source PIV (Particle Image Velocimetry) library in Python to get the displacement field.
* In `OpenPIV/OpenPIV.ipynb` there are a lot of parameters which I recommend going through the [OpenPIV source code](https://github.com/OpenPIV/openpiv-python/tree/master/openpiv) (which is well-commented) to get a sense of what they do. Make sure, however, that `df_winsize` is set to a value where a square in the still or moving image whose side length is `df_winsize` will contain around 9 dots and that `pixels_per_mm` is the value obtained earlier by taking a picture of a ruler.
* Make sure you're reading the right pair of still and moving images, and run the entire notebook.
* You'll be asked to input a value for the signal to noise ratio cut-off, I used values around 0.9-1.2 (1.0 normally).
* The notebook will then spit out a displacement field file, normally `fsss.txt` which contains the displacement field.

### Considerations
* There's a lot going on in this file in terms of customizability, though I found the settings I normally used were sufficient 99% of the time
* There is a regular python file `OpenPIV/OpenPIV.py` which doesn't have a graphical interface, used for batch processing.

## FSSS 
* The main file we'll be using is `/FSSS/plotgeneral.m`.
* This file contains lots of parameters and settings as well, make sure you read through it all and understand what needs to be what. In particular, pay attention to the physical experiment parameters. The values `dd` to `y_max` just under `General plot properties` are overwritten when we import our own displacement field, which we will in this case.
* Make sure `plot_type` is `fsss_numeric`, since we have a displacment field we'll be importing.
* Make sure our displacement field is in the same directory as `plot_general.m` and change the variable `filenm` to the name of the file (without the extension `.txt`, so `fsss.txt` would mean `filenm = "fsss"`).
* If the image contains a wedge, change `raw_img` to the location of an aligned image, otherwise set it to an empty string. We use `raw_img` to get the location of the wedge (which should be red (#FF0000)) and set it's height to be the same in that area for our final reconstruction (to make the wedge more visible).
* Then, running this file should output a final surface reconstruction of the wave.

#### Considerations
* There are a lot of ways we can present the final surface reconstruction, see `/FSSS/plot3dnumeric.m` to modify it. There's code to use light and reflection as one option and a typical height gradient as another.

## Extra

* We'll be discussing `overlay.ipynb` in this section.
* The output is an image of data points I collected on the harmonic edge, soliton edge, and wedge itself with lines fitted to them. The notebook also records the angles of those lines to files.
* Please see [Experiment 12](https://drive.google.com/drive/folders/1MctLo6h8wRmsJgD5uGMNowbEexO-CRRa?usp=sharing) for the directory structure expected.
