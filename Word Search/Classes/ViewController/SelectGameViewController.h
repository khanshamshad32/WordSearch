//
//  SelectGameViewController.h
//  Word Search
//
//  Created by Shamshad Khan on 25/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameType.h"

@interface SelectGameViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *topBarIconIV;

@property (weak, nonatomic) IBOutlet UILabel *topBarTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topBarDescLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray* tableDataSource;
@property (assign, nonatomic) GameType* gameType;

-(IBAction)onBackClick;

@end
