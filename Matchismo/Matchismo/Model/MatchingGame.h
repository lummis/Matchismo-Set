//
//  MatchingGame.h
//  Matchismo&Set
//
//  Created by Robert Lummis on 2/14/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

enum {
    newDealCode,
    flipUpCode,
    flipDownCode,
    noFlipCode,
    matchCode,
    mismatchCode
}; //model class sets code on each move. viewController displays message based on code

@interface MatchingGame : NSObject

@property (nonatomic) int mode; //2 or 3
@property (nonatomic) NSString *comment;
@property (nonatomic) int moveResultCode;
@property (nonatomic) int scoreThisMove;
@property (nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *upCards;

- (id) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (Card *) cardAtIndex:(NSUInteger)index;
- (void) flipCardAtIndex:(NSUInteger)index;

@end
