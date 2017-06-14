//
//  TDFSuitMenuService.m
//  RestApp
//
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSuitMenuService.h"
#import "TDFRequestModel.h"
#import "RestConstants.h"
#import "TDFDataCenter.h"
#import "TDFHTTPClient.h"
@implementation TDFSuitMenuService
- (TDFRequestModel *)getRequestModelWithPath:(NSString *)path params:(NSDictionary *)params{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = path;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.timeout = 15;
    
    NSMutableDictionary *mutableParams = params? [params mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
    mutableParams[@"session_key"] = [[Platform Instance] getkey:SESSION_KEY];
    
    requestModel.parameters = [mutableParams copy];
    
    return requestModel;
}

- (NSURLSessionDataTask *)listSuitAll:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/get_suit_menus" params:nil];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)saveSuitWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/save_suit_menu" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)updateSuitWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/update_suit_menu" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)listSuitDetailWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/get_suit_menu" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)loadMenuReserveDataWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/get_suit_menu_prop" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)updateMenuReserveWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/update_suit_menu_prop" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)saveSuitMenuDetailWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/save_suit_menu_detail" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)removeSuitMenuDetailWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/remove_suit_menu_detail" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)updateSuitMenuDetailWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/update_suit_menu_detail" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)saveSuitMenuChangeWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/save_suit_menu_change" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)removeSuitMenuChangeWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/remove_suit_menu_change" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)sortSuitMenuDetailsWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/sort_suit_menu_detail" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)sortSuitMenuChangesWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"suit_menu/v1/sort_suit_menu_change" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)listSuitSpecaDetailWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"specDetail/v1/list_suit_spec_detail" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)listSuitMenuImgWithParam:(NSMutableDictionary *)param suscess:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock {
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"menu/v1/list_suit_menu_img" params:param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:(model.responseObject[@"message"] == nil)?@"":model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}
- (void)getSuitMenuValuationRuleList:(nonnull NSString *)suit_menu_id callBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"menu_hit";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"rule_list";
    requestModel.parameters =  @{@"suit_menu_id":suit_menu_id,
                                 @"session_key":[TDFDataCenter sharedInstance].sessionKey
                                 }.mutableCopy;
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable response) {
        if (response.error) {
            callBack(response);
            return ;
        }
        NSInteger code = [response.responseObject[@"code"] integerValue];
        if (!code) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:response.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
            response.error = error;
        }
        callBack(response);
    }];
}

- (void)getSuitMenuValuationItemList:(nonnull NSString *)suit_menu_id callBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"menu_hit";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"item_list";
    requestModel.parameters =  @{@"suit_menu_id":suit_menu_id,
                                 @"session_key":[TDFDataCenter sharedInstance].sessionKey
                                 }.mutableCopy;
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable response) {
        if (response.error) {
            callBack(response);
            return ;
        }
        NSInteger code = [response.responseObject[@"code"] integerValue];
        if (!code) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:response.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
            response.error = error;
        }
        callBack(response);
    }];
}

- (void)saveSuitMenuValuationRule:(NSDictionary *)dict callBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"menu_hit";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"save_rule";
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:dict];
    parameters[@"session_key"] = [TDFDataCenter sharedInstance].sessionKey;
    requestModel.parameters =  [parameters copy];
    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable response) {
        if (response.error) {
            callBack(response);
            return ;
        }
        NSInteger code = [response.responseObject[@"code"] integerValue];
        if (!code) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:response.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
            response.error = error;
        }
        callBack(response);
    }];
}

- (void)deleteSuitMenuValuationRule:(NSMutableDictionary *)parameters callBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = @"menu_hit";
    requestModel.apiVersion = @"v1";
    requestModel.actionPath = @"del_rule";
    parameters[@"session_key"] = [TDFDataCenter sharedInstance].sessionKey;
    requestModel.parameters = parameters;
    

    [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable response) {
        if (response.error) {
            callBack(response);
            return ;
        }
        NSInteger code = [response.responseObject[@"code"] integerValue];
        if (!code) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:response.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
            response.error = error;
        }
        callBack(response);
    }];
}
@end
