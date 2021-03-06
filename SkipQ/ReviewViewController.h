//
//  ReviewViewController.h
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconCallback.h"

@interface ReviewViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, BeaconCallback>
@property (weak, nonatomic) IBOutlet UITableView *cartTableView;
@property (weak, nonatomic) IBOutlet UILabel *labelItemCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;

//@property(atomic, weak)NSMutableArray *productList;
@property (strong) NSMutableArray *productList;
- (IBAction)clearCart:(id)sender;
- (IBAction)checkout:(id)sender;

@end
