//
//  GridScreenViewController.h
//  Word Search
//
//  Created by Shamshad Khan on 19/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridManager.h"
#import "GridView.h"

@interface GamePlayerViewController : UIViewController<GridViewDelegate>
{
	NSInteger _timerCount;
	NSTimer* _timer;
	NSInteger _foundCluesCount;
}

@property (strong, nonatomic) UIActivityIndicatorView* spinner;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordFoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedItemsLabel;

@property (weak, nonatomic) IBOutlet UIView *baseGridView;
@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (strong, nonatomic) IBOutlet GridView* gridView;

@property (strong, nonatomic) NSThread* gridDataThread;

@property (strong, nonatomic) Game* game;

-(IBAction)onPlayButtonClick;

@end
