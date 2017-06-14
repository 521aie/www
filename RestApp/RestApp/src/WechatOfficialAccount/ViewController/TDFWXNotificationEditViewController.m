//
//  TDFWXNotificationEditViewController.m
//  RestApp
//
//  Created by Octree on 20/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import <TDFSKOptionPickerStrategy.h>
#import "TDFWXNotificationEditViewController.h"
#import "TDFForm.h"
#import "TDFAttributeLabelItem.h"
#import "TDFWXOptionModel.h"
#import "TDFCustomStrategy.h"
#import "UIColor+Hex.h"
#import "UIViewController+HUD.h"
#import "TDFButtonFactory.h"
#import "TDFLabelFactory.h"
#import "TDFWechatMarketingService.h"
#import "BackgroundHelper.h"
#import "TDFWXTextEditItem.h"
#import "DicSysItem+Extension.h"
#import "TDFWXGroupModel.h"
#import "TDFWechatMarketingService.h"
#import "TDFEditDetailController.h"
#import "TDFEditViewHelper.h"
#import "TDFWechatNotificationTypeViewController.h"

@class TDFWXOptionModel;
@interface TDFWXNotificationEditViewController ()

/*************** 推送对象 ******************/
@property (strong, nonatomic) DHTTableViewSection *targetTitleSection;
@property (strong, nonatomic) DHTTableViewSection *targetSection;
@property (strong, nonatomic) TDFShowPickerStrategy *targetStrategy;
@property (strong, nonatomic) TDFPickerItem *targetItem;
@property (strong, nonatomic) TDFAttributeLabelItem *fansCountItem;
@property (strong, nonatomic) TDFShowPickerStrategy *groupStrategy;
@property (strong, nonatomic) TDFPickerItem *groupItem;
@property (strong, nonatomic) TDFShowPickerStrategy *tagStrategy;
@property (strong, nonatomic) TDFPickerItem *tagItem;
@property (strong, nonatomic) TDFAttributeLabelItem *groupIntroduceItem;

/*************** 内容设置 ******************/

@property (strong, nonatomic) DHTTableViewSection *contentTitleSection;
@property (strong, nonatomic) DHTTableViewSection *contentSection;
@property (strong, nonatomic) TDFShowPickerStrategy *contentTypeStrategy;
@property (strong, nonatomic) TDFPickerItem *contentTypeItem;
@property (strong, nonatomic) TDFCustomStrategy *contentStrategy;
@property (strong, nonatomic) TDFPickerItem *contentItem;
@property (strong, nonatomic) TDFWXTextEditItem *textItem;
@property (strong, nonatomic) TDFAttributeLabelItem *contentIntroduceItem;

@property (strong, nonatomic) TDFPickerItem *selectPlatePickerItem;
@property (strong, nonatomic) TDFShowPickerStrategy *selectPlateStrategy;
/*************** Models ******************/

@property (copy, nonatomic) NSArray *tagGroups;             //  微信标签分组
@property (copy, nonatomic) NSArray *intelligenceGroups;    //  智能分组

@property (strong, nonatomic) NSArray <TDFWXOptionModel *> *plates;     // 等级体系

@property (assign, nonatomic) NSInteger fansCount;

@property (copy, nonatomic) NSArray *contentTypePickerItems;
@property (copy, nonatomic) NSArray *targetPickerItems;

/*************** TableView ******************/

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DHTTableViewManager *manager;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIImageView *sampleImageView;

@property (nonatomic) BOOL showGroup;           //   是否显示智能分组

@end

@implementation TDFWXNotificationEditViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViews];
    [self fetchData];
}

#pragma mark - Method

#pragma mark Config View

- (void)configViews {
    
    [self configBackground];
    [self configNavigationBar];
}

