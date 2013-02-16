//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Robert Lummis on 2/5/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"

#define MATCH_BONUS 4
#define MISMATCH_POINTS_2CARD -2
#define MISMATCH_POINTS_3CARD -4;
#define FLIP_POINTS -1

@implementation CardMatchingGame

    //this is here to provide a place to set a value for mode
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super initWithCardCount:count usingDeck:deck];
    self.mode = 2;
    return self;
}

    //handle the 2 cards that are turned up
- (void)evaluateCards:(NSArray *)upCards {
    if ( [upCards count] != 2 ) {
        NSLog(@"error: evaluateCards received %d cards", [upCards count]);
        return;
    }   //this should never happen
    
    NSMutableArray *cardsThatMatchByRank = [[NSMutableArray alloc] init];
    NSMutableArray *cardsThatMatchBySuit = [[NSMutableArray alloc] init];
    for (PlayingCard *card in upCards) {
        if ( [card matchByRank:upCards] ) [cardsThatMatchByRank addObject:card];
        if ( [card matchBySuit:upCards] ) [cardsThatMatchBySuit addObject:card];
    }
    
        //count cards that match by rank, cards that match by suit, and put the cards in a set
    NSUInteger rankMatches = [cardsThatMatchByRank count];
    NSUInteger suitMatches = [cardsThatMatchBySuit count];
    NSMutableSet *matchedCards = [NSMutableSet setWithCapacity:3];
    [matchedCards addObjectsFromArray:cardsThatMatchByRank];
    [matchedCards addObjectsFromArray:cardsThatMatchBySuit];
    
        //disable the cards that matched something
    for (PlayingCard *card in matchedCards) {
        card.unplayable = YES;
    }
    
        //get score for this play
    NSInteger scoreThisPlay = [self scoreForRankMatches:rankMatches suitMatches:suitMatches];
    
        //construct comment including the list of cards that match something (without saying
        //if it's by rank or by suit) and the score for this move
    if ( [matchedCards count] == 0 ) {
        self.comment = [NSString stringWithFormat:@"No match! %d points", scoreThisPlay];
    } else {
        self.comment = @"Matches: ";
        for (PlayingCard *card in matchedCards) {
            self.comment = [self.comment stringByAppendingString:[NSString stringWithFormat:@"%@ ", card.contents]];
        }
        self.comment = [self.comment stringByAppendingString:[NSString stringWithFormat:@"%d points", scoreThisPlay]];
    }
    
        //increment score
    self.score += scoreThisPlay;
}

-(void) flipCardAtIndex:(NSUInteger)index {
    [super flipCardAtIndex:index];
    PlayingCard *c = self.cards[index];
    if (c.faceUp) {     //penalty only for flipping up, not if down
        self.score += FLIP_POINTS;
    }
    if ( [self.upCards count] == self.mode ) {
        [self evaluateCards:self.upCards];
    }
}

-(NSInteger) scoreForRankMatches:(NSUInteger)r suitMatches:(NSUInteger)s {
    NSInteger score = 0;
    
    if (self.mode == 2) {
        if (r == 0 && s == 0) return -5;    //no match
        if (r == 2) return 10;
        if (s == 2) return 4;
        
    } else if (self.mode == 3) {
        if (r == 0 && s == 0) return -7;    //no match
        if (r == 2 && s == 0) return 8;
        if (r == 0 && s == 2) return 3;
        if (r == 2 && s == 2) return 12;
        if (r == 3) return 100;
        if (s == 3) return 20;
        
    } else {
        NSLog(@"self.mode should be 2 or 3, but it is: %d", self.mode);
    }
    return score;
}

@end
