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
    NSMutableArray *trendingList;
    double selectedSavings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _labelDealsTtile.text = [NSString stringWithFormat:@"Deals of the Day: %@", _sectionName];
    _dealsTable.hidden = true;
    _loadingIndicator.hidden = false;
    [_loadingIndicator startAnimating];
    // Send asynchronous request
    NSString *url = @"http://api.walmartlabs.com/v1/trends?format=json&apiKey=29848w8q74kj8q5c54rbkqna";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil)
        {
            WalmartProductModel *row;
            trendingList = [NSMutableArray arrayWithObjects: nil];
            
            NSMutableDictionary *allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; //data in serialized view
            NSArray* itemList = allData[@"items"];
            for (NSDictionary* item in itemList)
            {
                NSString *category = item[@"categoryPath"];
                //if(category != nil && [category containsString:@"Electronics"]){
                if(category != nil && [category containsString:_sectionName]){
                    row = [[WalmartProductModel alloc] initWithParams:item[@"name"]:item[@"salePrice"]:item[@"msrp"]:item[@"customerRating"]:item[@"largeImage"]];
                    row.upcCode = item[@"upc"];
                    row.productUrl = item[@"productUrl"];
                    [trendingList addObject:row];
                }
                //NSLog(@"item: %@, price: %@, msrp: %@, rating: %@, imageUrl: %@", obj.productName, obj.price, obj.msrp, obj.rating, obj.imageUrl);
            }
            for(WalmartProductModel *obj in trendingList){
                NSLog(@"Row: item: %@, price: %@, msrp: %@, rating: %@, imageUrl: %@", obj.productName, obj.price, obj.msrp, obj.rating, obj.imageUrl);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_loadingIndicator stopAnimating];
                [_dealsTable reloadData];
                _dealsTable.hidden = false;
            });
        }
    }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [trendingList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TrendingTable";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    WalmartProductModel *model =  [trendingList objectAtIndex:indexPath.row];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    double savings = [model.msrp doubleValue] - [model.price doubleValue];
    savings = (savings / [model.msrp doubleValue]) * 100;
    NSString *savingString = [formatter stringFromNumber:[NSNumber numberWithDouble:savings]];
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
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Savings:%@%%", savingString];
    }else{
        cell.detailTextLabel.text = @"Savings: Not Available";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedModel = [trendingList objectAtIndex:indexPath.row];
    double savings = [selectedModel.msrp doubleValue] - [selectedModel.price doubleValue];
    if([selectedModel.msrp doubleValue] != 0){
        selectedSavings = (savings / [selectedModel.msrp doubleValue]) * 100;
    }else{
        selectedSavings =  -1;
    }
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
        destViewController.obj.productUrl = selectedModel.productUrl;
        destViewController.isDeal = true;
        destViewController.savings = selectedSavings;
        destViewController.upcCode = selectedModel.upcCode;
        destViewController.sectionName = _sectionName;
        NSLog(@"Segue completed");
    }
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
@end
