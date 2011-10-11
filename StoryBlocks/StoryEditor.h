//
//  StoryEditor.h
//  StoryBlocks
//
//  Created by Patrick Tescher on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import "AQGridViewController.h"

@interface StoryEditor : UIViewController

@property (nonatomic, retain) Story *story;
@property (nonatomic, retain) AQGridViewController *gridViewController;

@end
