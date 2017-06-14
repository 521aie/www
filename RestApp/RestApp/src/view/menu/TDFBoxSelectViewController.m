//
//  TDFBoxSelectViewController.m
//  RestApp
//
//  Created by 栀子花 on 16/8/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFBoxSelectViewController.h"
#import "HeadNameItem.h"
#import "NSString+Estimate.h"
#import "TDFMediator+MenuModule.h"
#import "UIHelper.h"
#import "AlertBox.h"
#import "TDFSettingService.h"
#import "YYModel.h"
#import "KeyBoardUtil.h"
#import "ServiceFactory.h"
#import <Mantle.h>
#define HEADERVIEW_HEIGHT 44
#define ROW_HEIGHT 40

@interface TDFBoxSelectViewController()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath *_seleceCell;
    MBProgressHUD *_hud;
    UIView *tableHeaderView;
}

@property (nonatomic, strong) UIView *searchPanelView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) NSMutableArray *searchDataSource;
@property (nonatomic,assign) BOOL isSearchModel;
@property (nonatomic,strong)TDFSettingService *service;

@end

@implementation TDFBoxSelectViewController

-(TDFSettingService *)service
{
    if (!_service) {
        _service = [[TDFSettingService alloc]init];
    }
    return _service;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if (_dataArray.count >0) {
        self.imge.hidden = YES;
        self.tableHeaderView.hidden = NO;
        self.midLabel.hidden =YES;
        self.bottLabel.hidden = YES;
        [self.tableView reloadData];
    }else
    {
        self.imge.hidden = NO;
        self.tableHeaderView.hidden = YES;
        self.midLabel.hidden =NO;
        self.bottLabel.hidden = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMainView];
    self.title = NSLocalizedString(@"餐盒选择", nil);

    [self configLeftNavigationBar:Head_ICON_BACK leftButtonName:NSLocalizedString(@"返回", nil)];
    [self configRightNavigationBar:nil rightButtonName:nil];

//    [self configNavigationBar:YES];
    [self requestTogetAllBoxSelectList];
}



-(void)rightNavigationButtonAction:(UIButton *)button
{
    [super rightNavigationButtonAction:button];
    if (self.callBack) {
        self.callBack(self.packingBoxVo.menuName,self.packingBoxVo.price,self.packingBoxVo.menuId);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initMainView
{
    [self.view addSubview:self.searchPanelView];
    [self.searchPanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(-40);
    }];
        [self layoutTableView];
    
        self.imge = [[UIImageView alloc]init];
        [self.view addSubview:self.imge];
       self.imge.image= [UIImage imageNamed:@"xiaoer@2x.png"];
        [self.imge mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.view).offset(100);
            make.width.equalTo(@85);
            make.height.equalTo(@60);
            make.right.equalTo(@((SCREEN_WIDTH - 85)/2.));
            
        }];
    
        self.midLabel = [[UILabel alloc]init];
        self.midLabel.text = NSLocalizedString(@"您还没有添加带有餐具标签的商品！", nil);
        self.midLabel.textAlignment = NSTextAlignmentCenter;
        self.midLabel.font = [UIFont systemFontOfSize:14];
        self.midLabel.textAlignment = NSTextAlignmentCenter;
        self.midLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:self.midLabel];
        [self.midLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.imge.mas_bottom).with.offset(10);
            make.left.equalTo(self.view.mas_left).with.offset(30);
             make.right.equalTo(self.view.mas_right).with.offset(-30);
            make.height.mas_equalTo(30);
        }];
    
    
    self.bottLabel = [[UILabel alloc]init];
     self.bottLabel.text = NSLocalizedString(@"添加步骤如下：火掌柜-商品-添加新商品（如餐盒）-标签（选择“餐具”）-价格-保存。", nil);
    self.bottLabel.font = [UIFont systemFontOfSize:12];
    self.bottLabel.textColor = [UIColor whiteColor];
    self.bottLabel.numberOfLines = 0;
    [self.view addSubview:self.bottLabel];
     [self.bottLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.midLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
         make.height.mas_equalTo(40);
    }];
    
}

- (void)layoutTableView{
    self.tableView = [[UITableView alloc]init];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = ROW_HEIGHT;
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.searchPanelView.mas_bottom);
    }];
}

- (UIView *)tableHeaderView
{
    if (!tableHeaderView) {
        [self layoutHeaderView];
    }
    return tableHeaderView;
}

