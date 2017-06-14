//
//  TDFAddForceGoodView.m
//  RestApp
//
//  Created by hulatang on 16/8/2.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAddForceGoodView.h"
#import "TDFForceConfigVo.h"
//#import "OptionPickerBox.h"
#import "TDFForceMenuVo.h"
#import "EditItemList.h"
#import "TDFBaseCell.h"
#import "NameItemVO.h"
#import "TDFOptionPickerController.h"
@interface TDFAddForceGoodView ()<UITableViewDelegate,UITableViewDataSource,TDFBaseCellDelegate>

@property (nonatomic, strong)UIView *tableFooterView;

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation TDFAddForceGoodView
#pragma mark -- init

- (void)setForceConfig:(TDFForceConfigVo *)forceConfig
{
    if (!forceConfig) {
        forceConfig = [[TDFForceConfigVo alloc] init];
        forceConfig.forceNum = 1;
    }
    _forceConfig = forceConfig;
    [self initDataSource];
}

- (void)setForceMenuVo:(TDFForceMenuVo *)forceMenuVo
{
    _forceMenuVo = forceMenuVo;
    self.forceConfig = [forceMenuVo.forceConfigVo copy];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (TDFAddForceGoodView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutTableView];
    }
    return self;
}

- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    self.tableView.tableFooterView = isEdit?self.tableFooterView:nil ;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 20, SCREEN_WIDTH - 20, 30);
        [button setTitle:NSLocalizedString(@"去除必选商品", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_full_r.png"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 3;
        [button addTarget:self action:@selector(deleteMenuWithData:) forControlEvents:UIControlEventTouchUpInside];
        [_tableFooterView addSubview:button];
    }
    return _tableFooterView;
}

- (void)layoutTableView
{
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark -- dataArray
- (void)initDataSource{
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:@{@"name":NSLocalizedString(@"至少需要点的数量", nil),
                                @"dataArray":[TDFForceConfigVo forceTypeArray],
                                @"current":@(self.forceConfig.forceType),
                                @"hit":self.forceConfig.forceType != 1?@"":NSLocalizedString(@"注：商品数量跟顾客在顾客端输入用餐人数相同，商品会自动加入购物车中。", nil),
                                @"type":@(TDFTableViewCellTypePullDown),
                                @"id":@"forceType",
                                @"height":self.forceConfig.forceType != 1?@44:@80,
                                @"status":self.forceConfig.forceType==self.forceMenuVo.forceConfigVo.forceType?@(0):@(1)}];
    if (self.forceConfig.forceType != 1) {
        [self.dataArray addObject:@{@"name":NSLocalizedString(@"▪︎ 指定数量", nil),
                                    @"dataArray":[TDFForceConfigVo forceNumArray],
                                    @"current":self.forceConfig.forceNum?@(self.forceConfig.forceNum):@1,
                                    @"hit":NSLocalizedString(@"注：指定好必点商品数量后，顾客在顾客端点菜时，商品会自动加入购物车。", nil),
                                    @"type":@(TDFTableViewCellTypePullDown),
                                    @"id":@"forceNum",
                                    @"height":@80,
                                    @"status":self.forceConfig.forceNum==self.forceMenuVo.forceConfigVo.forceNum?@(0):@(1)}];
    }
    
    if (self.forceMenuVo.specList.count > 0) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < self.forceMenuVo.specList.count; i ++) {
            TDFForceSpecificationVo *makeVo = self.forceMenuVo.specList[i] ;
            NameItemVO *vo = [[NameItemVO alloc] initWithVal:makeVo.specName andId:makeVo.specId];
            [array addObject:vo];
        }
        
        [self.dataArray addObject:@{@"name":NSLocalizedString(@"规格", nil),
                                    @"isrequest":@1,
                                    @"dataArray":array,
                                    @"current":self.forceConfig.spec.specId?self.forceConfig.spec.specId:@"",
                                    @"hit":@"",
                                    @"type":@(TDFTableViewCellTypePullDown),
                                    @"id":@"specId",
                                    @"height":@44,
                                    @"status":self.forceConfig.spec.specId==self.forceMenuVo.forceConfigVo.spec.specId?@(0):@(1)}];
    }
    
    if (self.forceMenuVo.makeList.count > 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < self.forceMenuVo.makeList.count; i ++) {
            TDFForceMakeVo *makeVo = self.forceMenuVo.makeList[i] ;
            NameItemVO *vo = [[NameItemVO alloc] initWithVal:makeVo.makeName andId:makeVo.makeId];
            [array addObject:vo];
        }
        
        [self.dataArray addObject:@{@"name":NSLocalizedString(@"做法", nil),
                                    @"isrequest":@1,
                                    @"dataArray":array,
                                    @"current":self.forceConfig.make.makeId?self.forceConfig.make.makeId:@"",
                                    @"hit":@"",
                                    @"type":@(TDFTableViewCellTypePullDown),
                                    @"id":@"makeId",
                                    @"height":@44,
                                    @"status":self.forceConfig.make.makeId==self.forceMenuVo.forceConfigVo.make.makeId?@(0):@(1)}];
    }
    
    [self.tableView reloadData];

}

