//
//  SelectGameViewController.m
//  Word Search
//
//  Created by Shamshad Khan on 25/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "SelectGameViewController.h"
#import "SelectGameTableCell.h"
#import "GridManager.h"
#import "UIColor+WSColor.h"
#import "GamePlayerViewController.h"

#define kCellIdentifier @"SelectGameTableCell"
#define kToGamePlayerSegueId @"SelectGameToGamePlayer"


@interface SelectGameViewController ()

@end

@implementation SelectGameViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setUpVC];
}

-(IBAction)onBackClick
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _tableDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SelectGameTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
	
	Game* game = [_tableDataSource objectAtIndex:indexPath.row];
	[cell setGame:game];
	return cell;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSegueWithIdentifier:kToGamePlayerSegueId sender:[_tableDataSource objectAtIndex:indexPath.row]];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([segue.identifier isEqualToString:kToGamePlayerSegueId])
	{
		GamePlayerViewController* des = segue.destinationViewController;
		des.game = sender;
	}
}

#pragma mark - VC Initialiser
-(void)setUpVC
{
	_tableDataSource = [_gGridManager getPuzzleForType:_gameType];
	[_tableView reloadData];
	
	_topBarView.backgroundColor = [UIColor colorFromString:_gameType.colorName alph:100];
	_topBarIconIV.image = [UIImage imageNamed:_gameType.imageName];
	_topBarTitleLabel.text = _gameType.title;
	_topBarDescLabel.text = [NSString stringWithFormat:@"%ld %@",(long)_gameType.puzzlesCount,
							 NSLocalizedString(@"puzzle", nil)];
}

@end