- (void)configBackground {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:[BackgroundHelper getBackgroundImage]];
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [imageView addSubview:view];
    [self.view addSubview:imageView];
}
- (void)configNavigationBar {

    self.title = @"添加推送消息";
    UIButton *button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationClose];
    [button addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [[TDFButtonFactory factory] buttonWithType:TDFButtonTypeNavigationSave];
    [button addTarget:self action:@selector(sendButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configContentViews {

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.manager reloadData];
    [self updateSampleImageView];
}

- (void)updateSampleImageView {

    if ([[self.contentTypeItem requestValue] integerValue] == TDFWXNotificationContentTypeCoupon) {
        
        self.sampleImageView.image = [UIImage imageNamed:@"wxoa_noti_sample_coupon"];
    } else if ([[self.contentTypeItem requestValue] integerValue] == TDFWXNotificationContentTypePromotion) {
        
        self.sampleImageView.image = [UIImage imageNamed:@"wxoa_noti_sample_promotion"];
    } else {
    
        self.sampleImageView.image = [UIImage imageNamed:@"wxoa_noti_sample_member"];
    }
}


#pragma mark Action

- (void)closeButtonTapped {

    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"" message:@"是否放弃本次发送？取消将不会保存任何信息。" preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    __weak __typeof(self) wself = self;
    [avc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [wself.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:avc animated:YES completion:nil];
}


- (void)sendButtonTapped {

    NSError *error = nil;
    TDFWXNotificationModel *model = [self transToModelWithError:&error];
    if (error) {
    
        [self showErrorMessage:error.localizedDescription];
        return;
    }
    
    [self sendNotificationWithModel:model];
}

#pragma mark Network

- (void)sendNotificationWithModel:(TDFWXNotificationModel *)model {

    @weakify(self);
    [self showHUBWithText:@"正在保存"];
    [[TDFWechatMarketingService service] sendNotificationWithOAId:self.officialAccount._id json:[model yy_modelToJSONString] callback:^(id responseObj, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
            [self showErrorMessage:error.localizedDescription];
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)fetchData {

    [self showHUBWithText:@"正在加载"];
    @weakify(self);
    [[TDFWechatMarketingService service] fetchNotificationOptionsWithOAId:self.officialAccount._id callback:^(id responseObj, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        if (error) {
            
            [self showErrorMessage:error.localizedDescription];
            return ;
        }
        self.showGroup = [[[responseObj objectForKey:@"data"] objectForKey:@"isShowGroup"] boolValue];
        self.tagGroups = [NSArray yy_modelArrayWithClass:[TDFWXGroupModel class]
                                                    json:[[responseObj objectForKey:@"data"] objectForKey:@"tags"]];
        
        self.intelligenceGroups = [NSArray yy_modelArrayWithClass:[TDFWXGroupModel class]
                                                             json:[[responseObj objectForKey:@"data"] objectForKey:@"groups"]];
        
        self.plates = [NSArray yy_modelArrayWithClass:[TDFWXOptionModel class] json:[responseObj valueForKeyPath:@"data.plates"]];
        
        self.fansCount = [[[responseObj objectForKey:@"data"] objectForKey:@"totalMemberCount"] integerValue];
        [self configContentViews];
    }];
}

#pragma mark Helper

- (DicSysItem *)targetItemForType:(TDFWXNotificationTargetType)type {

    NSString *targetId = [NSString stringWithFormat:@"%zd", type];
    for (DicSysItem *item in [self targetPickerItems]) {
        if ([item._id isEqualToString:targetId]) {
            return item;
        }
    }
    return nil;
}

- (TDFWXGroupModel *)tagGroupForId:(NSString *)groupId {

    if (!groupId) {
        return nil;
    }
    
    for (TDFWXGroupModel *group in self.tagGroups) {
        
        if ([group._id isEqualToString:groupId]) {
            
            return group;
        }
    }
    return nil;
}

- (TDFWXOptionModel *)plateForId:(NSString *)plateId {
    if (!plateId) {
        return nil;
    }
    
    for (TDFWXOptionModel *plate in self.plates) {
        if ([plate._id isEqualToString:plateId]) {
            return plate;
        }
    }
    
    return nil;
}

- (TDFWXGroupModel *)intelligenceGroupForId:(NSString *)groupId {
    
    if (!groupId) {
        return nil;
    }
    
    for (TDFWXGroupModel *group in self.intelligenceGroups) {
        
        if ([group._id isEqualToString:groupId]) {
            
            return group;
        }
    }
    return nil;
}

- (NSString *)prettyReadingNumber:(NSInteger)num {
    
    if (num >= 100000) {
        
        CGFloat anum = num / 10000.0;
        return [NSString stringWithFormat:@"%.2f万", anum];
    } else {
        
        return [NSString stringWithFormat:@"%zd", num];
    }
}

- (void)updateGroupItemsWithType:(TDFWXNotificationTargetType)type {

    if (type == TDFWXNotificationTargetTypeAll) {
        
        self.groupItem.tdf_shouldShow(NO).tdf_isRequired(NO);
        self.tagItem.tdf_shouldShow(NO).tdf_isRequired(NO);
        self.groupIntroduceItem.tdf_shouldShow(NO);
        
        self.selectPlatePickerItem.shouldShow = NO;
    } else if (type == TDFWXNotificationTargetTypeTagGroup) {
        
        self.groupItem.tdf_shouldShow(NO).tdf_isRequired(NO);
        self.tagItem.tdf_shouldShow(YES).tdf_isRequired(YES);
        self.groupIntroduceItem.tdf_shouldShow(YES);
        NSString *text = @"注：此标签与您微信公众号后台设置的粉丝分组标签一致，如需修改，请前往公众号后台";
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName: [UIColor colorWithHeX:0x666666],
                                     NSFontAttributeName: [UIFont systemFontOfSize:11]
                                     };
        self.groupIntroduceItem.attributedString = [[NSAttributedString alloc] initWithString:text
                                                                                   attributes:attributes];
        
        self.selectPlatePickerItem.shouldShow = NO;
    } else {
        
        self.groupItem.tdf_shouldShow(YES).tdf_isRequired(YES);
        self.tagItem.tdf_shouldShow(NO).tdf_isRequired(NO);
        self.groupIntroduceItem.tdf_shouldShow(YES);
        NSString *text = @"注：此为二维火根据数据对您的会员进行智能分组后的顾客，可根据您的需要选择不同分组";
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName: [UIColor colorWithHeX:0x666666],
                                     NSFontAttributeName: [UIFont systemFontOfSize:11]
                                     };
        self.groupIntroduceItem.attributedString = [[NSAttributedString alloc] initWithString:text
                                                                                   attributes:attributes];
        
        
#pragma mark - TODO 查看当前选中的分组是否为v0-v7，是则显示selectPlatePickerItem
        self.selectPlatePickerItem.shouldShow = self.groupItem.shouldShow && [self intelligenceGroupForId:self.groupItem.textId].canPickPlate;
    }
}


- (void)showTextEditView {

    TDFEditDetailController *vc = [[TDFEditDetailController alloc] init];
    vc.navTitle = @"推送内容";
    vc.limitLength = 200;
    vc.text = self.textItem.requestValue;
    @weakify(self);
    vc.block = ^void(NSString *text) {
        @strongify(self);
        self.textItem.requestValue = text;
        [self.manager reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (TDFWXNotificationModel *)transToModelWithError:(NSError **)error {
    
    NSString *message = nil;
    message = [TDFEditViewHelper messageForCheckingItemEmptyInSections:self.manager.sections withIgnoredCharator:@" "];
    if (message) {
        *error = [NSError errorWithDomain:@"TDF" code:4000 userInfo:@{ NSLocalizedDescriptionKey: message }];
        return nil;
    }
    
    NSString *text = [self.textItem.requestValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) {
        
         *error = [NSError errorWithDomain:@"TDF" code:4000 userInfo:@{ NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%@不能为空!", self.textItem.title] }];
        return nil;
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [TDFEditViewHelper formatSectionsData:self.manager.sections toDictionary:dictionary];
    TDFWXNotificationModel *model = [TDFWXNotificationModel yy_modelWithDictionary:dictionary];
    if (model.targetType == TDFWXNotificationTargetTypeTagGroup) {
    
        model.tagName = [self tagGroupForId:model.tagId].name;
    } else if (model.targetType == TDFWXNotificationTargetTypeIntelligentGroup) {
        model.groupName = [self intelligenceGroupForId:model.groupId].name;
    }
    model.contentName = _contentItem.textValue;
    model.officialAccountName = self.officialAccount.name;
    model.officialAccountId = self.officialAccount._id;
    model.fansNumber = self.fansCount;
    if (model.targetType == TDFWXNotificationTargetTypeTagGroup) {
        
        model.tagMemberNumber = [self tagGroupForId:model.tagId].memberCount;
    } else if (model.targetType == TDFWXNotificationTargetTypeIntelligentGroup) {
    
        model.groupMemberNumber = [self intelligenceGroupForId:model.groupId].memberCount;
        
        model.plateId = self.selectPlatePickerItem.textId;
        model.plateName = self.selectPlatePickerItem.textValue;
    }
    return model;
}

- (void)showContentSelectViewController {
    
    TDFWechatNotificationTypeViewController *svc = [[TDFWechatNotificationTypeViewController alloc] init];
    svc.contentType = [[self.contentTypeItem requestValue] integerValue];
    svc.selectedId = [self.contentItem requestValue];
    svc.wechatId = self.officialAccount._id;
    @weakify(self);
    svc.completionBlock = ^void(NSString *contentId, NSString *contentName) {
        @strongify(self);
        self.contentItem.tdf_textValue(contentName).tdf_requestValue(contentId);
        [self.manager reloadData];
    };
    
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - Accessor

/*************** 推送对象 ******************/

- (DHTTableViewSection *)targetTitleSection {

    if (!_targetTitleSection) {
        
        _targetTitleSection = [DHTTableViewSection sectionWithTitleHeader:@"推送对象"];
    }
    return _targetTitleSection;
}

- (DHTTableViewSection *)targetSection {

    if (!_targetSection) {
        
        _targetSection = [DHTTableViewSection section];
        [_targetSection addItem:self.targetItem];
        [_targetSection addItem:self.fansCountItem];
        [_targetSection addItem:self.groupItem];
        [_targetSection addItem:self.tagItem];
        [_targetSection addItem:self.groupIntroduceItem];
        [_targetSection addItem:self.selectPlatePickerItem];
    }
    
    return _targetSection;
}

- (TDFShowPickerStrategy *)targetStrategy {
    
    if (!_targetStrategy) {
        
        _targetStrategy = [[TDFShowPickerStrategy alloc] init];
        _targetStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.targetPickerItems];
        _targetStrategy.selectedItem = [self targetItemForType:self.model.targetType];
        _targetStrategy.pickerName = @"选择推送对象";
    }
    return _targetStrategy;
}

- (TDFPickerItem *)targetItem {
    
    if (!_targetItem) {
        
        _targetItem  = [TDFPickerItem item];
        DicSysItem *item = self.targetPickerItems[self.model.targetType];
        @weakify(self);
        __weak __typeof(_targetItem) weakItem = _targetItem;
        _targetItem.tdf_title(@"消息推送对象")
        .tdf_isRequired(YES)
        .tdf_textValue(item.name)
        .tdf_preValue(item._id)
        .tdf_requestValue(item._id)
        .tdf_requestKey(@"targetType")
        .tdf_strategy(self.targetStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            TDFWXNotificationTargetType type = [requestValue integerValue];
            [self updateGroupItemsWithType:type];
            weakItem.textId = requestValue;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.manager reloadData];
            });
            
            return YES;
        });
        _targetItem.textId = item._id;
    }
    return _targetItem;
}

- (TDFAttributeLabelItem *)fansCountItem {
    
    if (!_fansCountItem) {
        _fansCountItem = [[TDFAttributeLabelItem alloc] init];
        NSString *headText = [NSString stringWithFormat:@"当前公众号为%@，共有粉丝：", self.officialAccount.name];
        NSString *contentText = [self prettyReadingNumber:self.fansCount];
        NSString *tailText = @"人";
        NSString *text = [NSString stringWithFormat:@"%@%@%@", headText, contentText, tailText];
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName: [UIColor colorWithHeX:0x666666],
                                     NSFontAttributeName: [UIFont systemFontOfSize:11]
                                     };

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text
                                                                                             attributes:attributes];
        [attributedString addAttributes:@{ NSForegroundColorAttributeName: [UIColor colorWithHeX:0xCC0000] }
                                  range:NSMakeRange(headText.length, contentText.length)];
        _fansCountItem.attributedString = attributedString;
    }
    return _fansCountItem;
}

- (TDFShowPickerStrategy *)groupStrategy {
    
    if (!_groupStrategy) {
        
        _groupStrategy = [[TDFShowPickerStrategy alloc] init];
        _groupStrategy.selectedItem = [self intelligenceGroupForId:self.model.groupId];
        _groupStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.intelligenceGroups];
        _groupStrategy.pickerName = @"选择智能分组";
    }
    return _groupStrategy;
}

- (TDFPickerItem *)groupItem {
    
    if (!_groupItem) {
        
        @weakify(self)
        TDFWXGroupModel *group = [self intelligenceGroupForId:self.model.groupId];
        TDFWXNotificationTargetType targetType = [self.targetItem.requestValue integerValue];
        _groupItem = [[TDFPickerItem alloc] init];
        __weak __typeof(_groupItem) weakItem = _groupItem;
        _groupItem.tdf_title(@"分组选择")
        .tdf_isRequired(targetType == TDFWXNotificationTargetTypeIntelligentGroup)
        .tdf_shouldShow(targetType == TDFWXNotificationTargetTypeIntelligentGroup)
        .tdf_textValue(group.obtainItemName)
        .tdf_preValue(group.obtainItemId)
        .tdf_requestValue(group.obtainItemId)
        .tdf_requestKey(@"groupId")
        .tdf_strategy(self.groupStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self)
            
            weakItem.textId = requestValue;
#pragma mark - TODO 选中的分组是否为v0-v7，是则显示selectPlatePickerItem
            self.selectPlatePickerItem.shouldShow = [self intelligenceGroupForId:requestValue].canPickPlate;
            [self.manager reloadData];
            
            return YES;
        });
        _groupItem.textId = group.obtainItemId;
    }
    return _groupItem;
}


