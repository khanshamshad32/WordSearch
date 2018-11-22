//
//  GridScreenViewController.m
//  Word Search
//
//  Created by Shamshad Khan on 19/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "GamePlayerViewController.h"
#import "PauseScreenView.h"
#import "UIColor+WSColor.h"

#define kClueIndexTagConstant 200
#define kCornerRadius 5
#define kBorderWidth 1

@interface GamePlayerViewController ()

@end

@implementation GamePlayerViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setUpVC];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self getDataForVC];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[_gridDataThread cancel];
	[super viewWillDisappear:animated];
}

-(IBAction)onPlayButtonClick
{
	[_gPauseScreen showViewWithInfo:_game.title];
	[self pause];
}

#pragma mark - GridView delegate
-(void)gridView:(GridView *)gridView selectedWord:(NSString *)selectedWord
{
	self.selectedItemsLabel.text = selectedWord;
}

-(void)gridView:(GridView *)gridView wordFound:(NSString *)word fromClues:(NSArray*)cluesArray
{
	NSInteger index = [cluesArray indexOfObject:word];
	
	UILabel* clueLabel = [self.view viewWithTag:index+kClueIndexTagConstant];
	clueLabel.textColor = [UIColor lightGrayColor];
	_selectedItemsLabel.text = word;
	_wordFoundLabel.text = [NSString stringWithFormat:@"%ld / %lu",(long)++_foundCluesCount,(unsigned long)cluesArray.count];
}

-(void)allWordsFound:(GridView *)gridView
{
	[self showAlert];
	[self stopGame];	
}

#pragma mark -
-(void)setUpVC
{
	_selectedItemsLabel.layer.cornerRadius = kCornerRadius;
	_selectedItemsLabel.layer.borderWidth = kBorderWidth;
	self.view.backgroundColor = [UIColor colorFromString:_game.colorName alph:100];
	self.selectedItemsLabel.textColor = [UIColor colorFromString:_game.colorName alph:100];
	self.timerView.backgroundColor = [UIColor colorFromString:_game.colorName alph:100];
	[self setPauseScreen];
}

-(void)getDataForVC
{
	[self showSpinner];
	__weak typeof(self) weakSelf = self;
	_gridDataThread = [[NSThread alloc]initWithBlock:^{
		
        [_gGridManager createGame:weakSelf.game completion:^(Game *game) {
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.game = game;
                    [weakSelf hideSpinner];
                    [weakSelf setUpGridView];
                    [weakSelf play];
                });
            }];
	}];
	[_gridDataThread start];
}

-(void)setUpGridView
{
	_gridView = [[GridView alloc]initWithFrame:_baseGridView.frame];
	_gridView.game = _game;
	_gridView.delegate = self;
	[_gridView setUpGrid];
	[self.view addSubview:_gridView];
	
	[self setUpClues];
}

-(void)setUpClues
{
	_wordFoundLabel.text = [NSString stringWithFormat:@"0 / %lu",(unsigned long)_game.cluesArray.count];
	
	for(int i=0; i<kMaxClueCount; i++)
	{
		UILabel* clueLabel = [self.view viewWithTag:i+kClueIndexTagConstant];
		clueLabel.textColor = [UIColor whiteColor];
		
		if(i < _game.cluesArray.count)
			clueLabel.text = [_game.cluesArray objectAtIndex:i];
		else
			clueLabel.hidden = YES;
	}
}

-(void)setPauseScreen
{
	_gPauseScreen.backgroundColor = [UIColor  colorFromString:_game.colorName alph:100];
	_gPauseScreen.superView = self.view;
	
	__weak typeof(self) weakSelf = self;
	_gPauseScreen.onCompletion = ^(EPauseAction action) {
		
		switch(action)
		{
			case EPauseActionRestart :
				[weakSelf restartGame];
				break;
			case EPauseActionResume :
				[weakSelf play];
				break;
			case EPauseActionQuit :
				[weakSelf quitGame];
		}
		[_gPauseScreen hideView];
	};
}

#pragma mark - Timer methods
-(void)play
{
	_timerLabel.text = [NSString stringWithFormat:@"%.2ld : %.2ld",_timerCount/60,_timerCount%60];
	_timer = [NSTimer scheduledTimerWithTimeInterval:1.0
											  target:self
											selector:@selector(changeTime)
											userInfo:nil
											 repeats:YES];
}

-(void)pause
{
	[_timer invalidate];
}

-(void)restartGame
{
	[self stopGame];
	[self.gridView clearGridView];
	[self setUpClues];
	[self play];
}

-(void)stopGame
{
	[self pause];
	_timerCount = 0;
}

-(void)changeTime
{
	_timerCount++;
	_timerLabel.text = [NSString stringWithFormat:@"%.2ld : %.2ld",_timerCount/60,_timerCount%60];
}

-(void)quitGame
{
	[_gridView removeFromSuperview];
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Spinner
-(void)showSpinner
{
	_spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_spinner.hidesWhenStopped = YES;
	_spinner.center = self.view.center;
	[_spinner startAnimating];
	[self.view addSubview:_spinner];
}

-(void)hideSpinner
{
	[_spinner stopAnimating];
}

#pragma mark - Alert
-(void)showAlert
{
	NSString* timeString = [NSString stringWithFormat:@"   %.2ld : %.2ld",_timerCount/60,_timerCount%60];
	
	NSString* message = [NSLocalizedString(@"time", nil) stringByAppendingString:timeString];
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"complete", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
	
	__weak typeof(self) weakSelf = self;
	UIAlertAction* action = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf dismissViewControllerAnimated:YES completion:nil];
	}];
	
	[alert addAction:action];
	[self presentViewController:alert animated:YES completion:nil];
}

@end
