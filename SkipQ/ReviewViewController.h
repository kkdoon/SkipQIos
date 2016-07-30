//
//  ReviewViewController.h
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(atomic, weak)NSMutableArray *productList;

@end