- (TDFShowPickerStrategy *)selectPlateStrategy {
    if (!_selectPlateStrategy) {
        _selectPlateStrategy = [[TDFShowPickerStrategy alloc] init];
        _selectPlateStrategy.selectedItem = [self plateForId:self.model.plateId];
        _selectPlateStrategy.pickerItemList = (NSMutableArray *)self.plates;
        _selectPlateStrategy.pickerName = self.selectPlatePickerItem.title;
    }
    
    return _selectPlateStrategy;
}

- (TDFPickerItem *)selectPlatePickerItem {
    if (!_selectPlatePickerItem) {
        _selectPlatePickerItem = [TDFPickerItem item]
        .tdf_title(@"请选择对应等级体系")
        .tdf_shouldShow(NO)
        .tdf_strategy(self.selectPlateStrategy)
        ;
        @weakify(self);
        _selectPlatePickerItem.filterBlock = ^BOOL(NSString *textValue, id requestValue) {
            @strongify(self)
            self.selectPlatePickerItem.textId = requestValue;
            
            return YES;
        };
    }
    
    return _selectPlatePickerItem;
}

- (TDFShowPickerStrategy *)tagStrategy {
    
    if (!_tagStrategy) {
        
        _tagStrategy = [[TDFShowPickerStrategy alloc] init];
        _tagStrategy.selectedItem = [self tagGroupForId:self.model.groupId];
        _tagStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.tagGroups];
        _tagStrategy.pickerName = @"选择微信标签分组";
    }
    return _tagStrategy;
}

