//
//  StoryEditor.m
//  StoryBlocks
//
//  Created by Patrick Tescher on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StoryEditor.h"
#import "ImageDemoFilledCell.h"
#import "Slideshow.h"
#import "StoryImage.h"

@implementation StoryEditor
@synthesize nameField;
@synthesize story = _story;
@synthesize gridView = _gridView;
@synthesize images;
@synthesize imageDatabase;
@synthesize imageNames;
@synthesize storyImages;

- (void)save {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setStory:(Story*)story {
    if (_story != nil) {
        [_story release];
        _story = nil;
    }
    _story = [story retain];
    self.images = [[NSMutableArray alloc] init];
    for (StoryImage* image in self.story.images) {
        [self.images addObject:[UIImage imageNamed:image.imageName]];
    }
    self.imageDatabase = [[NSMutableArray alloc] init];
    self.imageNames = [[NSMutableArray alloc] init];
    NSArray * paths = [NSBundle pathsForResourcesOfType: @"jpg" inDirectory: [[NSBundle mainBundle] bundlePath]];
    
    for ( NSString * path in paths )
    {
        [self.imageDatabase addObject: [UIImage imageNamed:[path lastPathComponent]]];
        [self.imageNames addObject: [path lastPathComponent]];
    }
    
    [self.storyImages reloadData];
    [self.gridView reloadData];
    self.title = story.name;
    [self.nameField setText:story.name];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
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
#pragma mark Grid View Delegate

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    [self.images addObject:[self.imageDatabase objectAtIndex:index]];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:self.story.managedObjectContext];
    
    StoryImage *storyImage = [[StoryImage alloc] initWithEntity:description insertIntoManagedObjectContext:self.story.managedObjectContext];
    storyImage.imageName = [self.imageNames objectAtIndex:index];
    storyImage.story = self.story;
    
    NSLog(@"Added an image, now have %d images", self.images.count);
    [self.imageDatabase removeObjectAtIndex:index];
    [self.imageNames removeObjectAtIndex:index];
    [gridView deleteItemsAtIndices:[NSIndexSet indexSetWithIndex:index] withAnimation:AQGridViewItemAnimationFade];
    [self.storyImages reloadData];
}
     


#pragma mark Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return self.imageDatabase.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    ImageDemoFilledCell *cell = (ImageDemoFilledCell *)[aGridView dequeueReusableCellWithIdentifier: @"ImageCell"];
    if ( cell == nil )
    {
        cell = [[[ImageDemoFilledCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 204, 204)
                                                 reuseIdentifier: @"ImageCell"] autorelease];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    cell.image = [self.imageDatabase objectAtIndex:index];
    cell.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return CGSizeMake(256, 256);
}

#pragma mark - Table view stuff

- (int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"NewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.clipsToBounds = TRUE;
    }
    
//    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 240, 240)];
    cell.imageView.image = [self.images objectAtIndex:indexPath.row];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.clipsToBounds = YES;
//    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
//    [cell addSubview:imageView];
//    [imageView release];
    
    return cell;
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
    [self setStoryImages:nil];
    [self setNameField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    NSError *error = [[NSError alloc] init];
    [[self.story managedObjectContext] save:&error];
}

- (void)dealloc {
    [_gridView release];
    [storyImages release];
    [nameField release];
    [super dealloc];
}

- (IBAction)preview:(id)sender {
    Slideshow *slideshow = [[Slideshow alloc] initWithNibName:nil bundle:nil];
    [slideshow setImages:self.images];
    [self.navigationController pushViewController:slideshow animated:YES];
    [slideshow release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)changedName:(id)sender {
    self.story.name = self.nameField.text;
    self.title = self.nameField.text;
}
@end
