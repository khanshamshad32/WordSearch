//
//  HomeScreenTableCell.m
//  Word Search
//
//  Created by Shamshad Khan on 25/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "SelectGameTableCell.h"
#import "UIColor+WSColor.h"


#define kBorderWidth 1

@implementation SelectGameTableCell

-(void)awakeFromNib
{
	_iconImageView.layer.cornerRadius = _iconImageView.frame.size.width/2 + 5;
	_iconImageView.layer.masksToBounds = YES;
	
	[super awakeFromNib];
}

-(void)setGame:(Game*)game
{
	_titleLabel.text = game.title;
	_iconImageView.backgroundColor = [UIColor colorFromString:game.colorName alph:100];
}

@end
