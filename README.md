# PDI
The polydispersity index (PDI) is a factor that expresses the polydispersity of a sample, based on the measurement of the size of the particles it is comprised of. Here a fast way to measure the PDI implemented in Matlab is proposed.

# Implementation
The image is scanned in a raster way and divided into small patches (i.e. areas of pixels) partially overlapping. Then, the mean intensity value of these patches is subtracted from the intensity of the patches, in order to compensate the uneven illumination of the image.
Furthermore, the image is filter by using a Gaussian filter 2 pixels wide, in order to significantly reduce the amount of misleading information on the image, in such a way to make the particles identification more robust. 
In order to simplify the particle identification step, the sharp variations of brightness in the image (i.e. edges) are computed, creating a mask with only the profiles of the imaged elements. The edges are computed by applying the Canny method.  At this point, the circular elements in the image are identified, saving only the elements with the two main dimensions differing at most by the 20% of their value. 

Once all the particles are identified in the image, their diameter is computed as the mean value of their two main dimensions. Finally, the mean values of all the diameters (d) and the standard deviation are computed in order to calculate the PDI.

  
## How to cite:
```
@InProceedings{Marchello_pdi,  
  author = {Marchello, Gabriele},  
  title = {Polydispersity index measurement},  
  year = {2020},  
  publisher = {GitHub},  
  journal = {GitHub repository},  
  howpublished = {\url{https://github.com/GabrieleMarchello/PDI}}  
}
