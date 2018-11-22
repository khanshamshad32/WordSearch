//
//  GridItem.h
//  Word Search
//
//  Created by Shamshad Khan on 19/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Define.h"

static char kNullChar = ' ';

@interface GridItem : NSObject

@property (assign, nonatomic) char value;
@property (strong, nonatomic) UIColor* itemTextColor;
@property (strong, nonatomic) UIColor* bgColor;
@property (assign, nonatomic) BOOL isPartOfClue;

-(NSString*)stringValue;

+(NSMutableArray*)getRandomData;
+(NSMutableArray*)getDefaultGrid;

@end
