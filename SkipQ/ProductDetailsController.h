//
//  ProductDetailsController.h
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/28/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalmartProductModel.h"
#import "BeaconCallback.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FBSDKShareKit/FBSDKShareKit.h"

@interface ProductDetailsController : UIViewController<BeaconCallback>
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelRating;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelQuantity;
@property (weak, nonatomic) IBOutlet UIStepper *stepperQuantity;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;
@property (weak, nonatomic) IBOutlet UIButton *btnCompare;
@property (weak, nonatomic) IBOutlet UIButton *btnAddCart;
@property (weak, nonatomic) IBOutlet UILabel *labelDeal;
@property (nonatomic) WalmartProductModel *obj;
@property (nonatomic) Boolean isDeal;
@property (nonatomic) double savings;
@property (nonatomic) NSString *upcCode;

- (IBAction)quantityValueChanged:(id)sender;
- (IBAction)addToCart:(id)sender;
- (IBAction)reviewCart:(id)sender;
- (IBAction)comparePrices:(id)sender;
- (IBAction)backButton:(id)sender;
@end
