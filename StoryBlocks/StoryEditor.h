//
//  StoryEditor.h
//  StoryBlocks
//
//  Created by Patrick Tescher on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import "AQGridView.h"

@interface StoryEditor : UIViewController <AQGridViewDelegate,AQGridViewDataSource>

@property (retain, nonatomic) Story *story;
@property (retain, nonatomic) IBOutlet AQGridView *gridView;

@end
