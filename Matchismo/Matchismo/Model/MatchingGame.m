//
//  MatchingGame.m
//  Matchismo&Set
//
//  Created by Robert Lummis on 2/14/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "MatchingGame.h"

@implementation MatchingGame

- (NSMutableArray *)cards {
    if (!!!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    if ( (self = [super init] ) ) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!!!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return index < [self.cards count] ? self.cards[index] : nil;
}

- (NSMutableArray *)upCards {
    if (!!!_upCards) {
        _upCards = [[NSMutableArray alloc] init];
    }
    return _upCards;
}

- (void)flipCardAtIndex:(NSUInteger)index { //only get here if card is NOT unplayable
    self.upCards = nil;
    Card *card = [self cardAtIndex:index];
    if (card.isFaceUp) {
        card.faceUp = NO;
        self.moveResultCode = flipDownCode;
        return;
    }
    
        //if we get here the card is NOT unplayable and is face down
        //get array of cards that are already up
    for (Card *aCard in self.cards) {
        if (aCard.isFaceUp && !!!aCard.isUnplayable) {
            [self.upCards addObject:aCard];
        }
    }
    
        //don't flip up this card if too many would be up
    if ( [self.upCards count] >= self.mode) {    //don't turn card up because too many would be up
        self.moveResultCode = noFlipCode;
        return;
    }
    
        //flip this card up
    self.moveResultCode = flipUpCode;
    card.faceUp = YES;
    [self.upCards addObject:card];
}

@end
