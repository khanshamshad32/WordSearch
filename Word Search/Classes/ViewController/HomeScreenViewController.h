//
//  HomeScreenViewController.h
//  Word Search
//
//  Created by Shamshad Khan on 25/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreenViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* tableDataSource;
@property (weak, nonatomic) IBOutlet UIButton *quickPlayButton;

-(IBAction)onQuickPlayClick;

@end
