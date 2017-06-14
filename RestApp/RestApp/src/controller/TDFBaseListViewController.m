//
//  TDFBaseListViewController.m
//  RestApp
//
//  Created by zishu on 16/10/7.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFBaseListViewController.h"
#import "NameValueCell.h"
#import "ViewFactory.h"
#import "TDFIntroductionHeaderView.h"


@implementation TDFBaseListViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
}

-(UITableView *) tableView
{
    if (! _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor darkGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = self.tableHeaderView;
    }
    return _tableView;
}

- (void) initGrid
{
    self.tableView.opaque=NO;
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor clearColor];
    [self.tableView setTableFooterView:view];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [ViewFactory generateFooter:60];
}

- (TDFIntroductionHeaderView *)tableHeaderView
{
    if (!_tableHeaderView) {
        [self layoutTableHeaderView];
    }
    return _tableHeaderView;
}

- (void)layoutTableHeaderView
{
    UIImage *iconImage = [UIImage imageNamed:self.imageName];
    NSString *description = self.contents;
    @weakify(self);
    _tableHeaderView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description badgeIcon:nil detailTitle:@"查看详情" detailBlock:^{
        @strongify(self);
        [self showHelpDialog];
    }];
}

- (void)initPlaceHolderView
{
    self.bgView=[[UIView alloc]initWithFrame:CGRectMake(0,160, SCREEN_WIDTH, 160)];
    self.bgView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.bgView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 80, 120)];
    label.text= self.placeholderContents;
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor whiteColor];
    label.numberOfLines=0;
    [self.bgView addSubview:label];
}

- (void)showHelpDialog
{
    [self.delegate showHelpEvent:nil];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameValueCell * cell = [tableView dequeueReusableCellWithIdentifier:NameValueCellIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NameValueCell" owner:self options:nil].lastObject;
    }
    
    if (self.dataArray.count > 0 && indexPath.row < self.dataArray.count) {
        id<INameValueItem> item=(id<INameValueItem>)[self.dataArray objectAtIndex: indexPath.row];
        cell.lblName.text= [item obtainItemName];
        cell.lblVal.text=[item obtainItemValue];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row >= self.dataArray.count) {
        [self.tableView reloadData];
    } else {
        id<INameValueItem> item=(id<INameValueItem>)[self.dataArray objectAtIndex: row];
        [self.delegate showEditNVItemEvent:nil withObj:item];
    }
}

- (void) viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void) leftNavigationButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)footerHelpButtonAction:(UIButton *)sender
{
    [self.delegate showHelpEvent:nil];
}

- (void)footerAddButtonAction:(UIButton *)sender {
    [self.delegate showAddEvent:nil];
}

@end