- (UIView *)searchPanelView {
    if(!_searchPanelView) {
        _searchPanelView = [[UIView alloc] init];
        _searchPanelView.backgroundColor = [UIColor colorWithWhite:0.33 alpha:0.75];
        [_searchPanelView.layer setCornerRadius:PANEL_OUTTER_CORNER_RADIUS];
        _searchPanelView.hidden = YES;
        
        UIView *panelBg = [[UIView alloc] initWithFrame:CGRectMake(6, 3,SCREEN_WIDTH * 266/320.0, 34)];
        panelBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        [_searchPanelView addSubview:panelBg];
        
        UIImageView *searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 22, 22)];
        searchImg.backgroundColor = [UIColor clearColor];
        searchImg.image = [UIImage imageNamed:@"ico_search.png"];
        [_searchPanelView addSubview:searchImg];
        [_searchPanelView addSubview:self.searchTextField];
        
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 268/320.0, 5, 46, 30)];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancleBtn.titleLabel.textColor = [UIColor whiteColor];
        [cancleBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
        [_searchPanelView addSubview:cancleBtn];
    }
    return _searchPanelView;
}

- (UITextField *)searchTextField {
    if(!_searchTextField) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(34, 5,SCREEN_WIDTH * 233/320.0, 32)];
        _searchTextField.font = [UIFont systemFontOfSize:14];
        _searchTextField.textColor = [UIColor whiteColor];
        _searchTextField.backgroundColor = [UIColor clearColor];
        _searchTextField.textAlignment = NSTextAlignmentLeft;
        _searchTextField.placeholder = NSLocalizedString(@"输入名称", nil);
        [_searchTextField setDelegate:self];
        [_searchTextField setValue:[UIColor whiteColor]  forKeyPath:@"_placeholderLabel.textColor"];
        [KeyBoardUtil initWithTarget:_searchTextField];
    }
    return _searchTextField;
}

#pragma mark -initTableHeaderView
- (void)layoutHeaderView
{
    tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH , 50)];
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH -30, 30)];
    bottomLabel.font = [UIFont systemFontOfSize:11];
    bottomLabel.textColor =[UIColor grayColor];
    bottomLabel.numberOfLines = 0;
    bottomLabel.text = NSLocalizedString(@"注：此列表中展示的商品为您在掌柜-商品-标签中设置了“餐具”的商品。", nil);
    [tableHeaderView addSubview:bottomLabel];
}

#pragma mark --UItableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < self.dataArray.count) {
        TDFPackingBoxKindVo *menuVo = self.dataArray[section];
        HeadNameItem *headNameItem = [[HeadNameItem alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [headNameItem initWithName:menuVo.kindMenuName];
        return headNameItem;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERVIEW_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.isSearchModel) {
        return self.dataArray.count;
    }else{
        return self.searchDataSource.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isSearchModel) {
            TDFPackingBoxKindVo *menuVo = self.dataArray[section];
            return menuVo.packingBoxVoList.count;
    }else{
        TDFPackingBoxKindVo *menuVo = self.searchDataSource[section];
        return menuVo.packingBoxVoList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.imageView.image = [UIImage imageNamed:@"ico_uncheck.png"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.imageView.layer.cornerRadius = 5;
        cell.imageView.clipsToBounds = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor grayColor];
        [cell addSubview:line];

        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(10);
            make.top.equalTo(cell.contentView.mas_top).offset(10);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
            make.width.equalTo(cell.imageView.mas_height);
        }];
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.imageView.mas_right).offset(15);
            make.top.equalTo(cell.contentView.mas_top).offset(10);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
        }];
        [cell.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
            make.top.equalTo(cell.contentView.mas_top).offset(10);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-10);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(@1);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.left.equalTo(cell.contentView.mas_left).offset(10);
            make.top.equalTo(cell.contentView.mas_bottom).offset(1);
        }];
    }

    if(!self.isSearchModel) {
    if (indexPath.section < self.dataArray.count) {
      TDFPackingBoxKindVo *kindMenuVo = self.dataArray[indexPath.section];
       if (indexPath.row < kindMenuVo.packingBoxVoList.count) {
                TDFPackingBoxVo *menuVo = kindMenuVo.packingBoxVoList[indexPath.row];
                cell.textLabel.text = menuVo.menuName;
                cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"¥%.2lf", nil),menuVo.price];
           if (menuVo.isSelected) {
               cell.imageView.image = [UIImage imageNamed:@"ico_check.png"];
           }else
           {
               cell.imageView.image =[UIImage imageNamed:@"ico_uncheck.png"];
           }
    }
        }
    }else {
            TDFPackingBoxKindVo *kindMenuVo = self.searchDataSource[indexPath.section];
             TDFPackingBoxVo * menuVo = kindMenuVo.packingBoxVoList[indexPath.row];
            cell.textLabel.text = menuVo.menuName;
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"¥%.2lf", nil),menuVo.price];
        if (menuVo.isSelected) {
            cell.imageView.image = [UIImage imageNamed:@"ico_check.png"];
        }else
        {
            cell.imageView.image =[UIImage imageNamed:@"ico_uncheck.png"];
        }

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_seleceCell == indexPath) {
        return;
    }
    
    [self configLeftNavigationBar:Head_ICON_CANCEL leftButtonName:NSLocalizedString(@"取消", nil)];
    [self configRightNavigationBar:Head_ICON_OK rightButtonName:NSLocalizedString(@"保存", nil)];
    TDFPackingBoxKindVo *kindMenuVo ;
    if (self.searchDataSource && indexPath.section < self.searchDataSource.count) {
        kindMenuVo = self.searchDataSource[indexPath.section];
    }else if (indexPath.section < self.dataArray.count) {
        
        kindMenuVo = self.dataArray[indexPath.section];
    }
    
    for (TDFPackingBoxKindVo *kindVo in self.dataArray) {
        for (TDFPackingBoxVo *vo in kindVo.packingBoxVoList) {
            vo.isSelected = NO;
        }
    }
    if (kindMenuVo) {
        if (indexPath.row <kindMenuVo.packingBoxVoList.count) {
            self.packingBoxVo =kindMenuVo.packingBoxVoList[indexPath.row];
//            UITableViewCell  *selectCell = [tableView cellForRowAtIndexPath:_seleceCell];
//            selectCell.imageView.image =[UIImage imageNamed:@"ico_uncheck.png"];
//            UITableViewCell  *cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.imageView.image =[UIImage imageNamed:@"ico_check.png"];
//            _seleceCell = indexPath;
            self.packingBoxVo.isSelected = YES;
        }
    }

    
    
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     cell.imageView.image = [UIImage imageNamed:@"ico_uncheck.png"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTextField resignFirstResponder];
    NSString *keyword = textField.text;
    if ([NSString isNotBlank:keyword]) {
        self.isSearchModel = YES;
        [self.searchTextField becomeFirstResponder];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"menuName contains %@", keyword];
        if (!_searchDataSource) {
            _searchDataSource = [NSMutableArray array];
        }else
        {
            [_searchDataSource removeAllObjects];
        }
        
         for( TDFPackingBoxKindVo *obj  in self.dataArray) {
        
             NSArray *array = [obj.packingBoxVoList filteredArrayUsingPredicate:predicate];
             TDFPackingBoxKindVo *temp = [[TDFPackingBoxKindVo alloc] init];
             temp.packingBoxVoList = array;
             if (temp.packingBoxVoList.count!=0) {
                    [_searchDataSource  addObject:temp];
             }
          
         }
        [self.tableView reloadData];
    }else{
        self.isSearchModel = NO;
    }
    return YES;
}

