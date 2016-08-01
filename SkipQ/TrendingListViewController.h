//
//  TrendingListViewController.h
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/29/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendingListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *dealsTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
- (IBAction)backButton:(id)sender;

//@property(atomic, weak)NSMutableArray *trendingList;

@end
