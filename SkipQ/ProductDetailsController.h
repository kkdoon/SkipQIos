//
//  ProductDetailsController.h
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/28/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalmartProductModel.h"

@interface ProductDetailsController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelRating;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelQuantity;
@property (weak, nonatomic) IBOutlet UIStepper *stepperQuantity;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (nonatomic) WalmartProductModel *obj;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;
@property (weak, nonatomic) IBOutlet UIButton *btnCompare;
@property (weak, nonatomic) IBOutlet UIButton *btnAddCart;

- (IBAction)quantityValueChanged:(id)sender;
- (IBAction)addToCart:(id)sender;
- (IBAction)reviewCart:(id)sender;
- (IBAction)comparePrices:(id)sender;

@end
