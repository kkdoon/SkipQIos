//
//  ConfirmViewController.h
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelSubtotal;
@property (weak, nonatomic) IBOutlet UILabel *labelTax;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;

- (IBAction)downloadReceipt:(id)sender;

@end
