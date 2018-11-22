//
//  UIColor+DLColor.m
//  DigitalLibrary
//
//  Created by Shamshad Khan on 24/04/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "UIColor+WSColor.h"

@implementation UIColor (WSColor)

#pragma mark -
+(UIColor*)colorFromString:(NSString *)colorString alph:(NSInteger)alpha
{
	NSArray* components = [colorString componentsSeparatedByString:@":"];
	
	if(components.count != 4)
		return [UIColor whiteColor];
	
	NSInteger red = [[components objectAtIndex:0] integerValue];
	NSInteger green = [[components objectAtIndex:1] integerValue];
	NSInteger blue = [[components objectAtIndex:2] integerValue];
	
	return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/100.0];
}

@end
