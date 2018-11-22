//
//  HomeScreenTableCell.m
//  Word Search
//
//  Created by Shamshad Khan on 25/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "HomeScreenTableCell.h"
#import "UIColor+WSColor.h"

#define kCornerRadius 5
#define kBorderWidth 1

@implementation HomeScreenTableCell

-(void)awakeFromNib
{
	[super awakeFromNib];
	_iconBGView.layer.cornerRadius = _iconBGView.frame.size.width/2;
	_iconBGView.layer.masksToBounds = YES;
}


-(void)setGameType:(GameType*)type
{
	self.titleLabel.text = type.title;
	self.detailLabel.text = [NSString stringWithFormat:@"%ld %@",(long)type.puzzlesCount,NSLocalizedString(@"puzzle", nil)];
	
	self.iconBGView.backgroundColor = [UIColor colorFromString:type.colorName alph:100];
	self.iconImageView.image = [UIImage imageNamed:type.imageName];
}


@end
