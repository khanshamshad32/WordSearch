//
//  HomeScreenViewController.m
//  Word Search
//
//  Created by Shamshad Khan on 25/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "HomeScreenTableCell.h"
#import "GridManager.h"
#import "SelectGameViewController.h"
#import "GamePlayerViewController.h"


#define kCellIdentifier @"HomeScreenTableCell"
#define kSelectGameSegueID @"HomeToSelectGame"
#define kGamePlayerSegueId @"HomeToGamePlayer"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

-(void)viewDidLoad
{
	[super viewDidLoad];
	[self setUpVC];
}

-(void)viewWillAppear:(BOOL)animated
{
	self.navigationController.navigationBar.hidden = YES;
	[super viewWillAppear:animated];
}

-(IBAction)onQuickPlayClick
{
	Game* game = [_gGridManager  getRandomGame];
	[self performSegueWithIdentifier:kGamePlayerSegueId sender:game];
}

#pragma mark - TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _tableDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	HomeScreenTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
	
	GameType* gameType = [_tableDataSource objectAtIndex:indexPath.row];
	[cell setGameType:gameType];
	return cell;
}

#pragma mark - TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSegueWithIdentifier:kSelectGameSegueID sender:[_tableDataSource objectAtIndex:indexPath.row]];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([segue.identifier isEqualToString:kSelectGameSegueID])
	{
		SelectGameViewController* des = segue.destinationViewController;
		des.gameType = sender;
	}
	else if([segue.identifier isEqualToString:kGamePlayerSegueId])
	{
		GamePlayerViewController* des = segue.destinationViewController;
		des.game = sender;
	}
}

#pragma mark - VC Initialiser
-(void)setUpVC
{
	_quickPlayButton.layer.cornerRadius = _quickPlayButton.frame.size.height/2;
	
	_tableDataSource = [_gGridManager getGameTypes];
	[_tableView reloadData];
}

@end
