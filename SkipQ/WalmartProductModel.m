//
//  WalmartProductModel.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/29/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalmartProductModel.h"

@implementation WalmartProductModel {
    // Private instance variables
}

- (id)initWithParams:(NSString *)productName :(NSNumber *)price :(NSNumber *)rating :(NSString *)imageUrl{
    self = [super init];
    if (self) {
        _productName = [productName copy];
        _price = [price copy];
        _rating = [rating copy];
        _imageUrl = [imageUrl copy];
    }
    return self;
}

- (id)initWithParams:(NSString *)productName :(NSNumber *)price :(NSNumber *)msrp :(NSNumber *)rating :(NSString *)imageUrl{
    self = [super init];
    if (self) {
        _productName = [productName copy];
        _price = [price copy];
        _msrp = [msrp copy];
        _rating = [rating copy];
        _imageUrl = [imageUrl copy];
    }
    return self;
}

@end