# Data augmentations with python and keras
from json import load
from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Conv2D, MaxPooling2D
from keras.layers import Activation, Dropout, Flatten, Dense
from keras import backend as K
import numpy as np
import matplotlib.pyplot as plt

datagen = ImageDataGenerator(
    rotation_range=40,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,
    fill_mode='nearest')

img = load_img('data/train/cats/cat.0.jpg')
x = ima_to_array(img)
x = x.reshape((1,) + x.shape)

i = 0 
for batch in datagen.flow(x, batch_size=1, save_to_dir='data/augmented', save_prefix='cat', save_format='jpeg'):
    i += 1
    if i > 20:
        break


