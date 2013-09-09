//
//  SavedRecords.h
//  0to60
//
//  Created by Chad D Grice on 2013-09-06.
//  Copyright (c) 2013 Iris Dynamics Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SavedRecords : NSManagedObject

@property (nonatomic, retain) NSString * savedmaxspeed;
@property (nonatomic, retain) NSString * saved0to60;
@property (nonatomic, retain) NSString * saved8th;
@property (nonatomic, retain) NSString * savedqtr;

@end
