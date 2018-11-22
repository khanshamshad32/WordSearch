//
//  GridView.m
//  Word Search
//
//  Created by Shamshad Khan on 23/05/17.
//  Copyright © 2017 Shamshad Khan. All rights reserved.
//

#import "GridView.h"
#import "NSString+WSString.h"
#import "UIColor+WSColor.h"
#import "GridManager.h"

@implementation GridView

-(void)setUpGrid
{
	_maxX = self.frame.size.width;
	_maxY = self.frame.size.height;
	_cellWidth  = _maxX/kGridSize;
	_cellHeight = _maxY/kGridSize;
	
	for(int i=0; i<kGridSize; i++)
		for(int j=0; j<kGridSize; j++)
		{
			NSArray* row = [_game.gridArray objectAtIndex:i];
			GridItem* item = [row objectAtIndex:j];
			
			CGRect rect = CGRectMake(j*_cellWidth, i*_cellHeight, _cellWidth, _cellHeight);
			UILabel* label = [self labelWithFrame:rect text:[item stringValue]];
			[self addSubview:label];
		}
	[self addPenGesture];
	_matchedClues = [[NSMutableArray alloc]init];
}

-(UILabel*)labelWithFrame:(CGRect)rect text:(NSString*)text
{
	UILabel* label = [[UILabel alloc]initWithFrame:rect];
	label.backgroundColor = [UIColor clearColor];
	label.text = text;
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor darkGrayColor];
	label.font = [UIFont boldSystemFontOfSize:20];
	return label;
}

-(void)clearGridView
{
	_matchedClues = [[NSMutableArray alloc]init];
	_selectedIndexPaths = nil;
	for(CALayer* layer in self.layer.sublayers)
		if([layer isKindOfClass:[CAShapeLayer class]])
			[layer removeFromSuperlayer];
}

#pragma mark - PanGesture
-(void)addPenGesture
{
	UIPanGestureRecognizer* gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
	[gesture setMaximumNumberOfTouches:1];
	[self addGestureRecognizer:gesture];
}

-(void)move:(UIPanGestureRecognizer*)sender
{
	CGPoint point = [sender locationInView:sender.view];	
	NSIndexPath* index = [self indexPathFromPoint:point];
	
	if(sender.state == UIGestureRecognizerStateBegan)
		_startIndex = index;
	
	else if (sender.state == UIGestureRecognizerStateEnded)
	{
		[self matchForClue];
		_currentIndex = nil;
		_startIndex = nil;
		return;
	}
	if(!index || [index isEqual:_currentIndex])
		return;
	_currentIndex = index;
	if([self canDrawLineFrom:_startIndex to:_currentIndex])
		[self makeTemporarySelection];
}

-(void)matchForClue
{
	[self removePreviousTemporarySelection];
	
	NSMutableString* result = [NSMutableString string];
	for(NSIndexPath* indexPath in _selectedIndexPaths)
	{
		GridItem* item = _game.gridArray[indexPath.section][indexPath.row];
		[result appendString:[NSString stringWithFormat:@"%c",item.value]];
	}
	
	NSString* reverseResult = [result reverseString];
	
	if([_matchedClues containsObject:result] || [_matchedClues containsObject:reverseResult])
		return;
	
	for(NSString* clue in  _game.cluesArray)
	{
		if([result isEqualToString:clue] || [reverseResult isEqualToString:clue])
		{
			[self makePermanentSelection];
			[_delegate gridView:self wordFound:clue fromClues:_game.cluesArray];
			_matchCount++;
			[_matchedClues addObject:clue];
			break;
		}
	}
	
	if(_matchCount == _game.cluesArray.count)
		[_delegate	allWordsFound:self];
}

#pragma mark -
-(void)makeTemporarySelection
{
	[self removePreviousTemporarySelection];
	
	NSMutableString* word = [NSMutableString string];
	_selectedIndexPaths = [self indexPathsFrom:_startIndex and:_currentIndex];
	
	for(NSIndexPath* index in _selectedIndexPaths)
	{
		NSArray* section = _game.gridArray[index.section];
		GridItem* row = section[index.row];
		[word appendString:[NSString stringWithFormat:@" %c",row.value]];
		
		UILabel* cell = [self labelAtIndex:index];
		if(cell)
			[self startShake:cell];
	}
	
	[self showSelectionFrom:_startIndex end:_currentIndex];
	[_delegate gridView:self selectedWord:word];
}

-(void)removePreviousTemporarySelection
{
	[_selectionLayer removeFromSuperlayer];
	[_delegate gridView:self selectedWord:@""];
}

-(void)makePermanentSelection
{
	_selectionLayer.fillColor = [UIColor colorFromString:_game.colorName alph:40].CGColor;
	[self.layer addSublayer:_selectionLayer];
	_selectionLayer = nil;
}

-(void)showSelectionFrom:(NSIndexPath*)start end:(NSIndexPath*)end
{
	UIBezierPath* path = [self getBezierPathFrom:start end:end];
	CAShapeLayer* layer = [CAShapeLayer layer];
	layer.path = path.CGPath;
	layer.strokeColor = [UIColor colorFromString:_game.colorName alph:40].CGColor;
	layer.fillColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.4f].CGColor;
	layer.lineWidth = 3;
	
	_selectionLayer = layer;
	[self.layer addSublayer:layer];
}

