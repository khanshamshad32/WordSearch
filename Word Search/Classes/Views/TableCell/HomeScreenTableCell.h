//
//  HomeScreenTableCell.h
//  Word Search
//
//  Created by Shamshad Khan on 25/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameType.h"

@interface HomeScreenTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIView *iconBGView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


-(void)setGameType:(GameType*)type;

@end