- (TDFPickerItem *)tagItem {
    
    if (!_tagItem) {
        
        TDFWXGroupModel *group = [self tagGroupForId:self.model.groupId];
        TDFWXNotificationTargetType targetType = [self.targetItem.requestValue integerValue];
        _tagItem = [[TDFPickerItem alloc] init];
        __weak __typeof(_tagItem) weakItem = _tagItem;
        _tagItem.tdf_title(@"标签选择")
        .tdf_isRequired(targetType == TDFWXNotificationTargetTypeTagGroup)
        .tdf_shouldShow(targetType == TDFWXNotificationTargetTypeTagGroup)
        .tdf_textValue(group.obtainItemName)
        .tdf_preValue(group.obtainItemId)
        .tdf_requestValue(group.obtainItemId)
        .tdf_requestKey(@"tagId")
        .tdf_strategy(self.tagStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            
            weakItem.textId = requestValue;
            return YES;
        });
        _tagItem.textId = group.obtainItemId;
    }
    return _tagItem;
}

- (TDFAttributeLabelItem *)groupIntroduceItem {
    
    if (!_groupIntroduceItem) {
        
        _groupIntroduceItem = [[TDFAttributeLabelItem alloc] init];
        TDFWXNotificationTargetType targetType = [self.targetItem.requestValue integerValue];
        [self updateGroupItemsWithType:targetType];
    }
    return _groupIntroduceItem;
}

