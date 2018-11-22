//
//  GameType.h
//  Word Search
//
//  Created by Shamshad Khan on 25/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"

@interface GameType : NSObject

@property (strong, nonatomic) NSString* title;
@property (assign, nonatomic) NSInteger puzzlesCount;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString* colorName;
@property (strong, nonatomic) NSString* imageName;

-(instancetype)initWithDictionary:(NSDictionary*)dict index:(NSInteger)index;

@end
