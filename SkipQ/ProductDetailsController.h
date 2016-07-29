//
//  ProductDetailsController.h
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/28/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailsController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelRating;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelQuantity;
@property (weak, nonatomic) IBOutlet UIStepper *stepperQuantity;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;

@property (copy) NSString *productName;
@property (copy) NSNumber *price;
@property (copy) NSNumber *rating;
@property (copy) NSString *imageUrl;

- (IBAction)quantityValueChanged:(id)sender;

@end
