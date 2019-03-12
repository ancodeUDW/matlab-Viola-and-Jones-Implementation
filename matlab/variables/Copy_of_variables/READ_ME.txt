all_haar_like_types
##################################################

It is a variable with all the haar like variations we will deal with. in general is a matrix of 
58140 files and 5 columns. Each file have the data of one classifier, and the colums are
organized as follows:

1: position x
2: position y
3: height
4: width
5: type of haar like feature (between 1, 2 and 3)

position x and y are the start position of the haar-like in the image, while the heigh and 
width are the dimension of one of the rectangles. Type is the type of haar-like feature 
between the 1, 2 and 3 that we can use:

                   [   ]
                   [#]    [   ][#]    [  ][#][  ]
                 type 1   type 2      type 3
 
The start position is always the most top-left part of the image.

##################################################