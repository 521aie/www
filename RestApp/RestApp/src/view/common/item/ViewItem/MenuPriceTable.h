//
//  MenuPriceTable.h
//  RestApp
//
//  Created by zishu on 16/10/18.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "NSString+Estimate.h"
@interface MenuPriceTable : UIView<UITableViewDelegate,UITableViewDataSource,ISampleListEvent>
@property (nonatomic, strong) UITableView *mainGrid;  //表格
@property (nonatomic, strong) id<ISampleListEvent> delegate;
@property (nonatomic, strong) NSMutableArray *dataList;    //商品.
@property (nonatomic, strong) NSString *event;
@property (nonatomic, assign) NSUInteger detailCount;
@property (nonatomic, assign) NSInteger itemMode;

- (void)initDelegate:(id<ISampleListEvent>)delegate event:(NSString*)event itemMode:(NSInteger)mode;
- (void)loadData:(NSMutableArray *)dataList detailCount:(NSUInteger)detailCount;
- (void)visibal:(BOOL)show;
@end