- (NSArray *)targetPickerItems {

    if (!_targetPickerItems) {
        
        if (self.showGroup) {
            _targetPickerItems  = @[
                                    [DicSysItem itemWithId:@"0"
                                                      name:[NSString stringWithFormat:@"全部微信粉丝(共%@人)", [self prettyReadingNumber:self.fansCount]]],
                                    [DicSysItem itemWithId:@"1" name:@"微信标签分组"],
                                    [DicSysItem itemWithId:@"2" name:@"智能分组"]
                                    ];
        } else {
        
            _targetPickerItems  = @[
                                    [DicSysItem itemWithId:@"0"
                                                      name:[NSString stringWithFormat:@"全部微信粉丝(共%@人)", [self prettyReadingNumber:self.fansCount]]],
                                    [DicSysItem itemWithId:@"1" name:@"微信标签分组"]
                                    ];
        }
    }
    return _targetPickerItems;
}


/*************** 内容设置 ******************/

- (DHTTableViewSection *)contentTitleSection {

    if (!_contentTitleSection) {
        
        _contentTitleSection = [DHTTableViewSection sectionWithTitleHeader:@"内容设置"];
    }
    
    return _contentTitleSection;
}

- (DHTTableViewSection *)contentSection {

    if (!_contentSection) {
        
        _contentSection = [DHTTableViewSection section];
        [_contentSection addItem:self.contentTypeItem];
        [_contentSection addItem:self.contentItem];
        [_contentSection addItem:self.textItem];
        [_contentSection addItem:self.contentIntroduceItem];
    }
    return _contentSection;
}

