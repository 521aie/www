//
//  TDFMenuListPanel.m
//  RestApp
//
//  Created by 刘红琳 on 2017/5/19.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFMenuListPanel.h"
#import "TDFNormalSearchBar.h"
#import <ReactiveObjC.h>
#import "GlobalRender.h"
#import "MenuItemCell.h"
#import "MenuItemTopCell.h"
#import "DHHeadItem.h"
#import "FormatUtil.h"
#import "UIView+Sizes.h"
#import "ColorHelper.h"
#import "ViewFactory.h"
#define DH_HEAD_HEIGHT 40
#define DH_SEARCHBAR_HEIGHT 40
#define DH_IMAGE_CELL_ITEM_HEIGHT 88
#define DH_BIG_IMAGE_CELL_ITEM_HEIGHT 230

@interface TDFMenuListPanel()<UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) TDFNormalSearchBar *searchBar;

@end

@implementation TDFMenuListPanel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMainView];
    }
    return self;
}

- (void) initMainView
{
    [self addSubview:self.headView];
    self.headView.hidden = YES;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    [self addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48);
        make.top.equalTo(self.headView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self. mas_right);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self. mas_right);
    }];
    
    [self addSubview:self.searchBigButton];
    [self.searchBigButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
    self.tableView.tableFooterView = [ViewFactory generateFooter:76];
}

#pragma mark - Get Set
- (TDFNormalSearchBar *)searchBar {
    if(!_searchBar) {
        _searchBar = [TDFNormalSearchBar searchBar];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"商品名称";
    }
    return _searchBar;
}

-(UIView *) headView
{
    if (!_headView) {
        _headView = [[UIView alloc]init];
        _headView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        _headView.tag = 100;
        [self addSubview:_headView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 31)];
        label.text = @"注：本店的商品与套餐是由总部管理，暂无法添加，如需添加，请联系总部。";
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [ColorHelper getRedColor];
        label.numberOfLines = 0;
        [_headView addSubview:label];
        return _headView;
    }
    return _headView;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque=NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 76, 0);
    }
    return _tableView;
}

- (UIButton *)searchBigButton {
    if(!_searchBigButton) {
        _searchBigButton = [[UIButton alloc] init];
        _searchBigButton.hidden = YES;
        @weakify(self);
        [[_searchBigButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self endEditing:YES];
            if(self.searchBar.text.length > 0) {
                [self.searchBar cancelButtonEnable:YES show:YES];
            }else {
                 [self.searchBar cancelButtonEnable:YES show:NO];;
            }
        }];
    }
    return _searchBigButton;
}

#pragma mark 分类按钮点击方法
- (void)categrayButtonAction {
    [self.delegate categrayButtonAction];
}