- (void)cancelSearch
{
    self.isSearchModel = NO;
    self.searchTextField.text = @"";
    [self hideDHSearchBar];
    [self.searchTextField resignFirstResponder];
    [self.searchDataSource removeAllObjects];
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.tableView reloadData];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.searchPanelView.hidden) {
        CGPoint point = scrollView.contentOffset;
        if (0 - point.y >= 44) {
            [self.searchTextField becomeFirstResponder];
            [self showDHSearchBar];
        }
    }
}

- (void)showDHSearchBar
{
    self.searchPanelView.hidden = NO;
    [self.searchPanelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)hideDHSearchBar
{
    [self.searchPanelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(-40);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.searchPanelView.hidden = YES;
    }];
}
#pragma mark --boxSelectData
- (void)requestTogetAllBoxSelectList
{
    UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
    if (!_hud) {
        _hud = [[MBProgressHUD alloc]initWithView:mainWindow];
    }
    [UIHelper showHUD:NSLocalizedString(@"正在加载", nil) andView:mainWindow  andHUD:_hud];
    @weakify(self);
    [self.service getBoxSelectList:^(NSURLSessionDataTask *_Nonnull task,id _Nonnull data){
        @strongify(self);
        [_hud hide:YES];
        NSMutableArray *array = [NSMutableArray array];
        NSArray *dataArray = [data objectForKey:@"data"];
        for (NSDictionary  *dic in dataArray ) {
            TDFPackingBoxKindVo *menuVo = [TDFPackingBoxKindVo yy_modelWithDictionary:dic];
            [array addObject:menuVo];
        }
        self.dataArray = array;
        for (TDFPackingBoxKindVo *kindVo in self.dataArray) {
            for (TDFPackingBoxVo *vo in kindVo.packingBoxVoList) {
                if ( [self.packingBoxId isEqualToString: vo.menuId]) {
                    vo.isSelected = YES;
                }else
                {
                    vo.isSelected = NO;
                }

            }
        }
      
    }failure:^(NSURLSessionDataTask *_Nonnull task,NSError *_Nonnull error ){
        [_hud hide: YES];
        [AlertBox show:error.localizedDescription];
    }];
}
@end
