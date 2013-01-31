//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Marek Štefkovič on 31.1.2013.
//  Copyright (c) 2013 Marek Štefkovič. All rights reserved.
//

#import "PlayingCard.h"
#import "PlayingCardDeck.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) NSMutableArray *flippedCards;
@property (readonly, nonatomic) NSInteger lastFlipScore;
@property (readonly, nonatomic) NSInteger score;

- (id)initWithCardCount:(NSUInteger)count usingDeck:(PlayingCardDeck *)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (PlayingCard *)cardAtIndex:(NSUInteger)index;

@end