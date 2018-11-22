//
//  PauseScreenView.m
//  Word Search
//
//  Created by Shamshad Khan on 25/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "PauseScreenView.h"

#define kResumeTag 100
#define kRestartTag 101
#define kQuitTag 102

static PauseScreenView* sSharedInstance;


@implementation PauseScreenView

+(instancetype)loadPauseScreen
{
	if(!sSharedInstance)
	{
		static dispatch_once_t token;
		dispatch_once(&token, ^{
			sSharedInstance = [[[NSBundle mainBundle] loadNibNamed:@"PauseScreenXIB" owner:self options:nil] firstObject];
		});
	}
	return sSharedInstance;
}

-(void)showViewWithInfo:(NSString*)info
{
	_title.text = info;
	self.frame = _superView.frame;	
    __weak typeof(self) weakSelf = self;
	[UIView transitionWithView:_superView
					  duration:0.8
					   options:UIViewAnimationOptionCurveEaseInOut
					animations:^{
						[weakSelf.superView addSubview:weakSelf];
					}
					completion:NULL];
}

-(void)hideView
{
	[UIView transitionWithView:self
					  duration:0.8
					   options:UIViewAnimationOptionCurveEaseOut
					animations:^{
						[self removeFromSuperview];
					}
					completion:NULL];
}

-(IBAction)onButtonClick:(id)sender
{
	if(_onCompletion)
		switch(((UIButton*)sender).tag)
	{
		case kRestartTag :
			_onCompletion(EPauseActionRestart);
			break;
		case kQuitTag :
			_onCompletion(EPauseActionQuit);
			break;
		default :
			_onCompletion(EPauseActionResume);
	}
}

@end
