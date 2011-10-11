//
//  Image.h
//  StoryBlocks
//
//  Created by Patrick Tescher on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StoryImage : NSManagedObject

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSManagedObject *story;

@end
