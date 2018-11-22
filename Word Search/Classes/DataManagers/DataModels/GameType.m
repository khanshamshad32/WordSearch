//
//  GameType.m
//  Word Search
//
//  Created by Shamshad Khan on 25/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "GameType.h"



@implementation GameType

-(instancetype)initWithDictionary:(NSDictionary*)dict index:(NSInteger)index
{
	if(self = [super init])
	{
		NSArray* puzzleArray = [dict valueForKey:kLevelDataKey];
		self.title = [dict valueForKey:kLevelTitleKey];
		self.puzzlesCount = puzzleArray.count;
		self.index = index;
		self.imageName = [dict valueForKey:kLevelImageKey];
		self.colorName = [dict valueForKey:kLevelColorKey];
	}
	return self;
}

@end
