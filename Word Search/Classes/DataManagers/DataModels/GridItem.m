//
//  GridItem.m
//  Word Search
//
//  Created by Shamshad Khan on 19/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "GridItem.h"

@implementation GridItem

-(instancetype)initWithValue:(char)value
{
	if(self = [super init])
	{
		self.value = value;
		self.isPartOfClue = NO;
	}
	return	self;
}

-(NSString*)stringValue
{
	return [NSString stringWithFormat:@"%c",_value];
}

+(NSMutableArray*)getRandomData
{
	NSMutableArray* result = [[NSMutableArray alloc]init];
	
	for(int i=0; i<kGridSize; i++)
	{
		NSMutableArray* column = [[NSMutableArray alloc]init];
		for(int j=0; j<kGridSize; j++)
		{
			int num = arc4random()%26 + 65;
			GridItem* item = [[GridItem alloc]initWithValue:num];
			[column addObject:item];
		}
		[result addObject:column];
	}
	return result;
}

+(NSMutableArray*)getDefaultGrid
{
	NSMutableArray* result = [[NSMutableArray alloc]init];
	
	for(int i=0; i<kGridSize; i++)
	{
		NSMutableArray* column = [[NSMutableArray alloc]init];
		for(int j=0; j<kGridSize; j++)
		{
			GridItem* item = [[GridItem alloc]initWithValue:kNullChar];
			[column addObject:item];
		}
		[result addObject:column];
	}
	return result;
}

@end
