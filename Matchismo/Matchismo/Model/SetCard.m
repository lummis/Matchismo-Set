//
//  SetCard.m
//  Matchismo&Set
//
//  Created by Robert Lummis on 2/10/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

#define NVALUES 3

- (void) setSymbol:(NSUInteger)symbol { //0..2
    if ( symbol < NVALUES ) {
        _symbol = symbol;
    }
}

- (void) setColor:(NSUInteger)color {   //0..2
    if ( color < NVALUES ) {
        _color = color;
    }
}

- (void) setShading:(NSUInteger)shading {   //0..2
    if ( shading < NVALUES ) {
        _shading = shading;
    }
}

- (void) setNumber:(NSUInteger)number { //0..2
    if ( number < NVALUES ) {
        _number = number;
    }
}

@end
