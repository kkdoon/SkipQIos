//
//  ReviewViewController.m
//  SkipQ
//
//  Created by Kanishk Karanawat on 7/30/16.
//  Copyright © 2016 CMU. All rights reserved.
//

#import "ReviewViewController.h"
#import "WalmartProductModel.h"
#import "ReviewCellViewController.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

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
    return [_productList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ReviewTableCell";
    
    ReviewCellViewController *cell = (ReviewCellViewController *)[tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    /*if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    WalmartProductModel *model =  [_productList objectAtIndex:indexPath.row];
    NSArray *words = [model.productName componentsSeparatedByString:@" "];
    NSString *word = [[NSString alloc] init];
    for(int i = 0; i < [words count]; i++){
        if(i <= 3){
            word = [[word stringByAppendingString:words[i]] stringByAppendingString:@" "];
        }else{
            word = [word stringByAppendingString:@"..."];
            break;
        }
    }
    cell.textLabel.text = word ;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.text = @([model.price doubleValue]).stringValue;*/

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    WalmartProductModel *model =  [_productList objectAtIndex:indexPath.row];
    NSArray *words = [model.productName componentsSeparatedByString:@" "];
    NSString *word = [[NSString alloc] init];
    for(int i = 0; i < [words count]; i++){
        if(i <= 3){
            word = [[word stringByAppendingString:words[i]] stringByAppendingString:@" "];
        }else{
            word = [word stringByAppendingString:@"..."];
            break;
        }
    }
    
    cell.labelProd.text = word;
    cell.labelPrice.text = @([model.price doubleValue]).stringValue;
    cell.labelQuantity.text = @([model.rating doubleValue]).stringValue;
    cell.labelTotalPrice.text = @([model.price doubleValue]).stringValue;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
