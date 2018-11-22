//
//  NSString+WSString.m
//  Word Search
//
//  Created by Shamshad Khan on 19/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "NSString+WSString.h"

@implementation NSString (WSString)

-(NSString*)reverseString
{
	NSMutableString *reversed = [NSMutableString string];
	NSInteger charIndex = [self length];
	while (charIndex > 0) {
		charIndex--;
		NSRange subRange = NSMakeRange(charIndex, 1);
		[reversed appendString:[self substringWithRange:subRange]];
	}
	return reversed;
}

@end
