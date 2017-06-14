//
//  TDFMenuSelectViewController.m
//  RestApp
//
//  Created by xueyu on 16/9/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMenuSelectViewController.h"
#import "SelectMenuItem.h"
#import "DHHeadItem.h"
@interface TDFMenuSelectViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TDFMenuSelectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"选择商品", nil);
    [self configLeftNavigationBar:@"ico_cancel" leftButtonName:NSLocalizedString(@"关闭", nil)];
     self.tableView = ({
        UITableView *view = [UITableView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        view.separatorStyle= UITableViewCellSeparatorStyleNone;
        view.backgroundColor = [UIColor clearColor];
        view.delegate = self;
        view.dataSource = self;
        view;
    });
}


#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
      id<INameValueItem> obj = self.data[section];
    return [obj obtainItems].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectMenuItem *detailItem = (SelectMenuItem *)[tableView dequeueReusableCellWithIdentifier:SelectMenuItemIndentifier];
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"SelectMenuItem" owner:self options:nil].lastObject;
    }
    id<INameValueItem> obj = self.data[indexPath.section];
    id<INameValueItem>item = [obj obtainItems][indexPath.row];
    [detailItem loadData:item];
    return detailItem;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id<INameValueItem> obj = self.data[indexPath.section];
    id<INameValueItem>item = [obj obtainItems][indexPath.row];
    if (self.callback) {
        self.callback(item);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DHHeadItem *headItem = [[[NSBundle mainBundle]loadNibNamed:@"DHHeadItem" owner:self options:nil]lastObject];
        id<INameValueItem> item = [self.data objectAtIndex:section];
        [headItem initWithData:item];
    return headItem;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

@end
