//
//  SGSViewController.m
//  SGSWebkit
//
//  Created by 961629701@qq.com on 03/26/2019.
//  Copyright (c) 2019 961629701@qq.com. All rights reserved.
//

#import "SGSViewController.h"
#import "SGSWebViewController.h"

@interface SGSViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SGSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"SGSWebkit";
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    UITableView *table = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.section];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SGSWebViewController *web = [[SGSWebViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    web.progressBar.tintColor = [UIColor yellowColor];
    [self.navigationController pushViewController:web animated:YES];
}

@end