#pragma mark - Bezier Path
-(UIBezierPath*)getBezierPathFrom:(NSIndexPath*)start end:(NSIndexPath*)end
{
	CGPoint c1 = CGPointMake( ((CGFloat)start.row + 0.5)*_cellWidth, ((CGFloat)start.section + 0.5)*_cellHeight);
	CGPoint c2 = CGPointMake( ((CGFloat)end.row + 0.5)*_cellWidth, ((CGFloat)end.section + 0.5)*_cellHeight);
	CGPoint p;
	CGFloat sAngle;
	CGFloat eAngle;
	CGFloat r = _cellWidth/2 - 3;
	EDirection d = [GridManager directionFromPoint:start to:end];
	switch(d)
	{
		case EDirectionRIGHT :
			sAngle = M_PI/2;	eAngle = 1.5*M_PI;
			p = CGPointMake(c2.x, c2.y-r);
			break;
		case EDirectionLEFT :
			sAngle = 1.5*M_PI;	eAngle = M_PI/2;
			p = CGPointMake(c2.x, c2.y+r);
			break;
		case EDirectionDOWN :
			sAngle = M_PI;	eAngle = 0;
			p = CGPointMake(c2.x+r, c2.y);
			break;
		case EDirectionUP :
			sAngle = 0;	eAngle = M_PI;
			p = CGPointMake(c2.x-r, c2.y);
			break;
		case EDirectionDOWNRIGHT :
			sAngle = 3*M_PI/4;	eAngle = 7*M_PI/4;
			p = CGPointMake(c2.x + r*cos(M_PI/4), c2.y - r*sin(M_PI/4));
			break;
		case EDirectionUPLEFT :
			sAngle = 7*M_PI/4;	eAngle = 3*M_PI/4;
			p = CGPointMake(c2.x + r*cos(5*M_PI/4), c2.y - r*sin(5*M_PI/4));
			break;
		case EDirectionUPRIGHT :
			sAngle = M_PI/4;	eAngle = 5*M_PI/4;
			p = CGPointMake(c2.x + r*cos(3*M_PI/4), c2.y - r*sin(3*M_PI/4));
			break;
		case EDirectionDOWNLEFT :
			sAngle = 5*M_PI/4;	eAngle = M_PI/4;
			p = CGPointMake(c2.x + r*cos(7*M_PI/4), c2.y - r*sin(7*M_PI/4));
			break;
	}
	UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:c1 radius:r startAngle:sAngle
													  endAngle:eAngle clockwise:YES];
	[path addLineToPoint:p];
	[path addArcWithCenter:c2 radius:r startAngle:eAngle endAngle:sAngle clockwise:YES];
	[path closePath];
	return path;
}

#pragma mark -
-(NSArray*)indexPathsFrom:(NSIndexPath*)start and:(NSIndexPath*)end
{
	NSIndexPath* index = start;
	EDirection d = [GridManager directionFromPoint:start to:end];
	NSMutableArray* result = [[NSMutableArray alloc]init];
	[result addObject:index];
	
	while(!(index.row == end.row && index.section == end.section))
	{
		index = [GridManager shiftPoint:index direction:d];
		[result addObject:index];
	}
	return result;
}

-(UILabel*)labelAtIndex:(NSIndexPath*)index
{
	NSInteger labelIndex = index.section*kGridSize + index.row;
	UIView* view = [self.subviews objectAtIndex:labelIndex];
	return ([view isKindOfClass:[UILabel class]]) ? (UILabel*)view : nil;
}
#pragma mark - Line
-(BOOL)canDrawLineFrom:(NSIndexPath*)pointX to:(NSIndexPath*)pointY
{
	if([self isHorizontalLine:pointX and:pointY] || [self isVerticalLine:pointX and:pointY] ||
	   [self isDiagonal:pointX and:pointY])
		return YES;
	return NO;
}

-(BOOL)isHorizontalLine:(NSIndexPath*)pointA and:(NSIndexPath*)pointB
{
	return (pointA.section == pointB.section) ? YES : NO;
}

-(BOOL)isVerticalLine:(NSIndexPath*)pointA and:(NSIndexPath*)pointB
{
	return (pointA.row == pointB.row) ? YES : NO;
}

-(BOOL)isDiagonal:(NSIndexPath*)pointA and:(NSIndexPath*)pointB
{
	return (ABS([self slopOfLineFrom:pointA and:pointB]) == 1) ? YES : NO;
}

-(BOOL)isLeadingDiagonal:(NSIndexPath*)pointA and:(NSIndexPath*)pointB
{
	return ([self slopOfLineFrom:pointA and:pointB] == 1) ? YES : NO;
}

-(NSInteger)slopOfLineFrom:(NSIndexPath*)pointA and:(NSIndexPath*)pointB
{
	NSInteger a = pointA.section - pointB.section;
	NSInteger b = pointA.row - pointB.row;
	
	return (b!=0 && ABS(a) == ABS(b)) ? a/b : INT_MAX;
}

-(NSIndexPath*)indexPathFromPoint:(CGPoint)point
{
	if(point.x < 0 || point.y < 0 || point.x >= _maxX || point.y >= _maxY)
		return nil;
	
	return [NSIndexPath indexPathForRow:point.x/_cellWidth inSection:point.y/_cellHeight];
}

#pragma mark - Shake
-(void)startShake:(UIView*)view
{
	CGAffineTransform leftShake = CGAffineTransformMakeTranslation(-2, 0);
	CGAffineTransform rightShake = CGAffineTransformMakeTranslation(2, 0);
	
	view.transform = leftShake;		//	starting point
	
	[UIView beginAnimations:@"shake_button" context:(__bridge void * _Nullable)(view)];
	[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(shakeEnded:finished:context:)];
	
	view.transform = rightShake;
	
	[UIView commitAnimations];
}

-(void)shakeEnded:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
	if ([finished boolValue])
	{
		UIView* item = (__bridge UIView *)context;
		item.transform = CGAffineTransformIdentity;
	}
}

@end
