//
//  ReviewCellViewController.h
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCellViewController : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *labelProd;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelQuantity;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
//@property (weak, nonatomic) IBOutlet UIStepper *stepperQuantity;

//- (IBAction)changeQuantity:(id)sender;

@end
