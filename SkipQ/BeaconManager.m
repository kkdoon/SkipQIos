//
//  BeaconManager.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/31/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconManager.h"
#import "BeaconCallback.h"

@interface BeaconManager ()

@end

@implementation BeaconManager

static BeaconManager *instance;
static NSString *sectionName;

NSMutableArray *callbackObj;

/*- (id)init
{
    self = [super init];
    if (self != nil) {
        if(instance == nil){
            instance = [[BeaconManager alloc] init];
        }
    }
    return self;
}*/

+(BeaconManager *)getInstance{
    /*if(instance == nil){
        [self init];
    }*/
    //[self init];
    if(instance == nil){
        instance = [[BeaconManager alloc] init];
        sectionName = [[NSString alloc] init];
    }
    return instance;
}

-(void)initWithDelegate:(id <BeaconCallback>) delegate{
    if(callbackObj == nil){
         callbackObj = [[NSMutableArray alloc] initWithObjects:nil];
    }
    [callbackObj addObject:delegate];
    /*self = [super init];
    if(self) {
        self.delegate = delegate
    }
    return self;*/
}

-(void)invokeBeaconFound{
    for(int i =0; i < [callbackObj count]; i++){
        id<BeaconCallback> obj = (id <BeaconCallback>)callbackObj[i];
        [obj beaconFound];        
    }
}

+(NSString *)getSectionName{
    return sectionName;
}

+(void)setSectionName:(NSString *)section{
    NSLog(@"section name manager1: %@", section);
    sectionName = [section copy];
    NSLog(@"section name manager: %@", sectionName);
}



@end