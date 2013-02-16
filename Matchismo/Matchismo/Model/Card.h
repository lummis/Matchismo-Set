//
//  Card.h
//  Matchismo
//
//  Created by Robert Lummis on 2/3/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property(strong, nonatomic) NSString *contents;
@property (nonatomic, readonly) NSString *imageName;
@property(nonatomic, getter = isFaceUp) BOOL faceUp;
@property(nonatomic, getter = isUnplayable) BOOL unplayable;

    //return 1 if self matches any card in otherCards, else return 0
-(int)match:(NSArray *)otherCards;

@end
