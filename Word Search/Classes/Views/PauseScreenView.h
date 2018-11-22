//
//  PauseScreenView.h
//  Word Search
//
//  Created by Shamshad Khan on 25/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,EPauseAction)
{
	EPauseActionResume=0,
	EPauseActionRestart,
	EPauseActionQuit
};

@interface PauseScreenView : UIView

@property (weak, nonatomic) IBOutlet UILabel* title;
@property (strong, nonatomic) void(^onCompletion)(EPauseAction action);
@property (strong, nonatomic) UIView* superView;

+(instancetype)loadPauseScreen;

-(void)showViewWithInfo:(NSString*)info;
-(void)hideView;
-(IBAction)onButtonClick:(id)sender;

@end

#define _gPauseScreen [PauseScreenView loadPauseScreen]
