//
//  GridManager.m
//  Word Search
//
//  Created by Shamshad Khan on 19/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "GridManager.h"

static GridManager* sShareInstance;
static NSMutableArray* sBuffer;

@implementation GridManager

#pragma mark -
+(instancetype)loadGridManager
{
	if(!sShareInstance)
	{
		static dispatch_once_t pred;
		dispatch_once(&pred, ^{
			sShareInstance = [[GridManager alloc] init];
		});
	}
	return sShareInstance;
}

-(Game*)getRandomGame
{
	NSArray* grid = [self getGameData];
	
	int i = arc4random()%grid.count;
	
	NSDictionary* dict = [grid objectAtIndex:i];
	GameType* gameType = [[GameType alloc]initWithDictionary:dict index:i];
	
	NSArray* puzzleArray = [dict valueForKey:kLevelDataKey];
	i = arc4random() % gameType.puzzlesCount;
	
	dict = [puzzleArray objectAtIndex:i];
	return [[Game alloc]initWithDictionary:dict index:i color:gameType.colorName];
}

#pragma mark -
-(void)createGame:(Game*)game completion:(void(^)(Game* game))callback
{
	self.game = game;
	[self fillClues];
	_game.gridArray = [GridItem getDefaultGrid];
	_addedCluesArray = [[NSMutableArray alloc]init];
	
	for(NSString* word in _game.cluesArray)
		[self insertWord:word];
	[self fillGrid];
	
	callback(game);
}

-(void)fillClues
{
	NSMutableArray* clueArray = [[NSMutableArray alloc]init];
	int index;
	NSNumber* clueIndex;
	
	[self fillBufferWithLength:_game.gameData.count];
	
	do{
		index = arc4random()%sBuffer.count;
		clueIndex = [sBuffer objectAtIndex:index];
		NSString* word = [_game.gameData objectAtIndex:clueIndex.integerValue];
		
		if(word.length < kGridSize)
			[clueArray addObject:word];
		
		[sBuffer removeObject:clueIndex];
		
	}while(sBuffer.count && clueArray.count < kMaxClueCount);
	
	_game.cluesArray = clueArray;
}

-(void)insertWord:(NSString*)word
{
	EDirection d;
	NSIndexPath* index;
	
	do{
		NSUInteger sec = arc4random() % kGridSize;
		NSUInteger row = arc4random() % kGridSize;
		d = arc4random() % kDirectionCount;
		index = [NSIndexPath indexPathForRow:row inSection:sec];
	}while(![self canInsertWord:word atIndex:index inDirection:d]);
	
	for(int j=0; j<word.length; j++)
	{
		GridItem* item = _game.gridArray[index.section][index.row];
		item.isPartOfClue = YES;
		item.value = [word characterAtIndex:j];
		index = [GridManager shiftPoint:index direction:d];
	}
	[self.addedCluesArray addObject:word];
}

-(BOOL)canInsertWord:(NSString*)word atIndex:(NSIndexPath*)start inDirection:(EDirection)d
{
	NSIndexPath* newIndex = start;
	
	for(int i=0; i<word.length; i++)
	{
		GridItem* item = _game.gridArray[newIndex.section][newIndex.row];
		
		if(item.value == kNullChar || item.value == [word characterAtIndex:i])
			newIndex = [GridManager shiftPoint:newIndex direction:d];
		else
			return NO;
		
		if(!newIndex)
			return NO;
	}
	return YES;
}

-(void)fillGrid
{
	for(int i=0; i<kGridSize; i++)
		for(int j=0; j<kGridSize; j++)
		{
			GridItem* item = _game.gridArray[i][j];
			if(item.value == kNullChar)
				item.value = arc4random()%26 + 65;
		}
}

#pragma mark - Levels
-(NSArray*)getGameTypes
{
	NSArray* levels = [self getGameData];
	
	NSMutableArray* result = [[NSMutableArray alloc]init];
	
	for(NSDictionary* dict in levels)
	{
		NSInteger index = [levels indexOfObject:dict];
		[result addObject:[[GameType alloc]initWithDictionary:dict index:index]];
	}
	return result;
}

-(NSArray*)getPuzzleForType:(GameType*)gameType
{
	NSArray* levelArray = [self getGameData];
	NSDictionary* dict = [levelArray objectAtIndex:gameType.index];
	NSArray* puzzleArray = [dict valueForKey:kLevelDataKey];
	NSMutableArray* result = [[NSMutableArray alloc]init];
	
	for(NSDictionary* dict in puzzleArray)
	{
		NSInteger index = [puzzleArray indexOfObject:dict];
		[result addObject:[[Game alloc] initWithDictionary:dict index:index color:gameType.colorName] ];
	}
	return result;
}

-(NSArray*)getGameData
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"WordSearch" ofType:@"plist"];
	return	[NSArray arrayWithContentsOfFile:path];
}

