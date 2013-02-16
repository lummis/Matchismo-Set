//
//  PlayingCard.m
//  Matchismo
//
//  Created by Robert Lummis on 2/3/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "PlayingCard.h"

@interface PlayingCard()
@property (nonatomic) int result;
@end

@implementation PlayingCard

-(NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+(NSArray *)validSuits {
    return @[@"♠", @"♦", @"♣", @"♥"];
}

+(NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6",
             @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+(NSUInteger)maxRank {
    return [[ self rankStrings ] count] - 1;
}

-(void)setRank:(NSUInteger)rank {
    if ( rank <= [PlayingCard maxRank] ) {
        _rank = rank;
    }
}

/* if you implement both the getter and the setter you MUST supply a synthesize stmt */
@synthesize suit = _suit;

-(void) setSuit:(NSString *)suit {
    if ( [ [PlayingCard validSuits] containsObject:suit ] ) {
        _suit = suit;
    }
}

-(NSString *)suit {
    return _suit ? _suit : @"?";
}

    //return YES if self matches at least one card in otherCards that is not self
    //self can be a member of otherCards
-(BOOL) matchByRank:(NSArray *)otherCards {
    if ( [otherCards count] == 0 ) {
        return NO;
    }
    for (PlayingCard *card in otherCards) {
        if (self != card && self.rank == card.rank) {
            return YES;
        }
    }
    return NO;
}

-(BOOL) matchBySuit:(NSArray *)otherCards {
    if ( [otherCards count] == 0 ) {
        return NO;
    }
    for (PlayingCard *card in otherCards) {
        if (self != card && [self.suit isEqualToString:card.suit] ) {
            return YES;
        }
    }
    return NO;
}

@end
