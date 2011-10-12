//
//  Slideshow.m
//  StoryBlocks
//
//  Created by Patrick Tescher on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Slideshow.h"
#import "StoryEditor.h"
#import "StoryImage.h"

@implementation Slideshow
@synthesize scrollView;

@synthesize images;
@synthesize story;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)setStory:(Story *)aStory {
    [story release];
    story = [aStory retain];
    self.images = [[NSMutableArray alloc] init];
    for (StoryImage *image in aStory.images) {
        [self.images addObject:[UIImage imageNamed:image.imageName]];
    }
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];

}

- (void)edit {
    if (self.story != nil) {
        StoryEditor *editor = [[StoryEditor alloc] initWithNibName:nil bundle:nil];
        [editor setStory:self.story];
        [self.navigationController pushViewController:editor animated:YES];
        [editor release];
    }
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
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * self.images.count, self.scrollView.frame.size.height)];
    for (UIImage *image in self.images) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(self.scrollView.frame.size.width * [images indexOfObject:image], 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:imageView];
        [imageView release];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * self.images.count, self.scrollView.frame.size.height)];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [scrollView release];
    [super dealloc];
}
@end
