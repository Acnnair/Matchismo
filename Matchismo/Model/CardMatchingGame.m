//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Marek Štefkovič on 31.1.2013.
//  Copyright (c) 2013 Marek Štefkovič. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite) NSMutableArray *flippedCards;
@property (nonatomic, readwrite) NSInteger lastFlipScore;
@property (nonatomic, readwrite) NSInteger score;

@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)count usingDeck:(PlayingCardDeck *)deck
{
	if (self = [super init]) {
		for (NSInteger i = 0; i < count; i++) {
			Card *card = [deck drawRandomCard];
			if (card) {
				self.cards[i] = card;
			} else {
				self = nil;
				break;
			}
		}
	}
	
	return self;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index;
{
	[self.flippedCards removeAllObjects];
	self.lastFlipScore = 0;
	
	PlayingCard *card = [self cardAtIndex:index];
	if (card && !card.isUnplayable) {
		if (!card.isFaceUp) {
			
			[self.flippedCards addObject:card.contents];
			
			for (PlayingCard *otherCard in self.cards) {
				if (otherCard.isFaceUp && !otherCard.isUnplayable) {
					NSInteger matchScore = [card match:@[otherCard]];
					if (matchScore) {
						card.unplayable = YES;
						otherCard.unplayable = YES;
						self.score += matchScore * MATCH_BONUS;
						self.lastFlipScore = matchScore * MATCH_BONUS;
					} else {
						otherCard.faceUp = NO;
						self.score -= MISMATCH_PENALTY;
						self.lastFlipScore = -MISMATCH_PENALTY;
					}
					[self.flippedCards addObject:otherCard.contents];
					break;
				}
			}
			self.score -= FLIP_COST;
		}
		card.faceUp = !card.isFaceUp;
	}
}

- (PlayingCard *)cardAtIndex:(NSUInteger)index;
{
	return (index < [self.cards count]) ? self.cards[index] : nil;
}

#pragma mark - Properties

- (NSMutableArray *)cards
{
	if (!_cards) {
		_cards = [NSMutableArray array];
	}
	
	return _cards;
}

- (NSMutableArray *)flippedCards
{
	if (!_flippedCards) {
		_flippedCards = [NSMutableArray array];
	}
	
	return _flippedCards;
}

@end
