//
//  Game.m
//  Word Search
//
//  Created by Shamshad Khan on 23/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "Game.h"

@implementation Game

-(instancetype)initWithDictionary:(NSDictionary*)dict index:(NSInteger)index color:(NSString*)color
{
	if(self = [super init])
	{
		self.title = [dict valueForKey:kSubLevelTitleKey];
		self.gameData  = [dict valueForKey:kSubLevelDataKey];
		self.index = index;
		self.colorName = color;
	}
	return  self;
}

@end
