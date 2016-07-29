//
//  ViewController.h
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/28/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

- (IBAction)getData:(id)sender;
@end

