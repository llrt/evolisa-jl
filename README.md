# evolisa-jl

Julia version of Roger Alsing's fascinating [Evolisa](https://rogerjohansson.blog/2008/12/07/genetic-programming-evolution-of-mona-lisa/), created for fun and lang learning

## Main Idea

The main script (_main.jl_) receives a img file path (currently hardcoded), loads the given image and tries to approximate it with a random set of colored polygons. 

## How it works

The random set is iteratively evolved in a Genetic Programming fashion, introducing minor adjustments and checking for better similarity with original image - if similarity is better than the previous one, this generation is kept; if not is discarded.

The GP algorithm is configured through parameters in _setting.jl_

## Examples

This repo provides a Mona Lisa original picture and two example approximations.


## Dependencies

- Images.jl, FileIO.jl, for image loading and manipulation
- Luxor.jl, excellent Cairo based library for picture drawing with geometric primitives (lines, circles, polygons, etc)
