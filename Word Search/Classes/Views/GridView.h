//
//  GridView.h
//  Word Search
//
//  Created by Shamshad Khan on 23/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@class GridView;

#pragma mark - GridViewDelegate Protocol
@protocol GridViewDelegate <NSObject>

@required
-(void)gridView:(GridView*)gridView wordFound:(NSString*)word fromClues:(NSArray*)cluesArray;
-(void)gridView:(GridView*)gridView selectedWord:(NSString*)selectedWord;
-(void)allWordsFound:(GridView *)gridView;

@end

@interface GridView : UIView
{
	NSArray* _selectedIndexPaths;
	NSMutableArray* _matchedClues;
	NSIndexPath* _currentIndex;
	NSIndexPath* _startIndex;
	NSInteger _matchCount;
	
	CGFloat _cellWidth;
	CGFloat _cellHeight;
	CGFloat	_maxX;
	CGFloat _maxY;
	
	CAShapeLayer* _selectionLayer;
}

@property (strong, nonatomic) id<GridViewDelegate> delegate;
@property (strong, nonatomic) Game* game;

-(void)setUpGrid;
-(void)clearGridView;

@end
