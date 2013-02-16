//
//  SetMatchingGame.m
//  Matchismo&Set
//
//  Created by Robert Lummis on 2/14/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "SetMatchingGame.h"
#import "SetCard.h"

@implementation SetMatchingGame

#define FLIP_POINTS -2
#define MATCH_POINTS 24
#define MISMATCH_POINTS -12

    //this is here to provide a place to set a value for mode
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super initWithCardCount:count usingDeck:deck];
    self.mode = 3;
    return self;
}

-(void) flipCardAtIndex:(NSUInteger)index {
    [super flipCardAtIndex:index];
    if (self.moveResultCode == noFlipCode) {    //already have 3 up
        self.scoreThisMove = 0;
        return;
    }
    SetCard *c = self.cards[index];
    if (c.faceUp) {     //penalty only for selecting, not for deselecting
        self.scoreThisMove = FLIP_POINTS;
        self.score += self.scoreThisMove;
    }
    if ( [self.upCards count] == self.mode ) {
        [self evaluateCards:self.upCards];
    }
}

    //handle the 3 cards that are turned up
- (void)evaluateCards:(NSArray *)upCards {
    if ( [upCards count] != 3 ) {
        NSLog(@"error: evaluateCards received %d cards", [upCards count]);
        return;
    }   //this should never happen
    
    if ( [self matchBySymbol:upCards] && [self matchByColor:upCards]
        && [self matchByShading:upCards] && [self matchByNumber:upCards] ) {
        self.moveResultCode = matchCode;
        self.scoreThisMove = MATCH_POINTS;
        for (SetCard *card in upCards) {
            card.unplayable = YES;  //disable cards that were matched
        }
    } else {
        self.moveResultCode = mismatchCode;
        self.scoreThisMove = MISMATCH_POINTS;
    }
    self.score += self.scoreThisMove;
}

- (BOOL) setCardsMatchOne:(int)valueOne two:(int)valueTwo three:(int)valueThree {
    int sum = valueOne + valueTwo + valueThree;
    switch (sum) {  //iff the sum is 3, 6, or 9 they are all different or all the same 
        case 0:
        case 3:
        case 6:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL) matchBySymbol:(NSArray *)cards {
    SetCard *c1 = cards[0];
    SetCard *c2 = cards[1];
    SetCard *c3 = cards[2];
    return [self setCardsMatchOne:c1.symbol two:c2.symbol three:c3.symbol];
}

- (BOOL) matchByNumber:(NSArray *)cards {
    SetCard *c1 = cards[0];
    SetCard *c2 = cards[1];
    SetCard *c3 = cards[2];
    return [self setCardsMatchOne:c1.number two:c2.number three:c3.number];
}

- (BOOL) matchByColor:(NSArray *)cards {
    SetCard *c1 = cards[0];
    SetCard *c2 = cards[1];
    SetCard *c3 = cards[2];
    return [self setCardsMatchOne:c1.color two:c2.color three:c3.color];
}

- (BOOL) matchByShading:(NSArray *)cards {
    SetCard *c1 = cards[0];
    SetCard *c2 = cards[1];
    SetCard *c3 = cards[2];
    return [self setCardsMatchOne:c1.shading two:c2.shading three:c3.shading];
}

@end
