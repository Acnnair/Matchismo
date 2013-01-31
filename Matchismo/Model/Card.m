//
//  Card.m
//  Matchismo
//
//  Created by Marek Štefkovič on 25.1.13.
//  Copyright (c) 2013 Marek Štefkovič. All rights reserved.
//

#import "Card.h"

@implementation Card

- (NSInteger)match:(NSArray *)otherCards
{
	NSInteger score = 0;
	
	for (Card *otherCard in otherCards) {
		if ([self.contents isEqualToString:otherCard.contents]) {
			score = 1;
		}
	}
	
	return score;
}

@end
