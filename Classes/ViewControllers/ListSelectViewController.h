//
//  ListSelectViewController.h
//  UltimateScorer
//
//  Created by Richard Chang on 2/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameState.h"

@interface ListSelectViewController : UITableViewController {
	SEL updateModelMethod;
	NSArray *options;  // options
	NSString *currentOption;  // currently selected option
	GameState *gameState;   // model object
	UITableView *parentTableView;  
}

@property (nonatomic, retain) NSArray *options;
@property (nonatomic, retain) NSString *currentOption;
@property (nonatomic, assign) SEL updateModelMethod;
@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, retain) UITableView *parentTableView;
@end
