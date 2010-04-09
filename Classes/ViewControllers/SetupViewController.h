//
//  SetupViewController.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 2/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameState.h";

@interface SetupViewController : UIViewController {
    IBOutlet UITableView *setupTableView;
    GameState *gameState;	
}

@property (nonatomic, retain) UITableView *setupTableView;
@property (nonatomic, retain) GameState *gameState;

@end
