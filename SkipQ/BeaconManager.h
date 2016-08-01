//
//  BeaconManager.h
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/31/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import "BeaconCallback.h"

@interface BeaconManager : NSObject
-(void)initWithDelegate:(id <BeaconCallback>) delegate;
- (void)invokeBeaconFound;
+(BeaconManager *)getInstance;
+(NSString *)getSectionName;
+(void)setSectionName:(NSString *)section;
@end

