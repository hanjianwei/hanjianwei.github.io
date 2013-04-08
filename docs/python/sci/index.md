---
title: Python Scientific Computing
layout: page
---

[Numpy][] cookbook.

## Data type

``` python
import numpy as np

# data type: bool, int[8|16|32|64], uint[8|16|32|64], float[16|32|64], complex[64|128]
x = np.float32(1.0)
y = np.int_([1,2,3]) # to avoid confliction with Python's type
z = np.array([1,2,3], dtype=np.float32)
# z = np.array([1,2,3], dtype='f')  # deprecated
z.dtype # => dtype('float64')
np.issubdtype(x.dtype, float) # => True
```

## Data creation

``` python
np.array([1,2,3,4]) # from list
np.array([[1,2], (1+2j, 3)]) # from list and tuple

np.zeros((2, 3)) # tuple dimension
np.ones([2, 3]) # list dimension
np.random.rand(2, 3)
np.arange(5) # => array([0, 1, 2, 3, 4])
np.arange(2, 5, dtype=np.float32) # array([ 2.,  3.,  4.], dtype=float32)
np.arange(2, 3, 0.2) # => array([ 2. ,  2.2,  2.4,  2.6,  2.8])
np.linspace(1., 4., 6) # => array([ 1. ,  1.6,  2.2,  2.8,  3.4,  4. ])

grid = np.indices((2,2)) # => array([[[0, 0] [1, 1]], [[0, 1],[0, 1]]])
grid[0] # x indices
grid[1] # y indices

# Matrix, their * and ** are override
m = np.matrix('1 2; 3 4') # Matlab like
m = np.matrix([[1, 2], [3, 4]], dtype = np.float64)
m.T # transpose
m.I # inverse
m.H # hermitian transpose
m.A # base array

```
## Indexing

``` python
x = np.arange(0, 20, 2)
x[2]   # => 4
x[-1]  # => 18

y = np.arange(0, 20, 2)
y.shape = (2,5) # y is 2-dimensional now
y[1,  3] # => 16
y[1, -1] # => 18
y[0] # => array([0, 2, 4, 6, 8])
y[0][2]     # <=> y[0, 2]

# slicing: view of data
x[2:5] # => array([4, 6, 8])
x[:-7] # => array([0, 2, 4])
x[1:7:2] # => array([2, 6, 10])
y[:, 1:5:2] # => array([[2, 6], [12, 16]])

# indexing array: copy of data
x[np.array([3, 3, -1])] # => array([6, 6, 18])
x[np.array([[1,3], [2, 4]])] # => array([[2, 6], [4, 4]])

# indexing multi-dimensional array: copy of data
y[np.array([0, 1, 1]), np.array([1, 3, 4])] # => array([2, 16, 18])
y[1, np.array([1, 3, 4])] # => array([12, 16, 18])
y[np.array([0, 1])] # => row 0, 1

# mask: copy of data
b = y > 10
y[b] # => array([12, 14, 16, 18])
b[:, 3] # => array([False,  True], dtype=bool)
y[b[:, 3]] # => array([[10, 12, 14, 16, 18]])

# Index array with slices: slice => index array
y[np.array([0, 1]), 1:3] # => array([[ 2,  4], [12, 14]])
y[b[:, 3], 1:3] # => array([[12, 14]])
```
## Shape

``` python
y = np.random.rand(5, 7)
y.shape # => (5, 7)
y[:, np.newaxis, :].shape # => (5, 1, 7)

x = np.arange(12).reshape(3, 4)
z = np.arange(81).reshape(3,3,3,3)
indices = (1,1,1,1)
z[indices] # => 40
# indices = [1, 1, 1, 1]
# z[indices] # lists are not converted to array
```

## Broadcasting

1. 在维度较低的shape前补1.
2. 输出数据的每个维度是所有输入数据中该维度的最大值.
3. 如果输入数据的每个维度都和输出维度相同或者是1, 则该数据可以参与计算.
4. 如果一个维度为1, 则该维度的第一个数据将被用与所有该维度上的计算.

## Book
* [Python科学计算](http://book.douban.com/subject/7175280/)
* [Programming Computer Vision with Python](http://book.douban.com/subject/10574101/)

## Document

* [Python Scientific Lecture Notes](http://scipy-lectures.github.com/)
* [Python for MATLAB Users](https://code.google.com/p/python-for-matlab-users/)
* [Performance Python](http://www.scipy.org/PerformancePython)
* [NumPy/SciPy Performance Tips](http://www.scipy.org/PerformanceTips)

## Notes

### NumPy

[numpy]: http://numpy.scipy.org
[scipy]: http://www.scipy.org
[sympy]: https://code.google.com/p/sympy
[matplotlib]: http://matplotlib.sourceforge.net
[chaco]: http://code.enthought.com/chaco
