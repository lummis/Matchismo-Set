//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Robert Lummis on 2/10/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetMatchingGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import <CoreText/CoreText.h>

#define SETMODE 3

@interface SetGameViewController ()
@property (strong, nonatomic) SetMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsDisplay;
@property (nonatomic) int flips;
@property (weak, nonatomic) IBOutlet UILabel *scoreDisplay;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *thisScore;
@property (strong, nonatomic) SetCard *currentCard;

@end

@implementation SetGameViewController

- (SetMatchingGame *)game {
    if (!!!_game) {
        _game = [[SetMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[SetCardDeck alloc] init]];
    }
    return _game;
}

-(void) viewDidLoad {
    LOG
    self.game.mode = SETMODE;
    [super viewDidLoad];
    [self updateUI];
}

- (void) updateUI {
    LOG
    
    for (UIButton *cardButton in self.cardButtons) {
        SetCard *card = (SetCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        NSAttributedString *at = [self makeAttributedStringWithSymbol:(NSUInteger)card.symbol number:card.number
                                     shading:card.shading color:card.color];
        [cardButton setAttributedTitle:at forState:UIControlStateNormal];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !!!card.isUnplayable;
        cardButton.hidden = card.isUnplayable;
        if (card.isFaceUp) {
            cardButton.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
        } else {
            cardButton.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:0.0f];
        }
    }

    if (self.game.moveResultCode == newDealCode) {
        self.comment.text = @"Select 3 cards that form a set";
        self.thisScore.text = @"";
    }
    
    else if (self.game.moveResultCode == matchCode) {
        NSMutableAttributedString *m = [[NSMutableAttributedString alloc] init];
        NSAttributedString *spaces = [[NSAttributedString alloc] initWithString:@"  "];
        for (int i = 0; i < [self.game.upCards count]; i++) {
            SetCard *c = self.game.upCards[i];
            [m appendAttributedString:[[NSMutableAttributedString alloc] initWithAttributedString:
                                            [self makeAttributedStringWithSymbol:c.symbol
                                                                          number:c.number
                                                                         shading:c.shading
                                                                           color:c.color]]];
            [m appendAttributedString:spaces];
        }
        [m appendAttributedString:[[NSAttributedString alloc] initWithString:@" is a set"]];
        self.comment.attributedText = [m copy];
        self.thisScore.text = [NSString stringWithFormat:@"%d points for finding a set", self.game.scoreThisMove];
    }
    
    else if (self.game.moveResultCode == mismatchCode) {
        NSMutableAttributedString *m = [[NSMutableAttributedString alloc] init];
        NSAttributedString *spaces = [[NSAttributedString alloc] initWithString:@"  "];
        for (int i = 0; i < [self.game.upCards count]; i++) {
            SetCard *c = self.game.upCards[i];
            [m appendAttributedString:[[NSMutableAttributedString alloc] initWithAttributedString:
                                       [self makeAttributedStringWithSymbol:c.symbol
                                                                     number:c.number
                                                                    shading:c.shading
                                                                      color:c.color]]];
            [m appendAttributedString:spaces];
        }
        [m appendAttributedString:[[NSAttributedString alloc] initWithString:@" is not a set"]];
        self.comment.attributedText = [m copy];
        self.thisScore.text = [NSString stringWithFormat:@"%d points", self.game.scoreThisMove];
    }
    
    else if (self.game.moveResultCode == noFlipCode) {
        self.comment.text = @"Can't select more cards";
        self.flips--;   //was incremented without checking if flip is allowed
        self.thisScore.text = @"";
    }
    
    else if (self.game.moveResultCode == flipUpCode) {
        NSMutableAttributedString *m = [[NSMutableAttributedString alloc] initWithAttributedString:
                                        [self makeAttributedStringWithSymbol:self.currentCard.symbol
                                                                      number:self.currentCard.number
                                                                     shading:self.currentCard.shading
                                                                       color:self.currentCard.color]];
        [m appendAttributedString:[[NSAttributedString alloc] initWithString:@"  selected"]];
        self.comment.attributedText = [m copy];
        self.thisScore.text = [NSString stringWithFormat:@"%d points for this selection", self.game.scoreThisMove];
    }
    
    else if (self.game.moveResultCode == flipDownCode) {
        NSMutableAttributedString *m = [[NSMutableAttributedString alloc] initWithAttributedString:
                                        [self makeAttributedStringWithSymbol:self.currentCard.symbol
                                                                      number:self.currentCard.number
                                                                     shading:self.currentCard.shading
                                                                       color:self.currentCard.color]];
        [m appendAttributedString:[[NSAttributedString alloc] initWithString:@"  deselected"]];
        self.comment.attributedText = [m copy];
        self.thisScore.text = @"";
    }
    
    else NSLog(@"invalid moveResultCode: %d", self.game.moveResultCode);
    
    self.flipsDisplay.text = [NSString stringWithFormat:@"%d", self.flips];
    self.scoreDisplay.text = [NSString stringWithFormat:@"%d", self.game.score];
}

- (NSAttributedString *) makeAttributedStringWithSymbol:(NSUInteger)symbol number:(NSUInteger)number
                                                shading:(NSUInteger)shading color:(NSUInteger)color {
    NSString *word = @"";
    for (int i = 0; i < number + 1; i++) {
        word = [word stringByAppendingString:[ @[@" ■", @" ▲", @" ●"] objectAtIndex:symbol]];
    }
    UIColor *strokeColor = @[ [UIColor redColor], [UIColor greenColor], [UIColor purpleColor] ] [ (int)color ];
    UIColor *fgColor = [strokeColor colorWithAlphaComponent:[@[@0.f, @0.2f, @1.0f][shading] floatValue]];
    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:word];
    NSRange r = NSMakeRange(0, [mat length]);
    [mat addAttribute:NSForegroundColorAttributeName    value:fgColor       range:r];
    [mat addAttribute:NSStrokeColorAttributeName        value:strokeColor   range:r];
    [mat addAttribute:NSStrokeWidthAttributeName        value:@-10          range:r];
    return [mat copy];
}

- (IBAction)flipCard:(UIButton *)sender {
    self.currentCard = (SetCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flips++;
    [self updateUI];
}


- (IBAction)deal {
    self.game = nil;
    self.flips = 0;
    self.game.moveResultCode = newDealCode;
    [self updateUI];
}

- (void)viewDidUnload {
    LOG
    
    [self setCardButtons:nil];
    [self setCardButtons:nil];
    [self setCardButtons:nil];
    [self setComment:nil];
    [self setFlipsDisplay:nil];
    [self setScoreDisplay:nil];
    [self setThisScore:nil];
    [super viewDidUnload];
}
@end