- (TDFShowPickerStrategy *)contentTypeStrategy {
    
    if (!_contentTypeStrategy) {
        
        _contentTypeStrategy = [[TDFShowPickerStrategy alloc] init];
        _contentTypeStrategy.selectedItem = self.contentTypePickerItems[self.model.contentType];
        _contentTypeStrategy.pickerItemList = [NSMutableArray arrayWithArray:self.contentTypePickerItems];
        _contentTypeStrategy.pickerName = @"选择推送内容";
    }
    return _contentTypeStrategy;
}

- (TDFPickerItem *)contentTypeItem {
    
    if (!_contentTypeItem) {
        
        DicSysItem *item = self.contentTypePickerItems[self.model.contentType];
        _contentTypeItem = [[TDFPickerItem alloc] init];
        __weak __typeof(_contentTypeItem) weakItem = _contentTypeItem;
        @weakify(self);
        _contentTypeItem.tdf_title(@"推送内容")
        .tdf_isRequired(YES)
        .tdf_textValue(item.name)
        .tdf_preValue(item.name)
        .tdf_requestValue(item._id)
        .tdf_requestKey(@"contentType")
        .tdf_strategy(self.contentTypeStrategy)
        .tdf_filterBlock(^BOOL(NSString *textValue,id requestValue) {
            @strongify(self);
            if (![requestValue isEqualToString:weakItem.requestValue]) {
                self.contentItem.tdf_textValue(nil).tdf_requestValue(nil);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateSampleImageView];
                    [self.manager reloadData];
                });
            }
            
            return YES;
        });
    }
    return _contentTypeItem;
}

