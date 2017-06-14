//
//  MenuPriceTable.m
//  RestApp
//
//  Created by zishu on 16/10/18.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "MenuPriceTable.h"
#import "UIHelper.h"
#import "ZmTableCell.h"
#import "UIView+Sizes.h"
#import "INameValueItem.h"

@implementation MenuPriceTable
- (void) awakeFromNib{
    [self addSubview:self.mainGrid];
    [self initGrid];
}

-(UITableView *) mainGrid
{
    if (! _mainGrid) {
        _mainGrid = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250) style:UITableViewStylePlain];
        _mainGrid.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _mainGrid.separatorColor = [UIColor darkGrayColor];
        _mainGrid.delegate = self;
        _mainGrid.dataSource = self;
        _mainGrid.backgroundColor = [UIColor clearColor];
    }
    return _mainGrid;
}

- (void)initGrid
{
    self.mainGrid.opaque=NO;
    self.mainGrid.scrollEnabled=NO;
    [self.mainGrid setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event itemMode:(NSInteger)mode
{
      self.itemMode=mode;
    self.delegate=delegate;
    self.event=event;
}

- (void)loadData:(NSMutableArray *)dataList detailCount:(NSUInteger)detailCount
{
    self.dataList = dataList;
    self.detailCount = detailCount;
    NSUInteger height = (dataList==nil || dataList.count==0)?0:(dataList.count*48);
    [self.mainGrid setHeight:height];
    [self setHeight:height];
    [self.mainGrid reloadData];
}

- (void)visibal:(BOOL)show
{
    [self setHeight:show?60:0];
    self.alpha=show?1:0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.dataList.count==0?0:self.dataList.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
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
            detailItem.lblName.hidden = YES;
            detailItem.lblVal.hidden = YES;
            detailItem.edititemList.hidden = NO;
            [detailItem.edititemList initLabel:[NSString stringWithFormat:NSLocalizedString(@"▪︎ %@", nil),[item obtainItemName]] withHit:nil delegate:self.delegate];
            if ([NSString isNotBlank:[item obtainItemValue]]) {
                if ([item obtainIsChange]) {
                      [detailItem.edititemList changeData:[item obtainItemValue] withVal:[item obtainItemValue]];
                }else{
                  [detailItem.edititemList initData:[item obtainItemValue] withVal:[item obtainItemValue]];
                }
              
            }else{
                [detailItem.edititemList initData:@"0"withVal:@"0"];
            }
            detailItem.line.hidden = YES;
            detailItem.edititemList.tdf_delegate = self.delegate;
            detailItem.edititemList.tag = 10000;
            detailItem.imgAct.hidden = YES;
            detailItem.btnAct.userInteractionEnabled = NO;
            detailItem.edititemList.frame = CGRectMake(0, 0, 320, 48);
            [detailItem.edititemList setUpKeyboardWithKeyboardType:TDFNumbericKeyboardTypeFloat hasSymbol:NO];

        detailItem.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return detailItem;
}

@end