#pragma table 处理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *details = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:details]) {
            SampleMenuVO *menu = (SampleMenuVO *)[details objectAtIndex:indexPath.row];
            if ([menu isTopMenu] && indexPath.section == 0) {
                MenuItemTopCell *detailItem = (MenuItemTopCell *)[tableView dequeueReusableCellWithIdentifier:MenuItemTopCellIdentifier];
                if (detailItem == nil) {
                    detailItem = [MenuItemTopCell getInstance];
                }
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return [self renderMenuItemTopCell:detailItem menu:menu];
            } else {
                MenuItemCell *detailItem = (MenuItemCell *)[tableView dequeueReusableCellWithIdentifier:MenuItemCellIndentifier];
                if (detailItem == nil) {
                    detailItem = [MenuItemCell getInstance];
                }
                detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
                return [self renderMenuItemCell:detailItem menu:menu];
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.headList.count > indexPath.section) {
        id<INameValueItem> item = [self.headList objectAtIndex:indexPath.section];
        if (item != nil) {
            NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
            if (details != nil) {
                id<IImageDataItem> item=[details objectAtIndex: indexPath.row];
                [self.delegate selectObj:item];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<INameValueItem> item = [self.headList objectAtIndex:section];
    if (item != nil) {
        NSMutableArray *details = [self.detailMap objectForKey:[item obtainItemId]];
        if (details != nil) {
            return details.count;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DHHeadItem *headItem = [[[NSBundle mainBundle]loadNibNamed:@"DHHeadItem" owner:self options:nil]lastObject];
    [self.headerItems addObject:headItem];
    if (self.headList.count > section) {
        id<INameValueItem> item = [self.headList objectAtIndex:section];
        [headItem initWithData:item];
    }
    return headItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.headList!=nil?self.headList.count:0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<INameValueItem> head = [self.headList objectAtIndex:indexPath.section];
    if ([ObjectUtil isNotNull:head]) {
        NSMutableArray *details = [self.detailMap objectForKey:[head obtainItemId]];
        if ([ObjectUtil isNotEmpty:details]) {
            SampleMenuVO *menu = (SampleMenuVO *)[details objectAtIndex:indexPath.row];
            if ([menu isTopMenu] && indexPath.section == 0) {
                return 230;
            } else {
                return 88;
            }
        }
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (MenuItemCell *)renderMenuItemCell:(MenuItemCell *)detailItem menu:(SampleMenuVO *)menu
{
    [detailItem loadItem:menu delegate:self.delegate];
    if (menu.chain == 0) {
        detailItem.lblIschain.hidden = YES;
    }else{
        detailItem.lblIschain.hidden = NO;
    }
    if (menu.memberPrice!=menu.price) {
        NSString* val=[NSString stringWithFormat:NSLocalizedString(@"￥%@", nil), [FormatUtil formatDouble5:menu.price]];
        detailItem.lblDetail.text=val;
        detailItem.lblDetail.textColor=[UIColor redColor];
        [detailItem.lblDetail sizeToFit];
        [detailItem.lblAccount setLeft:(detailItem.lblDetail.left+detailItem.lblDetail.width+2)];
        detailItem.lblAccount.textColor=[UIColor redColor];
        [detailItem.lblAccount sizeToFit];
        [detailItem.lblAccount setNeedsDisplay];
        detailItem.lblRedLine.frame =CGRectMake(detailItem.lblDetail.frame.origin.x, detailItem.lblDetail.frame.origin.y+9, detailItem.lblDetail.frame.size.width+detailItem.lblAccount.frame.size.width, 1);
        NSString* OriginVal =[NSString stringWithFormat:NSLocalizedString(@"￥%@ /%@", nil),[FormatUtil formatDouble5:menu.memberPrice],[menu showUnit]];
        detailItem.lblOriginPrice.text=OriginVal;
        detailItem.lblOriginPrice.textColor =[UIColor colorWithRed:0 green:204/255.0f blue:0 alpha:1];
        [detailItem.lblOriginPrice setLeft:(detailItem.lblAccount.left + detailItem.lblAccount.width+2)];
        NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:detailItem.lblOriginPrice.text];
        [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,[FormatUtil formatDouble5:menu.memberPrice].length+1)];
        detailItem.lblOriginPrice.attributedText =aAttributedString;
        [detailItem.lblOriginPrice sizeToFit];
        [detailItem.btnMember setHidden:NO];
        [detailItem.btnMember setLeft:(detailItem.lblOriginPrice.left+detailItem.lblOriginPrice.width+2)];
        [detailItem.btnMember setNeedsDisplay];
    } else {
        detailItem.lblDetail.textColor=[UIColor colorWithRed:204/255.0f green:0 blue:0 alpha:1];
        detailItem.lblDetail.text = [menu obtainItemValue];
        detailItem.lblAccount.textColor=[UIColor colorWithRed:204/255.0f green:0 blue:0 alpha:1];
        [detailItem.btnMember setHidden:YES];
        [detailItem.lblRedLine setHidden:YES];
        [detailItem.lblOriginPrice setHidden:YES];
    }
    return detailItem;
}

- (MenuItemTopCell *)renderMenuItemTopCell:(MenuItemTopCell *)detailItem menu:(SampleMenuVO *)menu
{
    [detailItem loadItem:menu delegate:self.delegate];
    if (menu.chain == 0) {
        detailItem.lblIsChain.hidden = YES;
    }else{
        detailItem.lblIsChain.hidden = NO;
    }
    if (menu.memberPrice!=menu.price ) {
        NSString* val=[NSString stringWithFormat:NSLocalizedString(@"￥%@ /%@", nil),[FormatUtil formatDouble5:menu.price], [menu showUnit]];
        detailItem.lblDetail.text=val;
        detailItem.lblDetail.textColor=[UIColor redColor];
        NSString* originval=[NSString stringWithFormat:NSLocalizedString(@"￥%@ /%@", nil),[FormatUtil formatDouble5:menu.memberPrice],[menu showUnit]];
        detailItem.lblOriginPrice.text=originval;
        detailItem.lblOriginPrice.textColor=[UIColor colorWithRed:0 green:204/255.0f blue:0 alpha:1];
        [detailItem.lblOriginPrice setLeft:(detailItem.lblDetail.left+detailItem.lblDetail.width+2)];
        CGRect originrect = [detailItem.lblDetail.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        detailItem.lblRedLine.frame=CGRectMake(detailItem.lblDetail.frame.origin.x, detailItem.lblDetail.frame.origin.y+8, originrect.size.width, 1);
        CGRect rectlabel = detailItem.lblOriginPrice.frame;
        rectlabel.origin.x = detailItem.lblDetail.origin.x + originrect.size.width;
        detailItem.lblOriginPrice.frame =rectlabel;
        [detailItem.lblOriginPrice sizeToFit];
        [detailItem.btnMember setLeft:(detailItem.lblOriginPrice.left+detailItem.lblOriginPrice.width+2)];
        CGRect rect = [detailItem.lblOriginPrice.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        CGRect rect1 = detailItem.btnMember.frame;
        rect1.origin.x = detailItem.lblOriginPrice.origin.x + rect.size.width;
        detailItem.btnMember.frame = rect1;
        [detailItem.lblAccount setNeedsDisplay];
        [detailItem.btnMember setHidden:NO];
        [detailItem.btnMember setNeedsDisplay];
    } else {
        detailItem.lblDetail.textColor=[UIColor colorWithRed:204/255.0f green:0 blue:0 alpha:1];
        NSString* val=[NSString stringWithFormat:NSLocalizedString(@"￥%@ /%@", nil),[FormatUtil formatDouble5:menu.memberPrice],[menu showUnit]];
        detailItem.lblDetail.text=val;
        [detailItem.btnMember setHidden:YES];
        [detailItem.lblOriginPrice setHidden:YES];
        [detailItem.lblRedLine setHidden:YES];
    }
    return detailItem;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    self.headList=[NSMutableArray array];
    self.detailMap=[NSMutableDictionary dictionary];
    NSMutableArray *details=nil;
    NSMutableArray* arr=nil;
    BOOL isExist=NO;
    for (id<INameValueItem> item in self.backHeadList) {
        details= [self.backDetailMap objectForKey:[item obtainItemId]];
        isExist=NO;
        BOOL nameCheck=NO;
        BOOL spellCheck=NO;
        BOOL codeCheck=NO;
        
        if ([ObjectUtil isNotEmpty:details]) {
            for (id<IImageDataItem> detail in details) {
                nameCheck=[[detail obtainItemName] rangeOfString:searchBar.text].location!=NSNotFound;
                spellCheck=[[detail obtainItemSpell] rangeOfString:[searchBar.text uppercaseString]].location!=NSNotFound;
                codeCheck=[[detail obtainItemCode] rangeOfString:searchBar.text].location!=NSNotFound;
                
                if (nameCheck || spellCheck || codeCheck) {
                    if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"店家推荐", nil)]) {
                        arr=[self.detailMap objectForKey:[item obtainItemId]];
                    }else{
                        arr=[self.detailMap objectForKey:[detail obtainHeadId]];
                    }
                    if (!arr) {
                        arr=[NSMutableArray array];
                    } else {
                        if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"店家推荐", nil)]){
                            [self.detailMap removeObjectForKey:[item obtainItemId]];
                        }
                        else{
                            [self.detailMap removeObjectForKey:[detail obtainHeadId]];
                        }
                    }
                    [arr addObject:detail];
                    if ([[item obtainItemName] isEqualToString:NSLocalizedString(@"店家推荐", nil)]){
                        [self.detailMap setObject:arr forKey:[item obtainItemId]];
                    }else{
                        [self.detailMap setObject:arr forKey:[detail obtainHeadId]];
                    }
                    isExist=YES;
                }
            }
        }
        if (isExist) {
            [self.headList addObject:item];
        }
    }
    [self.headerItems removeAllObjects];
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    [self endEditing:YES];
    searchBar.text = nil;
    [self initData:self.backHeadList map:self.backDetailMap];
}

- (void)initData:(NSMutableArray*)headListTemp map:(NSMutableDictionary*)detailMapTemp
{
    self.headList = headListTemp;
    self.detailMap = detailMapTemp;
    [self.tableView reloadData];
}

- (void)scrocll:(TreeNode*)node
{
    if ([ObjectUtil isNotNull:self.headList] && [ObjectUtil isNotNull:node]) {
        NSInteger index = [GlobalRender getPos:self.headList itemId:node.itemId];
        CGFloat offset = index*DH_HEAD_HEIGHT;
        for (NSUInteger i=0;i<index;++i) {
            TreeNode *nodeTemp = [self.headList objectAtIndex:i];
            if([ObjectUtil isNotNull:nodeTemp]) {
                NSArray *menus = [self.detailMap objectForKey:nodeTemp.itemId];
                if ([ObjectUtil isNotEmpty:menus]) {
                    for (SampleMenuVO *menu in menus) {
                        if ([menu isTopMenu]) {
                            offset += DH_BIG_IMAGE_CELL_ITEM_HEIGHT;
                        } else {
                            offset += DH_IMAGE_CELL_ITEM_HEIGHT;
                        }
                    }
                }
            }
        }
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

@end
