//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Marek Štefkovič on 25.1.13.
//  Copyright (c) 2013 Marek Štefkovič. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;

@property (nonatomic) NSInteger flipCount;
@property (nonatomic, strong) CardMatchingGame *game;
@end

@implementation CardGameViewController

- (void)updateUI
{
	for (UIButton *cardButton in self.cardButtons) {
		Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
		[cardButton setTitle:card.contents forState:UIControlStateSelected];
		[cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
		cardButton.selected = card.isFaceUp;
		cardButton.enabled = !card.isUnplayable;
		cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
	}
	
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	
	if ([self.game.flippedCards count] == 1) {
		self.lastFlipLabel.text = [@"Flipped " stringByAppendingString:[self.game.flippedCards lastObject]];
	} else if ([self.game.flippedCards count] > 1) {
		NSString *cards = [self.game.flippedCards componentsJoinedByString:@" & "];
		
		if (self.game.lastFlipScore < 0) {
			self.lastFlipLabel.text = [NSString stringWithFormat:@"%@ don't match! %d points penalty.", cards, self.game.lastFlipScore];
		} else {
			self.lastFlipLabel.text = [NSString stringWithFormat:@"Matched %@ for %d points.", cards, self.game.lastFlipScore];
		}
	}
}

#pragma mark - Actions

- (IBAction)flipCard:(UIButton *)sender
{
	[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
	self.flipCount++;
	[self updateUI];
}

#pragma mark -
#pragma mark Properties

- (void)setCardButtons:(NSArray *)cardButtons
{
	_cardButtons = cardButtons;
	[self updateUI];
}

- (void)setFlipCount:(NSInteger)flipCount
{
	_flipCount = flipCount;
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (CardMatchingGame *)game
{
	if (!_game) {
		_game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init]];
	}
	
	return _game;
}

@end
