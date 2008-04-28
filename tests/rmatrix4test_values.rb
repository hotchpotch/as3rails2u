#!/usr/bin/env ruby

require 'matrix'
require 'mathn'

m1 = Matrix[
 [1,2,3,4],
 [5,6,7,8],
 [9,10,11,12],
 [0,0,0,1]
]

m2 = Matrix[
 [2,-2,3,4],
 [-2,2,-5,7],
 [3,8,-4,9],
 [0,0,0,1]
]

p m1 * m2
p (m2 * m1).to_a.flatten
p m1.det
p m2.det
#p m1.inverse
p m2.inverse