#pragma mark - Parse File
-(void)praseFile
{
	NSString* filepath = [[NSBundle mainBundle] pathForResource:@"wordsearches" ofType:@"csv"];
	NSError* error;
	NSString* fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
	
	if(error)
		NSLog(@"Error reading file: %@", error.localizedDescription);
	
	NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
	
	NSMutableArray* resultArray = [[NSMutableArray alloc]init];
	NSString* preLevel;
	
	NSMutableDictionary* levelDict;
	
	for(NSString* str in listArray)
	{
		NSArray* itemArray = [str componentsSeparatedByString:@","];
		
		if(itemArray.count > 2)
		{
			NSString* levelTitle = [itemArray objectAtIndex:1];
			
			if([levelTitle isEqualToString:preLevel])	// data of same level
			{
				NSMutableArray* levelData = [levelDict valueForKey:kLevelDataKey];
				[levelData addObject:[self getSubLevelFor:itemArray]];
			}
			else
			{
				levelDict = [[NSMutableDictionary alloc]init];
				
				NSMutableArray* levelData = [[NSMutableArray alloc]init];
				[levelData addObject:[self getSubLevelFor:itemArray]];
				
				[levelDict setValue:levelTitle forKey:kLevelTitleKey];
				[levelDict setValue:levelData forKey:kLevelDataKey];
				
				[resultArray addObject:levelDict];
				preLevel = levelTitle;
			}
		}
	}
	[self saveToPlist:resultArray];
}

-(NSMutableDictionary*)getSubLevelFor:(NSArray*)itemArray
{
	NSMutableArray* subLevelDataArray = [[NSMutableArray alloc]init];
	
	for(NSInteger i=3; i< itemArray.count;i++)
	{
		NSString* data = [itemArray objectAtIndex:i];
		[subLevelDataArray addObject:data];
	}
	
	NSString* subLevel = [itemArray firstObject];
	
	NSMutableDictionary* subLevelDict = [[NSMutableDictionary alloc]init];
	[subLevelDict setValue:subLevel forKey:kSubLevelTitleKey];
	[subLevelDict setValue:subLevelDataArray forKey:kSubLevelDataKey];
	
	return subLevelDict;
}
-(void)saveToPlist:(NSArray*)data
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"WordSearch.plist"];
	[data writeToFile:path atomically:YES];
}

#pragma mark - Direction
+(NSIndexPath*)shiftPoint:(NSIndexPath*)start direction:(EDirection)d
{
	NSUInteger sec = start.section;
	NSUInteger row = start.row;
	NSIndexPath* newIndex;
	
	switch(d)
	{
		case EDirectionUP:
			newIndex = [NSIndexPath indexPathForRow:row inSection:sec-1];
			break;
		case EDirectionDOWN :
			newIndex = [NSIndexPath indexPathForRow:row inSection:sec+1];
			break;
		case EDirectionLEFT:
			newIndex = [NSIndexPath indexPathForRow:row-1  inSection:sec];
			break;
		case EDirectionRIGHT :
			newIndex = [NSIndexPath indexPathForRow:row+1 inSection: sec];
			break;
		case EDirectionUPLEFT :
			newIndex = [NSIndexPath indexPathForRow:row-1  inSection:sec-1];
			break;
		case EDirectionUPRIGHT :
			newIndex = [NSIndexPath indexPathForRow:row+1 inSection:sec-1];
			break;
		case EDirectionDOWNLEFT :
			newIndex = [NSIndexPath indexPathForRow:row-1 inSection:sec+1];
			break;
		case EDirectionDOWNRIGHT :
			newIndex = [NSIndexPath indexPathForRow:row+1  inSection:sec+1];
			break;
		default:
			newIndex = [NSIndexPath indexPathForRow:row inSection:sec];
			break;
	}
	
	if(newIndex.section <= -1 || newIndex.section >= kGridSize || newIndex.row <= -1 || newIndex.row >= kGridSize)
		return nil;
	return newIndex;
}

+(EDirection)directionFromPoint:(NSIndexPath*)start to:(NSIndexPath*)end
{
	NSUInteger x1 = start.row;
	NSUInteger y1 = start.section;
	NSUInteger x2 = end.row;
	NSUInteger y2 = end.section;
	EDirection d;
	
	if(y1 == y2)				//	for ROW
		d = x1 < x2 ? EDirectionRIGHT : EDirectionLEFT;
	else if(x1 == x2)			//	For Column
		d = y1 < y2 ? EDirectionDOWN : EDirectionUP;
	else if(x1+y2 == x2+y1)		//	For Leading Diagonal
		d = x1 < x2 ? EDirectionDOWNRIGHT : EDirectionUPLEFT;
	else
		d = x1 < x2 && y1 > y2?EDirectionUPRIGHT:EDirectionDOWNLEFT;
	
	return d;
}

#pragma mark - BUFFER
-(void)fillBufferWithLength:(NSUInteger)length
{
	sBuffer = [[NSMutableArray alloc]init];
	
	for(int i=0; i<length; i++)
		[sBuffer addObject:[NSNumber numberWithInt:i]];
}

@end
