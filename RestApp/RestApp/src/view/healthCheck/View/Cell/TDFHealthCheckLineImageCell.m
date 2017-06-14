//
//  TDFHealthCheckLineImageCell.m
//  RestApp
//
//  Created by happyo on 2017/6/8.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFHealthCheckLineImageCell.h"
#import "TDFHealthTitleView.h"
#import "TDFHealthCheckItemBodyModel.h"
#import "TDFHealthCheckImageItem.h"

@interface TDFHealthCheckLineImageCell ()

@property (nonatomic, strong) TDFHealthTitleView *titleView;

@property (nonatomic, strong) UIView *containerView;

@end
@implementation TDFHealthCheckLineImageCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configViews];
    }
    return self;
}


-(void)configViews{
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).with.offset(10);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

-(void)cellLoadData:(TDFHealthCheckItemBodyModel *)data{
    [self.titleView initTitle:data.title detail:data.desc];
    if ([ObjectUtil isEmpty:data.details]) {
        return;
    }
    
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    for (NSString *str in data.details) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
        [datas addObject:dict];
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[[data.details lastObject] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:NULL];
    
    if ( [ObjectUtil isEmpty:dict]) {
        return;
    }
    
    NSArray *itemDatas = [self data:datas maxItems:3];
    
    for (int i = 0 ; i < itemDatas.count; i++) {
        UIView *lineView = [self lineViewWithItems:itemDatas[i]];
        lineView.backgroundColor = [UIColor clearColor];
        CGFloat width = 0.95 * SCREEN_WIDTH - 15 * 2;
        lineView.frame = CGRectMake(15, i * 80, width, 70);
        
        [self.containerView addSubview:lineView];
    }
}

- (UIView *)lineViewWithItems:(NSArray *)items
{
    CGFloat scrollViewWidth = 0.95 * SCREEN_WIDTH - 30;
    CGFloat space = 20;
    CGFloat start = (scrollViewWidth - items.count *56 - (items.count-1)*space)/2;
    UIView *lineContainer = [[UIView alloc]initWithFrame:CGRectZero];
    UIView *lastView = nil;
    for (int i = 0; i < items.count ; i++) {
        TDFHealthCheckImageItem *item = [TDFHealthCheckImageItem new];
        item.backgroundColor = [UIColor clearColor];
        [lineContainer addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(56, 60));
            make.top.equalTo(lineContainer);
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(space);
            }else{
                make.left.equalTo(lineContainer.mas_left).offset(start);
            }
        }];
        [item loadDatas:items[i]];
        
        UILabel *view = [UILabel new];
        [lineContainer addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(item.mas_bottom).offset(5);
            make.right.and.left.equalTo(item);
        }];
        view.numberOfLines = 0;
        view.backgroundColor = [UIColor redColor];
        view.font = [UIFont systemFontOfSize:9];
        view.textAlignment = NSTextAlignmentCenter;
        view.text = items[i][@"title"];
        
        lastView = item;
    }
    
    return lineContainer;
}

-(NSArray*)data:(NSArray *)datas maxItems:(NSInteger)maxNum{
    NSMutableArray *data = [NSMutableArray array];
    for (NSInteger i = 0; i < [datas count]; i++) {
        NSMutableArray *items = [NSMutableArray array];
        NSInteger count = 0;
        while (count != maxNum && i < [datas count]) {
            count++;
            [items addObject:datas[i]];
            i++;
        }
        [data addObject:items];
        i--;
    }
    return data;
}

/**
 cell height
 */
+(CGFloat)heightForCellAtIndexPath:(UITableView *)tableView model:(id)data{
    TDFHealthCheckItemBodyModel *model = data;
    TDFHealthTitleView *titleView = [[TDFHealthTitleView alloc] init];
    [titleView initTitle:model.title detail:model.desc];
    
    return ((model.details.count - 1) / 3 + 1) * 80 + titleView.frame.size.height + 20 + 10;
}

#pragma mark -- Getters && Setters --

- (TDFHealthTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[TDFHealthTitleView alloc] init];
    }
    
    return _titleView;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _containerView;
}


@end
