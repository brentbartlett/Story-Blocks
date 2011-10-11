//
//  StoryEditor.m
//  StoryBlocks
//
//  Created by Patrick Tescher on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StoryEditor.h"
#import "ImageDemoFilledCell.h"

@implementation StoryEditor
@synthesize story = _story;
@synthesize gridView = _gridView;

- (void)setStory:(Story*)story {
    if (_story != nil) {
        [_story release];
        _story = nil;
    }
    _story = [story retain];
}

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

#pragma mark -
#pragma mark Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
//    return ( [_imageNames count] );
    return 13;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    ImageDemoFilledCell *cell = (ImageDemoFilledCell *)[aGridView dequeueReusableCellWithIdentifier: @"ImageCell"];
    if ( cell == nil )
    {
        cell = [[[ImageDemoFilledCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 200.0, 150.0)
                                                 reuseIdentifier: @"ImageCell"] autorelease];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    cell.image = [UIImage imageNamed: @"BW-kitten.jpg"];
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return CGSizeMake(256, 256);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AQGridView *newGridView = [[AQGridView alloc] initWithFrame:self.gridView.frame];
    [self.gridView removeFromSuperview];
    self.gridView = newGridView;
    [self.view addSubview:self.gridView];
    
    self.gridView.dataSource = self;
    self.gridView.delegate = self;
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
    self.gridView.backgroundColor = [UIColor blackColor];

    [self.gridView reloadData];

}

- (void)viewDidUnload
{
    [self setGridView:nil];
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
    [_gridView release];
    [super dealloc];
}
@end