- (void)updateDataStatusWith:(NSInteger)index andNameItem:(NameItemVO *)itemVo
{
    NSDictionary *dic = self.dataArray[index];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([dic[@"id"] isEqualToString:@"forceType"]) {
        self.forceConfig.forceType = itemVo.itemId.intValue;
        dictionary[@"status"] = self.forceConfig.forceType==self.forceMenuVo.forceConfigVo.forceType?@(0):@(1);
        dictionary[@"hit"] = self.forceConfig.forceType != 1?@"":NSLocalizedString(@"注：商品数量跟顾客在顾客端输入用餐人数相同，商品会自动加入购物车中。", nil);
        dictionary[@"height"] = self.forceConfig.forceType != 1?@44:@80;
        if (self.forceConfig.forceType == 1) {
            for (NSDictionary *dic in self.dataArray) {
                if ([dic[@"id"] isEqualToString:@"forceNum"]) {
                    [self.dataArray removeObject:dic];
                    break;
                }
            }
        }else
        {
            BOOL isForceNum = NO;
            for (NSDictionary *dic in self.dataArray) {
                if ([dic[@"id"] isEqualToString:@"forceNum"]) {
                    isForceNum = YES;
                    break;
                }
            }
            if (!isForceNum) {
                [self.dataArray insertObject:@{@"name":NSLocalizedString(@"▪︎ 指定数量", nil),
                                               @"dataArray":[TDFForceConfigVo forceNumArray],
                                               @"current":self.forceMenuVo.forceConfigVo.forceNum?@(self.forceMenuVo.forceConfigVo.forceNum):@1,
                                               @"hit":NSLocalizedString(@"注：指定好必点商品数量后，顾客在顾客端点菜时，商品会自动加入购物车。", nil),
                                               @"type":@(TDFTableViewCellTypePullDown),
                                               @"id":@"forceNum",
                                               @"height":@80,
                                               @"status":self.forceConfig.forceNum==self.forceMenuVo.forceConfigVo.forceNum?@(0):@(1)} atIndex:1];
            }
           
        }
    }else if ([dic[@"id"] isEqualToString:@"forceNum"]){
        self.forceConfig.forceNum = itemVo.itemId.intValue;
        dictionary[@"status"] = self.forceConfig.forceNum==self.forceMenuVo.forceConfigVo.forceNum?@(0):@(1);
    }else if ([dic[@"id"] isEqualToString:@"makeId"]){
        self.forceConfig.make.makeId = itemVo.itemId;
        self.forceConfig.make.makeName = itemVo.itemName;
        dictionary[@"status"] = self.forceConfig.make.makeId==self.forceMenuVo.forceConfigVo.make.makeId?@(0):@(1);
    }else if ([dic[@"id"] isEqualToString:@"specId"]){
        self.forceConfig.spec.specId = itemVo.itemId;
        self.forceConfig.spec.specName = itemVo.itemName;
        dictionary[@"status"] = self.forceConfig.spec.specId==self.forceMenuVo.forceConfigVo.spec.specId?@(0):@(1);
    }
    [self.dataArray replaceObjectAtIndex:index withObject:dictionary];
    [self.tableView reloadData];
}

#pragma mark --UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = self.dataArray[indexPath.row];
   TDFBaseCell *cell = [TDFBaseCell getCellinTableView:tableView WithType:[dic[@"type"] integerValue] withInitData:dic];
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([dic[@"status"] intValue]==1) {
        NSString* current ;
        if ([dic[@"id"] isEqualToString:@"forceType"]) {
            current = [NSString stringWithFormat:@"%d",self.forceConfig.forceType];
        }else if ([dic[@"id"] isEqualToString:@"forceNum"]){
            current = [NSString stringWithFormat:@"%d",self.forceConfig.forceNum];
        }else if ([dic[@"id"] isEqualToString:@"makeId"]){
            current = self.forceConfig.make.makeId;
        }else if ([dic[@"id"] isEqualToString:@"specId"]){
            current = self.forceConfig.spec.specId;
        }
        for (id obj in dic[@"dataArray"]) {
            if ([obj isKindOfClass:[NameItemVO class]]) {
                NameItemVO* vo= (NameItemVO *)obj;
                if ([current isEqualToString:vo.itemId]) {
                    [cell changeDataWithValue:vo with:[dic[@"type"] integerValue]];
                    break;
                }
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArray.count) {
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        return [dic[@"height"] floatValue];
    }
    return 0;
}
#pragma mark --TDFBaseCellDelegate
- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType withCell:(TDFBaseCell *)cell
{
    NameItemVO *itemVo = (NameItemVO *)selectObj;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row < self.dataArray.count) {
        [self updateDataStatusWith:indexPath.row andNameItem:itemVo];
            BOOL status = 0;
            for (NSDictionary *dic in self.dataArray) {
                if ([dic[@"status"] intValue] == 1) {
                    status = 1;
                    break;
                }
            }
            if ([self.delegate respondsToSelector:@selector(changeEditStatus:)]) {
                [self.delegate changeEditStatus:status];
            }
    }
    return YES;
}

- (void)editItemList:(EditItemList *)obj withCell:(TDFBaseCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dic = [NSDictionary dictionary];
    if (indexPath.row < self.dataArray.count) {
        dic = self.dataArray[indexPath.row];
//        [OptionPickerBox initData:dic[@"dataArray"] itemId:[obj getStrVal]];
    }
//    [OptionPickerBox show:obj.lblName.text client:(id)cell event:cell.tag];
    
    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:obj.lblName.text
                                                                                  options:dic[@"dataArray"]
                                                                            currentItemId:[obj getStrVal]];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {
        
        [wself pickOption:dic[@"dataArray"][index] event:cell.tag withCell:cell];
    };
    
    [TDF_ROOT_NAVIGATION_CONTROLLER presentViewController:pvc animated:YES completion:nil];
    
}

#pragma mark --buttonClick
- (void)deleteMenuWithData:(UIButton *)button
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"确定删除此必选商品？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(deleteForceMenuWithData:)]) {
        [self.delegate deleteForceMenuWithData:self.forceConfig];
    }

}

@end
