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
@property (nonatomic) GameMode gameMode;

@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)count mode:(GameMode)mode usingDeck:(PlayingCardDeck *)deck
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
		self.gameMode = mode;
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
			
			[self.flippedCards addObject:card];
			
			NSMutableArray *availableCards = [[NSMutableArray alloc] init];
			
			for (PlayingCard *otherCard in self.cards) {
				if (otherCard.isFaceUp && !otherCard.isUnplayable) {
					[availableCards addObject:otherCard];
					if ([availableCards count] == self.gameMode - 1) {
						NSInteger matchScore = [card match:availableCards];
						if (matchScore) {
							card.unplayable = YES;
							[availableCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
								if ([obj isMemberOfClass:[PlayingCard class]]) {
									[obj setUnplayable:YES];
								}
							}];
							matchScore *= MATCH_BONUS * self.gameMode;
							self.score += matchScore;
							self.lastFlipScore = matchScore;
						} else {
							[availableCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
								if ([obj isMemberOfClass:[PlayingCard class]]) {
									[obj setFaceUp:NO];
								}
							}];
							self.score -= MISMATCH_PENALTY;
							self.lastFlipScore = -MISMATCH_PENALTY;
						}
						[self.flippedCards addObjectsFromArray:availableCards];
					}
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
