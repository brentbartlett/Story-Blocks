//
//  LandingView.m
//  StoryBlocks
//
//  Created by Patrick Tescher on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LandingView.h"
#import "Story.h"
#import <CoreData/CoreData.h>
#import "SBAppDelegate.h"
#import "StoryEditor.h"
#import "StoryList.h"

@implementation LandingView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)chooseStories:(id)sender {
    StoryList *list = [[StoryList alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:list animated:YES];
    [list release];
}

- (IBAction)createStory:(id)sender {
    SBAppDelegate *appDelegate = (SBAppDelegate*)[[UIApplication alloc] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
//    NSManagedObjectModel *managedObjectModel = [[context persistentStoreCoordinator] managedObjectModel];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:context];
    Story *story = [[Story alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

    
    StoryEditor *editor = [[StoryEditor alloc] initWithNibName:nil bundle:nil];
    [editor setStory:story];
    [self.navigationController pushViewController:editor animated:YES];
    [editor release];
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
}

@end
