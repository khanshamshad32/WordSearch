//
//  Game.h
//  Word Search
//
//  Created by Shamshad Khan on 23/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"

@interface Game : NSObject

@property (strong, nonatomic) NSArray* cluesArray;
@property (strong, nonatomic) NSArray* gridArray;

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSArray* gameData;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString* colorName;

-(instancetype)initWithDictionary:(NSDictionary*)dict index:(NSInteger)index color:(NSString*)color;

@end
