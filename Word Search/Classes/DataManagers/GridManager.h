//
//  GridManager.h
//  Word Search
//
//  Created by Shamshad Khan on 19/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"
#import "GridItem.h"
#import "Game.h"
#import "GameType.h"

typedef NS_ENUM(NSInteger, EDirection)
{
	EDirectionUP = 0,
	EDirectionDOWN,
	EDirectionLEFT,
	EDirectionRIGHT,
	EDirectionUPLEFT,
	EDirectionUPRIGHT,
	EDirectionDOWNLEFT,
	EDirectionDOWNRIGHT
};

@interface GridManager : NSObject

@property (strong, nonatomic) Game* game;
@property (strong, nonatomic) NSMutableArray* addedCluesArray;

+(instancetype)loadGridManager;

-(Game*)getRandomGame;
-(void)createGame:(Game*)game completion:(void(^)(Game* game))callback;

-(NSArray*)getGameTypes;
-(NSArray*)getPuzzleForType:(GameType*)gameType;
-(void)praseFile;

+(NSIndexPath*)shiftPoint:(NSIndexPath*)start direction:(EDirection)d;
+(EDirection)directionFromPoint:(NSIndexPath*)start to:(NSIndexPath*)end;

@end

#define _gGridManager [GridManager loadGridManager]
