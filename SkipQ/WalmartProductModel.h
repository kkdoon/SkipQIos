//
//  WalmartProductModel.h
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/29/16.
//  Copyright © 2016 CMU. All rights reserved.
//
@interface WalmartProductModel: NSObject{
}

@property (nonatomic) NSString *productName;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSNumber *msrp;
@property (nonatomic) NSNumber *quantity;

 -(id)initWithParams:(NSString *)productName :(NSNumber *)price :(NSNumber *)rating :(NSString *)imageUrl;
- (id)initWithParams:(NSString *)productName :(NSNumber *)price :(NSNumber *)msrp :(NSNumber *)rating :(NSString *)imageUrl;
@end
