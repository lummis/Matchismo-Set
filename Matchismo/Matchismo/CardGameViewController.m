//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Robert Lummis on 2/3/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!!!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
    }
    return _game;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (void)updateUI {
    UIImage *cardBackImage = [UIImage imageNamed:@"four-suits.png"];
    UIImage *transparentCardBackImage = [UIImage imageNamed:@"transparent-card-back.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
    for (UIButton *cardButton in self.cardButtons) {
        cardButton.imageEdgeInsets = insets;
        Card *card = (PlayingCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !!!card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        [cardButton setBackgroundImage:transparentCardBackImage forState:UIControlStateSelected];
        [cardButton setBackgroundImage:cardBackImage forState:UIControlStateNormal];
        
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.commentLabel.text = self.game.comment;
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    NSLog(@"button state: %d", sender.state);
    self.flipCount++;
    [self updateUI];
}

- (IBAction)deal:(id)sender {
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
}

- (IBAction)chooseMode:(UISegmentedControl *)sender {
    self.game.mode = sender.selectedSegmentIndex + 2;
    NSLog(@"game mode: %d", self.game.mode);
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)viewDidUnload {
    [self setFlipsLabel:nil];
    [self setTitle:nil];
    [self setCardButtons:nil];
    [self setScoreLabel:nil];
    [self setCommentLabel:nil];
    [self setDealButton:nil];
    [super viewDidUnload];
}

@end
