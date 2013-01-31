//
//  Card.h
//  Matchismo
//
//  Created by Marek Štefkovič on 25.1.13.
//  Copyright (c) 2013 Marek Štefkovič. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic) NSString *contents;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;

- (NSInteger)match:(NSArray *)otherCards;

@end
