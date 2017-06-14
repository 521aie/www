//
//  ZMTable.m
//  RestApp
//
//  Created by zxh on 14-7-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "ZMTable.h"
#import "UIHelper.h"
#import "ZmTableCell.h"
#import "UIView+Sizes.h"
#import "INameValueItem.h"
#import "Masonry.h"
#import "PantryEditView.h"

@implementation ZMTable

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ZMTable" owner:self options:nil];
    CGRect frame = self.view.frame;
    frame.size.width = SCREEN_WIDTH;
    self.view.frame = frame;
    [self addSubview:self.view];
    [self initGrid];
}

- (UITableView *)mainGrid {
    if(!_mainGrid) {
        _mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 178) style:UITableViewStylePlain];
        _mainGrid.delegate = self;
        _mainGrid.dataSource = self;
        _mainGrid.backgroundColor = [UIColor clearColor];
    }
    return _mainGrid;
}

- (UIView *)footView {
    if(!_footView) {
        _footView = [[UIView alloc] init];
        _footView.backgroundColor = [UIColor clearColor];
        _footView.frame = CGRectMake(0, 180, SCREEN_WIDTH, 44);
        [_footView addSubview:self.lblName];
        [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_footView.mas_centerX);
            make.centerY.equalTo(_footView.mas_centerY);
        }];
        
        UIImageView *icon = [[UIImageView alloc] init];
        [icon setImage:[UIImage imageNamed:@"ico_add_rr.png"]];
        [_footView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.width.mas_offset(22);
            make.centerY.equalTo(_footView.mas_centerY);
            make.right.equalTo(self.lblName.mas_left).with.offset(-5);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.1;
        [_footView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(1);
            make.bottom.equalTo(_footView.mas_bottom);
            make.left.equalTo(_footView.mas_left).with.offset(10);
            make.right.equalTo(_footView.mas_right).with.offset(-10);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_footView);
        }];
        
    }
    return _footView;
}

- (UILabel *)lblName {
    if(!_lblName) {
        _lblName = [[UILabel alloc] init];
        _lblName.font = [UIFont systemFontOfSize:15];
        _lblName.textColor = [UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1];
        _lblName.text = NSLocalizedString(@"添加此促销内商品", nil);
    }
    return _lblName;
}

- (void)initGrid
{
    [self.view addSubview:self.mainGrid];
    [self.view addSubview:self.footView];
    
    self.mainGrid.opaque=NO;
    self.mainGrid.scrollEnabled=NO;
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event kindName:(NSString*)kindName addName:(NSString*)addName itemMode:(NSInteger)mode
{
    self.delegate=delegate;
    self.event=event;
    self.itemMode=mode;
    self.kindName=kindName;
    self.addName=addName;
    self.lblName.text=addName;
    self.isDelWaring = YES;
}

- (void)initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event kindName:(NSString*)kindName addName:(NSString*)addName itemMode:(NSInteger)mode isWaring:(BOOL)isWaring
{
    self.delegate=delegate;
    self.event=event;
    self.itemMode=mode;
    self.kindName=kindName;
    self.addName=addName;
    self.lblName.text=addName;
    self.isDelWaring = isWaring;
}



- (void)loadData:(NSMutableArray *)dataList detailCount:(NSUInteger)detailCount
{
    self.dataList = dataList;
    self.detailCount = detailCount;
    NSUInteger height = (dataList==nil || dataList.count==0)?0:(dataList.count*44);
    [self.mainGrid setHeight:height];
    if (self.isChain) {
        [self.view setHeight:height];
        [self.footView setHeight:0];
        
        [self setHeight:height];
    }else{
        [self.view setHeight:height+44];
        [self.footView setTop:height];
        
        [self setHeight:height+44];
    }
    [self.mainGrid reloadData];
}

#pragma mark UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZmTableCell *detailItem = (ZmTableCell *)[tableView dequeueReusableCellWithIdentifier:ZmTableCellIndentifier];
    
    if (!detailItem) {
        detailItem = [[NSBundle mainBundle] loadNibNamed:@"ZmTableCell" owner:self options:nil].lastObject;
    }
    
    if (self.dataList.count > 0 && indexPath.row < self.dataList.count) {
        id<INameValueItem> item = [self.dataList objectAtIndex:indexPath.row];
        [detailItem initDelegate:self obj:item event:self.event itemMode:self.itemMode];
        if (self.isChain) {
            detailItem.btnAct.userInteractionEnabled = NO;
            [detailItem.lblVal mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(detailItem.lblName.mas_centerY);
                make.right.equalTo(detailItem.btnAct.mas_right).with.offset(-10);
                make.height.mas_equalTo(43);
                make.left.equalTo(detailItem.lblName.mas_right).with.offset(0);
            }];
            detailItem.imgAct.hidden = YES;
            detailItem.lblVal.textColor = [UIColor grayColor];
        }else{
            detailItem.btnAct.userInteractionEnabled = YES;
            [detailItem.lblVal mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(detailItem.lblName.mas_centerY);
                make.right.equalTo(detailItem.btnAct.mas_left).with.offset(-8);
                make.height.mas_equalTo(43);
                make.left.equalTo(detailItem.lblName.mas_right).with.offset(0);
            }];
            
            detailItem.imgAct.hidden = NO;
            detailItem.lblVal.textColor = [ColorHelper getBlueColor];
        }
        if ([self.delegate isKindOfClass:[PantryEditView class]]) {
            detailItem.lblVal.text = @"";
        }
        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.dataList.count==0?0:self.dataList.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> item=[self.dataList objectAtIndex:indexPath.row];
    [self.delegate showEditNVItemEvent:self.event withObj:item];
}

#pragma btnAdd ...
- (IBAction)btnAddClick:(id)sender
{
    [self.delegate showAddEvent:self.event];
}

#pragma del确认包装.
- (void)delObjEvent:(NSString*)event obj:(id) obj
{
    self.currObj=(id<INameValueItem>)obj;
    if (self.isDelWaring) {
        [UIHelper alert:self andDelegate:self andTitle:[NSString stringWithFormat:NSLocalizedString(@"确认要删除[%@]吗？", nil),[self.currObj obtainItemName]]];
    } else{
        [self.delegate delObjEvent:self.event obj:self.currObj];
    }
    
}

- (void)showEditNVItemEvent:(NSString*)event withObj:(id<INameValueItem>) obj
{
    [self.delegate showEditNVItemEvent:self.event withObj:obj];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.delegate delObjEvent:self.event obj:self.currObj];
    }
}

- (void)visibal:(BOOL)show
{
    [self setHeight:show?60:0];
    self.alpha=show?1:0;
}

@end
