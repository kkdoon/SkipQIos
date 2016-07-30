//
//  TrendingListViewController.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/29/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import "TrendingListViewController.h"
#import "WalmartProductModel.h"
#import "ProductDetailsController.h"

@interface TrendingListViewController ()

@end

@implementation TrendingListViewController
    WalmartProductModel *selectedModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_trendingList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TrendingTable";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    WalmartProductModel *model =  [_trendingList objectAtIndex:indexPath.row];
    double savings = [model.msrp doubleValue] - [model.price doubleValue];
    savings = (savings / [model.msrp doubleValue]) * 100;
    /*cell.textLabel.text = [NSString stringWithFormat:@"@% Savings:$@%", model.productName, @(savings).stringValue];*/
    NSArray *words = [model.productName componentsSeparatedByString:@" "];
    NSString *word = [[NSString alloc] init];
    for(int i = 0; i < [words count]; i++){
        if(i <= 10){
            word = [[word stringByAppendingString:words[i]] stringByAppendingString:@" "];
        }else{
            word = [word stringByAppendingString:@"..."];
            break;
        }
    }
    cell.textLabel.text = word;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    if(model.msrp != nil){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Savings:%@%%", @(savings).stringValue];
    }else{
        cell.detailTextLabel.text = @"Savings: Not Available";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedModel = [_trendingList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showProductInfoFromTrending" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProductInfoFromTrending"]) {
        ProductDetailsController *destViewController = segue.destinationViewController;
        destViewController.obj = [[WalmartProductModel alloc] initWithParams:selectedModel.productName:selectedModel.price:selectedModel.rating:selectedModel.imageUrl];
    }
}
@end
