//
//  Deck.m
//  Matchismo
//
//  Created by Marek Štefkovič on 25.1.13.
//  Copyright (c) 2013 Marek Štefkovič. All rights reserved.
//

#import "Deck.h"

@interface Deck ()
@property (nonatomic) NSMutableArray *cards;
@end

@implementation Deck

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
	if (atTop) {
		[self.cards insertObject:card atIndex:0];
	} else {
		[self.cards addObject:card];
	}
}

- (Card *)drawRandomCard
{
	Card *randomCard = nil;
	
	if ([self.cards count]) {
		NSUInteger index = arc4random() % [self.cards count];
		randomCard = self.cards[index];
		[self.cards removeObjectAtIndex:index];
	}
	
	return randomCard;
}

#pragma mark -
#pragma mark Properties

- (NSMutableArray *)cards
{
	if (!_cards) _cards = [NSMutableArray array];
	return _cards;
}

@end
