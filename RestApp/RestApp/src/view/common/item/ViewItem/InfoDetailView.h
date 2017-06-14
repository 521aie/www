//
//  InfoDetailView.h
//  RestApp
//
//  Created by zxh on 14-11-3.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoDetailView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblTitleVal;
@property (nonatomic, strong) IBOutlet UITableView *grid;
@property (nonatomic, strong) IBOutlet UIView *line;

@property (nonatomic, retain) NSMutableArray* datas;

- (void)loadData:(NSString*)title titleValue:(NSString*)val datas:(NSMutableArray*)datas;
@end
