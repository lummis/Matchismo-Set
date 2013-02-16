//
//  PlayingCard.h
//  Matchismo
//
//  Created by Robert Lummis on 2/3/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+(NSArray *) validSuits;
+(NSUInteger) maxRank;
-(BOOL) matchByRank:(NSArray *)otherCards;
-(BOOL) matchBySuit:(NSArray *)otherCards;

@end
