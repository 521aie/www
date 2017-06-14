//
//  TDFAsyncPickerStrategy.m
//  RestApp
//
//  Created by Octree on 16/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFAsyncPickerStrategy.h"
#import "TDFOptionPickerController.h"
#import "UIViewController+HUD.h"

@implementation TDFAsyncPickerStrategy
- (void)invoke {
    if (self.shouldShowPickerBlock && !self.shouldShowPickerBlock()) {
        return;
    }
    
    __weak __typeof(self) wself = self;
    self.async.execute(^void(id obj, NSError *error) {
        __strong __typeof(wself) sself = self;
        if (error) {
            [TDF_ROOT_NAVIGATION_CONTROLLER showErrorMessage:error.localizedDescription];
            return;
        }
        [sself showPickerViewWithPickerItemList:(NSArray *)obj];
    });
}

- (void)showPickerViewWithPickerItemList:(NSArray *)pickerItemList {

    TDFOptionPickerController *pvc = [TDFOptionPickerController pickerControllerWithTitle:self.pickerName
                                                                                  options:pickerItemList
                                                                            currentItemId:self.currentSelectedItemId];
    __weak __typeof(self) wself = self;
    pvc.competionBlock = ^void(NSInteger index) {
        
        [wself pickOption:pickerItemList[index] event:0];
    };
    pvc.fontSize = self.fontSize;
    
    [(UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:pvc animated:YES completion:nil];
}

- (BOOL)pickOption:(id)selectObj event:(NSInteger)eventType {
    NSString *name = [selectObj obtainItemName];
    NSString *value = [selectObj obtainItemId];
    
    if ([self.delegate conformsToProtocol:@protocol(TDFPickerStrategyDelegate)]) {
        if ([self.delegate strategyCallbackWithTextValue:name requestValue:value]) {
            self.currentSelectedItemId = [selectObj obtainItemId];
        }
    }
    
    return YES;
}
@end
