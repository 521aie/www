//
//  TDFSuitMenuPrinterView.m
//  RestApp
//
//  Created by 黄河 on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSuitMenuPrinterModel.h"
#import "TDFSuitMenuPrinterView.h"
#import "TDFHeadNameItemView.h"

@interface TDFSuitMenuPrinterView()<UITableViewDelegate,UITableViewDataSource,FooterListEvent>
@property (nonatomic ,strong)TDFIntroductionHeaderView *tableHeaderView;

@end
@implementation TDFSuitMenuPrinterView

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (TDFIntroductionHeaderView *)tableHeaderView
{
    if (!_tableHeaderView) {
        [self layoutTableHeaderView];
    }
    return _tableHeaderView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
        [self addSubview:_tableView];
    }
    return _tableView ;
}

- (FooterListView *)footerListView
{
    if (!_footerListView) {
        _footerListView = [[FooterListView alloc] init];
        [_footerListView awakeFromNib];
        _footerListView.frame = CGRectMake(0, self.bounds.size.height - _footerListView.view.bounds.size.height, self.bounds.size.width, _footerListView.view.bounds.size.height);
        [self addSubview:_footerListView];
    }
    return _footerListView;
}
#pragma mark --initView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self initTableView];
        [self initFooterListView];
    }
    return self;
}

- (void)initTableView
{
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
}

- (void)initFooterListView{
    [self.footerListView setBackgroundColor:[UIColor clearColor]];
    NSArray *array = [[NSArray alloc] initWithObjects:@"add", nil];
    [self.footerListView initDelegate:self btnArrs:array];
    [self.footerListView showHelp:YES];
}

- (void)layoutTableHeaderView
{
    UIImage *iconImage = [UIImage imageNamed:@"ico_suitmenuprinter.png"];
    NSString *description = @"如果您在传菜方案中设置了一菜一切，但套餐打印时某些分类不需要一菜一切，可以在此处设置。\n此处设置仅在套餐打印时生效，普通商品打印仍然按照传菜方案中的设置。";
    @weakify(self);
    _tableHeaderView = [TDFIntroductionHeaderView headerViewWithIcon:iconImage description:description badgeIcon:nil detailTitle:@"查看详情" detailBlock:^{
        @strongify(self);
        [self showHelpDialog];
    }];
}
#pragma mark --UITableViewDataSource,UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TDFHeadNameItemView *headNameItem = [[TDFHeadNameItemView alloc] init];
    headNameItem.titleLabel.text = NSLocalizedString(@"套餐中不一菜一切的商品分类", nil);
    return headNameItem;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < self.dataArray.count) {
        return 44;
    }
    
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        view.image = [UIImage imageNamed:@"ico_block"];
        cell.accessoryView = view;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < self.dataArray.count) {
        TDFSuitMenuPrinterModel *printModel = self.dataArray[indexPath.row];
        cell.textLabel.text = printModel.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count) {
        TDFSuitMenuPrinterModel *model = self.dataArray[indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"您确认要删除[%@]分类吗？", nil),model.name] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = indexPath.row +10;
        [alert show];
    }

    
}


#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag - 10 < self.dataArray.count) {
            [self.dataArray removeObjectAtIndex:alertView.tag - 10];
            if ([self.delegate respondsToSelector:@selector(deletedInfoArray:)]) {
                [self.delegate deletedInfoArray:self.dataArray];
            }
        }
    }
}

#pragma mark --FooterListEvent
- (void)showAddEvent
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addNewSuitMenuPrinter)]) {
        [self.delegate addNewSuitMenuPrinter];
    }
}

- (void)showHelpEvent
{
    if ([self.delegate respondsToSelector:@selector(showHelpPage:)]) {
        [self.delegate showHelpPage:@"suitMenuPrinter"];
    }

}

#pragma mark --buttonClick
- (void)showHelpDialog
{
    if ([self.delegate respondsToSelector:@selector(showHelpPage:)]) {
        [self.delegate showHelpPage:@"suitMenuPrinter"];
    }
}

@end
