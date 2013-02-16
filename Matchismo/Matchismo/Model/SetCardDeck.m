//
//  SetCardDeck.m
//  Matchismo&Set
//
//  Created by Robert Lummis on 2/10/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id) init {
    LOG
    self = [super init];
    
    if (self) {
        for (NSUInteger symbol = 0; symbol < 3; symbol++ ) {
            for (NSUInteger color = 0; color < 3; color++ ) {
                for (NSUInteger shading = 0; shading < 3; shading++ ) {
                    for (NSUInteger number = 0; number < 3; number++ ) {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.color = color;
                        card.shading = shading;
                        card.number = number;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