- (TDFCustomStrategy *)contentStrategy {
    
    if (!_contentStrategy) {
        
        _contentStrategy = [[TDFCustomStrategy alloc] init];
        @weakify(self);
        _contentStrategy.btnClickedBlock = ^ {
            @strongify(self);
            [self showContentSelectViewController];
        };
    }
    return _contentStrategy;
}

- (TDFPickerItem *)contentItem {
    
    if (!_contentItem) {
        
        _contentItem = [[TDFPickerItem alloc] init];
        _contentItem.tdf_title(@"选择要推送的卡/券/促销")
        .tdf_isRequired(YES)
        .tdf_textValue(self.model.contentName)
        .tdf_preValue(self.model.contentId)
        .tdf_requestKey(@"contentId")
        .tdf_strategy(self.contentStrategy);
    }
    return _contentItem;
}

- (TDFWXTextEditItem *)textItem {
    
    if (!_textItem) {
        
        _textItem = [[TDFWXTextEditItem alloc] init];
        _textItem.isRequired = YES;
        _textItem.requestKey = @"text";
        _textItem.title = @"内容";
        @weakify(self);
        _textItem.clickBlock = ^ {
            @strongify(self);
            [self showTextEditView];
        };
    }
    return _textItem;  
}

- (TDFAttributeLabelItem *)contentIntroduceItem {
    
    if (!_contentIntroduceItem) {
        
        _contentIntroduceItem = [[TDFAttributeLabelItem alloc] init];
        NSString *text = @"注：推送的卡/券/促销活动链接将自动跟在您输入的文字内容最末。";
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName: [UIColor colorWithHeX:0x666666],
                                     NSFontAttributeName: [UIFont systemFontOfSize:11]
                                     };
        _contentIntroduceItem.attributedString = [[NSAttributedString alloc] initWithString:text
                                                                                   attributes:attributes];
    }
    return _contentIntroduceItem;  
}

- (NSArray *)contentTypePickerItems {
    if (!_contentTypePickerItems) {
        
        _contentTypePickerItems = @[
                                    [DicSysItem itemWithId:@"0" name:@"会员卡"],
                                    [DicSysItem itemWithId:@"1" name:@"优惠券"],
                                    [DicSysItem itemWithId:@"2" name:@"促销活动"]
                                    ];
    }
    return _contentTypePickerItems;
}

/*************** TableView ******************/

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (DHTTableViewManager *)manager {
    
    if (!_manager) {
        
        _manager = [[DHTTableViewManager alloc] initWithTableView:self.tableView];
        [_manager registerCell:@"TDFPickerCell" withItem:@"TDFPickerItem"];
        [_manager registerCell:@"TDFWXTextEditCell" withItem:@"TDFWXTextEditItem"];
        [_manager registerCell:@"TDFAttributeLabelCell" withItem:@"TDFAttributeLabelItem"];
        [_manager addSection:self.targetTitleSection];
        [_manager addSection:self.targetSection];
        [_manager addSection:self.contentTitleSection];
        [_manager addSection:self.contentSection];
    }
    return _manager;
}

- (UIImageView *)sampleImageView {

    if (!_sampleImageView) {
        
        UIImage *image = [UIImage imageNamed:@"wxoa_notification_sample"];
        CGFloat width = SCREEN_WIDTH - 40;
        CGFloat height = width * image.size.height / image.size.width;
        _sampleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, width, height)];
        _sampleImageView.contentMode = UIViewContentModeScaleAspectFit;
        _sampleImageView.image = image;
    }
    return _sampleImageView;
}

- (UIView *)footerView {
    
    if (!_footerView) {
    
        UIImage *image = [UIImage imageNamed:@"wxoa_notification_sample"];
        CGFloat width = SCREEN_WIDTH - 40;
        CGFloat height = width * image.size.height / image.size.width;
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height + 60)];
        [_footerView addSubview:self.sampleImageView];
    }
    return _footerView;  
}

@end
