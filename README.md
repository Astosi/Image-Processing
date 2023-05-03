# Card Recognition

This repository contains a playing card recognition program using image processing techniques. The program detects playing cards in an input image and identifies the rank and suit of each card.
Dependencies

To run this program, you'll need the following libraries:

    MATLAB Image Processing Toolbox

Ensure that you have MATLAB installed and the Image Processing Toolbox is available. You can check by running ver in the MATLAB Command Window.
Usage

    Download or clone the repository.
    Open MATLAB and navigate to the repository folder.
    Open the playing_card_recognizer.m script in the MATLAB editor.
    Modify the following line of code to specify the input image you want to process:

```matlab
    im = imread('images/10clubs.jpg');
```

    Replace 'images/10clubs.jpg' with the path to your input image.
    Run the script by pressing the "Run" button or pressing F5.

The program will display the input image with bounding boxes around detected cards, as well as the rank and suit of each card.
Overview of the code

The playing_card_recognizer.m script performs the following steps:

    Preprocess the input image by resizing and thresholding.
    Extract card regions using connected components analysis.
    For each card region, rotate and crop the image to isolate the card.
    Perform template matching using suit and rank templates to identify the card.
    Display the input image with detected cards and their identities.

The preprocessTemplate function is used to prepare the suit and rank templates for template matching.
Customization

You can customize the program by modifying the templates in the Templates folder. To add new card designs, create new templates for the suits and ranks, and update the suits and ranks cell arrays in the playing_card_recognizer.m script accordingly.
